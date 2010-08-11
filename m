Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab0HKX7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:14 -0400
Received: from kroah.org ([198.145.64.141]:43526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759170Ab0HKX6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:53 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235502.526268262@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miao Xie <miaox@cn.fujitsu.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [076/111] Btrfs: remove BUG_ON() due to mounting bad filesystem
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miao Xie <miaox@cn.fujitsu.com>

commit d7ce5843bb28ada6845ab2ae8510ba3f12d33154 upstream.

Mounting a bad filesystem caused a BUG_ON(). The following is steps to
reproduce it.
 # mkfs.btrfs /dev/sda2
 # mount /dev/sda2 /mnt
 # mkfs.btrfs /dev/sda1 /dev/sda2
 (the program says that /dev/sda2 was mounted, and then exits. )
 # umount /mnt
 # mount /dev/sda1 /mnt

At the third step, mkfs.btrfs exited in the way of make filesystem. So the
initialization of the filesystem didn't finish. So the filesystem was bad, and
it caused BUG_ON() when mounting it. But BUG_ON() should be called by the wrong
code, not user's operation, so I think it is a bug of btrfs.

This patch fixes it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/disk-io.c    |    7 ++++++-
 fs/btrfs/relocation.c |    3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1982,7 +1982,12 @@ struct btrfs_root *open_ctree(struct sup
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_recover_relocation(tree_root);
-		BUG_ON(ret);
+		if (ret < 0) {
+			printk(KERN_WARNING
+			       "btrfs: failed to recover relocation\n");
+			err = -EINVAL;
+			goto fail_trans_kthread;
+		}
 	}
 
 	location.objectid = BTRFS_FS_TREE_OBJECTID;
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3764,7 +3764,8 @@ out:
 				       BTRFS_DATA_RELOC_TREE_OBJECTID);
 		if (IS_ERR(fs_root))
 			err = PTR_ERR(fs_root);
-		btrfs_orphan_cleanup(fs_root);
+		else
+			btrfs_orphan_cleanup(fs_root);
 	}
 	return err;
 }


