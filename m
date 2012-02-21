Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2BUR6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:58:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2BUR6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:58:23 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/73] VFS: Add hard read-only users count to superblock [ver
 #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 17:58:17 +0000
Message-ID: <20120221175817.25235.36726.stgit@warthog.procyon.org.uk>
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

While we can check if a file system is currently read-only, we can't
guarantee that it will stay read-only.  The file system can be mounted
or remounted read-write at any time.  This is a problem for union
mounts, which require the underlying file system be read-only for the
entire duration of the union mount.

Add a hard read-only users count to the superblock.  When this count
is non-zero, don't allow any read-write mounts of this super, or any
read-write remounts of existing mounts.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/super.c         |   11 +++++++++++
 include/linux/fs.h |    6 ++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index f343eda..732e19b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -202,6 +202,7 @@ static inline void destroy_super(struct super_block *s)
 #ifdef CONFIG_SMP
 	free_percpu(s->s_files);
 #endif
+	BUG_ON(s->s_hard_readonly_users);
 	security_sb_free(s);
 	WARN_ON(!list_empty(&s->s_mounts));
 	kfree(s->s_subtype);
@@ -758,6 +759,9 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 		}
 	}
 
+	if (!(flags & MS_RDONLY) && sb->s_hard_readonly_users)
+		return -EROFS;
+
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
 		if (retval) {
@@ -1150,9 +1154,16 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	WARN((sb->s_maxbytes < 0), "%s set sb->s_maxbytes to "
 		"negative value (%lld)\n", type->name, sb->s_maxbytes);
 
+	if (!(flags & MS_RDONLY) && sb->s_hard_readonly_users)
+		goto out_sb_is_hard_ro;
+
 	up_write(&sb->s_umount);
 	free_secdata(secdata);
 	return root;
+
+out_sb_is_hard_ro:
+	up_write(&sb->s_umount);
+	error = -EROFS;
 out_sb:
 	dput(root);
 	deactivate_locked_super(sb);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d851be9..b8276c0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1496,6 +1496,12 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* Number of mounts requiring that the underlying file system never
+	 * transition to read-write.  Protected by s_umount.  Decremented by
+	 * free_vfsmnt() if MNT_HARD_READONLY is set.
+	 */
+	int s_hard_readonly_users;
 };
 
 /* superblock cache pruning functions */

