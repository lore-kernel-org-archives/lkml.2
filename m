Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0CRNW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:22:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35371 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab0CRNWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:22:25 -0400
Subject: Re: [PATCH] softlockup: stop spurious softlockup messages due to
 overflow
From: Colin Ian King <colin.king@canonical.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100316101251.GM7961@elte.hu>
References: <1268661673-21638-1-git-send-email-colin.king@canonical.com>
	 <1268663388.3154.30.camel@edumazet-laptop>  <20100316101251.GM7961@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 13:22:17 +0000
Message-ID: <1268918537.1894.143.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 11:12 +0100, Ingo Molnar wrote:
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Le lundi 15 mars 2010 ?? 14:01 +0000, Colin Ian King a ??crit :
> > > Ensure additions on touch_ts do not overflow.  This can occur when
> > > the top 32 bits of the TSC reach 0xffffffff causing additions to
> > > touch_ts to overflow and this in turn generates spurious softlockup
> > > warnings.
> > > 
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > ---
> > >  kernel/softlockup.c |    6 +++---
> > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/kernel/softlockup.c b/kernel/softlockup.c
> > > index 0d4c789..90d9aa0 100644
> > > --- a/kernel/softlockup.c
> > > +++ b/kernel/softlockup.c
> > > @@ -111,10 +111,10 @@ int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
> > >  void softlockup_tick(void)
> > >  {
> > >  	int this_cpu = smp_processor_id();
> > > -	unsigned long touch_ts = per_cpu(softlockup_touch_ts, this_cpu);
> > > +	unsigned long long touch_ts = per_cpu(softlockup_touch_ts, this_cpu);
> > >  	unsigned long print_ts;
> > >  	struct pt_regs *regs = get_irq_regs();
> > > -	unsigned long now;
> > > +	unsigned long long now;
> > >  
> > >  	/* Is detection switched off? */
> > >  	if (!per_cpu(softlockup_watchdog, this_cpu) || softlockup_thresh <= 0) {
> > > @@ -165,7 +165,7 @@ void softlockup_tick(void)
> > >  	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
> > >  
> > >  	spin_lock(&print_lock);
> > > -	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
> > > +	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %llus! [%s:%d]\n",
> > >  			this_cpu, now - touch_ts,
> > >  			current->comm, task_pid_nr(current));
> > >  	print_modules();
> > 
> > This looks wrong, touch_ts is a long, not a long long.
> 
> Could be increased to long long - but that's probably overkill as the touch_ts 
> is in seconds, so the scope of comparisons should never truly get even close 
> to ~2^31.
> 
> > You probably want to change the comparisons instead.
> > 
> > if (now > touch_ts + softlockup_thresh/2)
> > 	wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
> > if (now <= (touch_ts + softlockup_thresh))
> > 	return;
> > 	
> > ->
> > 
> > if ((long)(now - touch_ts) > softlockup_thresh/2)
> > 	wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
> > if ((long)(now - touch_ts) <= softlockup_thresh))
> > 	return;
> > 
> > Or use standard time_after()/time_before() macros.
> 
> Yeah, time_after/before would work better i suspect.
> 
> Thanks,
> 
> 	Ingo

Using time_after/before:

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 0d4c789..4b493f6 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -155,11 +155,11 @@ void softlockup_tick(void)
         * Wake up the high-prio watchdog task twice per
         * threshold timespan.
         */
-       if (now > touch_ts + softlockup_thresh/2)
+       if (time_after(now - softlockup_thresh/2, touch_ts))
                wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
 
        /* Warn about unreasonable delays: */
-       if (now <= (touch_ts + softlockup_thresh))
+       if (time_before_eq(now - softlockup_thresh, touch_ts))
                return;
 
        per_cpu(softlockup_print_ts, this_cpu) = touch_ts;

