Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab0JPEeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:34:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34228 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0JPEen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nyPEYL49G1toLm3WGopVtvBwpKzcZozydEZ/geZrcl6Hly66Qd/EVnFEGwnXiVn1pn
         rpaxmgrF5Uu4BlgfX8RkiHCdiooDP/JrH4DPHst9roknWZvtnCmWq0gyVSYFwa4sMF8a
         v6tdrveoO4aVVdCD09jOJZOyUeZt4ly4LX+AI=
Date: Sat, 16 Oct 2010 12:34:55 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org
Subject: [PATCH 2/2] kvm: use vzalloc instead of vmalloc
Message-ID: <20101016043455.GB3177@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vzalloc instead of vmalloc in kvm code.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 arch/x86/kvm/x86.c  |    3 +--
 virt/kvm/kvm_main.c |   13 ++++---------
 2 files changed, 5 insertions(+), 11 deletions(-)

--- linux-2.6.orig/virt/kvm/kvm_main.c	2010-09-25 21:18:06.000000000 +0800
+++ linux-2.6/virt/kvm/kvm_main.c	2010-10-16 11:26:05.106672156 +0800
@@ -604,13 +604,11 @@ int __kvm_set_memory_region(struct kvm *
 	/* Allocate if a slot is being created */
 #ifndef CONFIG_S390
 	if (npages && !new.rmap) {
-		new.rmap = vmalloc(npages * sizeof(*new.rmap));
+		new.rmap = vzalloc(npages * sizeof(*new.rmap));
 
 		if (!new.rmap)
 			goto out_free;
 
-		memset(new.rmap, 0, npages * sizeof(*new.rmap));
-
 		new.user_alloc = user_alloc;
 		new.userspace_addr = mem->userspace_addr;
 	}
@@ -633,14 +631,12 @@ int __kvm_set_memory_region(struct kvm *
 			     >> KVM_HPAGE_GFN_SHIFT(level));
 		lpages -= base_gfn >> KVM_HPAGE_GFN_SHIFT(level);
 
-		new.lpage_info[i] = vmalloc(lpages * sizeof(*new.lpage_info[i]));
+		new.lpage_info[i] = vzalloc(lpages *
+					sizeof(*new.lpage_info[i]));
 
 		if (!new.lpage_info[i])
 			goto out_free;
 
-		memset(new.lpage_info[i], 0,
-		       lpages * sizeof(*new.lpage_info[i]));
-
 		if (base_gfn & (KVM_PAGES_PER_HPAGE(level) - 1))
 			new.lpage_info[i][0].write_count = 1;
 		if ((base_gfn+npages) & (KVM_PAGES_PER_HPAGE(level) - 1))
@@ -663,10 +659,9 @@ skip_lpage:
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
 		unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(&new);
 
-		new.dirty_bitmap = vmalloc(dirty_bytes);
+		new.dirty_bitmap = vzalloc(dirty_bytes);
 		if (!new.dirty_bitmap)
 			goto out_free;
-		memset(new.dirty_bitmap, 0, dirty_bytes);
 		/* destroy any largepage mappings for dirty tracking */
 		if (old.npages)
 			flush_shadow = 1;
--- linux-2.6.orig/arch/x86/kvm/x86.c	2010-08-29 08:47:02.000000000 +0800
+++ linux-2.6/arch/x86/kvm/x86.c	2010-10-16 11:22:52.826666511 +0800
@@ -2917,10 +2917,9 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 		spin_unlock(&kvm->mmu_lock);
 
 		r = -ENOMEM;
-		dirty_bitmap = vmalloc(n);
+		dirty_bitmap = vzalloc(n);
 		if (!dirty_bitmap)
 			goto out;
-		memset(dirty_bitmap, 0, n);
 
 		r = -ENOMEM;
 		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
