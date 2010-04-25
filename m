Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0DYHEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 03:04:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab0DYHEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 03:04:06 -0400
Message-ID: <4BD3E8AB.4020704@cn.fujitsu.com>
Date: Sun, 25 Apr 2010 15:00:59 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 6/10] KVM MMU: don't write-protect if have new mapping
 to unsync page
References: <4BD3E306.4020202@cn.fujitsu.com>
In-Reply-To: <4BD3E306.4020202@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two cases maybe happen in kvm_mmu_get_page() function:

- one case is, the goal sp is already in cache, if the sp is unsync,
  we only need update it to assure this mapping is valid, but not
  mark it sync and not write-protect sp->gfn since it not broke unsync
  rule(one shadow page for a gfn)

- another case is, the goal sp not existed, we need create a new sp
  for gfn, i.e, gfn (may)has another shadow page, to keep unsync rule,
  we should sync(mark sync and write-protect) gfn's unsync shadow page.
  After enabling multiple unsync shadows, we sync those shadow pages
  only when the new sp not allow to become unsync(also for the unsyc
  rule, the new rule is: allow all pte page become unsync)

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 60a91c6..b946a5f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1330,7 +1330,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	unsigned index;
 	unsigned quadrant;
 	struct hlist_head *bucket;
-	struct kvm_mmu_page *sp;
+	struct kvm_mmu_page *sp, *unsync_sp = NULL;
 	struct hlist_node *node, *tmp;
 
 	role = vcpu->arch.mmu.base_role;
@@ -1349,12 +1349,17 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
 		if (sp->gfn == gfn) {
 			if (sp->unsync)
-				if (kvm_sync_page(vcpu, sp))
-					continue;
+				unsync_sp = sp;
 
 			if (sp->role.word != role.word)
 				continue;
 
+			if (unsync_sp &&
+			      kvm_sync_page_transient(vcpu, unsync_sp)) {
+				unsync_sp = NULL;
+				break;
+			}
+
 			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 			if (sp->unsync_children) {
 				set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
@@ -1363,6 +1368,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			trace_kvm_mmu_get_page(sp, false);
 			return sp;
 		}
+	if (!direct && unsync_sp)
+		kvm_sync_page(vcpu, unsync_sp);
+
 	++vcpu->kvm->stat.mmu_cache_miss;
 	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
 	if (!sp)
-- 
1.6.1.2


