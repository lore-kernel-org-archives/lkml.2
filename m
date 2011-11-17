Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1KQXBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:01:14 -0500
Received: from www17.your-server.de ([213.133.104.17]:60442 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1KQXBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:01:13 -0500
Message-ID: <1321570852.1624.312.camel@localhost.localdomain>
Subject: [PATCH] UBIFS: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 18 Nov 2011 00:00:52 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
--- a/fs/ubifs/lpt.c 2011-11-07 19:38:24.223836156 +0100
+++ b/fs/ubifs/lpt.c 2011-11-08 10:35:23.637000062 +0100
@@ -1986,12 +1986,11 @@ again:
 
 				if (path[h].in_tree)
 					continue;
-				nnode = kmalloc(sz, GFP_NOFS);
+				nnode = kmemdup(&path[h].nnode, sz, GFP_NOFS);
 				if (!nnode) {
 					err = -ENOMEM;
 					goto out;
 				}
-				memcpy(nnode, &path[h].nnode, sz);
 				parent = nnode->parent;
 				parent->nbranch[nnode->iip].nnode = nnode;
 				path[h].ptr.nnode = nnode;
@@ -2004,12 +2003,11 @@ again:
 				const size_t sz = sizeof(struct ubifs_pnode);
 				struct ubifs_nnode *parent;
 
-				pnode = kmalloc(sz, GFP_NOFS);
+				pnode = kmemdup(&path[h].pnode, sz, GFP_NOFS);
 				if (!pnode) {
 					err = -ENOMEM;
 					goto out;
 				}
-				memcpy(pnode, &path[h].pnode, sz);
 				parent = pnode->parent;
 				parent->nbranch[pnode->iip].pnode = pnode;
 				path[h].ptr.pnode = pnode;
diff -u -p a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
--- a/fs/ubifs/tnc.c 2011-11-07 19:38:24.250503228 +0100
+++ b/fs/ubifs/tnc.c 2011-11-08 10:35:18.593599122 +0100
@@ -344,12 +344,11 @@ static int lnc_add(struct ubifs_info *c,
 		return err;
 	}
 
-	lnc_node = kmalloc(zbr->len, GFP_NOFS);
+	lnc_node = kmemdup(node, zbr->len, GFP_NOFS);
 	if (!lnc_node)
 		/* We don't have to have the cache, so no error */
 		return 0;
 
-	memcpy(lnc_node, node, zbr->len);
 	zbr->leaf = lnc_node;
 	return 0;
 }
diff -u -p a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
--- a/fs/ubifs/xattr.c 2011-11-07 19:38:24.257169996 +0100
+++ b/fs/ubifs/xattr.c 2011-11-08 10:35:21.073632366 +0100
@@ -138,12 +138,11 @@ static int create_xattr(struct ubifs_inf
 	ui = ubifs_inode(inode);
 	ui->xattr = 1;
 	ui->flags |= UBIFS_XATTR_FL;
-	ui->data = kmalloc(size, GFP_NOFS);
+	ui->data = kmemdup(value, size, GFP_NOFS);
 	if (!ui->data) {
 		err = -ENOMEM;
 		goto out_free;
 	}
-	memcpy(ui->data, value, size);
 	inode->i_size = ui->ui_size = size;
 	ui->data_len = size;
 
@@ -204,12 +203,11 @@ static int change_xattr(struct ubifs_inf
 		return err;
 
 	kfree(ui->data);
-	ui->data = kmalloc(size, GFP_NOFS);
+	ui->data = kmemdup(value, size, GFP_NOFS);
 	if (!ui->data) {
 		err = -ENOMEM;
 		goto out_free;
 	}
-	memcpy(ui->data, value, size);
 	inode->i_size = ui->ui_size = size;
 	ui->data_len = size;
 


