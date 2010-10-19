Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab0JSNtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:49:45 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:39970 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0JSNtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:49:43 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        toralf.foerster@gmx.de, hch@lst.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/1] hostfs: fix UML crash (remove f_spare from hostfs)
Date: Tue, 19 Oct 2010 15:48:58 +0200
Message-Id: <1287496138-16490-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

365b1818 resized f_spare within struct statfs which
caused a UML crash.
There is no need to copy f_spare.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
LKML-Reference: <20101019011125.GA3905@lst.de>
---
 fs/hostfs/hostfs.h      |    3 +--
 fs/hostfs/hostfs_kern.c |    2 +-
 fs/hostfs/hostfs_user.c |    9 ++-------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/hostfs/hostfs.h b/fs/hostfs/hostfs.h
index 6bbd75c..3ccb4e4 100644
--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -96,7 +96,6 @@ extern int rename_file(char *from, char *to);
 extern int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 		     long long *bfree_out, long long *bavail_out,
 		     long long *files_out, long long *ffree_out,
-		     void *fsid_out, int fsid_size, long *namelen_out,
-		     long *spare_out);
+		     void *fsid_out, int fsid_size, long *namelen_out);
 
 #endif
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index f7dc9b5..cd7c939 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -217,7 +217,7 @@ int hostfs_statfs(struct dentry *dentry, struct kstatfs *sf)
 	err = do_statfs(dentry->d_sb->s_fs_info,
 			&sf->f_bsize, &f_blocks, &f_bfree, &f_bavail, &f_files,
 			&f_ffree, &sf->f_fsid, sizeof(sf->f_fsid),
-			&sf->f_namelen, sf->f_spare);
+			&sf->f_namelen);
 	if (err)
 		return err;
 	sf->f_blocks = f_blocks;
diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index 6777aa0..8d02683 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -364,8 +364,7 @@ int rename_file(char *from, char *to)
 int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 	      long long *bfree_out, long long *bavail_out,
 	      long long *files_out, long long *ffree_out,
-	      void *fsid_out, int fsid_size, long *namelen_out,
-	      long *spare_out)
+	      void *fsid_out, int fsid_size, long *namelen_out)
 {
 	struct statfs64 buf;
 	int err;
@@ -384,10 +383,6 @@ int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 	       sizeof(buf.f_fsid) > fsid_size ? fsid_size :
 	       sizeof(buf.f_fsid));
 	*namelen_out = buf.f_namelen;
-	spare_out[0] = buf.f_spare[0];
-	spare_out[1] = buf.f_spare[1];
-	spare_out[2] = buf.f_spare[2];
-	spare_out[3] = buf.f_spare[3];
-	spare_out[4] = buf.f_spare[4];
+
 	return 0;
 }
-- 
1.6.6.1

