Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2LDI5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:57:23 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:42357 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2LDI5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:57:19 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 08/10] KVM: VMX: fix memory order between loading vmcs and
 clearing vmcs
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org
Cc: sbw@mit.edu, tj@kernel.org, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 14:25:51 +0530
Message-ID: <20121204085547.25919.79009.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120408-9264-0000-0000-000002CAEDE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

vmcs->cpu indicates whether it exists on the target cpu, -1 means the vmcs
does not exist on any vcpu

If vcpu load vmcs with vmcs.cpu = -1, it can be directly added to cpu's percpu
list. The list can be corrupted if the cpu prefetch the vmcs's list before
reading vmcs->cpu. Meanwhile, we should remove vmcs from the list before
making vmcs->vcpu == -1 be visible

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kvm/vmx.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9dc562a..95e502b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1002,6 +1002,15 @@ static void __loaded_vmcs_clear(void *arg)
 	if (per_cpu(current_vmcs, cpu) == loaded_vmcs->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
 	list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
+
+	/*
+	 * we should ensure updating loaded_vmcs->loaded_vmcss_on_cpu_link
+	 * is before setting loaded_vmcs->vcpu to -1 which is done in
+	 * loaded_vmcs_init. Otherwise, other cpu can see vcpu = -1 fist
+	 * then adds the vmcs into percpu list before it is deleted.
+	 */
+	smp_wmb();
+
 	loaded_vmcs_init(loaded_vmcs);
 }
 
@@ -1537,6 +1546,14 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 		local_irq_disable();
+
+		/*
+		 * Read loaded_vmcs->cpu should be before fetching
+		 * loaded_vmcs->loaded_vmcss_on_cpu_link.
+		 * See the comments in __loaded_vmcs_clear().
+		 */
+		smp_rmb();
+
 		list_add(&vmx->loaded_vmcs->loaded_vmcss_on_cpu_link,
 			 &per_cpu(loaded_vmcss_on_cpu, cpu));
 		local_irq_enable();

