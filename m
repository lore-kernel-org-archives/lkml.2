Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab0EKWay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 18:30:54 -0400
Received: from kunzite.stewarts.org.uk ([80.68.93.148]:46623 "EHLO
	kunzite.stewarts.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab0EKWaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 18:30:52 -0400
X-Greylist: delayed 2264 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 18:30:52 EDT
Date: Tue, 11 May 2010 22:53:04 +0100
From: Thomas Stewart <thomas@stewarts.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Mounting BorderWare UFS File Systems
Message-ID: <20100511215300.GA22152@stewarts.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently had to recover some files from an old broken machine that was
running BorderWare Document Gateway. It's basically a drop in web server
for sharing files. From the look of the init process and using strings
on of a few files it seems to be based on FreeBSD 3.3. The process
turned out to be more difficult than I imagined, but to cut a long story
short BorderWare in their wisdom use a nonstandard magic number in their
UFS (ufstype=44bsd) file systems. Thus Linux refuses to mount the file
systems in order to recover the data. After a bit of hunting I was able
to make a quick fix to fs/ufs/super.c in order to detect the new magic
number. I don't think this needs to get into mainline, but hopefully
this will hit the archives to save anyone else the effort. I'm assume
that this number is the same for all installations. It's quite easy to
find out from ufs_fs.h. The superblock sits 8k into the block device and
the magic number its 1372 bytes into the superblock struct.

# dd if=/dev/sda5 skip=$(( 8192 + 1372 )) bs=1 count=4 2> /dev/null | hd
00000000  97 26 24 0f                                       |.&$.|
#

Here is the patch, please cc any questions or comments as I'm off list.

diff -urN linux-2.6.33.1.orig/fs/ufs/super.c linux-2.6.33.1/fs/ufs/super.c
--- linux-2.6.33.1.orig/fs/ufs/super.c  2010-05-11 20:07:08.000000000 +0100
+++ linux-2.6.33.1/fs/ufs/super.c       2010-05-11 21:23:06.000000000 +0100
@@ -918,6 +918,7 @@
        sbi->s_bytesex = BYTESEX_LE;
        switch ((uspi->fs_magic = fs32_to_cpu(sb, usb3->fs_magic))) {
                case UFS_MAGIC:
+               case UFS_MAGIC_BW:
                case UFS2_MAGIC:
                case UFS_MAGIC_LFN:
                case UFS_MAGIC_FEA:
@@ -927,6 +928,7 @@
        sbi->s_bytesex = BYTESEX_BE;
        switch ((uspi->fs_magic = fs32_to_cpu(sb, usb3->fs_magic))) {
                case UFS_MAGIC:
+               case UFS_MAGIC_BW:
                case UFS2_MAGIC:
                case UFS_MAGIC_LFN:
                case UFS_MAGIC_FEA:
diff -urN linux-2.6.33.1.orig/fs/ufs/ufs_fs.h linux-2.6.33.1/fs/ufs/ufs_fs.h
--- linux-2.6.33.1.orig/fs/ufs/ufs_fs.h 2010-03-15 16:09:39.000000000 +0000
+++ linux-2.6.33.1/fs/ufs/ufs_fs.h      2010-05-11 21:20:35.000000000 +0100
@@ -48,6 +48,7 @@
 #define UFS_SECTOR_SIZE 512
 #define UFS_SECTOR_BITS 9
 #define UFS_MAGIC  0x00011954
+#define UFS_MAGIC_BW 0x0f242697
 #define UFS2_MAGIC 0x19540119
 #define UFS_CIGAM  0x54190100 /* byteswapped MAGIC */
 
Regards
--
Tom
