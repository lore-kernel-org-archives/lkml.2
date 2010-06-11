Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330Ab0FKNeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:34:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53458 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760244Ab0FKNeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:34:09 -0400
Message-ID: <4C123A7C.1070205@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 21:30:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 3/7] KVM: MMU: avoid double write protected in sync page path
References: <4C1239EE.3090904@cn.fujitsu.com>
In-Reply-To: <4C1239EE.3090904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sync page is already write protected in mmu_sync_children(), don't
write protected it again

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 21ab85b..2ffd673 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1216,6 +1216,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 		if ((sp)->gfn != (gfn) || (sp)->role.direct ||		\
 			(sp)->role.invalid) {} else
 
+/* @sp->gfn should be write-protected at the call site */
 static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			   struct list_head *invalid_list, bool clear_unsync)
 {
@@ -1224,11 +1225,8 @@ static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		return 1;
 	}
 
-	if (clear_unsync) {
-		if (rmap_write_protect(vcpu->kvm, sp->gfn))
-			kvm_flush_remote_tlbs(vcpu->kvm);
+	if (clear_unsync)
 		kvm_unlink_unsync_page(vcpu->kvm, sp);
-	}
 
 	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
-- 
1.6.1.2


