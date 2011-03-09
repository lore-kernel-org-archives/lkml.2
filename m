Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1CIHmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 02:42:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63431 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1CIHmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 02:42:04 -0500
Message-ID: <4D772F84.6090501@cn.fujitsu.com>
Date: Wed, 09 Mar 2011 15:43:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 3/4] KVM: MMU: introduce a common function to get no-dirty-logged
 slot
References: <4D772F10.3020302@cn.fujitsu.com>
In-Reply-To: <4D772F10.3020302@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-09 15:40:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-09 15:40:49,
	Serialize complete at 2011-03-09 15:40:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the code of pte_prefetch_gfn_to_memslot and mapping_level_dirty_bitmap

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   37 +++++++++++++++++--------------------
 1 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 88d3689..83171fd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -549,13 +549,23 @@ static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
 	return ret;
 }
 
-static bool mapping_level_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t large_gfn)
+static struct kvm_memory_slot *
+gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    bool no_dirty_log)
 {
 	struct kvm_memory_slot *slot;
-	slot = gfn_to_memslot(vcpu->kvm, large_gfn);
-	if (slot && slot->dirty_bitmap)
-		return true;
-	return false;
+
+	slot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID ||
+	      (no_dirty_log && slot->dirty_bitmap))
+		slot = NULL;
+
+	return slot;
+}
+
+static bool mapping_level_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t large_gfn)
+{
+	return gfn_to_memslot_dirty_bitmap(vcpu, large_gfn, true);
 }
 
 static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
@@ -2145,26 +2155,13 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
-static struct kvm_memory_slot *
-pte_prefetch_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn, bool no_dirty_log)
-{
-	struct kvm_memory_slot *slot;
-
-	slot = gfn_to_memslot(vcpu->kvm, gfn);
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID ||
-	      (no_dirty_log && slot->dirty_bitmap))
-		slot = NULL;
-
-	return slot;
-}
-
 static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				     bool no_dirty_log)
 {
 	struct kvm_memory_slot *slot;
 	unsigned long hva;
 
-	slot = pte_prefetch_gfn_to_memslot(vcpu, gfn, no_dirty_log);
+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
 	if (!slot) {
 		get_page(bad_page);
 		return page_to_pfn(bad_page);
@@ -2185,7 +2182,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	gfn_t gfn;
 
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
-	if (!pte_prefetch_gfn_to_memslot(vcpu, gfn, access & ACC_WRITE_MASK))
+	if (!gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK))
 		return -1;
 
 	ret = gfn_to_page_many_atomic(vcpu->kvm, gfn, pages, end - start);
-- 
1.7.4

