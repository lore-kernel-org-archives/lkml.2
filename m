Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab0G3RhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:37:07 -0400
Received: from kroah.org ([198.145.64.141]:36084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758822Ab0G3Rfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:48 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:12 2010
Message-Id: <20100730173112.658600809@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Avi Kivity <avi@redhat.com>
Subject: [110/140] KVM: SVM: Implement workaround for Erratum 383
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

This patch implements a workaround for AMD erratum 383 into
KVM. Without this erratum fix it is possible for a guest to
kill the host machine. This patch implements the suggested
workaround for hypervisors which will be published by the
next revision guide update.

[jan: fix overflow warning on i386]
[xiao: fix unused variable warning]

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
(cherry picked from commit 67ec66077799f2fef84b21a643912b179c422281)
---
 arch/x86/include/asm/msr-index.h |    1 
 arch/x86/kvm/svm.c               |   81 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -107,6 +107,7 @@
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
+#define MSR_AMD64_DC_CFG		0xc0011022
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
 #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/ftrace_event.h>
 
+#include <asm/tlbflush.h>
 #include <asm/desc.h>
 
 #include <asm/virtext.h>
@@ -54,6 +55,8 @@ MODULE_LICENSE("GPL");
 
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
+static bool erratum_383_found __read_mostly;
+
 static const u32 host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
 	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
@@ -297,6 +300,31 @@ static void skip_emulated_instruction(st
 	svm_set_interrupt_shadow(vcpu, 0);
 }
 
+static void svm_init_erratum_383(void)
+{
+	u32 low, high;
+	int err;
+	u64 val;
+
+	/* Only Fam10h is affected */
+	if (boot_cpu_data.x86 != 0x10)
+		return;
+
+	/* Use _safe variants to not break nested virtualization */
+	val = native_read_msr_safe(MSR_AMD64_DC_CFG, &err);
+	if (err)
+		return;
+
+	val |= (1ULL << 47);
+
+	low  = lower_32_bits(val);
+	high = upper_32_bits(val);
+
+	native_write_msr_safe(MSR_AMD64_DC_CFG, low, high);
+
+	erratum_383_found = true;
+}
+
 static int has_svm(void)
 {
 	const char *msg;
@@ -352,6 +380,8 @@ static int svm_hardware_enable(void *gar
 
 	wrmsrl(MSR_VM_HSAVE_PA, page_to_pfn(sd->save_area) << PAGE_SHIFT);
 
+	svm_init_erratum_383();
+
 	return 0;
 }
 
@@ -1255,8 +1285,59 @@ static int nm_interception(struct vcpu_s
 	return 1;
 }
 
+static bool is_erratum_383(void)
+{
+	int err, i;
+	u64 value;
+
+	if (!erratum_383_found)
+		return false;
+
+	value = native_read_msr_safe(MSR_IA32_MC0_STATUS, &err);
+	if (err)
+		return false;
+
+	/* Bit 62 may or may not be set for this mce */
+	value &= ~(1ULL << 62);
+
+	if (value != 0xb600000000010015ULL)
+		return false;
+
+	/* Clear MCi_STATUS registers */
+	for (i = 0; i < 6; ++i)
+		native_write_msr_safe(MSR_IA32_MCx_STATUS(i), 0, 0);
+
+	value = native_read_msr_safe(MSR_IA32_MCG_STATUS, &err);
+	if (!err) {
+		u32 low, high;
+
+		value &= ~(1ULL << 2);
+		low    = lower_32_bits(value);
+		high   = upper_32_bits(value);
+
+		native_write_msr_safe(MSR_IA32_MCG_STATUS, low, high);
+	}
+
+	/* Flush tlb to evict multi-match entries */
+	__flush_tlb_all();
+
+	return true;
+}
+
 static void svm_handle_mce(struct vcpu_svm *svm)
 {
+	if (is_erratum_383()) {
+		/*
+		 * Erratum 383 triggered. Guest state is corrupt so kill the
+		 * guest.
+		 */
+		pr_err("KVM: Guest triggered AMD Erratum 383\n");
+
+		set_bit(KVM_REQ_TRIPLE_FAULT, &svm->vcpu.requests);
+
+		return;
+	}
+
 	/*
 	 * On an #MC intercept the MCE handler is not called automatically in
 	 * the host. So do it by hand here.


