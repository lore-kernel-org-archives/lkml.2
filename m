Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1CWKDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:03:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46886 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab1CWKDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:03:31 -0400
To: viro@ZenIV.linux.org.uk
CC: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
In-reply-to: <E1Q28EK-0001rI-9v@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Tue, 22 Mar 2011 21:31:04 +0100)
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
References: <20110322152602.053930811@szeredi.hu>
 <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <20110322183919.GV22723@ZenIV.linux.org.uk>
 <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
 <E1Q26mX-0001Tt-Jq@pomaz-ex.szeredi.hu>
 <20110322190002.GW22723@ZenIV.linux.org.uk>
 <E1Q27U5-0001eO-AL@pomaz-ex.szeredi.hu>
 <20110322195331.GY22723@ZenIV.linux.org.uk>
 <E1Q27qg-0001kq-IO@pomaz-ex.szeredi.hu> <20110322201101.GZ22723@ZenIV.linux.org.uk> <E1Q28EK-0001rI-9v@pomaz-ex.szeredi.hu>
Message-Id: <E1Q2KuI-0004o5-NB@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 Mar 2011 11:03:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Miklos Szeredi wrote:
> > What do you mean, before?  It's not atomic...  What happens if e.g.
> > you get
> > 
> > A: decided to do copy_up_locked
> >    blocked on i_mutex
> > 
> > B: did copy_up
> >    did rename(), complete with d_move()
> >    did unlink() in new place
> > 
> > A: got CPU back, got i_mutex
> 
> Here it can check if the file was copied up or not.  OK, I see the
> code doesn't quite get that right.
> 
> Patch below would fix it, I think.

Patch is correct, after all.  More cleanups in that area below, as
well as analysis of rename vs. copy up race.

Thanks for taking a look.

Miklos



diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index e7fcbde..b97a481 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -1166,15 +1166,8 @@ static int ovl_copy_up_locked(struct dentry *upperdir, struct dentry *dentry,
 
 	newpath.mnt = ofs->upper_mnt;
 	newpath.dentry = ovl_upper_create(upperdir, dentry, stat, link);
-	if (IS_ERR(newpath.dentry)) {
-		err = PTR_ERR(newpath.dentry);
-
-		/* Already copied up? */
-		if (err == -EEXIST && ovl_path_type(dentry) != OVL_PATH_LOWER)
-			return 0;
-
-		return err;
-	}
+	if (IS_ERR(newpath.dentry))
+		return PTR_ERR(newpath.dentry);
 
 	if (S_ISREG(stat->mode)) {
 		err = ovl_copy_up_data(lowerpath, &newpath, stat->size);
@@ -1218,6 +1211,21 @@ err_remove:
 	return err;
 }
 
+/*
+ * Copy up a single dentry
+ *
+ * Directory renames only allowed on "pure upper" (already created on
+ * upper filesystem, never copied up).  Directories which are on lower or
+ * are merged may not be renamed.  For these -EXDEV is returned and
+ * userspace has to deal with it.  This means, when copying up a
+ * directory we can rely on it and ancestors being stable.
+ *
+ * Non-directory renames start with copy up of source if necessary.  The
+ * actual rename will only proceed once the copy up was successful.  Copy
+ * up uses upper parent i_mutex for exclusion.  Since rename can change
+ * d_parent it is possible that the copy up will lock the old parent.  At
+ * that point the file will have already been copied up anyway.
+ */
 static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			   struct path *lowerpath, struct kstat *stat)
 {
@@ -1264,13 +1272,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	old_cred = override_creds(override_cred);
 
 	mutex_lock_nested(&upperdir->d_inode->i_mutex, I_MUTEX_PARENT);
-	/*
-	 * Using upper filesystem locking to protect against copy up
-	 * racing with rename (rename means the copy up was already
-	 * successful).
-	 */
-	if (dentry->d_parent != parent) {
-		WARN_ON((ovl_path_type(dentry) == OVL_PATH_LOWER));
+	if (ovl_path_type(dentry) != OVL_PATH_LOWER) {
 		err = 0;
 	} else {
 		err = ovl_copy_up_locked(upperdir, dentry, lowerpath,
