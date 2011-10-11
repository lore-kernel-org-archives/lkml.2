Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1JKJli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:41:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1625 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1JKJlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:41:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=RZWV9VlQ7Wta31knQf9BZ5HM1TwixSjuv0kdnTNZfgJNj/dnbztf31H7ZoJeiqmAy
	O32WOf17k5LMY9GjMb3Ng==
Date: Tue, 11 Oct 2011 11:41:28 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, fweisbec@gmail.com, acme@redhat.com,
        ming.m.lin@intel.com, robert.richter@amd.com, anton@samba.org
Subject: [BUG] perf_event: losing buffer full notifications and samples
Message-ID: <20111011094128.GA5085@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a serious issue with the 3.1-rc9 kernel when it comes
to user notifications when the buffer reaches a watermark threshold
when users are sampling on multiple events at the same time.

When you do:
	$ perf record -e cycles,cycles,cycles noploop 10

You expect about 10,000 samples for each event, i.e., 10s at
1000samples/sec. However, this is not what's happening. You
get much fewer samples, maybe 3700 samples/per event:

$ perf report -D | tail -15
Aggregated stats:
           TOTAL events:      10998
            MMAP events:         66
            COMM events:          2
          SAMPLE events:      10930
cycles stats:
           TOTAL events:       3644
          SAMPLE events:       3644
cycles stats:
           TOTAL events:       3642
          SAMPLE events:       3642
cycles stats:
           TOTAL events:       3644
          SAMPLE events:       3644

On a Intel Nehalem or even AMD64, there are 4 counters capable
of measuring cycles, so there is plenty of space to measure without
multiplexing (even with the NMI watchdog active).

What is also strange is that there is no LOST sample records
in the buffer either.

After a very painful debugging session, I discovered when the buffer
gets full, despite sending notification, the perf tool did not
update the tail pointer of the buffer. At first, I thought it was
some race condition or memory ordering problem. But the reality
was far simpler.

When sampling on multiple events, perf aggregates all samples into
a single sampling buffer controlled by the first event.

I checked that the arch low level handler was indeed detecting all
the counter overflows and calling perf_event_overflow() to process
them. Therefore at the lowest level, 30,000 samples were actually
generated, yet only 11,000 ended up in the perf.data file. The
interrupt throttling mechanism was not to blame here, because
we are way below the limit.

Then, I thought the ring_buffer code was to blame. Well, it was not.
The issue is that when you sample on multiple events, any one of
them can fire, the perf_event_overflow() is called for each event.
One of the events can cause the buffer notification threshold to be
crossed.  The poll notification is based on the event. But when samples
are aggregated into a single buffer, you MUST use the event that owns
the buffer when you notify. The perf tool ONLY polls on the events
with a sampling buffer. In my example, it polls on the fd for the
first event. But if the kernel sends a wakeup for the the second
event, nothing is going to happen and the buffer will get stuck.

Back in 2.6.34, perf_event_set_output() was setting the output event
for each "aggregated" event. But in 2.6.35, Peter removed that for
a reason I don't quite understand in this commit:

commit ac9721f3f54b27a16c7e1afb2481e7ee95a70318
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu May 27 12:54:41 2010 +0200

perf_events: Fix races and clean up perf_event and perf_mmap_data interaction


That means that since then, the above example does not work. We are
silently dropping samples. This needs to be fixed ASAP. The above patch
fixes the problem, but it may have some race conditions. I also suspect
we could stash the output event into the ring_buffer struct.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index a308820..4c50c1b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -798,6 +798,7 @@ struct perf_event {
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
+        struct perf_event               *output;
 	struct pmu			*pmu;
 
 	enum perf_event_active_state	state;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a7f388f..7ba3bc6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6194,6 +6194,7 @@ set:
 
 	old_rb = event->rb;
 	rcu_assign_pointer(event->rb, rb);
+        rcu_assign_pointer(event->output, output_event);
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index a2a2920..7fcd97a 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -102,6 +102,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 {
 	struct ring_buffer *rb;
 	unsigned long tail, offset, head;
+	struct perf_event *output_event;
 	int have_lost;
 	struct perf_sample_data sample_data;
 	struct {
@@ -121,6 +122,10 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (!rb)
 		goto out;
 
+        output_event = rcu_dereference(event->output);
+        if (output_event)
+                event = output_event;
+
 	handle->rb	= rb;
 	handle->event	= event;
 
