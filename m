Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2LJRcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:32:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab2LJRcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:32:52 -0500
Subject: [PATCH v2 02/10] kvm: Check userspace_addr when modifying a memory
 slot
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 10 Dec 2012 10:32:51 -0700
Message-ID: <20121210173251.10461.58971.stgit@bling.home>
In-Reply-To: <20121210171417.10461.20079.stgit@bling.home>
References: <20121210171417.10461.20079.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API documents that only flags and guest physical memory space can
be modified on an existing slot, but we don't enforce that the
userspace address cannot be modified.  Instead we just ignore it.
This means that a user may think they've successfully moved both the
guest and user addresses, when in fact only the guest address changed.
Check and error instead.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 virt/kvm/kvm_main.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e426704..6e9d3f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -779,13 +779,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	r = -ENOMEM;
 
-	/* Allocate if a slot is being created */
+	/*
+	 * Allocate if a slot is being created.  If modifying a slot,
+	 * the userspace_addr cannot change.
+	 */
 	if (!old.npages) {
 		new.user_alloc = user_alloc;
 		new.userspace_addr = mem->userspace_addr;
 
 		if (kvm_arch_create_memslot(&new, npages))
 			goto out_free;
+	} else if (npages && mem->userspace_addr != old.userspace_addr) {
+		r = -EINVAL;
+		goto out_free;
 	}
 
 	/* Allocate page dirty bitmap if needed */

