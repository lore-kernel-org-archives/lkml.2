Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0CXVDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:03:17 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40011 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0CXVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=alA0in7QR2Ql76tJOxbm8Quo4NS6iJ33FCIzJlz6nbq1AU3RmLj/AgvOi11M4u18SS
         COuBQTisAsOq0cyv6S/HZVRxnikA8kbgbqgRcLhNmihIh8ugfjkfRS5tYE5Pm2zTXyCf
         q1G9pgF8C+r+38bMQe4jPo7RhNmM5sV+T+a4M=
Subject: Re: [PATCH] slub: Potential stack overflow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1003241443520.14329@router.home>
References: <1269430856.3213.27.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1003241414270.14329@router.home>
	 <1269458528.2849.2.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1003241443520.14329@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 22:03:11 +0100
Message-ID: <1269464591.2849.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 24 mars 2010 à 14:49 -0500, Christoph Lameter a écrit :
> On Wed, 24 Mar 2010, Eric Dumazet wrote:
> 
> > Are we allowed to nest in these two functions ?
> 
> This is kmem_cache_close() no danger of nesting.
> 
> > These are debugging functions, what happens if kmalloc() returns NULL ?
> 
> Then you return ENOMEM and the user gets an error. We already do that in
> validate_slab_cache().
> 
> Hmmm... In this case we called from list_slab_objects() which gets called
> from free_partial() (which took a spinlock!) which gets called from
> kmem_cache_close().
> 
> Its just a debugging aid so no problem if it fails. GFP_ATOMIC?

OK, here is second version of the patch, thanks !


[PATCH] slub: Potential stack overflow

I discovered that we can overflow stack if CONFIG_SLUB_DEBUG=y and use
slabs with many objects, since list_slab_objects() and process_slab()
use DECLARE_BITMAP(map, page->objects);

With 65535 bits, we use 8192 bytes of stack ...

A possible solution is to allocate memory, using GFP_ATOMIC, and do
nothing if allocation fails.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/mm/slub.c b/mm/slub.c
index b364844..5ee857a 100644
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
 
@@ -3651,16 +3654,19 @@ static void process_slab(struct loc_track *t, struct kmem_cache *s,
 		struct page *page, enum track_item alloc)
 {
 	void *addr = page_address(page);
-	DECLARE_BITMAP(map, page->objects);
+	long *map = kzalloc(BITS_TO_LONGS(page->objects) * sizeof(long),
+			    GFP_ATOMIC);
 	void *p;
 
-	bitmap_zero(map, page->objects);
+	if (!map)
+		return;
 	for_each_free_object(p, s, page->freelist)
 		set_bit(slab_index(p, s, addr), map);
 
 	for_each_object(p, s, addr, page->objects)
 		if (!test_bit(slab_index(p, s, addr), map))
 			add_location(t, s, get_track(s, p, alloc));
+	kfree(map);
 }
 
 static int list_locations(struct kmem_cache *s, char *buf,


