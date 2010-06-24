Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab0FXFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 01:16:26 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33214 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738Ab0FXFQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 01:16:24 -0400
X-Sasl-enc: UHknhCXpbTOYR1ejxCpOtWdXAPOMSzUnkJaEgvjA16R2 1277356583
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount
 in super block info
From: Ian Kent <raven@themaw.net>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: autofs@linux.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Valerie Aurora <vaurora@redhat.com>, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
In-Reply-To: <1277091579.3827.9.camel@localhost>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	 <1276627208-17242-5-git-send-email-vaurora@redhat.com>
	 <1276661043.2339.35.camel@localhost>  <1277091579.3827.9.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 13:16:17 +0800
Message-ID: <1277356577.2841.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 11:39 +0800, Ian Kent wrote:
> On Wed, 2010-06-16 at 12:04 +0800, Ian Kent wrote:
> > On Tue, 2010-06-15 at 11:39 -0700, Valerie Aurora wrote:
> > > From: Jan Blunck <jblunck@suse.de>
> > > 
> > > XXX - This is broken and included just to make union mounts work.  See
> > > discussion at:
> > > 
> > > http://kerneltrap.org/mailarchive/linux-fsdevel/2010/1/15/6708053/thread
> > 
> > Instead of saving the vfsmount we could save a pointer to the dentry of
> > the mount point in the autofs super block info struct. I think that's
> > the bit I don't have so it would be sufficient for a lookup_mnt() for
> > the needed vfsmount in ->follow_mount().
> > 
> > Objections?
> > Suggestions?

Ok, lets try this again.

The compiler is way smarter that I, so it probably isn't quite so bad
this time. Obviously I need to add a Cc for the audit system maintainer.


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

 fs/autofs4/root.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/namei.c        |    7 ++-----
 fs/namespace.c    |    8 ++++++--
 3 files changed, 57 insertions(+), 7 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index db4117e..114959b 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -208,6 +208,42 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 	return 0;
 }
 
+struct args {
+	struct dentry *root;
+	struct vfsmount *mnt;
+};
+
+/* Since autofs mounts are distinct, there's exactly one */
+static int compare_mnt(struct vfsmount *mnt, void *arg)
+{
+	struct args *a = arg;
+	if (mnt->mnt_root != a->root)
+		return 0;
+	a->mnt = mntget(mnt);
+	return 1;
+}
+
+/*
+ * We need to find the vfsmount of the autofs mount that is triggering
+ * this mount but the path we have contains the parent vfsmount and
+ * the dentry of the directory that contains our mountpoint, not the
+ * dentry of the mountpoint itself. In this case we must rely on the
+ * fact that autofs file systems can't be bound elsewhere (and still
+ * work) so that when we locate a vfsmount with a matching global root
+ * it must be the one we want.
+ */
+static struct vfsmount *autofs4_find_vfsmount(struct vfsmount *parent,
+					      struct dentry *root)
+{
+	struct args args = {
+		.root = root,
+		.mnt = NULL
+	};
+
+	iterate_mounts(compare_mnt, &args, parent);
+	return args.mnt;
+}
+
 /* For autofs direct mounts the follow link triggers the mount */
 static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
@@ -215,11 +251,24 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int oz_mode = autofs4_oz_mode(sbi);
 	unsigned int lookup_type;
+	struct vfsmount *mnt;
 	int status;
 
 	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
 		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
 		nd->flags);
+
+	mnt = autofs4_find_vfsmount(nd->path.mnt, dentry);
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
index 88058de..3b5d0ca 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1272,13 +1272,17 @@ int iterate_mounts(int (*f)(struct vfsmount *, void *), void *arg,
 	int res = f(root, arg);
 	if (res)
 		return res;
+
+	spin_lock(&vfsmount_lock);
 	list_for_each_entry(mnt, &root->mnt_list, mnt_list) {
 		res = f(mnt, arg);
 		if (res)
-			return res;
+			break;
 	}
-	return 0;
+	spin_unlock(&vfsmount_lock);
+	return res;
 }
+EXPORT_SYMBOL_GPL(iterate_mounts);
 
 static void cleanup_group_ids(struct vfsmount *mnt, struct vfsmount *end)
 {


