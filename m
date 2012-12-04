Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2LDI5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:57:38 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45645 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2LDI5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:57:34 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 09/10] KVM: VMX: fix unsyc vmcs status when cpu is going
 down
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org
Cc: sbw@mit.edu, tj@kernel.org, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 14:26:05 +0530
Message-ID: <20121204085600.25919.21644.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120408-5490-0000-0000-000002975748
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

When vcpu is scheduled to the different cpu, it should sent IPI to
the cpu which the vcpu ran to clear the vcpu->vmcs

It is safe since cpu-offline path can not concurrently run with
other cpu. After implementing stop_machine()-free, smp_call_function_sing
will return -ENXIO immediately when the target cpu is going down, that
means, we can load the vmcs but it is not cleared on target cpu and corrupt
per_cpu(loaded_vmcss_on_cpu, cpu). This bug can be triggered under this case:

# general protection fault: 0000 [#1] PREEMPT SMP

[......]

Call Trace:
 [<ffffffffa052980f>] kvm_arch_hardware_disable+0x1f/0x50 [kvm]
 [<ffffffffa050ef43>] hardware_disable_nolock+0x33/0x40 [kvm]
 [<ffffffffa050efa3>] kvm_cpu_hotplug+0x53/0xb0 [kvm]
 [<ffffffff81548b1d>] notifier_call_chain+0x4d/0x70
 [<ffffffff81517fe0>] ? spp_getpage+0xb0/0xb0
 [<ffffffff8108459e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff810599f0>] __cpu_notify+0x20/0x40
 [<ffffffff8151802e>] take_cpu_down+0x4e/0x90
 [<ffffffff810d184b>] cpu_stopper_thread+0xdb/0x1d0
 [<ffffffff8108b3ce>] ? finish_task_switch+0x4e/0xe0
 [<ffffffff815438d0>] ? __schedule+0x460/0x740
 [<ffffffff810d1770>] ? cpu_stop_signal_done+0x40/0x40
 [<ffffffff8107de30>] kthread+0xc0/0xd0
 [<ffffffff8107dd70>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff8154cc6c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107dd70>] ? flush_kthread_worker+0xb0/0xb0

Fix it by waiting for target vcpu to clear the vmcs

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kvm/vmx.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 95e502b..4fb4e51 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1019,8 +1019,15 @@ static void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
 	int cpu = loaded_vmcs->cpu;
 
 	if (cpu != -1)
-		smp_call_function_single(cpu,
-			 __loaded_vmcs_clear, loaded_vmcs, 1);
+		if (smp_call_function_single(cpu,
+			 __loaded_vmcs_clear, loaded_vmcs, 1))
+
+			/*
+			 * The target cpu is going down, we should
+			 * wait for it to clear the vmcs status.
+			 */
+			while (ACCESS_ONCE(loaded_vmcs->cpu) != -1)
+				cpu_relax();
 }
 
 static inline void vpid_sync_vcpu_single(struct vcpu_vmx *vmx)

