Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab0FVErG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 00:47:06 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50994 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab0FVErE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 00:47:04 -0400
X-Sasl-enc: 8HBN1t0KGEw1EAP744NFl/1O1WdYHTLeuxZ1DQ9mIYd0 1277182005
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount
 in super block info
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, vaurora@redhat.com, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, jblunck@suse.de
In-Reply-To: <E1OQghj-0001Bt-RU@pomaz-ex.szeredi.hu>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	 <1276627208-17242-5-git-send-email-vaurora@redhat.com>
	 <1276661043.2339.35.camel@localhost> <1277091579.3827.9.camel@localhost>
	 <E1OQghj-0001Bt-RU@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 12:46:39 +0800
Message-ID: <1277181999.2829.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 15:06 +0200, Miklos Szeredi wrote:
> On Mon, 21 Jun 2010, Ian Kent wrote:
> > On Wed, 2010-06-16 at 12:04 +0800, Ian Kent wrote:
> > > On Tue, 2010-06-15 at 11:39 -0700, Valerie Aurora wrote:
> > > > From: Jan Blunck <jblunck@suse.de>
> > > > 
> > > > XXX - This is broken and included just to make union mounts work.  See
> > > > discussion at:
> > > > 
> > > > http://kerneltrap.org/mailarchive/linux-fsdevel/2010/1/15/6708053/thread
> > > 
> > > Instead of saving the vfsmount we could save a pointer to the dentry of
> > > the mount point in the autofs super block info struct. I think that's
> > > the bit I don't have so it would be sufficient for a lookup_mnt() for
> > > the needed vfsmount in ->follow_mount().
> > > 
> > > Objections?
> > > Suggestions?
> > 
> > No comments so far.
> > 
> > Before I dive into testing if this actually does what I need, can I get
> > an "in principal" ack or nack for the patch so union mounts can move on
> > please?
> > 
> > Note that this patch hasn't even been compile tested so the point is to
> > decide whether it is worth going ahead with it.
> 
> mnt_mountpoint is NULL at the point you try to save it, so this is not
> going to work.
> 

What about this approach then?


autofs4 - lookup vfsmount in follow_link()

From: Ian Kent <raven@themaw.net>

Adapted from the original patch from Jan Blunck <jblunck@suse.de>.

Original commit message:

This is a bugfix/replacement for commit
051d381259eb57d6074d02a6ba6e90e744f1a29f:

    During a path walk if an autofs trigger is mounted on a dentry,
    when the follow_link method is called, the nameidata struct
    contains the vfsmount and mountpoint dentry of the parent mount
    while the dentry that is passed in is the root of the autofs
    trigger mount.  I believe it is impossible to get the vfsmount of
    the trigger mount, within the follow_link method, when only the
    parent vfsmount and the root dentry of the trigger mount are
    known.

The solution in this commit was to replace the path embedded in the
parent's nameidata with the path of the link itself in
__do_follow_link().  This is a relatively harmless misuse of the
field, but union mounts ran into a bug during follow_link() caused by
the nameidata containing the wrong path (we count on it being what it
is all other places - the path of the parent).

A better solution is to lookup the vfsmount when the mount is triggered,
which can be done because binding an autofs file system mount to another
location isn't valid (even though we can't actually veto this from the
autofs module).

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Jan Blunck <jblunck@suse.de>
Cc: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: autofs@linux.kernel.org
---

 fs/autofs4/root.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/namei.c        |    7 ++-----
 fs/namespace.c    |    1 +
 3 files changed, 50 insertions(+), 5 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index db4117e..62dbcef 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -208,6 +208,40 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 	return 0;
 }
 
+/*
+ * We need to find the vfsmount of the autofs mount that is triggering
+ * this mount but the path we have contains the parent vfsmount and
+ * the dentry of the directory that contains our mountpoint, not the
+ * dentry of the mountpoint itself. In this case we must rely on the
+ * fact that autofs file systems can't be bound elsewhere (and still
+ * work) so that when we locate a vfsmount with a matching global root
+ * it must be the one we want.
+ */
+static vfsmount *autofs4_find_vfsmount(struct path *parent, struct dentry *root)
+{
+	struct vfsmount *mnt = NULL;
+	struct dentry *child;
+
+	spin_lock(&dcache_lock);
+	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
+		if (d_unhashed(child) || !child->d_inode)
+			continue;
+		if (d_mountpoint(child)) {
+			struct vfsmount *this;
+			this = lookup_mnt(parent.mnt, child);
+			if (this && this->mnt_root != root) {
+				mntput(this);
+				continue;
+			}
+			mnt = this;
+			break;
+		}
+	}
+	spin_unlock(&dcache_lock);
+
+	return mnt;
+}
+
 /* For autofs direct mounts the follow link triggers the mount */
 static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
@@ -215,11 +249,24 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int oz_mode = autofs4_oz_mode(sbi);
 	unsigned int lookup_type;
+	struct vfsmount *mnt;
 	int status;
 
 	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
 		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
 		nd->flags);
+
+	mnt = autofs4_find_vfsmount(&nd->path, dentry);
+	if (!mnt) {
+		status = -ENOENT;
+		goto out_error;
+	}
+
+	dput(nd->path.dentry);
+	mntput(nd->path.mnt);
+	nd->path.mnt = mnt;
+	nd->path.dentry = dget(dentry);
+
 	/*
 	 * For an expire of a covered direct or offset mount we need
 	 * to break out of follow_down() at the autofs mount trigger
diff --git a/fs/namei.c b/fs/namei.c
index 868d0cb..69a78ee 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -539,11 +539,8 @@ __do_follow_link(struct path *path, struct nameidata *nd, void **p)
 	touch_atime(path->mnt, dentry);
 	nd_set_link(nd, NULL);
 
-	if (path->mnt != nd->path.mnt) {
-		path_to_nameidata(path, nd);
-		dget(dentry);
-	}
-	mntget(path->mnt);
+	if (path->mnt == nd->path.mnt)
+		mntget(nd->path.mnt);
 	nd->last_type = LAST_BIND;
 	*p = dentry->d_inode->i_op->follow_link(dentry, nd);
 	error = PTR_ERR(*p);
diff --git a/fs/namespace.c b/fs/namespace.c
index 88058de..19b7fc9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -445,6 +445,7 @@ struct vfsmount *lookup_mnt(struct path *path)
 	spin_unlock(&vfsmount_lock);
 	return child_mnt;
 }
+EXPORT_SYMBOL_GPL(lookup_mnt);
 
 static inline int check_mnt(struct vfsmount *mnt)
 {


