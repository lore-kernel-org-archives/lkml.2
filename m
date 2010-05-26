Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0EZKNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:13:33 -0400
Received: from hera.amn.nl ([213.189.22.5]:1689 "EHLO AMN.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753285Ab0EZKNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:13:32 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2010 06:13:31 EDT
Message-ID: <4BFCF1EB.20709@cs.vu.nl>
Date: Wed, 26 May 2010 12:03:23 +0200
From: Erik van der Kouwe <vdkouwe@cs.vu.nl>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Fam Zheng <famcool@gmail.com>
Subject: [PATCH] fs/minix: bugfix, number of indirect block ptrs per block
 depends on block size
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
AMN-SPF: NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik van der Kouwe <vdkouwe@cs.vu.nl>

The MINIX filesystem driver used a constant number of indirect block 
pointers in an indirect block. This worked only for filesystems with 1kb 
block, while the MINIX default block size is now 4kb. As a consequence, 
large files were read incorrectly on such filesystems and writing a 
large file would cause the filesystem to become corrupted. This patch 
computes the number of indirect block pointers based on the block size, 
making the driver work for each block size. 

I would like to thank Feiran Zheng ('Fam') for pointing out the cause 
of the corruption.

Signed-off-by: Erik van der Kouwe <vdkouwe@cs.vu.nl>
---

--- fs/minix/itree_v2.c.orig	2010-05-26 14:10:15.000000000 +0200
+++ fs/minix/itree_v2.c	2010-05-26 13:44:53.000000000 +0200
@@ -20,6 +20,9 @@ static inline block_t *i_data(struct ino
 	return (block_t *)minix_i(inode)->u.i2_data;
 }
 
+#define DIRCOUNT 7
+#define INDIRCOUNT(sb) ((sb)->s_blocksize / 4)
+
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
@@ -34,21 +37,21 @@ static int block_to_path(struct inode * 
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %s\n",
 				block, bdevname(sb->s_bdev, b));
-	} else if (block < 7) {
+	} else if (block < DIRCOUNT) {
 		offsets[n++] = block;
-	} else if ((block -= 7) < 256) {
-		offsets[n++] = 7;
+	} else if ((block -= DIRCOUNT) < INDIRCOUNT(sb)) {
+		offsets[n++] = DIRCOUNT;
 		offsets[n++] = block;
-	} else if ((block -= 256) < 256*256) {
-		offsets[n++] = 8;
-		offsets[n++] = block>>8;
-		offsets[n++] = block & 255;
+	} else if ((block -= INDIRCOUNT(sb)) < INDIRCOUNT(sb) * INDIRCOUNT(sb)) {
+		offsets[n++] = DIRCOUNT + 1;
+		offsets[n++] = block / INDIRCOUNT(sb);
+		offsets[n++] = block % INDIRCOUNT(sb);
 	} else {
-		block -= 256*256;
-		offsets[n++] = 9;
-		offsets[n++] = block>>16;
-		offsets[n++] = (block>>8) & 255;
-		offsets[n++] = block & 255;
+		block -= INDIRCOUNT(sb) * INDIRCOUNT(sb);
+		offsets[n++] = DIRCOUNT + 2;
+		offsets[n++] = (block / INDIRCOUNT(sb)) / INDIRCOUNT(sb);
+		offsets[n++] = (block / INDIRCOUNT(sb)) % INDIRCOUNT(sb);
+		offsets[n++] = block % INDIRCOUNT(sb);
 	}
 	return n;
 }

