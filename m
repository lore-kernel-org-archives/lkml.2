Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1BVIMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:12:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58120 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab1BVIMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:12:17 -0500
Message-ID: <4D637019.9070208@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 16:13:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/7] KVM: cache the last used slot
References: <4D636EF8.60800@cn.fujitsu.com>
In-Reply-To: <4D636EF8.60800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:11:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:11:15,
	Serialize complete at 2011-02-22 16:11:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache the last used slot, the hit ratio is more than 35% during my test

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f1963a4..7fbae16 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -225,6 +225,7 @@ struct kvm_memslots {
 	int nmemslots;
 	int used_slots;
 	u64 generation;
+	struct kvm_memory_slot *slot_cache;
 	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
 	struct kvm_memory_slot *slots_sort[KVM_MEM_SLOTS_NUM];
 };
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0795426..4917d6a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -643,15 +643,21 @@ static struct kvm_memory_slot *search_memslots(struct kvm_memslots *slots,
 					       gfn_t gfn)
 {
 	int start = 0, end = slots->used_slots, idx;
-	struct kvm_memory_slot *memslot;
+	struct kvm_memory_slot *memslot = slots->slot_cache;
+
+	if (memslot && gfn >= memslot->base_gfn &&
+	      gfn < memslot->base_gfn + memslot->npages)
+		return memslot;
 
 	while (start < end) {
 		idx = (start + end) / 2;
 		memslot = slots->slots_sort[idx];
 
 		if (gfn >= memslot->base_gfn &&
-		      gfn < memslot->base_gfn + memslot->npages)
+		      gfn < memslot->base_gfn + memslot->npages) {
+			slots->slot_cache = memslot;
 			return memslot;
+		}
 
 		if (memslot->base_gfn < gfn)
 			start = idx + 1;
@@ -684,6 +690,7 @@ void memslots_updated(struct kvm_memslots *slots, int slot_id)
 	if (slot_id >= slots->nmemslots)
 		slots->nmemslots = slot_id + 1;
 	slots->generation++;
+	slots->slot_cache = NULL;
 	sort_memslots(slots);
 }
 
-- 
1.7.4

