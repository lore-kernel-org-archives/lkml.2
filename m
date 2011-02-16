Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab1BPAVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:21:14 -0500
Received: from kroah.org ([198.145.64.141]:39228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757225Ab1BPAVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:36 2011
Message-Id: <20110216001436.098713471@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [110/272] NFS: Fix NFSv3 exclusive open semantics
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 8a0eebf66e3b1deae036553ba641a9c2bdbae678 upstream.

Commit c0204fd2b8fe047b18b67e07e1bf2a03691240cd (NFS: Clean up
nfs4_proc_create()) broke NFSv3 exclusive open by removing the code
that passes the O_EXCL flag down to nfs3_proc_create(). This patch
reverts that offending hunk from the original commit.

Reported-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/dir.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1577,6 +1577,7 @@ static int nfs_create(struct inode *dir,
 {
 	struct iattr attr;
 	int error;
+	int open_flags = 0;
 
 	dfprintk(VFS, "NFS: create(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
@@ -1584,7 +1585,10 @@ static int nfs_create(struct inode *dir,
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
-	error = NFS_PROTO(dir)->create(dir, dentry, &attr, 0, NULL);
+	if ((nd->flags & LOOKUP_CREATE) != 0)
+		open_flags = nd->intent.open.flags;
+
+	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, NULL);
 	if (error != 0)
 		goto out_err;
 	return 0;


