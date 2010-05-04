Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab0EDNB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:01:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43236 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab0EDNBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=RGc4uaNeQnxjm7bcr9/UFvq3cIJpLurrjTO4It4ptWEvO/xPSIpdwfxZqAh45Qzs36
         69av8NQbG0kTfwRqME06Un6brM2cmbd0VwO4cVwjOsRsfpiIVdWIbwJXXBhGM/EuFJPj
         whKx89wMyYPdek04jn5e7YxNG0IqWbYu409bc=
Date: Tue, 4 May 2010 22:01:22 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 3/12] KVM: introduce wrapper functions to create and
 destroy dirty bitmaps
Message-Id: <20100504220122.0706ea6b.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will change the vmalloc() and vfree() to do_mmap() and do_munmap() later.
This patch makes it easy and cleanup the code.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---
 virt/kvm/kvm_main.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7ab6312..3e3acad 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -435,6 +435,12 @@ out_err_nodisable:
 	return ERR_PTR(r);
 }
 
+static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
+{
+	vfree(memslot->dirty_bitmap);
+	memslot->dirty_bitmap = NULL;
+}
+
 /*
  * Free any memory in @free but not in @dont.
  */
@@ -447,7 +453,7 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 		vfree(free->rmap);
 
 	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
-		vfree(free->dirty_bitmap);
+		kvm_destroy_dirty_bitmap(free);
 
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES - 1; ++i) {
@@ -458,7 +464,6 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 	}
 
 	free->npages = 0;
-	free->dirty_bitmap = NULL;
 	free->rmap = NULL;
 }
 
@@ -520,6 +525,18 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
+{
+	unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(memslot);
+
+	memslot->dirty_bitmap = vmalloc(dirty_bytes);
+	if (!memslot->dirty_bitmap)
+		return -ENOMEM;
+
+	memset(memslot->dirty_bitmap, 0, dirty_bytes);
+	return 0;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -653,12 +670,8 @@ skip_lpage:
 
 	/* Allocate page dirty bitmap if needed */
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
-		unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(&new);
-
-		new.dirty_bitmap = vmalloc(dirty_bytes);
-		if (!new.dirty_bitmap)
+		if (kvm_create_dirty_bitmap(&new) < 0)
 			goto out_free;
-		memset(new.dirty_bitmap, 0, dirty_bytes);
 		/* destroy any largepage mappings for dirty tracking */
 		if (old.npages)
 			flush_shadow = 1;
-- 
1.7.0.4

