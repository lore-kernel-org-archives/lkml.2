Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0IPWOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab0IPWO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:27 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Blunck <jblunck@suse.de>, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 13/34] union-mount: Free union stack on removal of topmost dentry from dcache
Date: Thu, 16 Sep 2010 15:12:04 -0700
Message-Id: <1284675145-4391-14-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

If a dentry is removed from dentry cache because its usage count drops
to zero, its union stack is freed too.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/dcache.c    |   11 +++++++++++
 fs/namespace.c |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 85e2737..0910ce7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -34,6 +34,7 @@
 #include <linux/fs_struct.h>
 #include <linux/hardirq.h>
 #include "internal.h"
+#include "union.h"
 
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
@@ -175,6 +176,7 @@ static struct dentry *d_kill(struct dentry *dentry)
 	dentry_stat.nr_dentry--;	/* For d_free, below */
 	/*drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
+	d_free_unions(dentry);
 	if (IS_ROOT(dentry))
 		parent = NULL;
 	else
@@ -695,6 +697,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 					iput(inode);
 			}
 
+			d_free_unions(dentry);
 			d_free(dentry);
 
 			/* finished when we fall off the top of the tree,
@@ -1535,6 +1538,7 @@ void d_delete(struct dentry * dentry)
 	if (atomic_read(&dentry->d_count) == 1) {
 		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
 		dentry_iput(dentry);
+		d_free_unions(dentry);
 		fsnotify_nameremove(dentry, isdir);
 		return;
 	}
@@ -1545,6 +1549,13 @@ void d_delete(struct dentry * dentry)
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
+	/*
+	 * Remove any associated unions.  While someone still has this
+	 * directory open (ref count > 0), we could not have deleted
+	 * it unless it was empty, and therefore has no references to
+	 * directories below it.  So we don't need the unions.
+	 */
+	d_free_unions(dentry);
 	fsnotify_nameremove(dentry, isdir);
 }
 EXPORT_SYMBOL(d_delete);
diff --git a/fs/namespace.c b/fs/namespace.c
index f8d7d11..ffa5ed7 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -33,6 +33,7 @@
 #include <asm/unistd.h>
 #include "pnode.h"
 #include "internal.h"
+#include "union.h"
 
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
@@ -1065,6 +1066,7 @@ void umount_tree(struct vfsmount *mnt, int propagate, struct list_head *kill)
 		propagate_umount(kill);
 
 	list_for_each_entry(p, kill, mnt_hash) {
+		d_free_unions(p->mnt_root);
 		list_del_init(&p->mnt_expire);
 		list_del_init(&p->mnt_list);
 		__touch_mnt_namespace(p->mnt_ns);
-- 
1.6.3.3

