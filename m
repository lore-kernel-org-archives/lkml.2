Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0ERAuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:50:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61553 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0ERAui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:50:38 -0400
Message-ID: <4BF1E458.7060500@cn.fujitsu.com>
Date: Tue, 18 May 2010 08:50:32 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: chris.mason@oracle.com, "Yan, Zheng" <zheng.yan@oracle.com>
CC: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: should add a permission check for setfacl
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On btrfs, do the following
------------------
# su user1
# cd btrfs-part/
# touch aaa
# getfacl aaa
  # file: aaa
  # owner: user1
  # group: user1
  user::rw-
  group::rw-
  other::r--
# su user2
# cd btrfs-part/
# setfacl -m u::rwx aaa
# getfacl aaa
  # file: aaa
  # owner: user1
  # group: user1
  user::rwx           <- successed to setfacl
  group::rw-
  other::r--
------------------
but we should prohibit it that user2 changing user1's acl.
In fact, on ext3 and other fs, a message occurs:
  setfacl: aaa: Operation not permitted

This patch fixed it.
Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
---
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index da3133c..12d7be8 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -159,6 +159,9 @@ static int btrfs_xattr_set_acl(struct inode *inode, int type,
 	int ret;
 	struct posix_acl *acl = NULL;
 
+	if (!is_owner_or_cap(inode))
+		return -EPERM;
+
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
 		if (acl == NULL) {


