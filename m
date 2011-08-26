Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab1H0PE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:04:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab1H0O6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:54 2011
Message-Id: <20110826215054.733386576@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Curt Wohlgemuth <curtw@google.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [18/35] ext4: Fix ext4_should_writeback_data() for no-journal mode
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Curt Wohlgemuth <curtw@google.com>

commit 441c850857148935babe000fc2ba1455fe54a6a9 upstream.

ext4_should_writeback_data() had an incorrect sequence of
tests to determine if it should return 0 or 1: in
particular, even in no-journal mode, 0 was being returned
for a non-regular-file inode.

This meant that, in non-journal mode, we would use
ext4_journalled_aops for directories, symlinks, and other
non-regular files.  However, calling journalled aop
callbacks when there is no valid handle, can cause problems.

This would cause a kernel crash with Jan Kara's commit
2d859db3e4 ("ext4: fix data corruption in inodes with
journalled data"), because we now dereference 'handle' in
ext4_journalled_write_end().

I also added BUG_ONs to check for a valid handle in the
obviously journal-only aops callbacks.

I tested this running xfstests with a scratch device in
these modes:

   - no-journal
   - data=ordered
   - data=writeback
   - data=journal

All work fine; the data=journal run has many failures and a
crash in xfstests 074, but this is no different from a
vanilla kernel.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4_jbd2.h |    4 ++--
 fs/ext4/inode.c     |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -289,10 +289,10 @@ static inline int ext4_should_order_data
 
 static inline int ext4_should_writeback_data(struct inode *inode)
 {
-	if (!S_ISREG(inode->i_mode))
-		return 0;
 	if (EXT4_JOURNAL(inode) == NULL)
 		return 1;
+	if (!S_ISREG(inode->i_mode))
+		return 0;
 	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
 		return 0;
 	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1849,6 +1849,8 @@ static int ext4_journalled_write_end(str
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
+	BUG_ON(!ext4_handle_valid(handle));
+
 	if (copied < len) {
 		if (!PageUptodate(page))
 			copied = 0;
@@ -2564,6 +2566,8 @@ static int __ext4_journalled_writepage(s
 		goto out;
 	}
 
+	BUG_ON(!ext4_handle_valid(handle));
+
 	ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
 				do_journal_get_write_access);
 


