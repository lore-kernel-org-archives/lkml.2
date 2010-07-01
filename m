Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab0GAVDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:03:39 -0400
Received: from kroah.org ([198.145.64.141]:47875 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839Ab0GAUvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:16 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:38 2010
Message-Id: <20100701173438.033376741@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 133/164] vfs: add NOFOLLOW flag to umount(2)
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit db1f05bb85d7966b9176e293f3ceead1cb8b5d79 upstream.

Add a new UMOUNT_NOFOLLOW flag to umount(2).  This is needed to prevent
symlink attacks in unprivileged unmounts (fuse, samba, ncpfs).

Additionally, return -EINVAL if an unknown flag is used (and specify
an explicitly unused flag: UMOUNT_UNUSED).  This makes it possible for
the caller to determine if a flag is supported or not.

CC: Eugene Teo <eugene@redhat.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namespace.c     |    9 ++++++++-
 include/linux/fs.h |    2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1121,8 +1121,15 @@ SYSCALL_DEFINE2(umount, char __user *, n
 {
 	struct path path;
 	int retval;
+	int lookup_flags = 0;
 
-	retval = user_path(name, &path);
+	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
+		return -EINVAL;
+
+	if (!(flags & UMOUNT_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+
+	retval = user_path_at(AT_FDCWD, name, lookup_flags, &path);
 	if (retval)
 		goto out;
 	retval = -EINVAL;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1308,6 +1308,8 @@ extern int send_sigurg(struct fown_struc
 #define MNT_FORCE	0x00000001	/* Attempt to forcibily umount */
 #define MNT_DETACH	0x00000002	/* Just detach from the tree */
 #define MNT_EXPIRE	0x00000004	/* Mark for expiry */
+#define UMOUNT_NOFOLLOW	0x00000008	/* Don't follow symlink on umount */
+#define UMOUNT_UNUSED	0x80000000	/* Flag guaranteed to be unused */
 
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;


