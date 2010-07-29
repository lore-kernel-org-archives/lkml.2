Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0G2JEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:04:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57727 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0G2JEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:04:45 -0400
Message-ID: <4C513BAC.8050904@cn.fujitsu.com>
Date: Thu, 29 Jul 2010 16:28:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Yan Zheng <zheng.yan@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/7] btrfs/acl: add noacl check for btrfs_get_acl()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btrfs returned the acl info though it was mounted with "noacl" option.

Steps to reproduce:
 # mkfs.btrfs /dev/sda2
 # mount /dev/sda2 /mnt
 # touch /mnt/file0
 # setfacl -m 'u:root:x,g::x,o::x' /mnt/file0
 # umount /mnt
 # mount /dev/sda2 -o noacl /mnt
 # getfacl /mnt/file0

we add a noacl check for btrfs_get_acl() to fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/acl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index bb35580..b070f58 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -37,6 +37,9 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 	char *value = NULL;
 	struct posix_acl *acl;
 
+	if (!IS_POSIXACL(inode))
+		return NULL;
+
 	acl = get_cached_acl(inode, type);
 	if (acl != ACL_NOT_CACHED)
 		return acl;
-- 
1.7.0.1
