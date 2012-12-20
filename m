Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2LTBo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:44:27 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:47595 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2LTBoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:44:21 -0500
Date: Wed, 19 Dec 2012 17:44:29 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] ksm: make rmap walks more scalable
In-Reply-To: <alpine.LNX.2.00.1212191735530.25409@eggly.anvils>
Message-ID: <alpine.LNX.2.00.1212191742440.25409@eggly.anvils>
References: <alpine.LNX.2.00.1212191735530.25409@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rmap walks in ksm.c are like those in rmap.c:
they can safely be done with anon_vma_lock_read().

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/ksm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- 3.7+git/mm/ksm.c	2012-12-16 16:35:08.752441527 -0800
+++ linux/mm/ksm.c	2012-12-19 16:58:05.292145790 -0800
@@ -1624,7 +1624,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		anon_vma_lock_write(anon_vma);
+		anon_vma_lock_read(anon_vma);
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       0, ULONG_MAX) {
 			vma = vmac->vma;
@@ -1648,7 +1648,7 @@ again:
 			if (!search_new_forks || !mapcount)
 				break;
 		}
-		anon_vma_unlock(anon_vma);
+		anon_vma_unlock_read(anon_vma);
 		if (!mapcount)
 			goto out;
 	}
@@ -1678,7 +1678,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		anon_vma_lock_write(anon_vma);
+		anon_vma_lock_read(anon_vma);
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       0, ULONG_MAX) {
 			vma = vmac->vma;
@@ -1697,11 +1697,11 @@ again:
 			ret = try_to_unmap_one(page, vma,
 					rmap_item->address, flags);
 			if (ret != SWAP_AGAIN || !page_mapped(page)) {
-				anon_vma_unlock(anon_vma);
+				anon_vma_unlock_read(anon_vma);
 				goto out;
 			}
 		}
-		anon_vma_unlock(anon_vma);
+		anon_vma_unlock_read(anon_vma);
 	}
 	if (!search_new_forks++)
 		goto again;
@@ -1731,7 +1731,7 @@ again:
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
 
-		anon_vma_lock_write(anon_vma);
+		anon_vma_lock_read(anon_vma);
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       0, ULONG_MAX) {
 			vma = vmac->vma;
@@ -1749,11 +1749,11 @@ again:
 
 			ret = rmap_one(page, vma, rmap_item->address, arg);
 			if (ret != SWAP_AGAIN) {
-				anon_vma_unlock(anon_vma);
+				anon_vma_unlock_read(anon_vma);
 				goto out;
 			}
 		}
-		anon_vma_unlock(anon_vma);
+		anon_vma_unlock_read(anon_vma);
 	}
 	if (!search_new_forks++)
 		goto again;
