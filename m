Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2DBGfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 02:35:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57860 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2DBGfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 02:35:41 -0400
Date: Mon, 2 Apr 2012 09:35:32 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemleak: do not leak object after tree insertion error
Message-ID: <20120402063532.GA3464@swordfish>
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
overwrite. Free allocated object before lookup happens.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 mm/kmemleak.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 45eb621..d6eec2d 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -260,6 +260,7 @@ static struct early_log
 static int crt_early_log __initdata;
 
 static void kmemleak_disable(void);
+static void __delete_object(struct kmemleak_object *);
 
 /*
  * Print a warning and dump the stack trace.
@@ -576,6 +577,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	 * random memory blocks.
 	 */
 	if (node != &object->tree_node) {
+		__delete_object(object);
 		kmemleak_stop("Cannot insert 0x%lx into the object search tree "
 			      "(already existing)\n", ptr);
 		object = lookup_object(ptr, 1);

