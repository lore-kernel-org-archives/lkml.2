Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0FXQaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:30:20 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56150 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0FXQaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:30:18 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
In-Reply-To: <87pqzrexon.fsf@linux.vnet.ibm.com>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com> <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org> <20100608004102.GQ31073@ZenIV.linux.org.uk> <87pqzrexon.fsf@linux.vnet.ibm.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Thu, 24 Jun 2010 22:00:10 +0530
Message-ID: <871vbwe6lp.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 22:12:32 +0530, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Tue, 8 Jun 2010 01:41:02 +0100, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > On Mon, Jun 07, 2010 at 05:08:19PM -0700, Linus Torvalds wrote:
> > 
> > > In fact, the other thing that I find doing that whole "dentry->d_parent" 
> > > thing seems to literally be broken. If you look at v9fs_fid_lookup(), 
> > > you'll notice how it walks up the d_parent chain, and at that point you do 
> > > NOT own the directory i_mutex, so at that point d_parent really _can_ be 
> > > changing wildly due to concurrent renames or whatever.
> > 
> > Eh...  It's bogus, all right, but i_mutex is not the correct solution.
> > You'd have to take it on a lot of inodes along the way to root *and*
> > you'd violate the ordering in process (ancestors first).
> > 
> > I'm not sure what's the right thing to do there, actually - s_vfs_rename_sem
> > also won't do, since it'll give you ordering problems of its own (it's
> > taken before i_mutex in VFS, so trying to take it under i_mutex would not
> > do).
> 
> Can we use dcache_lock in v9fs_fid_lookup ? Since we are holding
> parent directory inode->i_mutex in other places where we refer
> dentry->d_parent I guess those access are ok ?. And for v9fs_fid_lookup we
> can hold dcache_lock, walk the parent, build the full path name and use
> that for TWALK ? 
> 
> Another option is we deny a cross directory rename when
> doing fid_lookup. That is we can introduce a per superblock v9fs
> specific rwlock that get taken (in write mode) in a cross directory
> rename and in fid_lookup we take them in read mode ? We will have to set
> FS_RENAME_DOES_D_MOVE for 9p.

something like this ?

commit 86c06ad7506e7e05dd4e1e1b8cee28e19703c4f6
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Mon Jun 21 21:50:07 2010 +0530

    fs/9p: Prevent parallel rename when doing fid_lookup
    
    During fid lookup we need to make sure that the dentry->d_parent doesn't
    change so that we can safely walk the parent dentries. To ensure that
    we need to prevent cross directory rename during fid_lookup. Add a
    per superblock rename_lock rwlock to prevent parallel fid lookup and rename.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 7317b39..14b542a 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -139,14 +139,19 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 	fid = v9fs_fid_find(dentry, uid, any);
 	if (fid)
 		return fid;
-
+	/*
+	 * we don't have a matching fid. To do a TWALK we need
+	 * parent fid. We need to prevent rename when we want to
+	 * look at the parent.
+	 */
+	read_lock(&v9ses->rename_lock);
 	ds = dentry->d_parent;
 	fid = v9fs_fid_find(ds, uid, any);
 	if (!fid) { /* walk from the root */
 		n = 0;
 		for (ds = dentry; !IS_ROOT(ds); ds = ds->d_parent)
 			n++;
-
+		read_unlock(&v9ses->rename_lock);
 		fid = v9fs_fid_find(ds, uid, any);
 		if (!fid) { /* the user is not attached to the fs yet */
 			if (access == V9FS_ACCESS_SINGLE)
@@ -165,9 +170,11 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 
 			v9fs_fid_add(ds, fid);
 		}
-	} else /* walk from the parent */
+	} else  {
+		/* walk from the parent */
 		n = 1;
-
+		read_unlock(&v9ses->rename_lock);
+	}
 	if (ds == dentry)
 		return fid;
 
@@ -175,8 +182,10 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 	if (!wnames)
 		return ERR_PTR(-ENOMEM);
 
+	read_lock(&v9ses->rename_lock);
 	for (d = dentry, i = (n-1); i >= 0; i--, d = d->d_parent)
 		wnames[i] = (char *) d->d_name.name;
+	read_unlock(&v9ses->rename_lock);
 
 	clone = 1;
 	i = 0;
@@ -199,7 +208,6 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 		i += l;
 		clone = 0;
 	}
-
 	kfree(wnames);
 	v9fs_fid_add(dentry, fid);
 	return fid;
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index f8b86e9..6839fca 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -237,6 +237,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		__putname(v9ses->uname);
 		return ERR_PTR(-ENOMEM);
 	}
+	rwlock_init(&v9ses->rename_lock);
 
 	rc = bdi_setup_and_register(&v9ses->bdi, "9p", BDI_CAP_MAP_COPY);
 	if (rc) {
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index bec4d0b..dee4f26 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -104,6 +104,7 @@ struct v9fs_session_info {
 	struct p9_client *clnt;	/* 9p client */
 	struct list_head slist; /* list of sessions registered with v9fs */
 	struct backing_dev_info bdi;
+	rwlock_t rename_lock;
 };
 
 struct p9_fid *v9fs_session_init(struct v9fs_session_info *, const char *,
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 4331b3b..be39035 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -678,6 +678,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	sb = dir->i_sb;
 	v9ses = v9fs_inode2v9ses(dir);
+	/* We can walk d_parent because we hold the dir->i_mutex */
 	dfid = v9fs_fid_lookup(dentry->d_parent);
 	if (IS_ERR(dfid))
 		return ERR_CAST(dfid);
@@ -763,7 +764,7 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct p9_fid *olddirfid;
 	struct p9_fid *newdirfid;
 	struct p9_wstat wstat;
-	int retval;
+	int retval, cross_dir_rename;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 	retval = 0;
@@ -784,7 +785,7 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		retval = PTR_ERR(newdirfid);
 		goto clunk_olddir;
 	}
-
+	cross_dir_rename = (old_dentry->d_parent != new_dentry->d_parent);
 	if (v9fs_proto_dotl(v9ses)) {
 		retval = p9_client_rename(oldfid, newdirfid,
 					(char *) new_dentry->d_name.name);
@@ -806,6 +807,11 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = p9_client_wstat(oldfid, &wstat);
 
 clunk_newdir:
+	if (cross_dir_rename)
+		write_lock(&v9ses->rename_lock);
+	d_move(old_dentry, new_dentry);
+	if (cross_dir_rename)
+		write_unlock(&v9ses->rename_lock);
 	p9_client_clunk(newdirfid);
 
 clunk_olddir:
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index be74d02..0f6d06d 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -278,4 +278,5 @@ struct file_system_type v9fs_fs_type = {
 	.get_sb = v9fs_get_sb,
 	.kill_sb = v9fs_kill_super,
 	.owner = THIS_MODULE,
+	.fs_flags = FS_RENAME_DOES_D_MOVE,
 };
