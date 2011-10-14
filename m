Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1JNJXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:23:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab1JNJXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:23:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOH1cHkFitTHBkHzg+m7cZycOZTgWW8hF0g0=+pX6bPNVZNTxw@mail.gmail.com>
References: <CAOH1cHkFitTHBkHzg+m7cZycOZTgWW8hF0g0=+pX6bPNVZNTxw@mail.gmail.com> <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com> <2150.1314882260@redhat.com> <CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com> <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com> <5149.1317036720@redhat.com> <CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com> <CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com> <6324.1317308270@redhat.com> <CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com> <12748.1317313818@redhat.com> <CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com> <CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com> <18003.1317336244@redhat.com> <CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com> <6261.1317385734@redhat.com> <CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com> <8905.1317984176@redhat.com> <CAOH1cHkTiit!
 knOsjnu9n7B2Ax+pSgM-EFDFJodjDnamxt3RMCA@mail.gmail.com> <9908.1318413955@redhat.com> <CAOH1cHkg_eQRCHxOxiOPgO=-aZfnjts-tLFQFKffk5JjEfqy2w@mail.gmail.com> <CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com> <32454.1318519287@redhat.com> 
To: Mark Moseley <moseleymark@gmail.com>
Cc: dhowells@redhat.com,
        Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 Oct 2011 10:22:09 +0100
Message-ID: <17609.1318584129@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Moseley <moseleymark@gmail.com> wrote:

> > Did you look at /proc/fs/fscache/stats at all?
> 
> I didn't but I can repeat it. Which of the stats in
> /proc/fs/fscache/stats would be best to track?

If you could get two snapshots a couple of minutes apart, that'd be useful.
What I'm interested in is what stops changing and anything in the CacheOp list
at the bottom that becomes wedged on a non-zero value.

> >> [20839.802118] kernel BUG at fs/fscache/object-list.c:83!
> >> [20839.802733] invalid opcode: 0000 [#1] SMP
> >
> > That fits with the previous BUG elsewhere in object-list.c.  It sounds like
> > there's a refcounting problem somewhere.
> 
> Any sys or proc settings I should turn on to track that?

Not really.  However, if you could apply the attached patch, it will move the
object list handling to next to where the object allocation and freeing is
done.  I'm curious to see if this makes a difference.

The 'object list' is an RB tree keyed on the address of an object in RAM - so
if an object is already there it must have been double-added somehow or must
not have been removed.

David
---

 fs/cachefiles/interface.c     |    1 +
 fs/fscache/cache.c            |    1 -
 fs/fscache/cookie.c           |    1 -
 fs/fscache/object-list.c      |    1 +
 include/linux/fscache-cache.h |   19 +++++++++++--------
 5 files changed, 13 insertions(+), 10 deletions(-)


diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index ef5c02d..3dcecdf 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -104,6 +104,7 @@ nomem_key:
 	kfree(buffer);
 nomem_buffer:
 	BUG_ON(test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags));
+	fscache_object_destroy(&object->fscache);
 	kmem_cache_free(cachefiles_object_jar, object);
 	fscache_object_destroyed(&cache->cache);
 nomem_object:
diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
index b52aed1..98bca68 100644
--- a/fs/fscache/cache.c
+++ b/fs/fscache/cache.c
@@ -263,7 +263,6 @@ int fscache_add_cache(struct fscache_cache *cache,
 	spin_lock(&cache->object_list_lock);
 	list_add_tail(&ifsdef->cache_link, &cache->object_list);
 	spin_unlock(&cache->object_list_lock);
-	fscache_objlist_add(ifsdef);
 
 	/* add the cache's netfs definition index object to the top level index
 	 * cookie as a known backing object */
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 8dcb114..47d8cde 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -360,7 +360,6 @@ static int fscache_attach_object(struct fscache_cookie *cookie,
 	atomic_inc(&cookie->usage);
 	hlist_add_head(&object->cookie_link, &cookie->backing_objects);
 
-	fscache_objlist_add(object);
 	ret = 0;
 
 cant_attach_object:
diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
index f27c89d..f8fbb32 100644
--- a/fs/fscache/object-list.c
+++ b/fs/fscache/object-list.c
@@ -69,6 +69,7 @@ void fscache_objlist_add(struct fscache_object *obj)
 
 	write_unlock(&fscache_object_list_lock);
 }
+EXPORT_SYMBOL(fscache_objlist_add);
 
 /**
  * fscache_object_destroy - Note that a cache object is about to be destroyed
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 633b65d..f657c0a 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -440,6 +440,14 @@ extern const char *fscache_object_states[];
 
 extern void fscache_object_work_func(struct work_struct *work);
 
+#ifdef CONFIG_FSCACHE_OBJECT_LIST
+extern void fscache_objlist_add(struct fscache_object *obj);
+extern void fscache_object_destroy(struct fscache_object *object);
+#else
+#define fscache_object_destroy(object) do {} while(0)
+#define fscache_objlist_add(object) do {} while(0)
+#endif
+
 /**
  * fscache_object_init - Initialise a cache object description
  * @object: Object description
@@ -454,8 +462,6 @@ void fscache_object_init(struct fscache_object *object,
 			 struct fscache_cookie *cookie,
 			 struct fscache_cache *cache)
 {
-	atomic_inc(&cache->object_count);
-
 	object->state = FSCACHE_OBJECT_INIT;
 	spin_lock_init(&object->lock);
 	INIT_LIST_HEAD(&object->cache_link);
@@ -473,17 +479,14 @@ void fscache_object_init(struct fscache_object *object,
 	object->cache = cache;
 	object->cookie = cookie;
 	object->parent = NULL;
+
+	atomic_inc(&cache->object_count);
+	fscache_objlist_add(object);
 }
 
 extern void fscache_object_lookup_negative(struct fscache_object *object);
 extern void fscache_obtained_object(struct fscache_object *object);
 
-#ifdef CONFIG_FSCACHE_OBJECT_LIST
-extern void fscache_object_destroy(struct fscache_object *object);
-#else
-#define fscache_object_destroy(object) do {} while(0)
-#endif
-
 /**
  * fscache_object_destroyed - Note destruction of an object in a cache
  * @cache: The cache from which the object came

