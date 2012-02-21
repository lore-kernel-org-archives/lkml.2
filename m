Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2BUTyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab2BUTym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 31/73] union-mount: Create check_topmost_union_mnt() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:01:25 +0000
Message-ID: <20120221180125.25235.44111.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

check_topmost_union_mnt() checks that the topmost layer of a proposed
union mount is read-write, supports fallthrus and whiteouts, and isn't
mounted elsewhere.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 33aa310..bed9ccd 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1410,6 +1410,46 @@ static int invent_group_ids(struct mount *mnt, bool recurse)
 	return 0;
 }
 
+/**
+ * check_topmost_union_mnt - mount-time checks for union mount
+ * @topmost_mnt: vfsmount of the topmost union filed system
+ * @mnt_flags: mount flags for the topmost mount
+ *
+ * Our readdir() solution of copying up directory entries requires
+ * that the topmost layer be writeable and support whiteouts and
+ * fallthrus.  The topmost file system can't be mounted elsewhere
+ * because it's Too Hard(tm).
+ */
+static int check_topmost_union_mnt(struct vfsmount *topmost_mnt, int mnt_flags)
+{
+	struct super_block *sb = topmost_mnt->mnt_sb;
+
+#ifndef CONFIG_UNION_MOUNT
+	printk(KERN_INFO "union mount: not supported by the kernel\n");
+	return -EINVAL;
+#else
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
+#endif
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached

