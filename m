Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2DBXHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:07:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54193 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2DBXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:07:06 -0400
Date: Tue, 3 Apr 2012 02:06:56 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemleak: do not leak object after tree insertion error (v2,
 fixed)
Message-ID: <20120402230656.GA4353@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [PATCH] kmemleak: do not leak object after tree insertion error
 
 In case when tree insertion fails due to already existing object
 error, pointer to allocated object gets lost due to lookup_object()
 overwrite. Free allocated object and return the existing one, 
 obtained from lookup_object().
 
 Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
 
---

 mm/kmemleak.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 45eb621..4177d83 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -516,7 +516,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 					     int min_count, gfp_t gfp)
 {
 	unsigned long flags;
-	struct kmemleak_object *object;
+	struct kmemleak_object *object, *ex_object;
 	struct prio_tree_node *node;
 
 	object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
@@ -578,17 +578,22 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	if (node != &object->tree_node) {
 		kmemleak_stop("Cannot insert 0x%lx into the object search tree "
 			      "(already existing)\n", ptr);
-		object = lookup_object(ptr, 1);
-		spin_lock(&object->lock);
-		dump_object_info(object);
-		spin_unlock(&object->lock);
+		ex_object = lookup_object(ptr, 1);
+		spin_lock(&ex_object->lock);
+		dump_object_info(ex_object);
+		spin_unlock(&ex_object->lock);
 
-		goto out;
+		goto out_error;
 	}
 	list_add_tail_rcu(&object->object_list, &object_list);
-out:
+
 	write_unlock_irqrestore(&kmemleak_lock, flags);
 	return object;
+out_error:
+	write_unlock_irqrestore(&kmemleak_lock, flags);
+	object->flags &= ~OBJECT_ALLOCATED;
+	put_object(object);
+	return ex_object;
 }
 
 /*

