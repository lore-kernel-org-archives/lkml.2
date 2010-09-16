Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0IPWWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:22:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab0IPWOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:20 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Blunck <jblunck@suse.de>, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 06/34] union-mount: Introduce MNT_UNION and MS_UNION flags
Date: Thu, 16 Sep 2010 15:11:57 -0700
Message-Id: <1284675145-4391-7-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Add per mountpoint flag for Union Mount support. You need additional patches
to util-linux for that to work - see:

git://git.kernel.org/pub/scm/utils/util-linux-ng/val/util-linux-ng.git

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c        |    5 ++++-
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index cbaa3ea..f8d7d11 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -824,6 +824,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
 		{ MNT_STRICTATIME, ",strictatime" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
@@ -2047,10 +2048,12 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		mnt_flags &= ~(MNT_RELATIME | MNT_NOATIME);
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
-		   MS_STRICTATIME);
+		   MS_STRICTATIME | MS_UNION);
 
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7dcb95b..2e3d745 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -192,6 +192,7 @@ struct inodes_stat_t {
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256	/* Merge namespace with FS mounted below */
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
diff --git a/include/linux/mount.h b/include/linux/mount.h
index b300cf8..4014ff1 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -47,6 +47,7 @@ struct mnt_namespace;
 
 #define MNT_INTERNAL	0x4000
 #define MNT_HARD_READONLY	0x8000	/* has a hard read-only ref on the sb */
+#define MNT_UNION	0x10000		/* top layer of a union mount */
 
 struct vfsmount {
 	struct list_head mnt_hash;
-- 
1.6.3.3

