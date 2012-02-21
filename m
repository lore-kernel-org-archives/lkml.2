Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2BUUGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:06:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab2BUTww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 35/73] union-mount: Create prepare_mnt_union() and
 cleanup_mnt_union() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:01:54 +0000
Message-ID: <20120221180154.25235.71018.stgit@warthog.procyon.org.uk>
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

prepare_mnt_union() ties together all the mount-time checks and setup
for union mounts.  It tests the layers for suitability and builds the
root union stack.

cleanup_mnt_union() unwinds everything prepare_mnt_union() does.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 3355b99..261944d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1569,6 +1569,46 @@ out:
 	return err;
 }
 
+/**
+ * prepare_mnt_union - do setup necessary for a union mount
+ * @topmost_mnt: vfsmount of topmost layer
+ * @mntpnt: path of requested mountpoint
+ *
+ * We union every underlying file system that is mounted on the same mountpoint
+ * (well, pathname), read-only, and not shared.  If we get at least one layer,
+ * we don't return an error, although we will complain in the kernel log if we
+ * hit a mount that can't be unioned.
+ *
+ * Caller needs namespace_sem, but can't have vfsmount_lock.
+ */
+static int prepare_mnt_union(struct vfsmount *topmost_mnt, struct path *mntpnt)
+{
+	int err;
+
+	err = check_topmost_union_mnt(topmost_mnt, topmost_mnt->mnt_flags);
+	if (err)
+		return err;
+
+	err = clone_union_tree(real_mount(topmost_mnt), mntpnt);
+	if (err)
+		return err;
+
+	err = build_root_union(topmost_mnt);
+	if (err)
+		goto out;
+	return 0;
+
+out:
+	put_union_sb(topmost_mnt->mnt_sb);
+	return err;
+}
+
+static void cleanup_mnt_union(struct vfsmount *topmost_mnt)
+{
+	d_free_unions(topmost_mnt->mnt_root);
+	put_union_sb(topmost_mnt->mnt_sb);
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached

