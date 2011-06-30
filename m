Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab1F3IVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:21:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56486 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758739Ab1F3IVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:21:17 -0400
Message-ID: <4E0C326E.5070604@cn.fujitsu.com>
Date: Thu, 30 Jun 2011 16:23:10 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 09/19] KVM: MMU: split kvm_mmu_free_page
References: <4E0C3178.2080603@cn.fujitsu.com>
In-Reply-To: <4E0C3178.2080603@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:20:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:20:44,
	Serialize complete at 2011-06-30 16:20:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split kvm_mmu_free_page to kvm_mmu_isolate_page and
kvm_mmu_free_page

One is used to remove the page from cache under mmu lock and the other is
used to free page table out of mmu lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 91d3069..2f8543c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1039,14 +1039,28 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+/*
+ * Remove the sp from shadow page cache, after call it,
+ * we can not find this sp from the cache, and the shadow
+ * page table is still valid.
+ * It should be under the protection of mmu lock.
+ */
+static void kvm_mmu_isolate_page(struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
-	list_del(&sp->link);
-	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
+}
+
+/*
+ * Free the shadow page table and the sp, we can do it
+ * out of the protection of mmu lock.
+ */
+static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+{
+	list_del(&sp->link);
+	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -1678,6 +1692,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	do {
 		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
 		WARN_ON(!sp->role.invalid || sp->root_count);
+		kvm_mmu_isolate_page(sp);
 		kvm_mmu_free_page(sp);
 	} while (!list_empty(invalid_list));
 
-- 
1.7.5.4

