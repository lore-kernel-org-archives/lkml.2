Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1GFKdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 06:33:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1GFKdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 06:33:13 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs: fix lock initialization
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org
Date: Wed, 06 Jul 2011 12:33:55 +0200
Message-ID: <87iprf3dgs.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

locks_alloc_lock() assumed that the allocated struct file_lock is
already initialized to zero members.  This is only true for the first
allocation of the structure, after reuse some of the members will have
random values.

This will for example result in passing random fl_start values to
userspace in fuse for FL_FLOCK locks, which is an information leak at
best.

Fix by reinitializing those members which may be non-zero after freeing.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@kernel.org
---
 fs/locks.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c	2011-07-04 17:06:01.000000000 +0200
+++ linux-2.6/fs/locks.c	2011-07-04 17:06:04.000000000 +0200
@@ -160,10 +160,28 @@ EXPORT_SYMBOL_GPL(unlock_flocks);
 
 static struct kmem_cache *filelock_cache __read_mostly;
 
+static void locks_init_lock_always(struct file_lock *fl)
+{
+	fl->fl_next = NULL;
+	fl->fl_fasync = NULL;
+	fl->fl_owner = NULL;
+	fl->fl_pid = 0;
+	fl->fl_nspid = NULL;
+	fl->fl_file = NULL;
+	fl->fl_flags = 0;
+	fl->fl_type = 0;
+	fl->fl_start = fl->fl_end = 0;
+}
+
 /* Allocate an empty lock structure. */
 struct file_lock *locks_alloc_lock(void)
 {
-	return kmem_cache_alloc(filelock_cache, GFP_KERNEL);
+	struct file_lock *fl = kmem_cache_alloc(filelock_cache, GFP_KERNEL);
+
+	if (fl)
+		locks_init_lock_always(fl);
+
+	return fl;
 }
 EXPORT_SYMBOL_GPL(locks_alloc_lock);
 
@@ -200,17 +218,9 @@ void locks_init_lock(struct file_lock *f
 	INIT_LIST_HEAD(&fl->fl_link);
 	INIT_LIST_HEAD(&fl->fl_block);
 	init_waitqueue_head(&fl->fl_wait);
-	fl->fl_next = NULL;
-	fl->fl_fasync = NULL;
-	fl->fl_owner = NULL;
-	fl->fl_pid = 0;
-	fl->fl_nspid = NULL;
-	fl->fl_file = NULL;
-	fl->fl_flags = 0;
-	fl->fl_type = 0;
-	fl->fl_start = fl->fl_end = 0;
 	fl->fl_ops = NULL;
 	fl->fl_lmops = NULL;
+	locks_init_lock_always(fl);
 }
 
 EXPORT_SYMBOL(locks_init_lock);
