Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0CXLlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:41:04 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62612 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab0CXLlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=HYXHT3Mxv7L/U0aCqdtXjsVRRHdRn9qlN9io7RkQckBEz+4af/Elmm7uEqA3f2eJ6u
         HOzeVxztifJjH2xhqIxSLezB3vOiZG+HKdovFXyaQAXydpVYHHuzDSvfZv7PvfJaomIx
         xiQfKmheMmKCs1oXNwgT1qF9v5GITHFCyBKQ0=
Subject: [PATCH] slub: Potential stack overflow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 12:40:56 +0100
Message-ID: <1269430856.3213.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I discovered that we can overflow stack if CONFIG_SLUB_DEBUG=y and use
slabs with many objects, since list_slab_objects() and process_slab()
use DECLARE_BITMAP(map, page->objects);

With 65535 bits, we use 8192 bytes of stack ...

A possible fix is to lower MAX_OBJS_PER_PAGE so that these bitmaps dont
use more than a third of THREAD_SIZE. I suspect plain memory allocation
in these functions is not an option.

Using non dynamic stack allocation makes the problem more obvious if
somebody runs checkstack.pl

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/mm/slub.c b/mm/slub.c
index b364844..adf04c1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -167,7 +167,13 @@
 
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
+
+#ifdef CONFIG_SLUB_DEBUG
+/* We use an onstack BITMAP while debugging, make sure this wont be too big */
+#define MAX_OBJS_PER_PAGE	min_t(int, 65535, 8*(THREAD_SIZE/3))
+#else
 #define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
+#endif
 
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000 /* Poison object */
@@ -2426,7 +2432,7 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
 #ifdef CONFIG_SLUB_DEBUG
 	void *addr = page_address(page);
 	void *p;
-	DECLARE_BITMAP(map, page->objects);
+	DECLARE_BITMAP(map, MAX_OBJS_PER_PAGE);
 
 	bitmap_zero(map, page->objects);
 	slab_err(s, page, "%s", text);
@@ -3651,7 +3657,7 @@ static void process_slab(struct loc_track *t, struct kmem_cache *s,
 		struct page *page, enum track_item alloc)
 {
 	void *addr = page_address(page);
-	DECLARE_BITMAP(map, page->objects);
+	DECLARE_BITMAP(map, MAX_OBJS_PER_PAGE);
 	void *p;
 
 	bitmap_zero(map, page->objects);


