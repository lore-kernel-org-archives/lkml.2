Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab0HFWlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 18:41:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965782Ab0HFWgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 18:36:46 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 20/38] union-mount: Free union dirs on removal from dcache
Date: Fri,  6 Aug 2010 15:35:06 -0700
Message-Id: <1281134124-17041-21-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
References: <1281134124-17041-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a dentry is removed from dentry cache because its usage count drops
to zero, the union_dirs in its union stack are freed too.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/dcache.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index c7b6e67..4fe51a9 100644
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
-- 
1.6.3.3

