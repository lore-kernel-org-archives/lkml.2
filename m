Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1ALK4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:56:20 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:60475 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1ALK4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:56:15 -0500
X-Greylist: delayed 1295 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2011 05:56:15 EST
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1082)
Subject: [patch] NTFS: writev() fix and maintenance/contact details update
From: Anton Altaparmakov <anton@tuxera.com>
Date: Wed, 12 Jan 2011 10:34:35 +0000
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <49811222-802E-4A1B-A7BB-65278818D855@tuxera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix writev() to not keep writing the first segment over and over again instead of moving onto subsequent segments and update the NTFS entry in MAINTAINERS to reflect that Tuxera Inc. now supports the NTFS driver.

Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
---
diff --git a/Documentation/filesystems/ntfs.txt b/Documentation/filesystems/ntfs.txt
index ac2a261..6ef8cf3 100644
--- a/Documentation/filesystems/ntfs.txt
+++ b/Documentation/filesystems/ntfs.txt
@@ -457,6 +457,9 @@ ChangeLog
 
 Note, a technical ChangeLog aimed at kernel hackers is in fs/ntfs/ChangeLog.
 
+2.1.30:
+	- Fix writev() (it kept writing the first segment over and over again
+	  instead of moving onto subsequent segments).
 2.1.29:
 	- Fix a deadlock when mounting read-write.
 2.1.28:
diff --git a/MAINTAINERS b/MAINTAINERS
index bb6c1ac..faddb3a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4382,11 +4382,11 @@ F:	Documentation/scsi/NinjaSCSI.txt
 F:	drivers/scsi/nsp32*
 
 NTFS FILESYSTEM
-M:	Anton Altaparmakov <aia21@cantab.net>
+M:	Anton Altaparmakov <anton@tuxera.com>
 L:	linux-ntfs-dev@lists.sourceforge.net
-W:	http://www.linux-ntfs.org/
+W:	http://www.tuxera.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
-S:	Maintained
+S:	Supported
 F:	Documentation/filesystems/ntfs.txt
 F:	fs/ntfs/
 
diff --git a/fs/ntfs/Makefile b/fs/ntfs/Makefile
index 58b6be9..4ff028f 100644
--- a/fs/ntfs/Makefile
+++ b/fs/ntfs/Makefile
@@ -6,7 +6,7 @@ ntfs-objs := aops.o attrib.o collate.o compress.o debug.o dir.o file.o \
 	     index.o inode.o mft.o mst.o namei.o runlist.o super.o sysctl.o \
 	     unistr.o upcase.o
 
-EXTRA_CFLAGS = -DNTFS_VERSION=\"2.1.29\"
+EXTRA_CFLAGS = -DNTFS_VERSION=\"2.1.30\"
 
 ifeq ($(CONFIG_NTFS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 113ebd9..f4b1057 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1,7 +1,7 @@
 /*
  * file.c - NTFS kernel file operations.  Part of the Linux-NTFS project.
  *
- * Copyright (c) 2001-2007 Anton Altaparmakov
+ * Copyright (c) 2001-2011 Anton Altaparmakov and Tuxera Inc.
  *
  * This program/include file is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as published
@@ -1380,15 +1380,14 @@ static inline void ntfs_set_next_iovec(const struct iovec **iovp,
  * pages (out to offset + bytes), to emulate ntfs_copy_from_user()'s
  * single-segment behaviour.
  *
- * We call the same helper (__ntfs_copy_from_user_iovec_inatomic()) both
- * when atomic and when not atomic.  This is ok because
- * __ntfs_copy_from_user_iovec_inatomic() calls __copy_from_user_inatomic()
- * and it is ok to call this when non-atomic.
- * Infact, the only difference between __copy_from_user_inatomic() and
+ * We call the same helper (__ntfs_copy_from_user_iovec_inatomic()) both when
+ * atomic and when not atomic.  This is ok because it calls
+ * __copy_from_user_inatomic() and it is ok to call this when non-atomic.  In
+ * fact, the only difference between __copy_from_user_inatomic() and
  * __copy_from_user() is that the latter calls might_sleep() and the former
- * should not zero the tail of the buffer on error.  And on many
- * architectures __copy_from_user_inatomic() is just defined to
- * __copy_from_user() so it makes no difference at all on those architectures.
+ * should not zero the tail of the buffer on error.  And on many architectures
+ * __copy_from_user_inatomic() is just defined to __copy_from_user() so it
+ * makes no difference at all on those architectures.
  */
 static inline size_t ntfs_copy_from_user_iovec(struct page **pages,
 		unsigned nr_pages, unsigned ofs, const struct iovec **iov,
@@ -1409,28 +1408,28 @@ static inline size_t ntfs_copy_from_user_iovec(struct page **pages,
 		if (unlikely(copied != len)) {
 			/* Do it the slow way. */
 			addr = kmap(*pages);
-			copied = __ntfs_copy_from_user_iovec_inatomic(addr + ofs,
-					*iov, *iov_ofs, len);
-			/*
-			 * Zero the rest of the target like __copy_from_user().
-			 */
-			memset(addr + ofs + copied, 0, len - copied);
-			kunmap(*pages);
+			copied = __ntfs_copy_from_user_iovec_inatomic(addr +
+					ofs, *iov, *iov_ofs, len);
 			if (unlikely(copied != len))
 				goto err_out;
+			kunmap(*pages);
 		}
 		total += len;
+		ntfs_set_next_iovec(iov, iov_ofs, len);
 		bytes -= len;
 		if (!bytes)
 			break;
-		ntfs_set_next_iovec(iov, iov_ofs, len);
 		ofs = 0;
 	} while (++pages < last_page);
 out:
 	return total;
 err_out:
-	total += copied;
+	BUG_ON(copied > len);
 	/* Zero the rest of the target like __copy_from_user(). */
+	memset(addr + ofs + copied, 0, len - copied);
+	kunmap(*pages);
+	total += copied;
+	ntfs_set_next_iovec(iov, iov_ofs, copied);
 	while (++pages < last_page) {
 		bytes -= len;
 		if (!bytes)
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index a30ecacc..29099a0 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1,7 +1,7 @@
 /*
  * super.c - NTFS kernel super block handling. Part of the Linux-NTFS project.
  *
- * Copyright (c) 2001-2007 Anton Altaparmakov
+ * Copyright (c) 2001-2011 Anton Altaparmakov and Tuxera Inc.
  * Copyright (c) 2001,2002 Richard Russon
  *
  * This program/include file is free software; you can redistribute it and/or
@@ -3193,8 +3193,8 @@ static void __exit exit_ntfs_fs(void)
 	ntfs_sysctl(0);
 }
 
-MODULE_AUTHOR("Anton Altaparmakov <aia21@cantab.net>");
-MODULE_DESCRIPTION("NTFS 1.2/3.x driver - Copyright (c) 2001-2007 Anton Altaparmakov");
+MODULE_AUTHOR("Anton Altaparmakov <anton@tuxera.com>");
+MODULE_DESCRIPTION("NTFS 1.2/3.x driver - Copyright (c) 2001-2011 Anton Altaparmakov and Tuxera Inc.");
 MODULE_VERSION(NTFS_VERSION);
 MODULE_LICENSE("GPL");
 #ifdef DEBUG

