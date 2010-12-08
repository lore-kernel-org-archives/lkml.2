Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab0LHBlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:41:14 -0500
Received: from kroah.org ([198.145.64.141]:48844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132Ab0LHBAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:42 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:31 2010
Message-Id: <20101208005731.747532182@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Weinberger <richard@nod.at>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Jeff Dike <jdike@addtoit.com>
Subject: [104/289] hostfs: fix UML crash: remove f_spare from hostfs
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 1b627d5771312c92404b66f0a0b16f66036dd2e1 upstream.

365b1818 ("add f_flags to struct statfs(64)") resized f_spare within
struct statfs which caused a UML crash.  There is no need to copy f_spare.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hostfs/hostfs.h      |    3 +--
 fs/hostfs/hostfs_kern.c |    2 +-
 fs/hostfs/hostfs_user.c |    9 ++-------
 3 files changed, 4 insertions(+), 10 deletions(-)

--- a/fs/hostfs/hostfs.h
+++ b/fs/hostfs/hostfs.h
@@ -96,7 +96,6 @@ extern int rename_file(char *from, char
 extern int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 		     long long *bfree_out, long long *bavail_out,
 		     long long *files_out, long long *ffree_out,
-		     void *fsid_out, int fsid_size, long *namelen_out,
-		     long *spare_out);
+		     void *fsid_out, int fsid_size, long *namelen_out);
 
 #endif
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -217,7 +217,7 @@ int hostfs_statfs(struct dentry *dentry,
 	err = do_statfs(dentry->d_sb->s_fs_info,
 			&sf->f_bsize, &f_blocks, &f_bfree, &f_bavail, &f_files,
 			&f_ffree, &sf->f_fsid, sizeof(sf->f_fsid),
-			&sf->f_namelen, sf->f_spare);
+			&sf->f_namelen);
 	if (err)
 		return err;
 	sf->f_blocks = f_blocks;
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
@@ -384,10 +383,6 @@ int do_statfs(char *root, long *bsize_ou
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


