Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2AQXB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:01:27 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:23667 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756209Ab2AQXBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:01:24 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SIb_OWcVM1krbqWEJL5xc1IVkquOeNHz9Z62FL9T8nwpce8
 gTcx09MQtmY_7sA6YYovjNUV.E8iXny7r8Y9w6gabDKKFW83GEiiqadf4y5i
 Ztaelm2dD9HZMA9Mi5A0aWV8ZEYILPyLOHQhwnI9KV62PC0FQjT3ugvlBFh3
 61ThxksNhLVYt6QdUCskibUIVBKQyur6lmpwyLaKeeC401uGzMv5LSkY7xon
 nxV6yvuUhQrMG3t_rp8Shgymm4iKcxd7FFsIxLvBeRVfT3AbyXT0gHKJBMZ_
 cFi_t9ZK2jb_F5KpPzC9831EVFVXwvKnVTPtOUjvHN1.E87uaKgw_xDoeB5c
 zP.RGx8AJy.pMlPt6nvp55pxltN7q2fqwHTb6wCxOTybSjbwTeGZbkyVJ0Zd
 j
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 17 Jan 2012 16:22:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        davem <davem@davemloft.net>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, kaber@trash.net, pablo@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Hung task when calling clone() due to netfilter/slab
In-Reply-To: <alpine.DEB.2.00.1201170942240.4800@router.home>
Message-ID: <alpine.DEB.2.00.1201171620590.14697@router.home>
References: <1326558605.19951.7.camel@lappy>    <1326561043.5287.24.camel@edumazet-laptop>   <1326632384.11711.3.camel@lappy>  <1326648305.5287.78.camel@edumazet-laptop>   <alpine.DEB.2.00.1201170910130.4800@router.home>  <1326813630.2259.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
  <alpine.DEB.2.00.1201170927020.4800@router.home> <1326814208.2259.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1201170942240.4800@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another version that drops the slub lock for both invocations of sysfs
functions from kmem_cache_create. The invocation from slab_sysfs_init
is not a problem since user space is not active at that point.


Subject: slub: Do not take the slub lock while calling into sysfs

This patch avoids holding the slub_lock during kmem_cache_create()
when calling sysfs. It is possible because kmem_cache_create()
allocates the kmem_cache object and therefore is the only one context
that can access the newly created object. It is therefore possible
to drop the slub_lock early. We defer the adding of the new kmem_cache
to the end of processing because the new kmem_cache structure would
be reachable otherwise via scans over slabs. This allows sysfs_slab_add()
to run without holding any locks.

The case is different if we are creating an alias instead of a new
kmem_cache structure. In that case we can also drop the slub lock
early because we have taken a refcount on the kmem_cache structure.
It therefore cannot vanish from under us.
But if the sysfs_slab_alias() call fails we can no longer simply
decrement the refcount since the other references may have gone
away in the meantime. Call kmem_cache_destroy() to cause the
refcount to be decremented and the kmem_cache structure to be
freed if all references are gone.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/slub.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2012-01-17 09:53:26.599505365 -0600
+++ linux-2.6/mm/slub.c	2012-01-17 09:59:57.131497273 -0600
@@ -3912,13 +3912,14 @@ struct kmem_cache *kmem_cache_create(con
 		s->objsize = max(s->objsize, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));

+		up_write(&slub_lock);
 		if (sysfs_slab_alias(s, name)) {
-			s->refcount--;
+			kmem_cache_destroy(s);
 			goto err;
 		}
-		up_write(&slub_lock);
 		return s;
 	}
+	up_write(&slub_lock);

 	n = kstrdup(name, GFP_KERNEL);
 	if (!n)
@@ -3928,27 +3929,23 @@ struct kmem_cache *kmem_cache_create(con
 	if (s) {
 		if (kmem_cache_open(s, n,
 				size, align, flags, ctor)) {
-			list_add(&s->list, &slab_caches);
-			if (sysfs_slab_add(s)) {
-				list_del(&s->list);
-				kfree(n);
-				kfree(s);
-				goto err;
+
+			if (sysfs_slab_add(s) == 0) {
+				down_write(&slub_lock);
+				list_add(&s->list, &slab_caches);
+				up_write(&slub_lock);
+				return s;
 			}
-			up_write(&slub_lock);
-			return s;
 		}
 		kfree(n);
 		kfree(s);
 	}
 err:
-	up_write(&slub_lock);

 	if (flags & SLAB_PANIC)
 		panic("Cannot create slabcache %s\n", name);
-	else
-		s = NULL;
-	return s;
+
+	return NULL;
 }
 EXPORT_SYMBOL(kmem_cache_create);

