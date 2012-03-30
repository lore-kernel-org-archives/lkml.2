Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965257Ab2C3WMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:12:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56556 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965090Ab2C3VOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:14:39 -0400
Message-Id: <20120330194858.313865044@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lukas Czerner <lczerner@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 112/149] ext4: ignore EXT4_INODE_JOURNAL_DATA flag with delalloc
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 3d2b158262826e8b75bbbfb7b97010838dd92ac7 upstream.

Ext4 does not support data journalling with delayed allocation enabled.
We even do not allow to mount the file system with delayed allocation
and data journalling enabled, however it can be set via FS_IOC_SETFLAGS
so we can hit the inode with EXT4_INODE_JOURNAL_DATA set even on file
system mounted with delayed allocation (default) and that's where
problem arises. The easies way to reproduce this problem is with the
following set of commands:

 mkfs.ext4 /dev/sdd
 mount /dev/sdd /mnt/test1
 dd if=/dev/zero of=/mnt/test1/file bs=1M count=4
 chattr +j /mnt/test1/file
 dd if=/dev/zero of=/mnt/test1/file bs=1M count=4 conv=notrunc
 chattr -j /mnt/test1/file

Additionally it can be reproduced quite reliably with xfstests 272 and
269. In fact the above reproducer is a part of test 272.

To fix this we should ignore the EXT4_INODE_JOURNAL_DATA inode flag if
the file system is mounted with delayed allocation. This can be easily
done by fixing ext4_should_*_data() functions do ignore data journal
flag when delalloc is set (suggested by Ted). We also have to set the
appropriate address space operations for the inode (again, ignoring data
journal flag if delalloc enabled).

Additionally this commit introduces ext4_inode_journal_mode() function
because ext4_should_*_data() has already had a lot of common code and
this change is putting it all into one function so it is easier to
read.

Successfully tested with xfstests in following configurations:

delalloc + data=ordered
delalloc + data=writeback
data=journal
nodelalloc + data=ordered
nodelalloc + data=writeback
nodelalloc + data=journal

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4_jbd2.h |   56 ++++++++++++++++++++++++++--------------------------
 fs/ext4/inode.c     |   36 ++++++++++++++++++++-------------
 2 files changed, 51 insertions(+), 41 deletions(-)

--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -261,43 +261,45 @@ static inline void ext4_update_inode_fsy
 /* super.c */
 int ext4_force_commit(struct super_block *sb);
 
-static inline int ext4_should_journal_data(struct inode *inode)
+/*
+ * Ext4 inode journal modes
+ */
+#define EXT4_INODE_JOURNAL_DATA_MODE	0x01 /* journal data mode */
+#define EXT4_INODE_ORDERED_DATA_MODE	0x02 /* ordered data mode */
+#define EXT4_INODE_WRITEBACK_DATA_MODE	0x04 /* writeback data mode */
+
+static inline int ext4_inode_journal_mode(struct inode *inode)
 {
 	if (EXT4_JOURNAL(inode) == NULL)
-		return 0;
-	if (!S_ISREG(inode->i_mode))
-		return 1;
-	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
-		return 1;
-	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
-		return 1;
-	return 0;
+		return EXT4_INODE_WRITEBACK_DATA_MODE;	/* writeback */
+	/* We do not support data journalling with delayed allocation */
+	if (!S_ISREG(inode->i_mode) ||
+	    test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
+		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */
+	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
+	    !test_opt(inode->i_sb, DELALLOC))
+		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */
+	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
+		return EXT4_INODE_ORDERED_DATA_MODE;	/* ordered */
+	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
+		return EXT4_INODE_WRITEBACK_DATA_MODE;	/* writeback */
+	else
+		BUG();
+}
+
+static inline int ext4_should_journal_data(struct inode *inode)
+{
+	return ext4_inode_journal_mode(inode) & EXT4_INODE_JOURNAL_DATA_MODE;
 }
 
 static inline int ext4_should_order_data(struct inode *inode)
 {
-	if (EXT4_JOURNAL(inode) == NULL)
-		return 0;
-	if (!S_ISREG(inode->i_mode))
-		return 0;
-	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
-		return 0;
-	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
-		return 1;
-	return 0;
+	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE;
 }
 
 static inline int ext4_should_writeback_data(struct inode *inode)
 {
-	if (EXT4_JOURNAL(inode) == NULL)
-		return 1;
-	if (!S_ISREG(inode->i_mode))
-		return 0;
-	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
-		return 0;
-	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
-		return 1;
-	return 0;
+	return ext4_inode_journal_mode(inode) & EXT4_INODE_WRITEBACK_DATA_MODE;
 }
 
 /*
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2480,13 +2480,14 @@ static int ext4_da_write_end(struct file
 	int write_mode = (int)(unsigned long)fsdata;
 
 	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
-		if (ext4_should_order_data(inode)) {
+		switch (ext4_inode_journal_mode(inode)) {
+		case EXT4_INODE_ORDERED_DATA_MODE:
 			return ext4_ordered_write_end(file, mapping, pos,
 					len, copied, page, fsdata);
-		} else if (ext4_should_writeback_data(inode)) {
+		case EXT4_INODE_WRITEBACK_DATA_MODE:
 			return ext4_writeback_write_end(file, mapping, pos,
 					len, copied, page, fsdata);
-		} else {
+		default:
 			BUG();
 		}
 	}
@@ -3084,18 +3085,25 @@ static const struct address_space_operat
 
 void ext4_set_aops(struct inode *inode)
 {
-	if (ext4_should_order_data(inode) &&
-		test_opt(inode->i_sb, DELALLOC))
-		inode->i_mapping->a_ops = &ext4_da_aops;
-	else if (ext4_should_order_data(inode))
-		inode->i_mapping->a_ops = &ext4_ordered_aops;
-	else if (ext4_should_writeback_data(inode) &&
-		 test_opt(inode->i_sb, DELALLOC))
-		inode->i_mapping->a_ops = &ext4_da_aops;
-	else if (ext4_should_writeback_data(inode))
-		inode->i_mapping->a_ops = &ext4_writeback_aops;
-	else
+	switch (ext4_inode_journal_mode(inode)) {
+	case EXT4_INODE_ORDERED_DATA_MODE:
+		if (test_opt(inode->i_sb, DELALLOC))
+			inode->i_mapping->a_ops = &ext4_da_aops;
+		else
+			inode->i_mapping->a_ops = &ext4_ordered_aops;
+		break;
+	case EXT4_INODE_WRITEBACK_DATA_MODE:
+		if (test_opt(inode->i_sb, DELALLOC))
+			inode->i_mapping->a_ops = &ext4_da_aops;
+		else
+			inode->i_mapping->a_ops = &ext4_writeback_aops;
+		break;
+	case EXT4_INODE_JOURNAL_DATA_MODE:
 		inode->i_mapping->a_ops = &ext4_journalled_aops;
+		break;
+	default:
+		BUG();
+	}
 }
 
 


