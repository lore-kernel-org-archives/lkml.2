Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1AHNYD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 08:24:03 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:34811 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab1AHNYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 08:24:02 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] asm-generic headers: modify stat.h in include/asm-generic to be applicable to more architectures
Date: Sat, 8 Jan 2011 21:23:57 +0800
Message-ID: <024501cbaf37$4e479fd0$ead6df70$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuvNmfR1kHPkJu7QiSu/tkhJ/jjnw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

 This patch modifies stat.h in include/asm-generic to be applicable to more architectures.
 STAT64_HAS_BROKEN_ST_INO is defined in most architecture's asm/stat.h, and it need 
 32-bit __st_ino member to be defined in different position of 64-bit st_ino member.
 STAT64_PAD_BEFORE_ST_SIZE is the pad before st_size member, with default value 8 bytes.
 STAT64_PAD_BEFORE_ST_BLOCKS is the pad before st_blocks member, with default value
 4 bytes to align the following member to 64-bit.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 include/asm-generic/stat.h |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/stat.h b/include/asm-generic/stat.h
index bd8cad2..82d1108 100644
--- a/include/asm-generic/stat.h
+++ b/include/asm-generic/stat.h
@@ -45,18 +45,36 @@ struct stat {
 
 /* This matches struct stat64 in glibc2.1. Only used for 32 bit. */
 #if __BITS_PER_LONG != 64 || defined(__ARCH_WANT_STAT64)
+
+#ifndef STAT64_PAD_BEFORE_ST_SIZE
+#define STAT64_PAD_BEFORE_ST_SIZE	8
+#endif
+
+#ifndef STAT64_PAD_BEFORE_ST_BLOCKS
+#define STAT64_PAD_BEFORE_ST_BLOCKS	4
+#endif
+
 struct stat64 {
 	unsigned long long st_dev;	/* Device.  */
+#ifndef STAT64_HAS_BROKEN_ST_INO
 	unsigned long long st_ino;	/* File serial number.  */
+#else /* STAT64_HAS_BROKEN_ST_INO */
+	unsigned int	__unused1;	/* aligned to 64-bit. */
+	unsigned int	__st_ino;	/* File serial number.  */
+#endif /* STAT64_HAS_BROKEN_ST_INO */
 	unsigned int	st_mode;	/* File mode.  */
 	unsigned int	st_nlink;	/* Link count.  */
 	unsigned int	st_uid;		/* User ID of the file's owner.  */
 	unsigned int	st_gid;		/* Group ID of the file's group. */
 	unsigned long long st_rdev;	/* Device number, if device.  */
-	unsigned long long __pad1;
+#if STAT64_PAD_BEFORE_ST_SIZE != 0
+	unsigned char	__unused2[STAT64_PAD_BEFORE_ST_SIZE];
+#endif
 	long long	st_size;	/* Size of file, in bytes.  */
 	int		st_blksize;	/* Optimal block size for I/O.  */
-	int		__pad2;
+#if STAT64_PAD_BEFORE_ST_BLOCKS != 0
+	unsigned char	__unused3[STAT64_PAD_BEFORE_ST_BLOCKS];
+#endif
 	long long	st_blocks;	/* Number 512-byte blocks allocated. */
 	int		st_atime;	/* Time of last access.  */
 	unsigned int	st_atime_nsec;
@@ -64,8 +82,12 @@ struct stat64 {
 	unsigned int	st_mtime_nsec;
 	int		st_ctime;	/* Time of last status change.  */
 	unsigned int	st_ctime_nsec;
+#ifndef STAT64_HAS_BROKEN_ST_INO
 	unsigned int	__unused4;
 	unsigned int	__unused5;
+#else /* STAT64_HAS_BROKEN_ST_INO */
+	unsigned long long st_ino;	/* File serial number.  */
+#endif /* STAT64_HAS_BROKEN_ST_INO */
 };
 #endif


