Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab2LKOHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:07:08 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58305 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab2LKOHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:07:04 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 8/9] kvm,
 vmx: Add atomic synchronization with CPU Hotplug
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Dec 2012 19:35:32 +0530
Message-ID: <20121211140528.23621.52490.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com>
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121114-0260-0000-0000-000002479F04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preempt_disable() will no longer help prevent CPUs from going offline, once
stop_machine() gets removed from the CPU offline path. So use
get/put_online_cpus_atomic() in vmx_vcpu_load() to prevent CPUs from
going offline while clearing vmcs.

Reported-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Debugged-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kvm/vmx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f858159..d8a4cf1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1519,10 +1519,14 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
 
-	if (!vmm_exclusive)
+	if (!vmm_exclusive) {
 		kvm_cpu_vmxon(phys_addr);
-	else if (vmx->loaded_vmcs->cpu != cpu)
+	} else if (vmx->loaded_vmcs->cpu != cpu) {
+		/* Prevent any CPU from going offline */
+		get_online_cpus_atomic();
 		loaded_vmcs_clear(vmx->loaded_vmcs);
+		put_online_cpus_atomic();
+	}
 
 	if (per_cpu(current_vmcs, cpu) != vmx->loaded_vmcs->vmcs) {
 		per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;

