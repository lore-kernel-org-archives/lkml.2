Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0F3S6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:58:41 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36616 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0F3S6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:58:40 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
In-Reply-To: <AANLkTim0YCgTr_9GRo31kgwojIjeAyR895cyvbkFMmDg@mail.gmail.com>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com> <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org> <20100608004102.GQ31073@ZenIV.linux.org.uk> <87pqzrexon.fsf@linux.vnet.ibm.com> <871vbwe6lp.fsf@linux.vnet.ibm.com> <AANLkTiksmwITS6aCuXXZGR916OTEBm9VQ1MSzzEt8F7S@mail.gmail.com> <AANLkTikyqHtazndL_zBux7Zk0qZSJuNEvitHj8wkuSWW@mail.gmail.com> <87mxuc91r2.fsf@linux.vnet.ibm.com> <AANLkTim0YCgTr_9GRo31kgwojIjeAyR895cyvbkFMmDg@mail.gmail.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Thu, 01 Jul 2010 00:28:31 +0530
Message-ID: <878w5w8i08.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 09:48:15 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Jun 30, 2010 at 4:52 AM, Aneesh Kumar K. V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
> >
> > You are correct. we cannot drop the rename lock in between. I also found
> > another issue in that we are using dentry->d_name.name directly. That
> > would imply we need to hold the rename_lock even during the
> > client_walk.
> 
> Yes.
> 
> > How about the patch below ?. I updated the patch to hold
> > rename_lock during multiple path walk. Also the rename path is updated
> > to hold the lock during p9_client_rename operations.
> 
> I'm not finding any obvious problems with this, and you're right that
> you also need to hold the rename write-lock even for regular renames
> (not just cross-directory ones) in order to protect the name itself.
> So those two patches together seem to be ok at a quick glance.
> 
> That said, I do wonder if you wouldn't be better off copying the name
> components in order to then drop the lock earlier. That way you'd only
> need to hold the lock while walking the dentries, and could possibly
> release it during the actual walk (unless you need the names to be
> stable, but I don't think you can rely on that anyway, since other
> clients might be doing renames concurrently.. I don't know)
> 
>                        Linus


Updated patch

>From 0bae321401e88d495ea7e9e96272c11c1b9b9ec3 Mon Sep 17 00:00:00 2001
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Wed, 30 Jun 2010 19:18:50 +0530
Subject: [PATCH] fs/9p: Prevent parallel rename when doing fid_lookup

During fid lookup we need to make sure that the dentry->d_parent doesn't
change so that we can safely walk the parent dentries. To ensure that
we need to prevent cross directory rename during fid_lookup. Add a
per superblock rename_lock rwlock to prevent parallel fid lookup and rename.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/fid.c       |  134 ++++++++++++++++++++++++++++++++++++++---------------
 fs/9p/v9fs.c      |    1 +
 fs/9p/v9fs.h      |    1 +
 fs/9p/vfs_inode.c |   14 ++++--
 fs/9p/vfs_super.c |    1 +
 5 files changed, 110 insertions(+), 41 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 5d6cfcb..7dcefaa 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -97,6 +97,48 @@ static struct p9_fid *v9fs_fid_find(struct dentry *dentry, u32 uid, int any)
 	return ret;
 }
 
+static int build_path_from_dentry(struct v9fs_session_info *v9ses,
+				  struct dentry *dentry, char ***names)
+{
+	int n = 0, i;
+	char **wnames;
+	struct dentry *ds;
+
+	read_lock(&v9ses->rename_lock);
+	for (ds = dentry; !IS_ROOT(ds); ds = ds->d_parent)
+		n++;
+
+	wnames = kmalloc(sizeof(char *) * n, GFP_KERNEL);
+	if (!wnames) {
+		n = 0;
+		goto err_out;
+	}
+	for (ds = dentry, i = (n-1); i >= 0; i--, ds = ds->d_parent) {
+		wnames[i] = kmalloc(strlen(ds->d_name.name) + 1, GFP_KERNEL);
+		if (!wnames[i])
+			goto err_out;
+
+		strcpy(wnames[i], ds->d_name.name);
+	}
+	*names = wnames;
+	read_unlock(&v9ses->rename_lock);
+	return n;
+err_out:
+	read_unlock(&v9ses->rename_lock);
+	for (; i < n; i++)
+		kfree(wnames[i]);
+	kfree(wnames);
+	return -ENOMEM;
+}
+
+static void kfree_wnames(char **wnames, int n)
+{
+	int i;
+	for (i = 0; i < n; i++)
+		kfree(wnames[i]);
+	kfree(wnames);
+}
+
 /**
  * v9fs_fid_lookup - lookup for a fid, try to walk if not found
  * @dentry: dentry to look for fid in
@@ -112,7 +154,7 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 	int i, n, l, clone, any, access;
 	u32 uid;
 	struct p9_fid *fid, *old_fid = NULL;
-	struct dentry *d, *ds;
+	struct dentry *ds;
 	struct v9fs_session_info *v9ses;
 	char **wnames, *uname;
 
@@ -139,46 +181,62 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
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
-	if (!fid) { /* walk from the root */
-		n = 0;
-		for (ds = dentry; !IS_ROOT(ds); ds = ds->d_parent)
-			n++;
-
-		fid = v9fs_fid_find(ds, uid, any);
-		if (!fid) { /* the user is not attached to the fs yet */
-			if (access == V9FS_ACCESS_SINGLE)
-				return ERR_PTR(-EPERM);
-
-			if (v9fs_proto_dotu(v9ses) ||
-				v9fs_proto_dotl(v9ses))
+	if (fid) {
+		/*
+		 * Found the parent fid do a lookup with that.
+		 * We want to do the walk without holding rename_lock
+		 */
+		char *dentry_name;
+		dentry_name = kmalloc(strlen(dentry->d_name.name) + 1,
+				      GFP_KERNEL);
+		if (dentry_name) {
+			strcpy(dentry_name, dentry->d_name.name);
+			read_unlock(&v9ses->rename_lock);
+			fid = p9_client_walk(fid, 1, (char **)&dentry_name, 1);
+			kfree(dentry_name);
+			goto dentry_out;
+		} else {
+			read_unlock(&v9ses->rename_lock);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
+	read_unlock(&v9ses->rename_lock);
+	/* start from the root and try to do a lookup */
+	fid = v9fs_fid_find(dentry->d_sb->s_root, uid, any);
+	if (!fid) {
+		/* the user is not attached to the fs yet */
+		if (access == V9FS_ACCESS_SINGLE)
+			return ERR_PTR(-EPERM);
+
+		if (v9fs_proto_dotu(v9ses) || v9fs_proto_dotl(v9ses))
 				uname = NULL;
-			else
-				uname = v9ses->uname;
-
-			fid = p9_client_attach(v9ses->clnt, NULL, uname, uid,
-				v9ses->aname);
+		else
+			uname = v9ses->uname;
 
-			if (IS_ERR(fid))
-				return fid;
-
-			v9fs_fid_add(ds, fid);
-		}
-	} else /* walk from the parent */
-		n = 1;
+		fid = p9_client_attach(v9ses->clnt, NULL, uname, uid,
+				       v9ses->aname);
+		if (IS_ERR(fid))
+			return fid;
 
-	if (ds == dentry)
+		v9fs_fid_add(dentry->d_sb->s_root, fid);
+	}
+	/* If we are root just return the fid */
+	if (dentry->d_sb->s_root == dentry)
 		return fid;
 
-	wnames = kmalloc(sizeof(char *) * n, GFP_KERNEL);
-	if (!wnames)
-		return ERR_PTR(-ENOMEM);
-
-	for (d = dentry, i = (n-1); i >= 0; i--, d = d->d_parent)
-		wnames[i] = (char *) d->d_name.name;
-
+	n  = build_path_from_dentry(v9ses, dentry, &wnames);
+	if (n < 0) {
+		fid = ERR_PTR(n);
+		goto err_out;
+	}
 	clone = 1;
 	i = 0;
 	while (i < n) {
@@ -193,16 +251,18 @@ struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 				 */
 				p9_client_clunk(old_fid);
 			}
-			kfree(wnames);
-			return fid;
+			kfree_wnames(wnames, n);
+			goto err_out;
 		}
 		old_fid = fid;
 		i += l;
 		clone = 0;
 	}
+	kfree_wnames(wnames, n);
 
-	kfree(wnames);
+dentry_out:
 	v9fs_fid_add(dentry, fid);
+err_out:
 	return fid;
 }
 
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 3c49201..b41bcef 100644
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
index 503a6a2..97fee13 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -964,6 +964,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	sb = dir->i_sb;
 	v9ses = v9fs_inode2v9ses(dir);
+	/* We can walk d_parent because we hold the dir->i_mutex */
 	dfid = v9fs_fid_lookup(dentry->d_parent);
 	if (IS_ERR(dfid))
 		return ERR_CAST(dfid);
@@ -1070,28 +1071,33 @@ v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		retval = PTR_ERR(newdirfid);
 		goto clunk_olddir;
 	}
-
 	if (v9fs_proto_dotl(v9ses)) {
 		retval = p9_client_rename(oldfid, newdirfid,
 					(char *) new_dentry->d_name.name);
 		if (retval != -ENOSYS)
 			goto clunk_newdir;
 	}
+	if (old_dentry->d_parent != new_dentry->d_parent) {
+		/*
+		 * 9P .u can only handle file rename in the same directory
+		 */
 
-	/* 9P can only handle file rename in the same directory */
-	if (memcmp(&olddirfid->qid, &newdirfid->qid, sizeof(newdirfid->qid))) {
 		P9_DPRINTK(P9_DEBUG_ERROR,
 				"old dir and new dir are different\n");
 		retval = -EXDEV;
 		goto clunk_newdir;
 	}
-
 	v9fs_blank_wstat(&wstat);
 	wstat.muid = v9ses->uname;
 	wstat.name = (char *) new_dentry->d_name.name;
 	retval = p9_client_wstat(oldfid, &wstat);
 
 clunk_newdir:
+	write_lock(&v9ses->rename_lock);
+	if (!retval)
+		/* successful rename */
+		d_move(old_dentry, new_dentry);
+	write_unlock(&v9ses->rename_lock);
 	p9_client_clunk(newdirfid);
 
 clunk_olddir:
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 0740675..3abc3ec 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -287,4 +287,5 @@ struct file_system_type v9fs_fs_type = {
 	.get_sb = v9fs_get_sb,
 	.kill_sb = v9fs_kill_super,
 	.owner = THIS_MODULE,
+	.fs_flags = FS_RENAME_DOES_D_MOVE,
 };
-- 
1.7.2.rc0

