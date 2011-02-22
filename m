Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1BVIKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:10:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1BVIKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:10:21 -0500
Message-ID: <4D636FA4.4000602@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 16:11:16 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: introduce memslots_updated function
References: <4D636EF8.60800@cn.fujitsu.com>
In-Reply-To: <4D636EF8.60800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:09:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:09:18,
	Serialize complete at 2011-02-22 16:09:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce memslots_updated function which is called after memslots updated

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c       |    2 +-
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   15 +++++++++------
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17af71d..888f0b0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3252,7 +3252,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 			goto out;
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
 		slots->memslots[log->slot].dirty_bitmap = dirty_bitmap;
-		slots->generation++;
+		memslots_updated(slots, log->slot);
 
 		old_slots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 865486f..15ff818 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -331,6 +331,7 @@ int is_error_pfn(pfn_t pfn);
 int is_hwpoison_pfn(pfn_t pfn);
 int is_fault_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
+void memslots_updated(struct kvm_memslots *slots, int slot_id);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
 			  int user_alloc);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e3e744c..e1c6e24 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -623,6 +623,13 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 }
 #endif /* !CONFIG_S390 */
 
+void memslots_updated(struct kvm_memslots *slots, int slot_id)
+{
+	if (slot_id >= slots->nmemslots)
+		slots->nmemslots = slot_id + 1;
+	slots->generation++;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -768,10 +775,8 @@ skip_lpage:
 		if (!slots)
 			goto out_free;
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-		if (mem->slot >= slots->nmemslots)
-			slots->nmemslots = mem->slot + 1;
-		slots->generation++;
 		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
+		memslots_updated(slots, mem->slot);
 
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
@@ -803,9 +808,6 @@ skip_lpage:
 	if (!slots)
 		goto out_free;
 	memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-	if (mem->slot >= slots->nmemslots)
-		slots->nmemslots = mem->slot + 1;
-	slots->generation++;
 
 	/* actual memory is freed via old in kvm_free_physmem_slot below */
 	if (!npages) {
@@ -816,6 +818,7 @@ skip_lpage:
 	}
 
 	slots->memslots[mem->slot] = new;
+	memslots_updated(slots, mem->slot);
 	old_memslots = kvm->memslots;
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);
-- 
1.7.4

