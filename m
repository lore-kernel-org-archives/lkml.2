Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2BCO7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:59:19 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35020 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab2BCO7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:59:17 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH RESEND] ceph: avoid panic with mismatched symlink sizes in fill_inode()
Date: Fri,  3 Feb 2012 09:55:36 -0500
Message-Id: <1328280936-2688-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -EINVAL rather than panic if iinfo->symlink_len and
inode->i_size do not match.

Also use kstrndup rather than kmalloc/memcpy.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 fs/ceph/inode.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2c48937..6c0205d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -677,18 +677,19 @@ static int fill_inode(struct inode *inode,
 	case S_IFLNK:
 		inode->i_op = &ceph_symlink_iops;
 		if (!ci->i_symlink) {
-			int symlen = iinfo->symlink_len;
+			u32 symlen = iinfo->symlink_len;
 			char *sym;
 
-			BUG_ON(symlen != inode->i_size);
 			spin_unlock(&ci->i_ceph_lock);
 
+			err = -EINVAL;
+			if (symlen != inode->i_size)
+				goto out;
+
 			err = -ENOMEM;
-			sym = kmalloc(symlen+1, GFP_NOFS);
+			sym = kstrndup(iinfo->symlink, symlen, GFP_NOFS);
 			if (!sym)
 				goto out;
-			memcpy(sym, iinfo->symlink, symlen);
-			sym[symlen] = 0;
 
 			spin_lock(&ci->i_ceph_lock);
 			if (!ci->i_symlink)
-- 
1.7.5.4

