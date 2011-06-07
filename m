Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1FGNBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:01:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50029 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab1FGNBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:01:36 -0400
Message-ID: <4DEE21AE.9050703@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 21:03:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 09/15] KVM: MMU: split kvm_mmu_free_page
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 21:01:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 21:01:25,
	Serialize complete at 2011-06-07 21:01:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split kvm_mmu_free_page to kvm_mmu_free_lock_parts and
kvm_mmu_free_unlock_parts

One is used to free the parts which is under mmu lock and the other is
used to free the parts which can allow be freed out of mmu lock

It is used by later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 43e7ca1..9f3a746 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1039,17 +1039,27 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_lock_parts(struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
-	list_del(&sp->link);
-	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
+}
+
+static void kvm_mmu_free_unlock_parts(struct kvm_mmu_page *sp)
+{
+	list_del(&sp->link);
+	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
+static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+{
+	kvm_mmu_free_lock_parts(sp);
+	kvm_mmu_free_unlock_parts(sp);
+}
+
 static unsigned kvm_page_table_hashfn(gfn_t gfn)
 {
 	return gfn & ((1 << KVM_MMU_HASH_SHIFT) - 1);
-- 
1.7.4.4

