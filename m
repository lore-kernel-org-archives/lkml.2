Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0ETKwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 06:52:53 -0400
Received: from www.tglx.de ([62.245.132.106]:49874 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab0ETKww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 06:52:52 -0400
Date: Thu, 20 May 2010 12:52:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
cc: Sujit K M <sjt.kar@gmail.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RT (2.6.33-rt17) disabled printk-to-console after
 console_init
In-Reply-To: <201005201423.09075@zigzag.lvk.cs.msu.su>
Message-ID: <alpine.LFD.2.00.1005201225170.3368@localhost.localdomain>
References: <AANLkTimxLHngWamPvWt-htGoZ7Nub72rvJAnmGtw4Eqw@mail.gmail.com> <AANLkTil18TnOR9D-dSFsSFA74Q4UFnldrGLhG1H4jwhf@mail.gmail.com> <alpine.LFD.2.00.1005201142360.3368@localhost.localdomain> <201005201423.09075@zigzag.lvk.cs.msu.su>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Nikita V. Youshchenko wrote:

> > > >>> Well, obviously it's unsafe if you remove safety checks. And if
> > > >>> you care to look at the changelog of kernel/printk.c you'll find
> > > >>> out why.
> > > >>
> > > >> Hmm... did a quick look and could not find anything related there.
> > > >> Could you please give a pointer?
> >
> > Gah, yes. The changelog of the commit is not really helpful. Let me
> > explain:
> >
> > The console drivers might take locks, which are converted to "sleeping
> > locks" in preempt-rt. As a result we cannot call into those drivers
> > from atomic contexts. And that's what the checks in the printk code
> > prevent.
> 
> I've already understood that when looking at that code some weeks ago.
> 
> Still questions:
> 
> 1) why does that prevent klogd from working?

Patch below.
 
> 2) why does print not pass to non-CON_ATOMIC even if called from non-atomic 
> context?

That's a good question. We call release_console_mutex() always with
interrupts disabled from printk(), so that atomic check triggers. Have
to look deeper to figure out whether we can enable interupts there,
probably not, but with the klogd fix this should not matter.
 
> 3) I believe that 8250 serial driver is aware of preempt-rt.
> Could you please comment on my "2.6.33.2-rt13: RFC: fix serial console" 
> post to linux-rt-users list 
> (http://eeek.borgchat.net/lists/linux-rt-users/msg05569.html)

While that can work due to the trylock, it can introduce massive
latencies just in case some driver reports a status change or what
ever.

Thanks,

	tglx
----
Subject: printk: Fix missing klogd wakeup
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 20 May 2010 12:33:00 +0200

The RT check for !in_atomic() && !irqs_disabled()) to prevent the
klogd wakeup is actually bogus as wake_up_klogd() is just setting the
needs print flag which is then evaluated from printk_tick() which does
the actual wakeup.

Remove the double raw_spin_unlock_irqrestore(&logbuf_lock, flags)
while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/printk.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: linux-2.6-tip/kernel/printk.c
===================================================================
--- linux-2.6-tip.orig/kernel/printk.c
+++ linux-2.6-tip/kernel/printk.c
@@ -1084,18 +1084,8 @@ void release_console_mutex(void)
 #endif
 	}
 	console_locked = 0;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 	mutex_unlock(&console_mutex);
 
-	/*
-	 * On PREEMPT_RT kernels __wake_up may sleep, so wake syslogd
-	 * up only if we are in a preemptible section. We normally dont
-	 * printk from non-preemptible sections so this is for the emergency
-	 * case only.
-	 */
-#ifdef CONFIG_PREEMPT_RT
-	if (!in_atomic() && !irqs_disabled())
-#endif
 	if (wake_klogd)
 		wake_up_klogd();
 }


