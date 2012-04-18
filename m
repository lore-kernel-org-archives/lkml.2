Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2DRPpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:45:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59573 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2DRPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:45:05 -0400
Date: Wed, 18 Apr 2012 18:44:48 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kmemleak: do not leak object after tree insertion error (v3)
Message-ID: <20120418154448.GA3617@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [PATCH] kmemleak: do not leak object after tree insertion error

 In case when tree insertion fails due to already existing object
 error, pointer to allocated object gets lost because of overwrite
 with lookup_object() return. Free allocated object before object
 lookup. 

 Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 mm/kmemleak.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 45eb621..5f05993 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -578,6 +578,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	if (node != &object->tree_node) {
 		kmemleak_stop("Cannot insert 0x%lx into the object search tree "
 			      "(already existing)\n", ptr);
+		kmem_cache_free(object_cache, object);
 		object = lookup_object(ptr, 1);
 		spin_lock(&object->lock);
 		dump_object_info(object);

