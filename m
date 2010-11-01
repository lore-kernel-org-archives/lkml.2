Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab0KAPqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:46:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab0KAPqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:46:01 -0400
Date: Mon, 1 Nov 2010 11:45:36 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Eric Paris <eparis@redhat.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: using smp_processor_id() in preemptible
 arch_trigger_all_cpu_backtrace_handler
Message-ID: <20101101154536.GT4823@redhat.com>
References: <4CCEB51C.7010901@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCEB51C.7010901@web.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 01:39:56PM +0100, Jan Kiszka wrote:
> Hi,
> 
> I was getting this BUG while running into a GPF:
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: qemu-system-x86/2248
> caller is arch_trigger_all_cpu_backtrace_handler+0x1d/0xf7
> Pid: 2248, comm: qemu-system-x86 Not tainted 2.6.36+ #12
> Call Trace:
> [<ffffffff81203194>] debug_smp_processor_id+0xd8/0xf4
> [<ffffffff813803ab>] arch_trigger_all_cpu_backtrace_handler+0x1d/0xf7
> [<ffffffff81381e64>] notifier_call_chain+0xa4/0xdb
> [<ffffffff81381efe>] __atomic_notifier_call_chain+0x63/0x95
> [<ffffffff81381e9b>] ? __atomic_notifier_call_chain+0x0/0x95
> [<ffffffff81381cfb>] ? sub_preempt_count+0x97/0xaa
> [<ffffffff8121de8c>] ? pfn_to_dma_pte+0x73/0x190
> [<ffffffff81381f44>] atomic_notifier_call_chain+0x14/0x16
> [<ffffffff81381f74>] notify_die+0x2e/0x30
> [<ffffffff8137f498>] do_general_protection+0x121/0x142
> [<ffffffff81002df2>] system_call_fastpath+0x16/0x1b

<snip>

> 
> I guess this is not intended to trigger here, specifically as it showed
> up first and may be misinterpreted as the core of the issue.

Heh.  Yeah when I migrated the code, I completely forgot the notifier
chain could be called from a preemptible context (ie not NMI).

This patch should fix it and I think it is the correct fix.  Let me know
how it works out.

Cheers,
Don

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index c7c9ae4..1bdd0b5 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -63,7 +63,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 {
 	struct die_args *args = __args;
 	struct pt_regs *regs;
-	int cpu = smp_processor_id();
+	int cpu;
 
 	switch (cmd) {
 	case DIE_NMI:
@@ -74,6 +74,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 	}
 
 	regs = args->regs;
+	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
 		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
