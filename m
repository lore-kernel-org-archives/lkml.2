Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0DYHDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 03:03:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61512 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0DYHDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 03:03:50 -0400
Message-ID: <4BD3E89C.8090307@cn.fujitsu.com>
Date: Sun, 25 Apr 2010 15:00:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/10] KVM MMU: split kvm_sync_page() function
References: <4BD3E306.4020202@cn.fujitsu.com>
In-Reply-To: <4BD3E306.4020202@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split kvm_sync_page() into kvm_sync_page() and kvm_sync_page_transient()
to clarify the code address Avi's suggestion

kvm_sync_page_transient() function only update shadow page but not mark
it sync and not write protect sp->gfn. it will be used by later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index abf8bd4..60a91c6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1196,6 +1196,23 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+static int kvm_sync_page_transient(struct kvm_vcpu *vcpu,
+				   struct kvm_mmu_page *sp)
+{
+	if (sp->role.cr4_pae != !!is_pae(vcpu)) {
+		kvm_mmu_zap_page(vcpu->kvm, sp);
+		return 1;
+	}
+
+	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
+		kvm_mmu_zap_page(vcpu->kvm, sp);
+		return 1;
+	}
+
+	kvm_mmu_flush_tlb(vcpu);
+	return 0;
+}
+
 static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	if (sp->role.cr4_pae != !!is_pae(vcpu)) {
-- 
1.6.1.2


