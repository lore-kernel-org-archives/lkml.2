Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0F3MzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 08:55:15 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:47607 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0F3MzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:55:13 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
In-Reply-To: <871vbwe6lp.fsf@linux.vnet.ibm.com>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com> <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org> <20100608004102.GQ31073@ZenIV.linux.org.uk> <87pqzrexon.fsf@linux.vnet.ibm.com> <871vbwe6lp.fsf@linux.vnet.ibm.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 30 Jun 2010 18:25:05 +0530
Message-ID: <87k4pg8yty.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 22:00:10 +0530, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Wed, 16 Jun 2010 22:12:32 +0530, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > On Tue, 8 Jun 2010 01:41:02 +0100, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > > On Mon, Jun 07, 2010 at 05:08:19PM -0700, Linus Torvalds wrote:
> > > 
> > > > In fact, the other thing that I find doing that whole "dentry->d_parent" 
> > > > thing seems to literally be broken. If you look at v9fs_fid_lookup(), 
> > > > you'll notice how it walks up the d_parent chain, and at that point you do 
> > > > NOT own the directory i_mutex, so at that point d_parent really _can_ be 
> > > > changing wildly due to concurrent renames or whatever.
> > > 
> > > Eh...  It's bogus, all right, but i_mutex is not the correct solution.
> > > You'd have to take it on a lot of inodes along the way to root *and*
> > > you'd violate the ordering in process (ancestors first).
> > > 
> > > I'm not sure what's the right thing to do there, actually - s_vfs_rename_sem
> > > also won't do, since it'll give you ordering problems of its own (it's
> > > taken before i_mutex in VFS, so trying to take it under i_mutex would not
> > > do).
> > 
> > Can we use dcache_lock in v9fs_fid_lookup ? Since we are holding
> > parent directory inode->i_mutex in other places where we refer
> > dentry->d_parent I guess those access are ok ?. And for v9fs_fid_lookup we
> > can hold dcache_lock, walk the parent, build the full path name and use
> > that for TWALK ? 
> > 
> > Another option is we deny a cross directory rename when
> > doing fid_lookup. That is we can introduce a per superblock v9fs
> > specific rwlock that get taken (in write mode) in a cross directory
> > rename and in fid_lookup we take them in read mode ? We will have to set
> > FS_RENAME_DOES_D_MOVE for 9p.
> 
> something like this ?
> 
> commit 86c06ad7506e7e05dd4e1e1b8cee28e19703c4f6
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Mon Jun 21 21:50:07 2010 +0530
> 
>     fs/9p: Prevent parallel rename when doing fid_lookup
>     
>     During fid lookup we need to make sure that the dentry->d_parent doesn't
>     change so that we can safely walk the parent dentries. To ensure that
>     we need to prevent cross directory rename during fid_lookup. Add a
>     per superblock rename_lock rwlock to prevent parallel fid lookup and rename.
>     
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 

To make sure d_name.name remain correct we need something like below ?

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index eae89ad..9f9f804 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1050,7 +1050,7 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct p9_fid *olddirfid;
 	struct p9_fid *newdirfid;
 	struct p9_wstat wstat;
-	int retval, cross_dir_rename = 0;
+	int retval;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 	retval = 0;
@@ -1071,17 +1071,15 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		retval = PTR_ERR(newdirfid);
 		goto clunk_olddir;
 	}
-	cross_dir_rename = (old_dentry->d_parent != new_dentry->d_parent);
-	if (cross_dir_rename)
-		write_lock(&v9ses->rename_lock);
 
+	write_lock(&v9ses->rename_lock);
 	if (v9fs_proto_dotl(v9ses)) {
 		retval = p9_client_rename(oldfid, newdirfid,
 					(char *) new_dentry->d_name.name);
 		if (retval != -ENOSYS)
 			goto clunk_newdir;
 	}
-	if (cross_dir_rename) {
+	if (old_dentry->d_parent != new_dentry->d_parent) {
 		/*
 		 * 9P .u can only handle file rename in the same directory
 		 */
@@ -1100,8 +1098,7 @@ clunk_newdir:
 	if (!retval)
 		/* successful rename */
 		d_move(old_dentry, new_dentry);
-	if (cross_dir_rename)
-		write_unlock(&v9ses->rename_lock);
+	write_unlock(&v9ses->rename_lock);
 	p9_client_clunk(newdirfid);
 
 clunk_olddir:
