Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab2GKPMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:12:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:33375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2GKPMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:12:17 -0400
Message-ID: <1342019524.3462.167.camel@twins>
Subject: Re: [PATCH] trace: add ability to set a target task for events (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>
Date: Wed, 11 Jul 2012 17:12:04 +0200
In-Reply-To: <1342018508.3462.163.camel@twins>
References: <1342016098-213063-1-git-send-email-avagin@openvz.org>
	 <20120711143121.GA17991@somewhere> <1342017221.3462.159.camel@twins>
	 <20120711143656.GB17991@somewhere> <1342017499.3462.160.camel@twins>
	 <20120711144840.GC17991@somewhere> <1342018508.3462.163.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 16:55 +0200, Peter Zijlstra wrote:
> Right.. back when I did that the plan was to make PERF_SAMPLE_PERIOD fix
> that, of course that never seemed to have happened.
> 
> With PERF_SAMPLE_PERIOD you can simply write the 1b into the period of 1
> event and be done with it. 

It did! Andrew fixed it..

---
commit 5d81e5cfb37a174e8ddc0413e2e70cdf05807ace
Author: Andrew Vagin <avagin@openvz.org>
Date:   Mon Nov 7 15:54:12 2011 +0300

    events: Don't divide events if it has field period
    
    This patch solves the following problem:
    
    Now some samples may be lost due to throttling. The number of samples is
    restricted by sysctl_perf_event_sample_rate/HZ.  A trace event is
    divided on some samples according to event's period.  I don't sure, that
    we should generate more than one sample on each trace event. I think the
    better way to use SAMPLE_PERIOD.
    
    E.g.: I want to trace when a process sleeps. I created a process, which
    sleeps for 1ms and for 4ms.  perf got 100 events in both cases.
    
    swapper     0 [000]  1141.371830: sched_stat_sleep: comm=foo pid=1801 delay=1386750 [ns]
    swapper     0 [000]  1141.369444: sched_stat_sleep: comm=foo pid=1801 delay=4499585 [ns]
    
    In the first case a kernel want to send 4499585 events and
    in the second case it wants to send 1386750 events.
    perf-reports shows that process sleeps in both places equal time. It's
    bug.
    
    With this patch kernel generates one event on each "sleep" and the time
    slice is saved in the field "period". Perf knows how handle it.
    
    Signed-off-by: Andrew Vagin <avagin@openvz.org>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/1320670457-2633428-3-git-send-email-avagin@openvz.org
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/events/core.c b/kernel/events/core.c
index eadac69..8d9dea5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4528,7 +4528,6 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 	struct hw_perf_event *hwc = &event->hw;
 	int throttle = 0;
 
-	data->period = event->hw.last_period;
 	if (!overflow)
 		overflow = perf_swevent_set_period(event);
 
@@ -4562,6 +4561,12 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
 	if (!is_sampling_event(event))
 		return;
 
+	if ((event->attr.sample_type & PERF_SAMPLE_PERIOD) && !event->attr.freq) {
+		data->period = nr;
+		return perf_swevent_overflow(event, 1, data, regs);
+	} else
+		data->period = event->hw.last_period;
+
 	if (nr == 1 && hwc->sample_period == 1 && !event->attr.freq)
 		return perf_swevent_overflow(event, 1, data, regs);
 

