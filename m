Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab2BCU6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:58:21 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41050 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab2BCU5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:57:18 -0500
Message-ID: <4F2C4A29.7000000@gmail.com>
Date: Fri, 03 Feb 2012 15:57:13 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Alex Elder <elder@dreamhost.com>, Sage Weil <sage@newdream.net>
CC: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ceph: avoid panic with mismatched symlink sizes in fill_inode()
References: <1328280936-2688-1-git-send-email-xi.wang@gmail.com>
In-Reply-To: <1328280936-2688-1-git-send-email-xi.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -EINVAL rather than panic if iinfo->symlink_len and inode->i_size
do not match.

Also use kstrndup rather than kmalloc/memcpy.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 fs/ceph/inode.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2c48937..9fff9f3 100644
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
+			if (WARN_ON(symlen != inode->i_size))
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

