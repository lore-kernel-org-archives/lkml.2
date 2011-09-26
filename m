Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1IZLcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:32:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1IZLcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:32:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
References: <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com> <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com> <2150.1314882260@redhat.com> <CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
To: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
Date: Mon, 26 Sep 2011 12:32:00 +0100
Message-ID: <5149.1317036720@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Moseley <moseleymark@gmail.com> wrote:

> I thought I'd be extra-helpful by getting that trace with a 3.0.4
> kernel but got a completely different error this time (there was
> nothing logged above this though). There was a
> '__fscache_read_or_alloc_pages' crash for the previous boot too,
> though it went for about 2.5 hours that time (with an empty cache
> partition though).

I'm fairly certain I know what the cause of this one is: Invalidation upon
server change isn't handled correctly.  NFS tries to invalidate a file by
discarding that file's attachment to the cache - without first clearing up the
operations it has outstanding on the cache for that file.

I'm working on adding formal invalidation at the moment.

The attached patch may get you more precise information.  The first hunk is the
main catcher.

David
---
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 9905350..48c63b8 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -452,6 +452,13 @@ void __fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
 
 		_debug("RELEASE OBJ%x", object->debug_id);
 
+		if (atomic_read(&object->n_reads)) {
+			spin_unlock(&cookie->lock);
+			printk(KERN_ERR "FS-Cache: Cookie '%s' still has outstanding reads\n",
+			       cookie->def->name);
+			BUG();
+		}
+
 		/* detach each cache object from the object cookie */
 		spin_lock(&object->lock);
 		hlist_del_init(&object->cookie_link);
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index b8b62f4..f087051 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -496,6 +496,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 	if (fscache_submit_op(object, &op->op) < 0)
 		goto nobufs_unlock;
 	spin_unlock(&cookie->lock);
+	ASSERTCMP(object->cookie, ==, cookie);
 
 	fscache_stat(&fscache_n_retrieval_ops);
 
@@ -513,6 +514,26 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 		goto error;
 
 	/* ask the cache to honour the operation */
+	if (!object->cookie) {
+		const char prefix[] = "fs-";
+		printk(KERN_ERR "%sobject: OBJ%x\n",
+		       prefix, object->debug_id);
+		printk(KERN_ERR "%sobjstate=%s fl=%lx wbusy=%x ev=%lx[%lx]\n",
+		       prefix, fscache_object_states[object->state],
+		       object->flags, work_busy(&object->work),
+		       object->events,
+		       object->event_mask & FSCACHE_OBJECT_EVENTS_MASK);
+		printk(KERN_ERR "%sops=%u inp=%u exc=%u\n",
+		       prefix, object->n_ops, object->n_in_progress,
+		       object->n_exclusive);
+		printk(KERN_ERR "%sparent=%p\n",
+		       prefix, object->parent);
+		printk(KERN_ERR "%scookie=%p [pr=%p nd=%p fl=%lx]\n",
+		       prefix, object->cookie,
+		       cookie->parent, cookie->netfs_data, cookie->flags);
+	}
+	ASSERTCMP(object->cookie, ==, cookie);
+
 	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
 		fscache_stat(&fscache_n_cop_allocate_pages);
 		ret = object->cache->ops->allocate_pages(
