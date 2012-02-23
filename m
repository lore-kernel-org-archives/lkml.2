Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2BWLaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:30:16 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41833 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2BWLaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:30:14 -0500
Date: Thu, 23 Feb 2012 20:36:32 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 4/4] KVM: Remove unused dirty_bitmap_head and nr_dirty_pages
Message-Id: <20120223203632.cc79abe2.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we do neither double buffering nor heuristic selection of the
write protection method these are not needed anymore.

Note: some drivers have their own implementation of set_bit_le() and
making it generic needs a bit of work; so we use test_and_set_bit_le()
and will later replace it with generic set_bit_le().

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 include/linux/kvm_host.h |    2 --
 virt/kvm/kvm_main.c      |   14 +++++---------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 355e445..73c7d76 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -177,8 +177,6 @@ struct kvm_memory_slot {
 	unsigned long flags;
 	unsigned long *rmap;
 	unsigned long *dirty_bitmap;
-	unsigned long *dirty_bitmap_head;
-	unsigned long nr_dirty_pages;
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
 	int user_alloc;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e4431ad..27a1083 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -522,12 +522,11 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 		return;
 
 	if (2 * kvm_dirty_bitmap_bytes(memslot) > PAGE_SIZE)
-		vfree(memslot->dirty_bitmap_head);
+		vfree(memslot->dirty_bitmap);
 	else
-		kfree(memslot->dirty_bitmap_head);
+		kfree(memslot->dirty_bitmap);
 
 	memslot->dirty_bitmap = NULL;
-	memslot->dirty_bitmap_head = NULL;
 }
 
 /*
@@ -611,8 +610,7 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 
 /*
  * Allocation size is twice as large as the actual dirty bitmap size.
- * This makes it possible to do double buffering: see x86's
- * kvm_vm_ioctl_get_dirty_log().
+ * See x86's kvm_vm_ioctl_get_dirty_log() why this is needed.
  */
 static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
@@ -627,8 +625,6 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 	if (!memslot->dirty_bitmap)
 		return -ENOMEM;
 
-	memslot->dirty_bitmap_head = memslot->dirty_bitmap;
-	memslot->nr_dirty_pages = 0;
 #endif /* !CONFIG_S390 */
 	return 0;
 }
@@ -1476,8 +1472,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		if (!test_and_set_bit_le(rel_gfn, memslot->dirty_bitmap))
-			memslot->nr_dirty_pages++;
+		/* TODO: introduce set_bit_le() and use it */
+		test_and_set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
-- 
1.7.5.4

