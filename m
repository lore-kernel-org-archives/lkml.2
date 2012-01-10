Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab2AJXVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:21:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933840Ab2AJW7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:59:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:22 2012
Message-Id: <20120110215022.387200962@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>
Subject: [17/42] ext3: Dont warn from writepage when readonly inode is spotted after error
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 33c104d415e92a51aaf638dc3d93920cfa601e5c upstream.

WARN_ON_ONCE(IS_RDONLY(inode)) tends to trip when filesystem hits error and is
remounted read-only. This unnecessarily scares users (well, they should be
scared because of filesystem error, but the stack trace distracts them from the
right source of their fear ;-). We could as well just remove the WARN_ON but
it's not hard to fix it to not trip on filesystem with errors and not use more
cycles in the common case so that's what we do.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/inode.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1617,7 +1617,13 @@ static int ext3_ordered_writepage(struct
 	int err;
 
 	J_ASSERT(PageLocked(page));
-	WARN_ON_ONCE(IS_RDONLY(inode));
+	/*
+	 * We don't want to warn for emergency remount. The condition is
+	 * ordered to avoid dereferencing inode->i_sb in non-error case to
+	 * avoid slow-downs.
+	 */
+	WARN_ON_ONCE(IS_RDONLY(inode) &&
+		     !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
 	/*
 	 * We give up here if we're reentered, because it might be for a
@@ -1692,7 +1698,13 @@ static int ext3_writeback_writepage(stru
 	int err;
 
 	J_ASSERT(PageLocked(page));
-	WARN_ON_ONCE(IS_RDONLY(inode));
+	/*
+	 * We don't want to warn for emergency remount. The condition is
+	 * ordered to avoid dereferencing inode->i_sb in non-error case to
+	 * avoid slow-downs.
+	 */
+	WARN_ON_ONCE(IS_RDONLY(inode) &&
+		     !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
 	if (ext3_journal_current_handle())
 		goto out_fail;
@@ -1735,7 +1747,13 @@ static int ext3_journalled_writepage(str
 	int err;
 
 	J_ASSERT(PageLocked(page));
-	WARN_ON_ONCE(IS_RDONLY(inode));
+	/*
+	 * We don't want to warn for emergency remount. The condition is
+	 * ordered to avoid dereferencing inode->i_sb in non-error case to
+	 * avoid slow-downs.
+	 */
+	WARN_ON_ONCE(IS_RDONLY(inode) &&
+		     !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ERROR_FS));
 
 	if (ext3_journal_current_handle())
 		goto no_write;


