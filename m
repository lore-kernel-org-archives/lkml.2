Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2BUSIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:08:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab2BUSHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:07:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/73] union-mount: Introduce MNT_UNION and MS_UNION flags
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
        Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 17:59:55 +0000
Message-ID: <20120221175955.25235.29086.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Add per mountpoint flag for Union Mount support.  You need additional patches
to util-linux for that to work - see:

git://git.kernel.org/pub/scm/utils/util-linux-ng/val/util-linux-ng.git

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c        |    4 +++-
 fs/proc_namespace.c   |    1 +
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 4 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c01aff2..33aa310 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2214,10 +2214,12 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		mnt_flags &= ~(MNT_RELATIME | MNT_NOATIME);
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
-		   MS_STRICTATIME);
+		   MS_STRICTATIME | MS_UNION);
 
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 1241285..4609740 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -65,6 +65,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5e6658..a014f0f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -193,6 +193,7 @@ struct inodes_stat_t {
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256	/* Merge namespace with FS mounted below */
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 41c7c84..0ba1def 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -47,6 +47,7 @@ struct mnt_namespace;
 
 #define MNT_INTERNAL	0x4000
 #define MNT_HARD_READONLY	0x8000	/* has a hard read-only ref on the sb */
+#define MNT_UNION	0x10000		/* top layer of a union mount */
 
 struct vfsmount {
 	struct dentry *mnt_root;	/* root of the mounted tree */

