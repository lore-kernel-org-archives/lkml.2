Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab0EMBoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:44:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab0EMBoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:44:08 -0400
Date: Thu, 13 May 2010 11:43:51 +1000
From: Neil Brown <neilb@suse.de>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 5/9] vfs: Add freadlink syscall
Message-ID: <20100513114351.793caf70@notabene.brown>
In-Reply-To: <1273679444-14903-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1273679444-14903-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 21:20:40 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> This enables to use open-by-handle and then get the link target
> details of a symlink using the fd returned by handle
> 


I find it very frustrating that a new syscall seems to be needed here.
We have 'readlinkat', and it should be enough.
How:  the 'dfd' has to be a 'directory', and the path name as to be non-empty.

The following patch allows 'path' to be NULL and in that case 'dfd' to be a
non-directory.  This allows readlinkat and faccessat (and probably others)
to be used on an fd with not following path name.

What do people think of this alternative?

NeilBrown


From: NeilBrown <neilb@suse.de>

Allow '*at' syscalls to have a NULL path name, thus using the 'fd' directly.

Move the 'is a directory' test from path_init to the start of link_path_walk
(which is always called after a successful path_init).
Remove the file_permission(MAY_EXEC) test from path_init as such a test
already exists in link_path_walk as exec_permission()
Allow user_path_at to use a NULL resulting in the dfd being the target object.

This effectively provides an 'f*' version for all syscalls with a '*at'
version. In particular: link, access, chmod, chown, stat, readlink, utimes

Some of those already have f* versions, but link, access, readlink all
benefit directly, and futimes code can be tidied up.

NULL is only allowed if 'dfd' is not ATFD_CWD to reduce possible
backward-compatibility issues.

openat is not effected by this change, even in non-O_CREAT instances.  Maybe
it should.

Signed-off-by: NeilBrown <neilb@suse.de>


diff --git a/fs/namei.c b/fs/namei.c
index 48e60a1..b9b091e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -824,6 +824,11 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		goto return_reval;
 
 	inode = nd->path.dentry->d_inode;
+
+	err = -ENOTDIR;
+	if (!S_ISDIR(inode->i_mode))
+		goto return_err;
+
 	if (nd->depth)
 		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
 
@@ -1030,14 +1035,6 @@ static int path_init(int dfd, const char *name, unsigned int flags, struct namei
 
 		dentry = file->f_path.dentry;
 
-		retval = -ENOTDIR;
-		if (!S_ISDIR(dentry->d_inode->i_mode))
-			goto fput_fail;
-
-		retval = file_permission(file, MAY_EXEC);
-		if (retval)
-			goto fput_fail;
-
 		nd->path = file->f_path;
 		path_get(&file->f_path);
 
@@ -1241,17 +1238,22 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
 		 struct path *path)
 {
 	struct nameidata nd;
-	char *tmp = getname(name);
-	int err = PTR_ERR(tmp);
-	if (!IS_ERR(tmp)) {
-
-		BUG_ON(flags & LOOKUP_PARENT);
+	char *tmp;
+	int err;
 
-		err = do_path_lookup(dfd, tmp, flags, &nd);
-		putname(tmp);
-		if (!err)
-			*path = nd.path;
+	BUG_ON(flags & LOOKUP_PARENT);
+	if (name == NULL && dfd >= 0)
+		err = do_path_lookup(dfd, "", flags, &nd);
+	else {
+		tmp = getname(name);
+		err = PTR_ERR(tmp);
+		if (!IS_ERR(tmp)) {
+			err = do_path_lookup(dfd, tmp, flags, &nd);
+			putname(tmp);
+		}
 	}
+	if (!err)
+		*path = nd.path;
 	return err;
 }
 
