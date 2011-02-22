Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1BVIIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:08:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60787 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1BVIIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:08:37 -0500
Message-ID: <4D636F3E.2040007@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 16:09:34 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/7] KVM: cleanup memslot_id function
References: <4D636EF8.60800@cn.fujitsu.com>
In-Reply-To: <4D636EF8.60800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:07:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:07:35,
	Serialize complete at 2011-02-22 16:07:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get memslot id from memslot->id directly

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    7 ++++++-
 virt/kvm/kvm_main.c      |   17 -----------------
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab42855..b1a7430 100644
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
@@ -388,6 +387,12 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
+
+static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
+{
+	return gfn_to_memslot(kvm, gfn)->id;
+}
+
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
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

