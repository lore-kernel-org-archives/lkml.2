Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab2EMLEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 07:04:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab2EMLEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 07:04:09 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 2/2] fat: use fat_msg_ratelimit in fat__get_entry.
Date: Sun, 13 May 2012 07:03:59 -0400
Message-Id: <1336907039-18638-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When application tried to lookup(opendir/readdir/stat) 5000 files in plugging usb device formatted by FAT, If unplugging usb device while lookup files, so many message occured like the below log. and currently it make app slow.
So this patch use fat_msg_ratelimit function about this message to decrease this messages.

#> ./file_lookup_testcase ./files_directory/
[   57.768000] usb 2-1.4: USB disconnect, device number 4
[   57.812000] FAT-fs (sda1): FAT read failed (blocknr 2631)
stat failed
[   57.816000] FAT-fs (sda1): Directory bread(block 396816) failed
[   57.824000] FAT-fs (sda1): Directory bread(block 396817) failed
: No such file [   57.832000] FAT-fs (sda1): Directory bread(block 396818) failed
or directory
[   57.840000] FAT-fs (sda1): Directory bread(block 396819) failed
[   57.848000] FAT-fs (sda1): Directory bread(block 396820) failed
[   57.860000] FAT-fs (sda1): Directory bread(block 396821) failed
[   57.876000] FAT-fs (sda1): Directory bread(block 396822) failed
[   57.892000] FAT-fs (sda1): Directory bread(block 396823) failed
[   57.904000] FAT-fs (sda1): Directory bread(block 406824) failed
[   57.920000] FAT-fs (sda1): Directory bread(block 406825) failed
[   57.932000] FAT-fs (sda1): Directory bread(block 406826) failed
[   57.940000] FAT-fs (sda1): Directory bread(block 406827) failed
[   57.952000] FAT-fs (sda1): Directory bread(block 406828) failed
[   57.960000] FAT-fs (sda1): Directory bread(block 406829) failed
[   57.964000] FAT-fs (sda1): Directory bread(block 406830) failed
[   57.972000] FAT-fs (sda1): Directory bread(block 406831) failed
[   57.976000] FAT-fs (sda1): Directory bread(block 417696) failed
[   57.984000] FAT-fs (sda1): Directory bread(block 417697) failed
[   57.988000] FAT-fs (sda1): Directory bread(block 417698) failed
[   57.996000] FAT-fs (sda1): Directory bread(block 417699) failed
[   58.000000] FAT-fs (sda1): Directory bread(block 417700) failed
[   58.004000] FAT-fs (sda1): Directory bread(block 417701) failed
[   58.012000] FAT-fs (sda1): Directory bread(block 417702) failed
[   58.016000] FAT-fs (sda1): Directory bread(block 417703) failed
[   58.024000] FAT-fs (sda1): FAT read failed (blocknr 2631)
stat[   58.028000] FAT-fs (sda1): Directory bread(block 396816) failed
[   58.036000] FAT-fs (sda1): Directory bread(block 396817) failed
[   58.040000] FAT-fs (sda1): Directory bread(block 396818) failed
[   58.048000] FAT-fs (sda1): Directory bread(block 396819) failed
[   58.052000] FAT-fs (sda1): Directory bread(block 396820) failed
[   58.060000] FAT-fs (sda1): Directory bread(block 396821) failed
....
...
.
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index aca191b..b2cdbf4 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -98,8 +98,8 @@ next:
 
 	*bh = sb_bread(sb, phys);
 	if (*bh == NULL) {
-		fat_msg(sb, KERN_ERR, "Directory bread(block %llu) failed",
-		       (llu)phys);
+		fat_msg_ratelimit(sb, KERN_ERR, "Directory bread(block %llu) "
+				"failed", (llu)phys);
 		/* skip this block */
 		*pos = (iblock + 1) << sb->s_blocksize_bits;
 		goto next;
-- 
1.7.5.4

