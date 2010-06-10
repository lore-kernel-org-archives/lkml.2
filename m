Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab0FJLAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:00:45 -0400
Received: from smtp.nokia.com ([192.100.105.134]:38937 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806Ab0FJLAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:00:42 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/1] VFS: introduce s_dirty accessors
Date: Thu, 10 Jun 2010 13:56:33 +0300
Message-Id: <1276167393-31492-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1276167393-31492-1-git-send-email-dedekind1@gmail.com>
References: <1276167393-31492-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 10 Jun 2010 11:00:11.0678 (UTC) FILETIME=[18EC63E0:01CB088C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch introduces 3 VFS accessors: 'sb_mark_dirty()',
'sb_mark_clean()', and 'sb_is_dirty()'. They simply
set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
every FS use these accessors later instead of manipulating
the 'sb->s_dirt' flag directly.

Ultimately, this change is a preparation for the periodic
superblock synchronization optimization which is about
preventing the "sync_supers" kernel thread from waking up
even if there is nothing to synchronize.

This patch does not do any functional change, just adds
accessor functions.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/fs.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..68ca1b0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1783,6 +1783,19 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 	struct vfsmount *mnt);
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 
+static inline void sb_mark_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+}
+static inline void sb_mark_clean(struct super_block *sb)
+{
+	sb->s_dirt = 0;
+}
+static inline int sb_is_dirty(struct super_block *sb)
+{
+	return sb->s_dirt;
+}
+
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-- 
1.7.0.1

