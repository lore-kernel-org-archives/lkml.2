Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab1CDLAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:00:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1CDLAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:00:15 -0500
Message-ID: <4D70C676.5050602@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 19:01:10 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 8/10] KVM: MMU: cleanup page alloc and free
References: <4D70C569.1030107@cn.fujitsu.com>
In-Reply-To: <4D70C569.1030107@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:59:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:59:05,
	Serialize complete at 2011-03-04 18:59:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __get_free_page instead of alloc_page and page_address,
using free_page instead of __free_page and virt_to_page

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8acb8e3..7d558b8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -379,15 +379,15 @@ static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
 static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
 				       int min)
 {
-	struct page *page;
+	void *page;
 
 	if (cache->nobjs >= min)
 		return 0;
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = alloc_page(GFP_KERNEL);
+		page = (void *)__get_free_page(GFP_KERNEL);
 		if (!page)
 			return -ENOMEM;
-		cache->objects[cache->nobjs++] = page_address(page);
+		cache->objects[cache->nobjs++] = page;
 	}
 	return 0;
 }
@@ -1043,9 +1043,9 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	ASSERT(is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
-	__free_page(virt_to_page(sp->spt));
+	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
-		__free_page(virt_to_page(sp->gfns));
+		free_page((unsigned long)sp->gfns);
 	kmem_cache_free(mmu_page_header_cache, sp);
 	kvm_mod_used_mmu_pages(kvm, -1);
 }
-- 
1.7.4

