Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0HHPy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:54:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab0HHPyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:54:47 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 15/39] union-mount: Introduce MNT_UNION and MS_UNION flags
Date: Sun,  8 Aug 2010 11:52:32 -0400
Message-Id: <1281282776-5447-16-git-send-email-vaurora@redhat.com>
In-Reply-To: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
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
 include/linux/mount.h |    4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 984c331..f115cb6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -809,6 +809,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
 		{ MNT_STRICTATIME, ",strictatime" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
@@ -2008,10 +2009,12 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
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
index 71ee74e..31cfa48 100644
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
index 4bd0547..0302703 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -43,9 +43,9 @@ struct mnt_namespace;
  */
 #define MNT_SHARED_MASK	(MNT_UNBINDABLE)
 #define MNT_PROPAGATION_MASK	(MNT_SHARED | MNT_UNBINDABLE)
+#define MNT_UNION	0x4000	/* top layer of a union mount */
 
-
-#define MNT_INTERNAL	0x4000
+#define MNT_INTERNAL	0x8000
 
 struct vfsmount {
 	struct list_head mnt_hash;
-- 
1.6.3.3

