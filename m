Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0KLDkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:40:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0KLDkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:40:21 -0500
Date: Thu, 11 Nov 2010 22:39:54 -0500
From: Don Zickus <dzickus@redhat.com>
To: DDD <dongdong.deng@windriver.com>
Cc: mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [V3 PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace()
 at the same time on SMP
Message-ID: <20101112033954.GL4823@redhat.com>
References: <1289473307-7965-1-git-send-email-dongdong.deng@windriver.com>
 <4CDCA895.7010806@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDCA895.7010806@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 10:38:13AM +0800, DDD wrote:
> Dongdong Deng wrote:
> >The spin_lock_debug/rcu_cpu_stall detector uses
> >trigger_all_cpu_backtrace() to dump cpu backtrace.
> >Therefore it is possible that trigger_all_cpu_backtrace()
> >could be called at the same time on different CPUs, which
> >triggers and 'unknown reason NMI' warning. The following case
> >illustrates the problem:
> >
> >      CPU1                    CPU2                     ...   CPU N
> >                       trigger_all_cpu_backtrace()
> >                       set "backtrace_mask" to cpu mask
> >                               |
> >generate NMI interrupts  generate NMI interrupts       ...
> >    \                          |                               /
> >     \                         |                              /
> >   The "backtrace_mask" will be cleaned by the first NMI interrupt
> >  at nmi_watchdog_tick(), then the following NMI interrupts generated
> >by other cpus's arch_trigger_all_cpu_backtrace() will be took as
> >unknown reason NMI interrupts.
> >
> >This patch uses a lock to avoid the problem, and stop the
> >arch_trigger_all_cpu_backtrace() calling to avoid dumping double cpu
> >backtrace info when there is already a trigger_all_cpu_backtrace()
> >in progress.
> >
> >Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
> >Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
> >CC: Thomas Gleixner <tglx@linutronix.de>
> >CC: Ingo Molnar <mingo@redhat.com>
> >CC: "H. Peter Anvin" <hpa@zytor.com>
> >CC: x86@kernel.org
> >CC: linux-kernel@vger.kernel.org
> >Signed-off-by: Don Zickus <dzickus@redhat.com>
> >---
> > arch/x86/kernel/apic/hw_nmi.c |   23 +++++++++++++++++++++++
> > arch/x86/kernel/apic/nmi.c    |   23 +++++++++++++++++++++++
> > 2 files changed, 46 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> >index cefd694..bfdab3b 100644
> >--- a/arch/x86/kernel/apic/hw_nmi.c
> >+++ b/arch/x86/kernel/apic/hw_nmi.c
> >@@ -26,9 +26,27 @@ u64 hw_nmi_get_sample_period(void)
> > }
> > #ifdef ARCH_HAS_NMI_WATCHDOG
> >+/* "in progress" flag of arch_trigger_all_cpu_backtrace */
> >+static unsigned long backtrace_flag;
> >+
> > void arch_trigger_all_cpu_backtrace(void)
> > {
> > 	int i;
> >+	unsigned long flags;
> >+
> >+	/*
> >+	 * Have to disable irq here, as the
> >+	 * arch_trigger_all_cpu_backtrace() could be
> >+	 * triggered by "spin_lock()" with irqs on.
> >+	 */
> >+	local_irq_save(flags);
> >+
> >+	if (test_and_set_bit(0, &backtrace_flag))
> >+		/*
> >+		 * If there is already a trigger_all_cpu_backtrace() in progress
> >+		 * (backtrace_flag == 1), don't output double cpu dump infos.
> >+		 */
> >+		goto out_restore_irq;
> > 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
> >@@ -41,6 +59,11 @@ void arch_trigger_all_cpu_backtrace(void)
> > 			break;
> > 		mdelay(1);
> > 	}
> >+
> >+	clear_bit(0, &backtrace_flag);
> 
> Hi Don,
> 
>    The clear_bit() on x86 (arch/x86/include/asm/bitops.h) does not
> contain a memory barrier, Could you add a memory barrier ops here
> when you pick up this patch?
> 
> +	clear_bit(0, &backtrace_flag);
> +	smp_mb__after_clear_bit();
> 
> 

Ok.  Thanks.

Cheers,
Don
