Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab0I0IMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:12:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44387 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab0I0IMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:12:16 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, agruen@suse.de, linuxram@us.ibm.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, viro@zeniv.linux.org.uk
In-reply-to: <20100924175653.GB25129@shell> (message from Valerie Aurora on
	Fri, 24 Sep 2010 13:56:54 -0400)
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
References: <20100920180404.939991832@szeredi.hu> <20100920180447.854260354@szeredi.hu> <20100924175653.GB25129@shell>
Message-Id: <E1P08oT-0004C7-3O@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 27 Sep 2010 10:11:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010, Valerie Aurora wrote:
> On Mon, Sep 20, 2010 at 08:04:10PM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > This overlay filesystem is a hybrid of entirely filesystem based
> > (unionfs, aufs) and entierly VFS based (union mounts) solutions.
> 
> [...]
> 
> > +static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
> > +			     const char *link)
> > +{
> > +	int err;
> > +	struct dentry *newdentry;
> > +	struct dentry *upperdir;
> > +	struct inode *inode;
> > +	struct kstat stat = {
> > +		.mode = mode,
> > +		.rdev = rdev,
> > +	};
> > +
> > +	err = -ENOMEM;
> > +	inode = ovl_new_inode(dentry->d_sb, mode);
> > +	if (!inode)
> > +		goto out;
> > +
> > +	err = ovl_copy_up(dentry->d_parent);
> > +	if (err)
> > +		goto out_iput;
> > +
> > +	upperdir = ovl_dentry_upper(dentry->d_parent);
> > +	mutex_lock_nested(&upperdir->d_inode->i_mutex, I_MUTEX_PARENT);
> > +
> > +	newdentry = ovl_upper_create(upperdir, dentry, &stat, link);
> > +	err = PTR_ERR(newdentry);
> > +	if (IS_ERR(newdentry))
> > +		goto out_unlock;
> > +
> > +	if (ovl_dentry_is_opaque(dentry) && S_ISDIR(mode)) {
> > +		err = ovl_set_opaque(newdentry);
> > +		if (err)
> > +			goto out_dput;
> > +	}
> 
> Andreas Gruenbacher just convinced me that every single new directory
> created in the unioned file system should be marked opaque.  "New"
> means either it replaces a whiteout or has no matching directory on
> the lower layer.  The theory is that the topmost file system changes
> should take precedence and override any changes (off-line) in the
> lower file system.

That's logical.  However marking new directories opaque is only a half
solution.  E.g. consider the case when we have /a/b/c/ on the lower fs
and /a/b/ on the upper, which is not opaque.  Then /a/b/c/ is created
on the upper fs off-line.  The union logic can't notice that "c"
should really be opaque and will merge with the contents of the lower
layer.

The real solution to this problem is to make opaque the default and
only mark *non* opaque directories.  These are only created on copy-up
or by explicit admin action on the upper fs.

Thanks,
Miklos
