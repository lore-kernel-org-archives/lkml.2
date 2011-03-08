Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1CHSui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:50:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44360 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1CHSuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:50:37 -0500
Date: Tue, 8 Mar 2011 19:50:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Andi Kleen <andi@firstfloor.org>,
        Yong Zhang <yong.zhang@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mce.c related WARNING: at kernel/timer.c:983 del_timer_sync
Message-ID: <20110308185035.GF2499@one.firstfloor.org>
References: <AANLkTikupmQqgVd5Y6Tg0Cj-0TGUvzko8-VPs6_n_pKE@mail.gmail.com> <AANLkTi=7S60UjieW0_ZhX7F5gm39+c28Bdv=dRhPd=tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=7S60UjieW0_ZhX7F5gm39+c28Bdv=dRhPd=tQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > But, the actual reason is likely some MCE parameter change at boot causing
> > mce_restart() which in turn calls on_each_cpu mce_cpu_restart() which calls
> > del_timer_sync().
> 
> Seems we found a real bug.

I don't think it's a real bug actually because the timer cannot run at
the same time in this state. It's an interrupt which runs with irq disabled 
Really the only case where it could lead to deadlock is when the timer
runs with irqs on and the other interrupt with the del_timer_sync
interrupts it. So most likely your new WARN_ON() is catching
lots of innocent code.

That said I don't think we need the del_timer_sync in mce.c either
for the same reason.  The timer is always on the
same CPU, so it cannot run in parallel.

Remove del_timer_sync()s in mce.c

All the del_timers happen on the same CPUs as the actual timers, so
the timer handlers cannot run at the same time. Replace them
with plain del_timer()s.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d916183..ba7058a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1774,7 +1774,7 @@ static int mce_resume(struct sys_device *dev)
 
 static void mce_cpu_restart(void *data)
 {
-	del_timer_sync(&__get_cpu_var(mce_timer));
+	del_timer(&__get_cpu_var(mce_timer));
 	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
 	__mcheck_cpu_init_generic();
@@ -1793,7 +1793,7 @@ static void mce_disable_ce(void *all)
 	if (!mce_available(__this_cpu_ptr(&cpu_info)))
 		return;
 	if (all)
-		del_timer_sync(&__get_cpu_var(mce_timer));
+		del_timer(&__get_cpu_var(mce_timer));
 	cmci_clear();
 }
 
@@ -2075,7 +2075,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-		del_timer_sync(t);
+		del_timer(t);
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
 		break;
 	case CPU_DOWN_FAILED:

