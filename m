Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab1FVO1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:27:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64279 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757743Ab1FVO1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:27:48 -0400
Message-ID: <4E01FC5B.9040809@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:29:47 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 04/22] KVM: x86: introduce vcpu_gva_to_gpa to cleanup the
 code
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:27:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:27:22,
	Serialize complete at 2011-06-22 22:27:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce vcpu_gva_to_gpa to translate the gva to gpa, we can use it
to cleanup the code between read emulation and write emulation

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb27be4..c29ef96 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3944,6 +3944,27 @@ out:
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
 
+static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
+			   gpa_t *gpa, struct x86_exception *exception,
+			   bool write)
+{
+	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
+
+	if (write)
+		access |= PFERR_WRITE_MASK;
+
+	*gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
+
+	if (*gpa == UNMAPPED_GVA)
+		return -1;
+
+	/* For APIC access vmexit */
+	if ((*gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
+		return 1;
+
+	return 0;
+}
+
 static int emulator_read_emulated_onepage(unsigned long addr,
 					  void *val,
 					  unsigned int bytes,
@@ -3951,7 +3972,7 @@ static int emulator_read_emulated_onepage(unsigned long addr,
 					  struct kvm_vcpu *vcpu)
 {
 	gpa_t gpa;
-	int handled;
+	int handled, ret;
 
 	if (vcpu->mmio_read_completed) {
 		memcpy(val, vcpu->mmio_data, bytes);
@@ -3961,13 +3982,12 @@ static int emulator_read_emulated_onepage(unsigned long addr,
 		return X86EMUL_CONTINUE;
 	}
 
-	gpa = kvm_mmu_gva_to_gpa_read(vcpu, addr, exception);
+	ret = vcpu_gva_to_gpa(vcpu, addr, &gpa, exception, false);
 
-	if (gpa == UNMAPPED_GVA)
+	if (ret < 0)
 		return X86EMUL_PROPAGATE_FAULT;
 
-	/* For APIC access vmexit */
-	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
+	if (ret)
 		goto mmio;
 
 	if (!kvm_read_guest(vcpu->kvm, gpa, val, bytes))
@@ -4043,15 +4063,15 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 					   struct kvm_vcpu *vcpu)
 {
 	gpa_t                 gpa;
-	int handled;
+	int handled, ret;
 
-	gpa = kvm_mmu_gva_to_gpa_write(vcpu, addr, exception);
+	ret = vcpu_gva_to_gpa(vcpu, addr, &gpa, exception, true);
 
-	if (gpa == UNMAPPED_GVA)
+	if (ret < 0)
 		return X86EMUL_PROPAGATE_FAULT;
 
 	/* For APIC access vmexit */
-	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
+	if (ret)
 		goto mmio;
 
 	if (emulator_write_phys(vcpu, gpa, val, bytes))
-- 
1.7.5.4

