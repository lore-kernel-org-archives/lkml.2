Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2FNPNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:13:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab2FNPNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:13:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] VFS: Fix the banner comment on lookup_open()
To: viro@ZenIV.linux.org.uk
Cc: miklos@szeredi.hu, dhowells@redhat.com, linux-fsdevel@vger.kernel.or,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Jun 2012 16:13:46 +0100
Message-ID: <20120614151346.7905.28763.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 197e37d9, the banner comment on lookup_open() no longer matches
what the function returns.  It used to return a struct file pointer or NULL and
now it returns an integer and is passed the struct file pointer it is to use
amongst its arguments.  Update the comment to reflect this.

Also add a banner comment to atomic_open().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1fc02ff..42006b7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2185,6 +2185,19 @@ static int may_o_create(struct path *dir, struct dentry *dentry, umode_t mode)
 	return security_inode_create(dir->dentry->d_inode, dentry, mode);
 }
 
+/*
+ * Attempt to atomically look up, create and open a file from a negative
+ * dentry.
+ *
+ * Returns 0 if successful.  The file will have been created and attached to
+ * @file by the filesystem calling finish_open().
+ *
+ * Returns 1 if the file was looked up only or didn't need creating.  The
+ * caller will need to perform the open themselves.  @path will have been
+ * updated to point to the new dentry.  This may be negative.
+ *
+ * Returns an error code otherwise.
+ */
 static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 			struct path *path, struct file *file,
 			const struct open_flags *op,
@@ -2329,12 +2342,22 @@ looked_up:
 }
 
 /*
- * Lookup, maybe create and open the last component
+ * Look up and maybe create and open the last component.
  *
  * Must be called with i_mutex held on parent.
  *
- * Returns open file or NULL on success, error otherwise.  NULL means no open
- * was performed, only lookup.
+ * Returns 0 if the file was successfully atomically created (if necessary) and
+ * opened.  In this case the file will be returned attached to @file.
+ *
+ * Returns 1 if the file was not completely opened at this time, though lookups
+ * and creations will have been performed and the dentry returned in @path will
+ * be positive upon return if O_CREAT was specified.  If O_CREAT wasn't
+ * specified then a negative dentry may be returned.
+ *
+ * An error code is returned otherwise.
+ *
+ * FILE_CREATE will be set in @*opened if the dentry was created and will be
+ * cleared otherwise prior to returning.
  */
 static int lookup_open(struct nameidata *nd, struct path *path,
 			struct file *file,

