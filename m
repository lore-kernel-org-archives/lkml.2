Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab0DVTex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:34:53 -0400
Received: from kroah.org ([198.145.64.141]:41545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905Ab0DVT3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:53 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:23 2010
Message-Id: <20100422190923.426555648@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       maximilian attems <max@stro.at>
Subject: [179/197] fs-writeback: Add helper function to start writeback if idle
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 17bd55d037a02b04d9119511cfd1a4b985d20f63 upstream.

ext4, at least, would like to start pushing on writeback if it starts
to get close to ENOSPC when reserving worst-case blocks for delalloc
writes.  Writing out delalloc data will convert those worst-case
predictions into usually smaller actual usage, freeing up space
before we hit ENOSPC based on this speculation.

Thanks to Jens for the suggestion for the helper function,
& the naming help.

I've made the helper return status on whether writeback was
started even though I don't plan to use it in the ext4 patch;
it seems like it would be potentially useful to test this
in some cases.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fs-writeback.c         |   17 +++++++++++++++++
 include/linux/writeback.h |    1 +
 2 files changed, 18 insertions(+)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1213,6 +1213,23 @@ void writeback_inodes_sb(struct super_bl
 EXPORT_SYMBOL(writeback_inodes_sb);
 
 /**
+ * writeback_inodes_sb_if_idle	-	start writeback if none underway
+ * @sb: the superblock
+ *
+ * Invoke writeback_inodes_sb if no writeback is currently underway.
+ * Returns 1 if writeback was started, 0 if not.
+ */
+int writeback_inodes_sb_if_idle(struct super_block *sb)
+{
+	if (!writeback_in_progress(sb->s_bdi)) {
+		writeback_inodes_sb(sb);
+		return 1;
+	} else
+		return 0;
+}
+EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
+
+/**
  * sync_inodes_sb	-	sync sb inode pages
  * @sb: the superblock
  *
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -69,6 +69,7 @@ struct writeback_control {
 struct bdi_writeback;
 int inode_wait(void *);
 void writeback_inodes_sb(struct super_block *);
+int writeback_inodes_sb_if_idle(struct super_block *);
 void sync_inodes_sb(struct super_block *);
 void writeback_inodes_wbc(struct writeback_control *wbc);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);


