Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab0CXVZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:25:55 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54515 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0CXVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fw0CxAcFv5sW7hlje7Nn4sidbnGh02MphMiJ16ZUGE/WymrjnuWAk/ksBcuqKMENrx
         PcL7idpX0ETLDR1qCAOlBq06HzXbI9MCUr0KYZOI+sAOk5OXp8LjbQYLT6e0uEycQIPF
         i92nHyNgnnyXjyCt6cExap2K+OTUHgEyGhnII=
Subject: Re: [PATCH] slub: Potential stack overflow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1003241613350.16858@router.home>
References: <1269430856.3213.27.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1003241414270.14329@router.home>
	 <1269458528.2849.2.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1003241443520.14329@router.home>
	 <1269464591.2849.15.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1003241608270.16858@router.home>
	 <alpine.DEB.2.00.1003241613350.16858@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 22:25:47 +0100
Message-ID: <1269465947.2849.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 24 mars 2010 à 16:14 -0500, Christoph Lameter a écrit :
> Here is a patch for the second case. I think its better since it results
> in an error display and it avoids the alloc for each slab. Add this piece
> to your patch?
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Sure, here is third version :

Thanks

[PATCH] slub: Potential stack overflow

I discovered that we can overflow stack if CONFIG_SLUB_DEBUG=y and use
slabs with many objects, since list_slab_objects() and process_slab()
use DECLARE_BITMAP(map, page->objects);

With 65535 bits, we use 8192 bytes of stack ...

Switch these allocations to dynamic allocations.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
---
 mm/slub.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)
diff --git a/mm/slub.c b/mm/slub.c
index b364844..7dc8e73 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2426,9 +2426,11 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
 #ifdef CONFIG_SLUB_DEBUG
 	void *addr = page_address(page);
 	void *p;
-	DECLARE_BITMAP(map, page->objects);
+	long *map = kzalloc(BITS_TO_LONGS(page->objects) * sizeof(long),
+			    GFP_ATOMIC);
 
-	bitmap_zero(map, page->objects);
+	if (!map)
+		return;
 	slab_err(s, page, "%s", text);
 	slab_lock(page);
 	for_each_free_object(p, s, page->freelist)
@@ -2443,6 +2445,7 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
 		}
 	}
 	slab_unlock(page);
+	kfree(map);
 #endif
 }
 
@@ -3648,10 +3651,10 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 }
 
 static void process_slab(struct loc_track *t, struct kmem_cache *s,
-		struct page *page, enum track_item alloc)
+		struct page *page, enum track_item alloc,
+		long *map)
 {
 	void *addr = page_address(page);
-	DECLARE_BITMAP(map, page->objects);
 	void *p;
 
 	bitmap_zero(map, page->objects);
@@ -3670,11 +3673,14 @@ static int list_locations(struct kmem_cache *s, char *buf,
 	unsigned long i;
 	struct loc_track t = { 0, 0, NULL };
 	int node;
+	unsigned long *map = kmalloc(BITS_TO_LONGS(oo_objects(s->max)) *
+				     sizeof(unsigned long), GFP_KERNEL);
 
-	if (!alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
-			GFP_TEMPORARY))
+	if (!map || !alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
+				     GFP_TEMPORARY)) {
+		kfree(map);
 		return sprintf(buf, "Out of memory\n");
-
+	}
 	/* Push back cpu slabs */
 	flush_all(s);
 
@@ -3688,9 +3694,9 @@ static int list_locations(struct kmem_cache *s, char *buf,
 
 		spin_lock_irqsave(&n->list_lock, flags);
 		list_for_each_entry(page, &n->partial, lru)
-			process_slab(&t, s, page, alloc);
+			process_slab(&t, s, page, alloc, map);
 		list_for_each_entry(page, &n->full, lru)
-			process_slab(&t, s, page, alloc);
+			process_slab(&t, s, page, alloc, map);
 		spin_unlock_irqrestore(&n->list_lock, flags);
 	}
 
@@ -3741,6 +3747,7 @@ static int list_locations(struct kmem_cache *s, char *buf,
 	}
 
 	free_loc_track(&t);
+	kfree(map);
 	if (!t.count)
 		len += sprintf(buf, "No data\n");
 	return len;


