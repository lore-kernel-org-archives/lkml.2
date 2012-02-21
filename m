Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2BUSK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:10:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab2BUSHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:07:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/73] union-mount: Free union stack on removal of topmost
 dentry from dcache [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:00:48 +0000
Message-ID: <20120221180048.25235.44056.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

If a dentry is removed from dentry cache because its usage count drops
to zero, its union stack is freed too.

Original-author: Jan Blunck <jblunck@suse.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/dcache.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 326a432..e450890 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -39,6 +39,7 @@
 #include <linux/ratelimit.h>
 #include "internal.h"
 #include "mount.h"
+#include "union.h"
 
 /*
  * Usage:
@@ -316,6 +317,7 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	if (parent)
 		spin_unlock(&parent->d_lock);
 	dentry_iput(dentry);
+	d_free_unions(dentry);
 	/*
 	 * dentry_iput drops the locks, at which point nobody (except
 	 * transient RCU lookups) can reach this dentry.
@@ -907,6 +909,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 					iput(inode);
 			}
 
+			d_free_unions(dentry);
 			d_free(dentry);
 
 			/* finished when we fall off the top of the tree,
@@ -2009,6 +2012,7 @@ again:
 		}
 		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
 		dentry_unlink_inode(dentry);
+		d_free_unions(dentry);
 		fsnotify_nameremove(dentry, isdir);
 		return;
 	}
@@ -2018,6 +2022,12 @@ again:
 
 	spin_unlock(&dentry->d_lock);
 
+	/* Remove any associated unions.  While someone still has this
+	 * directory open (ref count > 0), we could not have deleted it unless
+	 * it was empty, and therefore has no references to directories below
+	 * it.  So we don't need the unions.
+	 */
+	d_free_unions(dentry);
 	fsnotify_nameremove(dentry, isdir);
 }
 EXPORT_SYMBOL(d_delete);

