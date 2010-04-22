Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab0DVGQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:16:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61207 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab0DVGQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:16:42 -0400
Message-ID: <4BCFE911.1030908@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:13:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/10] KVM MMU: allow more page become unsync at getting sp
 time
References: <4BCFE581.8050305@cn.fujitsu.com>
In-Reply-To: <4BCFE581.8050305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow more page become asynchronous at getting sp time, if need create new
shadow page for gfn but it not allow unsync(level > 0), we should unsync all
gfn's unsync page

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 13378e7..e0bb4d8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1199,6 +1199,23 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return 0;
 }
 
+static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
+{
+	struct hlist_head *bucket;
+	struct kvm_mmu_page *s;
+	struct hlist_node *node, *n;
+	unsigned index;
+
+	index = kvm_page_table_hashfn(gfn);
+	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
+	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
+		if (s->gfn != gfn || !s->unsync)
+			continue;
+		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
+		kvm_sync_page(vcpu, s, true);
+	}
+}
+
 struct mmu_page_path {
 	struct kvm_mmu_page *parent[PT64_ROOT_LEVEL-1];
 	unsigned int idx[PT64_ROOT_LEVEL-1];
@@ -1334,8 +1351,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			trace_kvm_mmu_get_page(sp, false);
 			return sp;
 		}
-	if (unsync_sp)
-		kvm_sync_page(vcpu, unsync_sp, true);
+
+	if (!direct && level > PT_PAGE_TABLE_LEVEL && unsync_sp)
+		kvm_sync_pages(vcpu, gfn);
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
-- 
1.6.1.2


