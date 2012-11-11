Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2KKUzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 15:55:15 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41929 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab2KKUzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 15:55:12 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        sage@inktank.com, ceph-devel@vger.kernel.org
Subject: [PATCH 3/3] ceph: fix dentry reference leak in ceph_encode_fh().
Date: Sun, 11 Nov 2012 21:49:31 +0100
Message-Id: <1352666971-13551-4-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352666971-13551-1-git-send-email-tipecaml@gmail.com>
References: <1352666971-13551-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dput() was not called in the error path.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 fs/ceph/export.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 9349bb3..ca3ab3f 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -56,13 +56,15 @@ static int ceph_encode_fh(struct inode *inode, u32 *rawfh, int *max_len,
 	struct ceph_nfs_confh *cfh = (void *)rawfh;
 	int connected_handle_length = sizeof(*cfh)/4;
 	int handle_length = sizeof(*fh)/4;
-	struct dentry *dentry = d_find_alias(inode);
+	struct dentry *dentry;
 	struct dentry *parent;
 
 	/* don't re-export snaps */
 	if (ceph_snap(inode) != CEPH_NOSNAP)
 		return -EINVAL;
 
+	dentry = d_find_alias(inode);
+
 	/* if we found an alias, generate a connectable fh */
 	if (*max_len >= connected_handle_length && dentry) {
 		dout("encode_fh %p connectable\n", dentry);
-- 
1.7.10.4

