Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1CIHlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 02:41:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54773 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab1CIHlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 02:41:07 -0500
Message-ID: <4D772F47.2010408@cn.fujitsu.com>
Date: Wed, 09 Mar 2011 15:41:59 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 2/4] KVM: cleanup memslot_id function
References: <4D772F10.3020302@cn.fujitsu.com>
In-Reply-To: <4D772F10.3020302@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-09 15:39:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-09 15:39:52,
	Serialize complete at 2011-03-09 15:39:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get memslot id from memslot->id directly

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    6 +++++-
 virt/kvm/kvm_main.c      |   17 -----------------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab42855..57d7092 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -365,7 +365,6 @@ pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
 pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn);
-int memslot_id(struct kvm *kvm, gfn_t gfn);
 void kvm_release_pfn_dirty(pfn_t);
 void kvm_release_pfn_clean(pfn_t pfn);
 void kvm_set_pfn_dirty(pfn_t pfn);
@@ -597,6 +596,11 @@ static inline void kvm_guest_exit(void)
 	current->flags &= ~PF_VCPU;
 }
 
+static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
+{
+	return gfn_to_memslot(kvm, gfn)->id;
+}
+
 static inline unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
 					       gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1fa0d29..cf90f28 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -997,23 +997,6 @@ out:
 	return size;
 }
 
-int memslot_id(struct kvm *kvm, gfn_t gfn)
-{
-	int i;
-	struct kvm_memslots *slots = kvm_memslots(kvm);
-	struct kvm_memory_slot *memslot = NULL;
-
-	for (i = 0; i < slots->nmemslots; ++i) {
-		memslot = &slots->memslots[i];
-
-		if (gfn >= memslot->base_gfn
-		    && gfn < memslot->base_gfn + memslot->npages)
-			break;
-	}
-
-	return memslot - slots->memslots;
-}
-
 static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 				     gfn_t *nr_pages)
 {
-- 
1.7.4

