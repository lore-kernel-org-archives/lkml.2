Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0ERAwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:52:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52953 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab0ERAwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:52:00 -0400
Message-ID: <4BF1E4AA.9090709@cn.fujitsu.com>
Date: Tue, 18 May 2010 08:51:54 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: chris.mason@oracle.com, "Yan, Zheng" <zheng.yan@oracle.com>
CC: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: prohibit a operation of changing acl's mask when noacl
 mount option used
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when used Posix File System Test Suite(pjd-fstest) to test btrfs, 
some cases about setfacl failed when noacl mount option used.
I simplified used commands in pjd-fstest, and the following steps 
can reproduce it.
------------------------
# cd btrfs-part/
# mkdir aaa
# setfacl -m m::rw aaa    <- successed, but not expected by pjd-fstest.
------------------------
I checked ext3, a warning message occured, like as:
  setfacl: aaa/: Operation not supported
Certainly, it's expected by pjd-fstest.

So, i compared acl.c of btrfs and ext3. Based on that, a patch created.
Fortunately, it works.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
---
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index da3133c..f2e09c2 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -159,6 +159,9 @@ static int btrfs_xattr_set_acl(struct inode *inode, int type,
 	int ret;
 	struct posix_acl *acl = NULL;
 
+	if (!IS_POSIXACL(inode))
+		return -EOPNOTSUPP;
+
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
 		if (acl == NULL) {




