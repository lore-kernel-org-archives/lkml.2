Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405Ab1JGKn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:43:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965393Ab1JGKn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:43:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com>
References: <CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com> <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com> <2150.1314882260@redhat.com> <CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com> <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com> <5149.1317036720@redhat.com> <CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com> <CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com> <6324.1317308270@redhat.com> <CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com> <12748.1317313818@redhat.com> <CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com> <CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com> <18003.1317336244@redhat.com> <CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com> <6261.1317385734@redhat.com> 
To: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
Date: Fri, 07 Oct 2011 11:42:56 +0100
Message-ID: <8905.1317984176@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Moseley <moseleymark@gmail.com> wrote:

> [ 7719.996883] FS-Cache: Assertion failed
> [ 7719.996886] 3 == 5 is false
> [ 7719.996906] ------------[ cut here ]------------
> [ 7720.006139] kernel BUG at fs/fscache/operation.c:408!

Can you add the attached patch?  It will display which operation was being run
just before displaying the above assertion.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS-Cache: Give operations names for debugging

Give operations names for debugging and print it if we're going to assert.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/object.c           |    1 +
 fs/fscache/operation.c        |   18 ++++++++++++++++++
 fs/fscache/page.c             |    5 +++++
 include/linux/fscache-cache.h |   14 +++++++++++++-
 4 files changed, 37 insertions(+), 1 deletions(-)


diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index 80b5491..91d998b 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -940,6 +940,7 @@ static void fscache_invalidate_object(struct fscache_object *object)
 	}
 
 	fscache_operation_init(op, object->cache->ops->invalidate_object, NULL);
+	op->name = FSCACHE_OP_INVALIDATE;
 	op->flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_EXCLUSIVE);
 
 	spin_lock(&cookie->lock);
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index 2037f03..6bfefee 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -20,6 +20,16 @@
 atomic_t fscache_op_debug_id;
 EXPORT_SYMBOL(fscache_op_debug_id);
 
+static const char *const fscache_op_names[FSCACHE_OP__NR] = {
+	[FSCACHE_OP_UNNAMED]		= "Unnamed",
+	[FSCACHE_OP_INVALIDATE]		= "Invalidate",
+	[FSCACHE_OP_ATTR_CHANGED]	= "AttrChanged",
+	[FSCACHE_OP_ALLOC_PAGE]		= "AllocPage",
+	[FSCACHE_OP_READ_OR_ALLOC_PAGE]	= "ReadOrAllocPage",
+	[FSCACHE_OP_READ_OR_ALLOC_PAGES] = "ReadOrAllocPages",
+	[FSCACHE_OP_WRITE]		= "Write",
+};
+
 /**
  * fscache_enqueue_operation - Enqueue an operation for processing
  * @op: The operation to enqueue
@@ -86,6 +96,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 {
 	_enter("{OBJ%x OP%x},", object->debug_id, op->debug_id);
 
+	ASSERTCMP(op->name, >, FSCACHE_OP_UNNAMED);
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_INITIALISED);
 	ASSERTCMP(atomic_read(&op->usage), >, 0);
 
@@ -189,6 +200,7 @@ int fscache_submit_op(struct fscache_object *object,
 	_enter("{OBJ%x OP%x},{%u}",
 	       object->debug_id, op->debug_id, atomic_read(&op->usage));
 
+	ASSERTCMP(op->name, >, FSCACHE_OP_UNNAMED);
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_INITIALISED);
 	ASSERTCMP(atomic_read(&op->usage), >, 0);
 
@@ -404,6 +416,12 @@ void fscache_put_operation(struct fscache_operation *op)
 		return;
 
 	_debug("PUT OP");
+
+	if (op->state != FSCACHE_OP_ST_COMPLETE &&
+	    op->state != FSCACHE_OP_ST_CANCELLED)
+		printk("FS-Cache: Asserting on %s operation\n",
+		       fscache_op_names[op->name]);
+
 	ASSERTIFCMP(op->state != FSCACHE_OP_ST_COMPLETE,
 		    op->state, ==, FSCACHE_OP_ST_CANCELLED);
 	op->state = FSCACHE_OP_ST_DEAD;
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 00a5ed9..cf6dd34 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -188,6 +188,7 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 	}
 
 	fscache_operation_init(op, fscache_attr_changed_op, NULL);
+	op->name = FSCACHE_OP_ATTR_CHANGED;
 	op->flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_EXCLUSIVE);
 
 	spin_lock(&cookie->lock);
@@ -379,6 +380,7 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 		_leave(" = -ENOMEM");
 		return -ENOMEM;
 	}
+	op->op.name = FSCACHE_OP_READ_OR_ALLOC_PAGE;
 	op->n_pages = 1;
 
 	spin_lock(&cookie->lock);
@@ -505,6 +507,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 	op = fscache_alloc_retrieval(mapping, end_io_func, context);
 	if (!op)
 		return -ENOMEM;
+	op->op.name = FSCACHE_OP_READ_OR_ALLOC_PAGES;
 	op->n_pages = *nr_pages;
 
 	spin_lock(&cookie->lock);
@@ -635,6 +638,7 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 	op = fscache_alloc_retrieval(page->mapping, NULL, NULL);
 	if (!op)
 		return -ENOMEM;
+	op->op.name = FSCACHE_OP_ALLOC_PAGE;
 	op->n_pages = 1;
 
 	spin_lock(&cookie->lock);
@@ -856,6 +860,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 
 	fscache_operation_init(&op->op, fscache_write_op,
 			       fscache_release_write_op);
+	op->op.name = FSCACHE_OP_WRITE;
 	op->op.flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_WAITING);
 
 	ret = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 29f552d..fa61436 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -85,6 +85,17 @@ enum fscache_operation_state {
 	FSCACHE_OP_ST_DEAD		/* Op is now dead */
 };
 
+enum fscache_operation_name {
+	FSCACHE_OP_UNNAMED,
+	FSCACHE_OP_INVALIDATE,
+	FSCACHE_OP_ATTR_CHANGED,
+	FSCACHE_OP_ALLOC_PAGE,
+	FSCACHE_OP_READ_OR_ALLOC_PAGE,
+	FSCACHE_OP_READ_OR_ALLOC_PAGES,
+	FSCACHE_OP_WRITE,
+	FSCACHE_OP__NR
+};
+
 struct fscache_operation {
 	struct work_struct	work;		/* record for async ops */
 	struct list_head	pend_link;	/* link in object->pending_ops */
@@ -99,7 +110,8 @@ struct fscache_operation {
 #define FSCACHE_OP_DEC_READ_CNT	6	/* decrement object->n_reads on destruction */
 #define FSCACHE_OP_KEEP_FLAGS	0x0070	/* flags to keep when repurposing an op */
 
-	enum fscache_operation_state state;
+	enum fscache_operation_state state : 8;
+	enum fscache_operation_name name : 8;
 	atomic_t		usage;
 	unsigned		debug_id;	/* debugging ID */
 
