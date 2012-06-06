Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2FFOqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:46:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:50884 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2FFOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:46:43 -0400
Date: Wed, 6 Jun 2012 16:46:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel
 machines
In-Reply-To: <alpine.LFD.2.02.1206061535410.3086@ionos>
Message-ID: <alpine.LFD.2.02.1206061641450.3086@ionos>
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com> <alpine.LFD.2.02.1206042158200.3086@ionos> <4FCDF1C8.9020007@linux.intel.com> <alpine.LFD.2.02.1206051503560.3086@ionos>
 <4FCF0500.9050704@linux.intel.com> <alpine.LFD.2.02.1206061056520.3086@ionos> <alpine.LFD.2.02.1206061215250.3086@ionos> <4FCF4BFE.6090103@linux.intel.com> <alpine.LFD.2.02.1206061535410.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2481929-1338993998=:3086"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2481929-1338993998=:3086
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 6 Jun 2012, Thomas Gleixner wrote:

> On Wed, 6 Jun 2012, Chen Gong wrote:
> > 于 2012/6/6 18:23, Thomas Gleixner 写道:
> > I think you mean
> > 
> > -               del_timer_sync(t);
> >                 smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
> > +		del_timer_sync(t);
> >                 break;
> 
> No I meant it the way I wrote, but as you don't execute hotplug it's
> irrelevant.
> 
> So the obvious candidate is the mce-injection code, which was
> obviously never tested with DEBUG_PREEMPT enabled.
> 
> raise_local() can be called with preemption enabled from
> raise_mce(). Fix for that below.
> 
> Though I can't see how that would do anything with the timer.

I think I found it. Do you have CONFIG_NO_HZ enabled? Then mod_timer()
will try to move the timer to a different cpu, when the cpu which is
running that code is idle. Bloody obvious :(

I'll send out a combo patch with all changes so far later.

Thanks,
	
	tglx

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1307,7 +1307,7 @@ void mce_timer_kick(unsigned long interv
 
 	if (timer_pending(t)) {
 		if (time_before(when, t->expires))
-			mod_timer(t, when);
+			mod_timer_pinned(t, when);
 	} else {
 		t->expires = round_jiffies(when);
 		add_timer_on(t, smp_processor_id());
--8323328-2481929-1338993998=:3086--
