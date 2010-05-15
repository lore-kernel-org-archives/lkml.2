Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0EOK4K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 06:56:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab0EOK4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 06:56:08 -0400
Message-ID: <4BEE7CF2.3080502@cn.fujitsu.com>
Date: Sat, 15 May 2010 18:52:34 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: MMU: don't write-protect if have new mapping to
 unsync page
References: <4BEE7CAC.5020603@cn.fujitsu.com>
In-Reply-To: <4BEE7CAC.5020603@cn.fujitsu.com>
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
 arch/x86/kvm/mmu.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 549255d..97c5217 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1336,7 +1336,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	unsigned index;
 	unsigned quadrant;
 	struct hlist_head *bucket;
-	struct kvm_mmu_page *sp;
+	struct kvm_mmu_page *sp, *unsync_sp = NULL;
 	struct hlist_node *node, *tmp;
 
 	role = vcpu->arch.mmu.base_role;
@@ -1355,20 +1355,30 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
 		if (sp->gfn == gfn) {
 			if (sp->unsync)
-				if (kvm_sync_page(vcpu, sp))
-					continue;
+				unsync_sp = sp;
 
 			if (sp->role.word != role.word)
 				continue;
 
+			if (!direct && unsync_sp &&
+			      kvm_sync_page_transient(vcpu, unsync_sp)) {
+				unsync_sp = NULL;
+				break;
+			}
+
 			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 			if (sp->unsync_children) {
 				set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
 				kvm_mmu_mark_parents_unsync(sp);
-			}
+			} else if (sp->unsync)
+				kvm_mmu_mark_parents_unsync(sp);
+
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


