Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1A1Upd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:45:33 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:53915 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab1A1Upc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:45:32 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1082)
Subject: [PATCH] NTFS: Fix invalid pointer dereference in ntfs_mft_record_alloc().
From: Anton Altaparmakov <anton@tuxera.com>
Date: Fri, 28 Jan 2011 20:45:28 +0000
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ntfs-dev <linux-ntfs-dev@lists.sourceforge.net>,
        Julia Lawall <julia@diku.dk>
Content-Transfer-Encoding: 8BIT
Message-Id: <F7EA7DCD-C585-4101-BCB7-3423543976CB@tuxera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ntfs_mft_record_alloc() when mapping the new extent mft record with map_extent_mft_record() we overwrite @m with the return value and on error, we then try to use the old @m but that is no longer there as @m now contains an error code instead so we crash when dereferencing the error code as if it were a pointer.

The simple fix is to use a temporary variable to store the return value thus preserving the original @m for later use.  This is a backport from the commercial Tuxera-NTFS driver and is well tested...

Thanks go to Julia Lawall for pointing this out (whilst I had fixed it in the commercial driver I had failed to fix it in the Linux kernel).

Signed-off-by: Anton Altaparmakov <anton@tuxera.com>
---
diff --git a/Documentation/filesystems/ntfs.txt b/Documentation/filesystems/ntfs.txt
index 6ef8cf3..933bc66 100644
--- a/Documentation/filesystems/ntfs.txt
+++ b/Documentation/filesystems/ntfs.txt
@@ -460,6 +460,8 @@ Note, a technical ChangeLog aimed at kernel hackers is in fs/ntfs/ChangeLog.
 2.1.30:
 	- Fix writev() (it kept writing the first segment over and over again
 	  instead of moving onto subsequent segments).
+	- Fix crash in ntfs_mft_record_alloc() when mapping the new extent mft
+	  record failed.
 2.1.29:
 	- Fix a deadlock when mounting read-write.
 2.1.28:
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index b572b67..326e747 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -1,7 +1,7 @@
 /**
  * mft.c - NTFS kernel mft record operations. Part of the Linux-NTFS project.
  *
- * Copyright (c) 2001-2006 Anton Altaparmakov
+ * Copyright (c) 2001-2011 Anton Altaparmakov and Tuxera Inc.
  * Copyright (c) 2002 Richard Russon
  *
  * This program/include file is free software; you can redistribute it and/or
@@ -2576,6 +2576,8 @@ mft_rec_already_initialized:
 	flush_dcache_page(page);
 	SetPageUptodate(page);
 	if (base_ni) {
+		MFT_RECORD *m_tmp;
+
 		/*
 		 * Setup the base mft record in the extent mft record.  This
 		 * completes initialization of the allocated extent mft record
@@ -2588,11 +2590,11 @@ mft_rec_already_initialized:
 		 * attach it to the base inode @base_ni and map, pin, and lock
 		 * its, i.e. the allocated, mft record.
 		 */
-		m = map_extent_mft_record(base_ni, bit, &ni);
-		if (IS_ERR(m)) {
+		m_tmp = map_extent_mft_record(base_ni, bit, &ni);
+		if (IS_ERR(m_tmp)) {
 			ntfs_error(vol->sb, "Failed to map allocated extent "
 					"mft record 0x%llx.", (long long)bit);
-			err = PTR_ERR(m);
+			err = PTR_ERR(m_tmp);
 			/* Set the mft record itself not in use. */
 			m->flags &= cpu_to_le16(
 					~le16_to_cpu(MFT_RECORD_IN_USE));
@@ -2603,6 +2605,7 @@ mft_rec_already_initialized:
 			ntfs_unmap_page(page);
 			goto undo_mftbmp_alloc;
 		}
+		BUG_ON(m != m_tmp);
 		/*
 		 * Make sure the allocated mft record is written out to disk.
 		 * No need to set the inode dirty because the caller is going

