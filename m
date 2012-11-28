Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab2K1MyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:54:25 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:41413 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2K1MyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:54:24 -0500
Message-ID: <50B60976.7020905@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 20:54:14 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/2] KVM: VMX: fix memory order between loading vmcs and clearing
 vmcs
References: <50B6093B.7040404@linux.vnet.ibm.com>
In-Reply-To: <50B6093B.7040404@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112812-1618-0000-0000-000002EFEA1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmcs->cpu indicates whether it exists on the target cpu, -1 means the vmcs
does not exist on any vcpu

If vcpu load vmcs with vmcs.cpu = -1, it can be directly added to cpu's percpu
list. The list can be corrupted if the cpu prefetch the vmcs's list before
reading vmcs->cpu. Meanwhile, we should remove vmcs from the list before
making vmcs->vcpu == -1 be visible

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 29e8f42..6056d88 100644
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
-- 
1.7.7.6

