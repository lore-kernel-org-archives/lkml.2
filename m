Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab1J1MOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:14:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44591 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab1J1MOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:14:05 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 11/13] vfs: protect i_nlink
Date: Fri, 28 Oct 2011 14:13:30 +0200
Message-Id: <1319804012-16346-12-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
References: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Prevent direct modification of i_nlink by making it const and adding a
non-const __i_nlink alias.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/inode.c         |    2 +-
 include/linux/fs.h |   20 +++++++++++++++-----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ec79246..e2d3633 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -142,7 +142,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	atomic_set(&inode->i_count, 1);
 	inode->i_op = &empty_iops;
 	inode->i_fop = &empty_fops;
-	inode->i_nlink = 1;
+	inode->__i_nlink = 1;
 	inode->i_opflags = 0;
 	inode->i_uid = 0;
 	inode->i_gid = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a56dbef..b9a4920 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -767,7 +767,17 @@ struct inode {
 
 	/* Stat data, not accessed from path walking */
 	unsigned long		i_ino;
-	unsigned int		i_nlink;
+	/*
+	 * Filesystems may only read i_nlink directly.  They shall use the
+	 * following functions for modification:
+	 *
+	 *    (set|clear|inc|drop)_nlink
+	 *    inode_(inc|dec)_link_count
+	 */
+	union {
+		const unsigned int i_nlink;
+		unsigned int __i_nlink;
+	};
 	dev_t			i_rdev;
 	loff_t			i_size;
 	struct timespec		i_atime;
@@ -1761,7 +1771,7 @@ static inline void mark_inode_dirty_sync(struct inode *inode)
  */
 static inline void set_nlink(struct inode *inode, unsigned int nlink)
 {
-	inode->i_nlink = nlink;
+	inode->__i_nlink = nlink;
 }
 
 /**
@@ -1774,7 +1784,7 @@ static inline void set_nlink(struct inode *inode, unsigned int nlink)
  */
 static inline void inc_nlink(struct inode *inode)
 {
-	inode->i_nlink++;
+	inode->__i_nlink++;
 }
 
 static inline void inode_inc_link_count(struct inode *inode)
@@ -1796,7 +1806,7 @@ static inline void inode_inc_link_count(struct inode *inode)
  */
 static inline void drop_nlink(struct inode *inode)
 {
-	inode->i_nlink--;
+	inode->__i_nlink--;
 }
 
 /**
@@ -1809,7 +1819,7 @@ static inline void drop_nlink(struct inode *inode)
  */
 static inline void clear_nlink(struct inode *inode)
 {
-	inode->i_nlink = 0;
+	inode->__i_nlink = 0;
 }
 
 static inline void inode_dec_link_count(struct inode *inode)
-- 
1.7.3.4

