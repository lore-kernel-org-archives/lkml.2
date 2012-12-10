Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2LJRcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:32:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab2LJRcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:32:46 -0500
Subject: [PATCH v2 01/10] kvm: Restrict non-existing slot state transitions
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 10 Dec 2012 10:32:45 -0700
Message-ID: <20121210173245.10461.94547.stgit@bling.home>
In-Reply-To: <20121210171417.10461.20079.stgit@bling.home>
References: <20121210171417.10461.20079.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API documentation states:

	When changing an existing slot, it may be moved in the guest
	physical memory space, or its flags may be modified.

An "existing slot" requires a non-zero npages (memory_size).  The only
transition we should therefore allow for a non-existing slot should be
to create the slot, which includes setting a non-zero memory_size.  We
currently allow calls to modify non-existing slots, which is pointless,
confusing, and possibly wrong.

With this we know that the invalidation path of __kvm_set_memory_region
is always for a delete or move and never for adding a zero size slot.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 virt/kvm/kvm_main.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6e8fa7e..e426704 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -753,10 +753,15 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new.npages = npages;
 	new.flags = mem->flags;
 
-	/* Disallow changing a memory slot's size. */
+	/*
+	 * Disallow changing a memory slot's size or changing anything about
+	 * zero sized slots that doesn't involve making them non-zero.
+	 */
 	r = -EINVAL;
 	if (npages && old.npages && npages != old.npages)
 		goto out_free;
+	if (!npages && !old.npages)
+		goto out_free;
 
 	/* Check for overlaps */
 	r = -EEXIST;
@@ -775,7 +780,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	r = -ENOMEM;
 
 	/* Allocate if a slot is being created */
-	if (npages && !old.npages) {
+	if (!old.npages) {
 		new.user_alloc = user_alloc;
 		new.userspace_addr = mem->userspace_addr;
 

