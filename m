Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab0IPWOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab0IPWOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:50 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 18/34] union-mount: Create check_topmost_union_mnt()
Date: Thu, 16 Sep 2010 15:12:09 -0700
Message-Id: <1284675145-4391-19-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_topmost_union_mnt() checks that the topmost layer of a proposed
union mount is read-write, supports fallthrus and whiteouts, and isn't
mounted elsewhere.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ffa5ed7..62c2f7a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1353,6 +1353,46 @@ static int invent_group_ids(struct vfsmount *mnt, bool recurse)
 	return 0;
 }
 
+/**
+ * check_topmost_union_mnt - mount-time checks for union mount
+ *
+ * @topmost_mnt: vfsmount of the topmost union filed system
+ * @mnt_flags: mount flags for the topmost mount
+ *
+ * Our readdir() solution of copying up directory entries requires
+ * that the topmost layer be writeable and support whiteouts and
+ * fallthrus.  The topmost file system can't be mounted elsewhere
+ * because it's Too Hard(tm).
+ */
+
+static int check_topmost_union_mnt(struct vfsmount *topmost_mnt, int mnt_flags)
+{
+	struct super_block *sb = topmost_mnt->mnt_sb;
+#ifndef CONFIG_UNION_MOUNT
+	printk(KERN_INFO "union mount: not supported by the kernel\n");
+	return -EINVAL;
+#endif
+	if (mnt_flags & MNT_READONLY)
+		return -EROFS;
+
+	if (atomic_read(&sb->s_active) != 1) {
+		printk(KERN_INFO "union mount: topmost fs mounted elsewhere\n");
+		return -EBUSY;
+	}
+
+	if (!(sb->s_flags & MS_WHITEOUT)) {
+		printk(KERN_INFO "union mount: whiteouts not supported by fs\n");
+		return -EINVAL;
+	}
+
+	if (!(sb->s_flags & MS_FALLTHRU)) {
+		printk(KERN_INFO "union mount: fallthrus not supported by fs\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached
-- 
1.6.3.3

