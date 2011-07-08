Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1GHFJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:09:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab1GHFFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:01 2011
Message-Id: <20110708001701.494896424@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [090/107] fs: fix lock initialization
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit a51cb91d81f8e6fc4e5e08b772cc3ceb13ac9d37 upstream.

locks_alloc_lock() assumed that the allocated struct file_lock is
already initialized to zero members.  This is only true for the first
allocation of the structure, after reuse some of the members will have
random values.

This will for example result in passing random fl_start values to
userspace in fuse for FL_FLOCK locks, which is an information leak at
best.

Fix by reinitializing those members which may be non-zero after freeing.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/locks.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
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


