Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2HaQLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:11:33 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:34657 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab2HaQLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:11:32 -0400
Subject: [PATCH] KVM: VMX: invalidate vpid for invlpg instruction
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 31 Aug 2012 18:10:48 +0200
Message-ID: <1346429448.2823.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For processors that support VPIDs we should invalidate the page table entry
specified by the lineal address. For this purpose add support for individual
address invalidations.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/include/asm/vmx.h |    6 ++++--
 arch/x86/kvm/vmx.c         |   15 +++++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 74fcb96..20abb18 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -393,6 +393,7 @@ enum vmcs_field {
 #define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	(KVM_MEMORY_SLOTS + 2)
 
 #define VMX_NR_VPIDS				(1 << 16)
+#define VMX_VPID_EXTENT_INDIVIDUAL_ADDR         0
 #define VMX_VPID_EXTENT_SINGLE_CONTEXT		1
 #define VMX_VPID_EXTENT_ALL_CONTEXT		2
 
@@ -406,12 +407,13 @@ enum vmcs_field {
 #define VMX_EPTP_WB_BIT				(1ull << 14)
 #define VMX_EPT_2MB_PAGE_BIT			(1ull << 16)
 #define VMX_EPT_1GB_PAGE_BIT			(1ull << 17)
-#define VMX_EPT_AD_BIT					(1ull << 21)
+#define VMX_EPT_AD_BIT				(1ull << 21)
 #define VMX_EPT_EXTENT_INDIVIDUAL_BIT		(1ull << 24)
 #define VMX_EPT_EXTENT_CONTEXT_BIT		(1ull << 25)
 #define VMX_EPT_EXTENT_GLOBAL_BIT		(1ull << 26)
 
-#define VMX_VPID_EXTENT_SINGLE_CONTEXT_BIT      (1ull << 9) /* (41 - 32) */
+#define VMX_VPID_EXTENT_INDIVIDUAL_ADDR_BIT     (1ull << 8)  /* (40 - 32) */
+#define VMX_VPID_EXTENT_SINGLE_CONTEXT_BIT      (1ull << 9)  /* (41 - 32) */
 #define VMX_VPID_EXTENT_GLOBAL_CONTEXT_BIT      (1ull << 10) /* (42 - 32) */
 
 #define VMX_EPT_DEFAULT_GAW			3
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c00f03d..d87b22c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -816,6 +816,11 @@ static inline bool cpu_has_vmx_invept_global(void)
 	return vmx_capability.ept & VMX_EPT_EXTENT_GLOBAL_BIT;
 }
 
+static inline bool cpu_has_vmx_invvpid_individual_addr(void)
+{
+	return vmx_capability.vpid & VMX_VPID_EXTENT_INDIVIDUAL_ADDR_BIT;
+}
+
 static inline bool cpu_has_vmx_invvpid_single(void)
 {
 	return vmx_capability.vpid & VMX_VPID_EXTENT_SINGLE_CONTEXT_BIT;
@@ -1011,6 +1016,15 @@ static void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs)
 			loaded_vmcs->cpu, __loaded_vmcs_clear, loaded_vmcs, 1);
 }
 
+static inline void vpid_sync_vcpu_individual_addr(struct vcpu_vmx *vmx, gpa_t gpa)
+{
+	if (vmx->vpid == 0)
+		return;
+
+	if (cpu_has_vmx_invvpid_individual_addr())
+		__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR, vmx->vpid, gpa);
+}
+
 static inline void vpid_sync_vcpu_single(struct vcpu_vmx *vmx)
 {
 	if (vmx->vpid == 0)
@@ -4719,6 +4733,7 @@ static int handle_invlpg(struct kvm_vcpu *vcpu)
 	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 
 	kvm_mmu_invlpg(vcpu, exit_qualification);
+	vpid_sync_vcpu_individual_addr(to_vmx(vcpu), exit_qualification);
 	skip_emulated_instruction(vcpu);
 	return 1;
 }
-- 
1.7.4.1



