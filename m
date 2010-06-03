Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab0FCJdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:33:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:41598 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab0FCJdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:33:24 -0400
Subject: Re: [GIT PULL] perf crash fix
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>
In-Reply-To: <1275557202.27810.35201.camel@twins>
References: <1275534810-1837-1-git-send-regression-fweisbec@gmail.com>
	 <1275557202.27810.35201.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 11:33:29 +0200
Message-ID: <1275557609.27810.35218.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 11:26 +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-03 at 05:13 +0200, Frederic Weisbecker wrote:
> >     What happens here is a double pmu->disable() due to a race between
> >     two perf_adjust_period().
> >     
> >     We first overflow a page fault event and then re-adjust the period.
> >     When we reset the period_left, we stop the pmu by removing the
> >     perf event from the software event hlist. And just before we
> >     re-enable it, we are interrupted by a sched tick that also tries to
> >     re-adjust the period. There we eventually disable the event a second
> >     time, which leads to a double hlist_del_rcu() that ends up
> >     dereferencing LIST_POISON2.
> >     
> >     In fact, the goal of embracing the reset of the period_left with
> >     a pmu:stop() and pmu:start() is only relevant to hardware events. We
> >     want them to reprogram the next period interrupt.
> >     
> >     But this is useless for software events. They have their own way to
> >     handle the period left, and in a non-racy way. They don't need to
> >     be stopped here.
> >     
> >     So, use a new pair of perf_event_stop/start_hwevent that only stop
> >     and restart hardware events in this path.
> >     
> >     The race won't happen with hardware events as sched ticks can't
> >     happen during nmis. 
> 
> I've queued the below.

Uhhm, the compiler reminded me of trace events..

---
Subject: perf: Fix crash in swevents
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Jun 03 11:21:20 CEST 2010

Frederic reported that because swevents handling doesn't disable IRQs
anymore, we can get a recursion of perf_adjust_period(), once from
overflow handling and once from the tick.

If both call ->disable, we get a double hlist_del_rcu() and trigger
a LIST_POISON2 dereference.

Since we don't actually need to stop/start a swevent to re-programm
the hardware (lack of hardware to program), simply nop out these
callbacks for the swevent pmu.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1275557202.27810.35201.camel@twins>
---
 kernel/perf_event.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4055,13 +4055,6 @@ static void perf_swevent_overflow(struct
 	}
 }
 
-static void perf_swevent_unthrottle(struct perf_event *event)
-{
-	/*
-	 * Nothing to do, we already reset hwc->interrupts.
-	 */
-}
-
 static void perf_swevent_add(struct perf_event *event, u64 nr,
 			       int nmi, struct perf_sample_data *data,
 			       struct pt_regs *regs)
@@ -4276,11 +4269,22 @@ static void perf_swevent_disable(struct 
 	hlist_del_rcu(&event->hlist_entry);
 }
 
+static void perf_swevent_void(struct perf_event *event)
+{
+}
+
+static int perf_swevent_int(struct perf_event *event)
+{
+	return 0;
+}
+
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
+	.start		= perf_swevent_int,
+	.stop		= perf_swevent_void,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_unthrottle,
+	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
 };
 
 /*
@@ -4561,8 +4565,10 @@ static int swevent_hlist_get(struct perf
 static const struct pmu perf_ops_tracepoint = {
 	.enable		= perf_trace_enable,
 	.disable	= perf_trace_disable,
+	.start		= perf_swevent_int,
+	.stop		= perf_swevent_void,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_unthrottle,
+	.unthrottle	= perf_swevent_void,
 };
 
 static int perf_tp_filter_match(struct perf_event *event,

