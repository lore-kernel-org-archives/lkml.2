Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0EFJdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:33:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60637 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756123Ab0EFJdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:33:39 -0400
Message-ID: <4BE28C36.705@cn.fujitsu.com>
Date: Thu, 06 May 2010 17:30:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/9] KVM MMU: split kvm_sync_page() function
References: <4BE2818A.5000301@cn.fujitsu.com>
In-Reply-To: <4BE2818A.5000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split kvm_sync_page() into kvm_sync_page() and kvm_sync_page_transient()
to clarify the code address Avi's suggestion

kvm_sync_page_transient() function only update shadow page but not mark
it sync and not write protect sp->gfn. it will be used by later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index de99638..72238ec 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1196,16 +1196,20 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
-static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			   bool clear_unsync)
 {
 	if (sp->role.cr4_pae != !!is_pae(vcpu)) {
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 		return 1;
 	}
 
-	if (rmap_write_protect(vcpu->kvm, sp->gfn))
-		kvm_flush_remote_tlbs(vcpu->kvm);
-	kvm_unlink_unsync_page(vcpu->kvm, sp);
+	if (clear_unsync) {
+		if (rmap_write_protect(vcpu->kvm, sp->gfn))
+			kvm_flush_remote_tlbs(vcpu->kvm);
+		kvm_unlink_unsync_page(vcpu->kvm, sp);
+	}
+
 	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 		return 1;
@@ -1215,6 +1219,22 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	return 0;
 }
 
+static void mmu_convert_notrap(struct kvm_mmu_page *sp);
+static int kvm_sync_page_transient(struct kvm_vcpu *vcpu,
+				   struct kvm_mmu_page *sp)
+{
+	int ret;
+
+	ret = __kvm_sync_page(vcpu, sp, false);
+	mmu_convert_notrap(sp);
+	return ret;
+}
+
+static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	return __kvm_sync_page(vcpu, sp, true);
+}
+
 struct mmu_page_path {
 	struct kvm_mmu_page *parent[PT64_ROOT_LEVEL-1];
 	unsigned int idx[PT64_ROOT_LEVEL-1];
-- 
1.6.1.2



