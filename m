Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab0JFQS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:18:27 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:44187 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0JFQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:18:26 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 1/3] fs/9p: Update TLCREATE to allow create without open
In-Reply-To: <m362xfkfo8.fsf@linux.vnet.ibm.com>
References: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <AANLkTinpie0YLpiuJjv1RzYr4LN1HbdtXh=OoNNJbG6k@mail.gmail.com> <m362xfkfo8.fsf@linux.vnet.ibm.com>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.2 (i686-pc-linux-gnu)
Date: Wed, 06 Oct 2010 16:33:48 +0530
Message-ID: <m3wrpvinvv.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Oct 2010 11:48:15 +0530, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Tue, 5 Oct 2010 13:15:42 -0400, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> > Ouch.  Protocol change.
> > 
> > Also - not sure I understand what's going on here.  Why does mknod go
> > through TLCREATE, shouldn't we have our
> > own protocol messages for mknod?//
> 
> This is needed for the below mknod usage
> 
> mknod("k2", S_IFREG) ;
> 
> 

May be a better fix is to make sure we use TLMKNOD instead of TLCREATE
in case we get a create without LOOKUP_OPEN flags set. So how about

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 2f904a8..e89754f 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -55,6 +55,10 @@ static const struct inode_operations v9fs_file_inode_operations_dotl;
 static const struct inode_operations v9fs_symlink_inode_operations;
 static const struct inode_operations v9fs_symlink_inode_operations_dotl;
 
+static int
+v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
+		    dev_t rdev);
+
 /**
  * unixmode2p9mode - convert unix mode bits to plan 9
  * @v9ses: v9fs session information
@@ -681,8 +685,14 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 	v9ses = v9fs_inode2v9ses(dir);
 	if (nd && nd->flags & LOOKUP_OPEN)
 		flags = nd->intent.open.flags - 1;
-	else
-		flags = O_RDWR;
+	else {
+		/*
+		 * create call without LOOKUP_OPEN is due
+		 * to mknod of regular files. So use mknod
+		 * operation.
+		 */
+		return v9fs_vfs_mknod_dotl(dir, dentry, omode, 0);
+	}
 
 	name = (char *) dentry->d_name.name;
 	P9_DPRINTK(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
