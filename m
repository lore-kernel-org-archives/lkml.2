Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2F2SXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:23:43 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:44722 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2F2SXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:23:42 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=from:message-id;
	b=E5/TQ8ZPKWn6ogHcpF2Rfd9k6rhKZFcxv/T6wgS069V1vYY9xWIoYRKHgcfw
	KAzWxWx1okV+4ZAs0nVkjSDZAM8/i38/S8AbXfX6TnfQ1/zpu5rACxqgs
	lLj1YgNkRu2GqllDi4G14aErgkfk1NkebhQHd1vhJklviVvleCRPeA=;
X-Spam-Processed: mail.digidescorp.com, Fri, 29 Jun 2012 13:23:40 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=152756e0c6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH v2] fat: Fix non-atomic NFS i_pos read
Date: Fri, 29 Jun 2012 13:23:32 -0500
Message-Id: <1340994212-17153-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fat_encode_fh() can fetch an invalid i_pos value on systems
where 64-bit accesses are not atomic. Make it use the same
accessor as the rest of the FAT code.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
diff -uprN linux-3.5-rc4/fs/fat/inode.c new/fs/fat/inode.c
--- linux-3.5-rc4/fs/fat/inode.c	2012-06-29 11:20:12.781348652 -0500
+++ new/fs/fat/inode.c	2012-06-29 13:18:13.712940800 -0500
@@ -738,22 +738,21 @@ static int
 fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
 {
 	int len = *lenp;
-	u32 ipos_h, ipos_m, ipos_l;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
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

