Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2F2R30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 13:29:26 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:26063 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2F2R3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 13:29:25 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2012 13:29:25 EDT
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=from:message-id;
	b=KN0Ge3FpKCAFTmPt5ezUYy9bj0esRZRAbqZRSf9xoAXjR4IOzkXMQMtbMB3X
	TFaxfWRqEXysHuGyoeUebHaTNH7DLMJgrjl3cmnJmO3l0QrHLQjgrnaM+
	0ae68xBGFkFsXZXKgX7XiT1NOnqZ3EEe/rP39AQmDIu7IhIxcBBigQ=;
X-Spam-Processed: mail.digidescorp.com, Fri, 29 Jun 2012 12:19:34 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=152756e0c6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] fat: Fix non-atomic NFS i_pos read
Date: Fri, 29 Jun 2012 12:19:10 -0500
Message-Id: <1340990350-9565-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fat_encode_fh() can fetch an invalid i_pos value on systems
where 64-bit accesses are not atomic. Make it use the same
accessor as the rest of the FAT code.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN linux-3.5-rc4/fs/fat/inode.c new/fs/fat/inode.c
--- linux-3.5-rc4/fs/fat/inode.c	2012-06-29 11:20:12.781348652 -0500
+++ new/fs/fat/inode.c	2012-06-29 11:25:29.484713183 -0500
@@ -738,22 +738,22 @@ static int
 fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
 {
 	int len = *lenp;
-	u32 ipos_h, ipos_m, ipos_l;
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	loff_t i_pos;
 
 	if (len < 5) {
 		*lenp = 5;
 		return 255; /* no room */
 	}
 
-	ipos_h = MSDOS_I(inode)->i_pos >> 8;
-	ipos_m = (MSDOS_I(inode)->i_pos & 0xf0) << 24;
-	ipos_l = (MSDOS_I(inode)->i_pos & 0x0f) << 28;
+	i_pos = fat_i_pos_read(sbi, inode);
 	*lenp = 5;
 	fh[0] = inode->i_ino;
 	fh[1] = inode->i_generation;
-	fh[2] = ipos_h;
-	fh[3] = ipos_m | MSDOS_I(inode)->i_logstart;
-	fh[4] = ipos_l;
+	fh[2] = i_pos >> 8;
+	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
+	fh[4] = (i_pos & 0x0f) << 28;
 	if (parent)
 		fh[4] |= MSDOS_I(parent)->i_logstart;
 	return 3;

