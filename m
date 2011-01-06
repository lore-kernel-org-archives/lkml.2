Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1AFAbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:50 -0500
Received: from kroah.org ([198.145.64.141]:36098 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab1AFAbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:45 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:09 2011
Message-Id: <20110106002309.606602619@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [137/152] KVM: SVM: Do not report xsave in supported cpuid
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 24d1b15f72abe3465e871d11cfc9dc34d1aab8b2 upstream.

To support xsave properly for the guest the SVM module need
software support for it. As long as this is not present do
not report the xsave as supported feature in cpuid.
As a side-effect this patch moves the bit() helper function
into the x86.h file so that it can be used in svm.c too.

KVM-Stable-Tag.
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |    4 ++++
 arch/x86/kvm/vmx.c |    5 -----
 arch/x86/kvm/x86.c |    5 -----
 arch/x86/kvm/x86.h |    5 +++++
 4 files changed, 9 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3383,6 +3383,10 @@ static void svm_cpuid_update(struct kvm_
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	switch (func) {
+	case 0x00000001:
+		/* Mask out xsave bit as long as it is not supported by SVM */
+		entry->ecx &= ~(bit(X86_FEATURE_XSAVE));
+		break;
 	case 0x80000001:
 		if (nested)
 			entry->ecx |= (1 << 2); /* Set SVM bit */
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4248,11 +4248,6 @@ static int vmx_get_lpage_level(void)
 		return PT_PDPE_LEVEL;
 }
 
-static inline u32 bit(int bitno)
-{
-	return 1 << (bitno & 31);
-}
-
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -153,11 +153,6 @@ struct kvm_stats_debugfs_item debugfs_en
 
 u64 __read_mostly host_xcr0;
 
-static inline u32 bit(int bitno)
-{
-	return 1 << (bitno & 31);
-}
-
 static void kvm_on_user_return(struct user_return_notifier *urn)
 {
 	unsigned slot;
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -65,6 +65,11 @@ static inline int is_paging(struct kvm_v
 	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
 }
 
+static inline u32 bit(int bitno)
+{
+	return 1 << (bitno & 31);
+}
+
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 


