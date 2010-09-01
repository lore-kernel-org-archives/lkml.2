Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab0IAEdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 00:33:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:49125 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab0IAEdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 00:33:45 -0400
Date: Wed, 1 Sep 2010 14:33:33 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100901143333.0b9db01a@notabene>
In-Reply-To: <20100830214027.77e197f5@notabene>
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
	<20100829144207.4fbf2713@notabene>
	<E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
	<20100830214027.77e197f5@notabene>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 21:40:27 +1000
Neil Brown <neilb@suse.de> wrote:

> > > > I think it's best to leave that stuff until someone actually cares.
> > > > The "people might find it useful" argument is not strong enough to put
> > > > nontrivial effort into thinking about all the weird corner cases.
> > > 
> > > My thought on this is that in order to describe the behaviour of the
> > > filesystem accurately you need to think about all the weird corner cases.
> > > 
> > > Then it becomes a question of: is it easier to document the weird behaviour,
> > > or change the code so the documentation will be easier to understand?
> > > Some cases will go one way, some the other.
> > > 
> > > But as you suggest this isn't urgent.
> > 
> > You didn't mention one possibility: add limitations that prevent the
> > weird corner cases arising.  I believe this is the simplest option.
> 
> Val has been following that approach and asking if it is possible to make an
> NFS filesystem really-truly read-only. i.e. no changes.
> I don't believe it is.
> 
> But I won't pursue this further without patches.
> 

And here is a patch.  It isn't really complete, but I have done enough for
today.  It at least shows what I am trying to do.

To see a clear indication of the effect, try the following script before and
after the patch..

-----------------------
#!/bin/sh

# L = lower U = upper O = overlay

umount /tmp/O
rm -rf /tmp/[LUO]

mkdir /tmp/{L,U,O}

for i in 1 2 3; do > /tmp/L/$i ; done

mount -t union -o upperdir=/tmp/U,lowerdir=/tmp/L pointlessword /tmp/O

ls -l /tmp/O/foo
ls -l /tmp/O
> /tmp/L/foo
ls -l /tmp/O
-------------------------


The last 'ls -l' report a non-existent 'foo' without the patch.  With the
patch it more correctly doesn't report anything at all about foo.


No patch change-log yet because I'm not suggesting it be included, just
reviewed.

NeilBrown

diff --git a/fs/union/union.c b/fs/union/union.c
index e19fe62..434d152 100644
--- a/fs/union/union.c
+++ b/fs/union/union.c
@@ -392,9 +392,160 @@ static void union_dentry_iput(struct dentry *dentry, struct inode *inode)
 	iput(inode);
 }
 
+static int union_still_valid(struct dentry *dentry,
+			     struct dentry *parent, struct dentry *child)
+{
+	/* dentry is in the union filesystem
+	 * child is the corresponding dentry in the upper to lower layer
+	 * parent is the corresponding dentry of dentry's parent in the same layer
+	 *
+	 * If child is NULL, the parent must be NULL or negative.
+	 * Otherwise child must be hashed, have parent as the d_parent, and
+	 * have the same name as dentry
+	 *
+	 */
+	struct qstr *qstr;
+	int rv;
+
+	if (child == NULL)
+		return (parent == NULL || parent->d_inode == NULL);
+
+	if (child->d_parent != parent)
+		return 0;
+	if (d_unhashed(child))
+		return 0;
+
+	/* Unfortunately we need d_lock to compare names */
+	spin_lock(&dentry->d_lock);
+	spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+	qstr = &child->d_name;
+	if (parent->d_op && parent->d_op->d_compare)
+		rv = ! (parent->d_op->d_compare(parent, qstr, &dentry->d_name));
+	else
+		rv =  (qstr->len == dentry->d_name.len &&
+		       memcmp(qstr->name, dentry->d_name.name, qstr->len) == 0);
+
+	spin_unlock(&child->d_lock);
+	spin_unlock(&dentry->d_lock);
+	return rv;
+}
+
+static struct dentry *union_lookup_real(struct dentry *dir, struct qstr *name);
+static struct inode *union_new_inode(struct super_block *sb, umode_t mode);
+
+static struct union_entry do_union_lookup(struct inode *dir, struct dentry *dentry,
+					   struct nameidata *nd)
+{
+	struct union_entry *pue = dentry->d_parent->d_fsdata;
+	struct union_entry ue;
+	struct dentry *upperdir = pue->upperpath.dentry;
+	struct dentry *upperdentry = NULL;
+	struct dentry *lowerdir = pue->lowerpath.dentry;
+	struct dentry *lowerdentry = NULL;
+	int err;
+
+	memset(&ue, 0, sizeof(ue));
+
+	if (upperdir) {
+		upperdentry = union_lookup_real(upperdir, &dentry->d_name);
+		err = PTR_ERR(upperdentry);
+		if (IS_ERR(upperdentry))
+			goto out;
+
+		if (upperdentry) {
+			if (union_is_opaquedir(upperdentry))
+				ue.opaque = true;
+			else if (union_is_whiteout(upperdentry)) {
+				dput(upperdentry);
+				upperdentry = NULL;
+				ue.opaque = true;
+			}
+		}
+	}
+	if (lowerdir && !ue.opaque) {
+		lowerdentry = union_lookup_real(lowerdir, &dentry->d_name);
+		if (IS_ERR(lowerdentry)) {
+			err = PTR_ERR(lowerdentry);
+			dput(upperdentry);
+			goto out;
+		}
+	}
+
+	if (lowerdentry && upperdentry &&
+	    (!S_ISDIR(upperdentry->d_inode->i_mode) ||
+	     !S_ISDIR(lowerdentry->d_inode->i_mode))) {
+		dput(lowerdentry);
+		lowerdentry = NULL;
+		ue.opaque = true;
+	}
+
+	if (upperdentry) {
+		ue.upperpath.mnt = pue->upperpath.mnt;
+		ue.upperpath.dentry = upperdentry;
+		path_get(&ue.upperpath);
+		dput(upperdentry);
+	}
+	if (lowerdentry) {
+		ue.lowerpath.mnt = pue->lowerpath.mnt;
+		ue.lowerpath.dentry = lowerdentry;
+		path_get(&ue.lowerpath);
+		dput(lowerdentry);
+	}
+
+	return ue;
+
+out:
+	ue.upperpath.dentry = ERR_PTR(err);
+	return ue;
+}
+
+static int union_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	/* We need to revalidate this dentry if the upper parent might have
+	 * changed.
+	 */
+	struct dentry *parent = dget_parent(dentry);
+	struct union_entry *ue = dentry->d_fsdata;
+	struct union_entry *pue = parent->d_fsdata;
+	struct union_entry nue;
+	int rv = 1;
+
+	if (union_still_valid(dentry, pue->upperpath.dentry,  ue->upperpath.dentry) &&
+	    union_still_valid(dentry, pue->lowerpath.dentry,  ue->lowerpath.dentry))
+		goto out;
+
+	/* If dentry is not a directory, it is safe to fail */
+	rv = 0;
+	if (dentry->d_inode == NULL || !S_ISDIR(dentry->d_inode->i_mode))
+		goto out;
+
+	/* If this dentry or a child is in use by someone else, it cannot be
+	 * invalidated so the best thing to do is re-lookup the names
+	 */
+	mutex_lock(&parent->d_inode->i_mutex);
+	if (dentry->d_parent != parent)
+		goto out_unlock;
+	rv = 1;
+	nue = do_union_lookup(parent->d_inode, dentry, nd);
+	if (IS_ERR(nue.upperpath.dentry))
+		/* Leave the dentry unchanged, but return the error */
+		rv = PTR_ERR(nue.upperpath.dentry);
+	else {
+		path_put(&ue->upperpath);
+		path_put(&ue->lowerpath);
+		*ue = nue;
+	}
+out_unlock:
+	mutex_unlock(&parent->d_inode->i_mutex);
+out:
+	dput(parent);
+	return rv;
+}
+
 static const struct dentry_operations union_dentry_operations = {
 	.d_release = union_dentry_release,
 	.d_iput = union_dentry_iput,
+	.d_revalidate = union_dentry_revalidate,
 };
 
 static struct inode *union_new_inode(struct super_block *sb, umode_t mode)
@@ -459,12 +610,7 @@ static struct dentry *union_lookup_real(struct dentry *dir, struct qstr *name)
 static struct dentry *union_lookup(struct inode *dir, struct dentry *dentry,
 				   struct nameidata *nd)
 {
-	struct union_entry *pue = dentry->d_parent->d_fsdata;
 	struct union_entry *ue;
-	struct dentry *upperdir = pue->upperpath.dentry;
-	struct dentry *upperdentry = NULL;
-	struct dentry *lowerdir = pue->lowerpath.dentry;
-	struct dentry *lowerdentry = NULL;
 	struct inode *inode = NULL;
 	int err;
 
@@ -472,71 +618,29 @@ static struct dentry *union_lookup(struct inode *dir, struct dentry *dentry,
 	ue = kzalloc(sizeof(struct union_entry), GFP_KERNEL);
 	if (!ue)
 		goto out;
-
-	if (upperdir) {
-		upperdentry = union_lookup_real(upperdir, &dentry->d_name);
-		err = PTR_ERR(upperdentry);
-		if (IS_ERR(upperdentry))
-			goto out_free;
-
-		if (upperdentry) {
-			if (union_is_opaquedir(upperdentry))
-				ue->opaque = true;
-			else if (union_is_whiteout(upperdentry)) {
-				dput(upperdentry);
-				upperdentry = NULL;
-				ue->opaque = true;
-			}
-		}
-	}
-	if (lowerdir && !ue->opaque) {
-		lowerdentry = union_lookup_real(lowerdir, &dentry->d_name);
-		if (IS_ERR(lowerdentry)) {
-			err = PTR_ERR(lowerdentry);
-			dput(upperdentry);
-			goto out_free;
-		}
+	*ue = do_union_lookup(dir, dentry, nd);
+	if (IS_ERR(ue->upperpath.dentry)) {
+		err = PTR_ERR(ue->upperpath.dentry);
+		goto out_free;
 	}
-
-	if (lowerdentry && upperdentry &&
-	    (!S_ISDIR(upperdentry->d_inode->i_mode) ||
-	     !S_ISDIR(lowerdentry->d_inode->i_mode))) {
-		dput(lowerdentry);
-		lowerdentry = NULL;
-		ue->opaque = true;
-	}
-
-	if (lowerdentry || upperdentry) {
+	if (ue->upperpath.dentry || ue->lowerpath.dentry) {
 		struct dentry *realdentry;
 
-		realdentry = upperdentry ? upperdentry : lowerdentry;
+		realdentry = ue->upperpath.dentry ? : ue->lowerpath.dentry;
 		inode = union_new_inode(dir->i_sb, realdentry->d_inode->i_mode);
-		if (!inode)
-			goto out_dput;
-	}
-
-	if (upperdentry) {
-		ue->upperpath.mnt = pue->upperpath.mnt;
-		ue->upperpath.dentry = upperdentry;
-		path_get(&ue->upperpath);
-		dput(upperdentry);
-	}
-	if (lowerdentry) {
-		ue->lowerpath.mnt = pue->lowerpath.mnt;
-		ue->lowerpath.dentry = lowerdentry;
-		path_get(&ue->lowerpath);
-		dput(lowerdentry);
+		err = -ENOMEM;
+		if (!inode) {
+			path_put(&ue->upperpath);
+			path_put(&ue->lowerpath);
+			goto out_free;
+		}
 	}
-
 	d_add(dentry, inode);
 	dentry->d_fsdata = ue;
 	dentry->d_op = &union_dentry_operations;
 
 	return NULL;
 
-out_dput:
-	dput(upperdentry);
-	dput(lowerdentry);
 out_free:
 	kfree(ue);
 out:
