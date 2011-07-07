Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1GGLFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:05:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51237 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1GGLFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:05:21 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org
Subject: Re: [PATCH] fs: fix lock initialization
References: <87iprf3dgs.fsf@tucsk.pomaz.szeredi.hu>
	<20110706182154.GB31214@fieldses.org>
	<87k4bu2y0k.fsf@tucsk.pomaz.szeredi.hu>
Date: Thu, 07 Jul 2011 13:06:09 +0200
In-Reply-To: <87k4bu2y0k.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Thu, 07 Jul 2011 12:19:55 +0200")
Message-ID: <87fwmi2vvi.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> "J. Bruce Fields" <bfields@fieldses.org> writes:
>
>> On Wed, Jul 06, 2011 at 12:33:55PM +0200, Miklos Szeredi wrote:
>>> From: Miklos Szeredi <mszeredi@suse.cz>
>>> 
>>> locks_alloc_lock() assumed that the allocated struct file_lock is
>>> already initialized to zero members.  This is only true for the first
>>> allocation of the structure, after reuse some of the members will have
>>> random values.
>>> 
>>> This will for example result in passing random fl_start values to
>>> userspace in fuse for FL_FLOCK locks, which is an information leak at
>>> best.
>>> 
>>> Fix by reinitializing those members which may be non-zero after freeing.
>>
>> Could you also just get rid of init_once() while you're at it?
>
> Sure.  Updated patch below.

Oh, the original was already applied.  Here's the incremental, if you
still want it.

Thanks,
Miklos
----


Subject: fs: locks: remove init_once

From: Miklos Szeredi <mszeredi@suse.cz>

Remove SLAB initialization entirely, as suggested by Bruce and Linus.
Allocate with __GFP_ZERO instead and only initialize list heads.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/locks.c |   41 ++++++++++-------------------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c	2011-07-07 13:03:49.000000000 +0200
+++ linux-2.6/fs/locks.c	2011-07-07 13:03:58.000000000 +0200
@@ -160,26 +160,20 @@ EXPORT_SYMBOL_GPL(unlock_flocks);
 
 static struct kmem_cache *filelock_cache __read_mostly;
 
-static void locks_init_lock_always(struct file_lock *fl)
+static void locks_init_lock_heads(struct file_lock *fl)
 {
-	fl->fl_next = NULL;
-	fl->fl_fasync = NULL;
-	fl->fl_owner = NULL;
-	fl->fl_pid = 0;
-	fl->fl_nspid = NULL;
-	fl->fl_file = NULL;
-	fl->fl_flags = 0;
-	fl->fl_type = 0;
-	fl->fl_start = fl->fl_end = 0;
+	INIT_LIST_HEAD(&fl->fl_link);
+	INIT_LIST_HEAD(&fl->fl_block);
+	init_waitqueue_head(&fl->fl_wait);
 }
 
 /* Allocate an empty lock structure. */
 struct file_lock *locks_alloc_lock(void)
 {
-	struct file_lock *fl = kmem_cache_alloc(filelock_cache, GFP_KERNEL);
+	struct file_lock *fl = kmem_cache_zalloc(filelock_cache, GFP_KERNEL);
 
 	if (fl)
-		locks_init_lock_always(fl);
+		locks_init_lock_heads(fl);
 
 	return fl;
 }
@@ -215,27 +209,12 @@ EXPORT_SYMBOL(locks_free_lock);
 
 void locks_init_lock(struct file_lock *fl)
 {
-	INIT_LIST_HEAD(&fl->fl_link);
-	INIT_LIST_HEAD(&fl->fl_block);
-	init_waitqueue_head(&fl->fl_wait);
-	fl->fl_ops = NULL;
-	fl->fl_lmops = NULL;
-	locks_init_lock_always(fl);
+	memset(fl, 0, sizeof(struct file_lock));
+	locks_init_lock_heads(fl);
 }
 
 EXPORT_SYMBOL(locks_init_lock);
 
-/*
- * Initialises the fields of the file lock which are invariant for
- * free file_locks.
- */
-static void init_once(void *foo)
-{
-	struct file_lock *lock = (struct file_lock *) foo;
-
-	locks_init_lock(lock);
-}
-
 static void locks_copy_private(struct file_lock *new, struct file_lock *fl)
 {
 	if (fl->fl_ops) {
@@ -2333,8 +2312,8 @@ EXPORT_SYMBOL(lock_may_write);
 static int __init filelock_init(void)
 {
 	filelock_cache = kmem_cache_create("file_lock_cache",
-			sizeof(struct file_lock), 0, SLAB_PANIC,
-			init_once);
+			sizeof(struct file_lock), 0, SLAB_PANIC, NULL);
+
 	return 0;
 }
 
