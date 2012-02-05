Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab2BEWet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:34:49 -0500
Received: from 1wt.eu ([62.212.114.60]:62112 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab2BEW07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:59 -0500
Message-Id: <20120205220951.716704592@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:42 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>, Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>,
        Yingbin Wang <yingbin.wangyb@aliyun-inc.com>,
        Jia Wan <jia.wanj@aliyun-inc.com>, Zheng Liu <wenqing.lz@taobao.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 53/91] ext4: fix BUG_ON() in ext4_ext_insert_extent()
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

Does not corrispond with a direct commit in Linus's tree as it was fixed
differently in the 3.0 release.


We will meet with a BUG_ON() if following script is run.

mkfs.ext4 -b 4096 /dev/sdb1 1000000
mount -t ext4 /dev/sdb1 /mnt/sdb1
fallocate -l 100M /mnt/sdb1/test
sync
for((i=0;i<170;i++))
do
        dd if=/dev/zero of=/mnt/sdb1/test conv=notrunc bs=256k count=1
seek=`expr $i \* 2`
done
umount /mnt/sdb1
mount -t ext4 /dev/sdb1 /mnt/sdb1
dd if=/dev/zero of=/mnt/sdb1/test conv=notrunc bs=256k count=1 seek=341
umount /mnt/sdb1
mount /dev/sdb1 /mnt/sdb1
dd if=/dev/zero of=/mnt/sdb1/test conv=notrunc bs=256k count=1 seek=340
sync

The reason is that it forgot to mark dirty when splitting two extents in
ext4_ext_convert_to_initialized(). Althrough ex has been updated in
memory, it is not dirtied both in ext4_ext_convert_to_initialized() and
ext4_ext_insert_extent(). The disk layout is corrupted. Then it will
meet with a BUG_ON() when writting at the start of that extent again.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>
Cc: Yingbin Wang <yingbin.wangyb@aliyun-inc.com>
Cc: Jia Wan <jia.wanj@aliyun-inc.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/fs/ext4/extents.c
===================================================================
--- longterm-2.6.27.orig/fs/ext4/extents.c	2012-02-05 22:34:33.413914999 +0100
+++ longterm-2.6.27/fs/ext4/extents.c	2012-02-05 22:34:42.416916530 +0100
@@ -2327,6 +2327,7 @@
 		ex1 = ex;
 		ex1->ee_len = cpu_to_le16(iblock - ee_block);
 		ext4_ext_mark_uninitialized(ex1);
+		ext4_ext_dirty(handle, inode, path + depth);
 		ex2 = &newex;
 	}
 	/*


