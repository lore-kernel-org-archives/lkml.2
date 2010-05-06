Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab0EFPnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 11:43:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab0EFPnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 11:43:03 -0400
Subject: Re: [BUG] perf_events: PERF_FORMAT_GROUP not working correctly
 when monitoring another task
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Carl Love <carll@us.ibm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       stephane eranian <eranian@googlemail.com>
In-Reply-To: <4BDF8118.3090200@linux.vnet.ibm.com>
References: <4BDF8118.3090200@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 May 2010 17:42:46 +0200
Message-ID: <1273160566.5605.404.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 19:06 -0700, Corey Ashford wrote:
> In the last couple of days, I've run across what appears to be a
> kernel bug in 2.6.33.3 (haven't tested later kernels yet) having to do
> with using the PERF_FORMAT_GROUP feature in combination with
> enable_on_exec and reading counts from a remote task.
> 
> What happens is that when we go to read the entire group up, only the
> first counter in can be accessed; the read() call returns too few
> bytes.  This problem doesn't occur if measuring the from the same
> task.
> 
> I have attached a "cut down", though it's not terribly small.  It is a
> cut down from the "task" example program in libpfm4/perf_examples.  In
> addition to trimming the program down a lot, I've removed the
> dependency on libpfm4 and made modifications so that it will compile
> in the tools/perf subdirectory.  If you copy the attachment into your
> tools/perf subdir, you should be able to compile it with just:
> 
> gcc -o show_fg_bug show_fg_bug.c
> 
> Then invoke it by passing it an executable that will give it something
> to chew on a little, e.g.:
> 
> ./show_fg_bug md5sum `which gdb`
> 
> The test cases creates two counters and places them in the same group,
> and sets the PERF_FORMAT_GROUP option on the first counter.  It
> fork/execs the child and when the child is done executing, it reads
> back the counter values.
> 
> When I run it, I see this output:
> 
> % ./show_fg_bug md5sum `which gdb`
> 825b15d7279ef21d6c9d018d775758ae  /usr/bin/gdb
> Error! tried to read 40 bytes, but got 32
>             58684138 PERF_COUNT_HW_CPU_CYCLES (35469840 : 35469840)
>                    0 PERF_COUNT_HW_INSTRUCTIONS (35469840 : 35469840)
> 
> Oddly enough, if you look at the "nr" (number of counters) value that
> gets read up as part of the group, it is two, but it can only read the
> first of the two counters.  Another data point is that it doesn't
> matter how many counters you add to the group, only the first can be
> read up.
> 
> Please let me know if you have any questions about this.

Looks like you hit the exact same bug Stephane did:
  http://lkml.org/lkml/2010/4/9/142

The below patch seems to cure it for me.

# gcc -o show_fg_bug show_fg_bug.c
# ./show_fg_bug md5sum `which gdb`
bc88d978c10446689326245529e6c4c1  /usr/bin/gdb
            29721534 PERF_COUNT_HW_CPU_CYCLES (18657335 : 18657335)
            18681747 PERF_COUNT_HW_INSTRUCTIONS (18657335 : 18657335)


---
Subject: perf: Fix exit() vs PERF_FORMAT_GROUP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu May 06 17:31:38 CEST 2010

Both Stephane and Corey reported that PERF_FORMAT_GROUP didn't work as
expected if the task the counters were attached to quit before the
read() call.

The cause is that we unconditionally destroy the grouping when we
remove counters from their context. Fix this by only doing this when
we free the counter itself.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -548,6 +548,7 @@ struct pmu {
  * enum perf_event_active_state - the states of a event
  */
 enum perf_event_active_state {
+	PERF_EVENT_STATE_FREE		= -3,
 	PERF_EVENT_STATE_ERROR		= -2,
 	PERF_EVENT_STATE_OFF		= -1,
 	PERF_EVENT_STATE_INACTIVE	=  0,
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -342,6 +342,9 @@ list_del_event(struct perf_event *event,
 	if (event->state > PERF_EVENT_STATE_OFF)
 		event->state = PERF_EVENT_STATE_OFF;
 
+	if (event->state > PERF_EVENT_STATE_FREE)
+		return;
+
 	/*
 	 * If this was a group event with sibling events then
 	 * upgrade the siblings to singleton events by adding them
@@ -1861,6 +1864,8 @@ int perf_event_release_kernel(struct per
 {
 	struct perf_event_context *ctx = event->ctx;
 
+	event->state = PERF_EVENT_STATE_FREE;
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_event_remove_from_context(event);

