Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab2FENf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:35:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:46192 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934115Ab2FENfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:35:25 -0400
Date: Tue, 5 Jun 2012 15:35:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel
 machines
In-Reply-To: <4FCDF1C8.9020007@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1206051503560.3086@ionos>
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com> <alpine.LFD.2.02.1206042158200.3086@ionos> <4FCDF1C8.9020007@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1653951612-1338903322=:3086"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1653951612-1338903322=:3086
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 5 Jun 2012, Chen Gong wrote:
> 于 2012/6/5 4:01, Thomas Gleixner 写道:
> > On Mon, 4 Jun 2012, Chen Gong wrote:
> >  static void mce_timer_fn(unsigned long data)
> >  {
> > ...
> > +	/* Might have become 0 after CMCI storm subsided */
> > +	if (iv) {
> > +		t->expires = jiffies + iv;
> > +		add_timer_on(t, smp_processor_id());
> > +	}
> > +}
> 
> I've found under some conditions, *t* is pending on the timer tree, so
> add_timer_on will crash the whole system. Furthermore, if this timer

How should that happen? This is the timer callback function, which is
called from the timer code when the timer expired. It CANNOT be
pending at that point. The add_timer_on() in mce_timer_kick() might
cause that BUG to trigger, but definitely not the one here in the
timer callback.

> function triggers "WARN_ON(smp_processor_id() != data);", this timer

What causes the timer to be added on the wrong CPU in the first place?
The WARN_ON meriliy detects it after the fact.

> will be added on the other CPU, which means it loses the chance to
> decrement *cmci_storm_on_cpus* to zero to reenable the CMCI. Maybe
> this situation happens seldomly, but once it happens, CMCI will never
> be actived again after it is disabled.
> 
> > +void mce_timer_kick(unsigned long interval)
> > +{
> > +	struct timer_list *t = &__get_cpu_var(mce_timer);
> > +	unsigned long when = jiffies + interval;
> > +	unsigned long iv = __this_cpu_read(mce_next_interval);
> > +
> > +	if (time_before(when, t->expires) && timer_pending(t)) {
> > +		mod_timer(t, when);
> > +	} else if (!mce_next_interval) {
> > +		t->expires = round_jiffies(jiffies + iv);
> > +		add_timer_on(t, smp_processor_id());
> 
> I've changed "else if (!mce_next_interval)" to "else if (iv)", but

  else if (!iv) perhaps ?

> I still think it is not right. Imaging *when* is after t->expires and
> this timer is pending on the timer tree, so it will hit *else if*
> if iv is not zero(common situations), again, add_timer_on will trigger
> BUG_ON because this timer is pending.

See above. Aside of that I rewrote the code to be more clear. See
delta patch below.
 
> >  static void intel_threshold_interrupt(void)
> >  {
> > +	if (cmci_storm_detect())
> > +		return;
> >  	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
> >  	mce_notify_irq();
> >  }
> 
> I think cmci_storm_detect should be placed in the machine_check_poll,
> not out of it. Because machine_check_poll it the core execution logic
> for CMCI handling, in the meanwhile, poll timer and mce-inject module
> call machine_check_poll at any time. If poll timer or mce-inject run
> too quickly, the CMCI handler has trouble. Whereas, if
> cmci_storm_detect is in the machine_check_poll, this kind of possibility
> can be avoid.

No, it's wrong to put it into machine_check_poll(). 

machine_check_poll() is a generic functionality which has nothing to
do with CMCI storms. That CMCI storm/poll stuff is intel specific and
therefor the detection logic is in the intel specific interrupt
handler and nowhere else.

Thanks,

	tglx
---
 arch/x86/kernel/cpu/mcheck/mce.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1305,13 +1305,14 @@ void mce_timer_kick(unsigned long interv
 	unsigned long when = jiffies + interval;
 	unsigned long iv = __this_cpu_read(mce_next_interval);
 
-	if (time_before(when, t->expires) && timer_pending(t)) {
-		mod_timer(t, when);
-	} else if (!mce_next_interval) {
-		t->expires = round_jiffies(jiffies + iv);
+	if (timer_pending(t)) {
+		if (time_before(when, t->expires))
+			mod_timer(t, when);
+	} else {
+		t->expires = round_jiffies(jiffies + when);
 		add_timer_on(t, smp_processor_id());
 	}
-	if (interval < iv)
+	if (interval > iv)
 		__this_cpu_write(mce_next_interval, iv);
 }
 
--8323328-1653951612-1338903322=:3086--
