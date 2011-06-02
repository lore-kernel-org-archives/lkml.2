Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1FBPpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:45:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:51782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1FBPpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:45:04 -0400
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <20110602142340.GA3356@zhy>
References: <1306835745.2353.3.camel@twins>
	 <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
	 <20110531125621.GA24439@gere.osrc.amd.com> <1306847516.2353.80.camel@twins>
	 <20110601070547.GB3368@liondog.tnic> <1306924612.2353.176.camel@twins>
	 <20110601155017.GD24028@aftab>
	 <BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
	 <1307019866.2497.675.camel@laptop>  <20110602142340.GA3356@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 17:48:31 +0200
Message-ID: <1307029711.2497.717.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 22:23 +0800, Yong Zhang wrote:
> On Thu, Jun 02, 2011 at 03:04:26PM +0200, Peter Zijlstra wrote:
> > On Thu, 2011-06-02 at 15:52 +0800, Yong Zhang wrote:
> > > In sched_clock_local(), clock is calculated around ->tick_gtod even if
> > > that ->tick_gtod is stale for long time because we stays in idle state. 
> > > You know ->tick_gtod is only updated in sched_clock_tick();
> > 
> > (well, no, there's idle callbacks as you said below)
> > 
> > > IOW, when a cpu goes out of idle, sched_clock_tick() is called from
> > > tick_nohz_stop_idle() which is later than interrupt.
> > 
> > Gah, that would be awefull and mean wakeups from interrupts were already
> > borken. /me goes look at code.
> > 
> > irq_enter() -> tick_check_idle() -> tick_check_nohz() ->
> > tick_nohz_stop_idle() -> sched_clock_idle_wakeup_event()
> > 
> > should update the thing before we run any isrs, right?
> 
> Hmmm, you are right.
> 
> But smp_reschedule_interrupt() doesn't call irq_enter()/irq_exit(),
> is that correct?

Crap.. you're right. And I bet other archs don't do that either. With
NO_HZ you really need irq_enter() for pretty much all interrupts so I
was assuming the resched IPI had it, but its been special and never
really needed it. If it would wake an idle cpu the idle loop exit would
deal with it, if it interrupted userspace the thing was running and
NO_HZ wasn't relevant.

Damn. 

And yes, the only reason I didn't see this on my dev box was because we
do indeed set that sched_clock_stable thing on wsm. And I never noticed
on my desktop because firefox/X/etc. consuming heaps of CPU isn't weird
at all.

Adding it to all resched int handlers is of course a possibility but
would slow down the thing, although with the new code, most users are
now indeed wakeups (excepting weird and wonderful users like KVM).

We could of course add it in sched.c since the logic recurses just
fine.. its not pretty though.. :/

Thoughts?

---
 kernel/sched.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2fe98ed..365ed6b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2554,7 +2554,23 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
-	sched_ttwu_pending();
+	struct rq *rq = this_rq();
+	struct task_struct *list = xchg(&rq->wake_list, NULL);
+
+	if (!list)
+		return;
+
+	irq_enter();
+	raw_spin_lock(&rq->lock);
+
+	while (list) {
+		struct task_struct *p = list;
+		list = list->wake_entry;
+		ttwu_do_activate(rq, p, 0);
+	}
+
+	raw_spin_unlock(&rq->lock);
+	irq_exit();
 }
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)


