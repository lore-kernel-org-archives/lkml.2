Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab0I0SsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124Ab0I0SsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:48:21 -0400
Date: Mon, 27 Sep 2010 14:47:47 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: agruen@suse.de, linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
Message-ID: <20100927184747.GC8089@shell>
References: <20100920180404.939991832@szeredi.hu> <20100920180447.854260354@szeredi.hu> <20100924175653.GB25129@shell> <E1P08oT-0004C7-3O@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1P08oT-0004C7-3O@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:11:53AM +0200, Miklos Szeredi wrote:
> On Fri, 24 Sep 2010, Valerie Aurora wrote:
> > On Mon, Sep 20, 2010 at 08:04:10PM +0200, Miklos Szeredi wrote:
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > This overlay filesystem is a hybrid of entirely filesystem based
> > > (unionfs, aufs) and entierly VFS based (union mounts) solutions.
> > 
> > [...]
> > 
> > > +static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
> > > +			     const char *link)
> > > +{
> > > +	int err;
> > > +	struct dentry *newdentry;
> > > +	struct dentry *upperdir;
> > > +	struct inode *inode;
> > > +	struct kstat stat = {
> > > +		.mode = mode,
> > > +		.rdev = rdev,
> > > +	};
> > > +
> > > +	err = -ENOMEM;
> > > +	inode = ovl_new_inode(dentry->d_sb, mode);
> > > +	if (!inode)
> > > +		goto out;
> > > +
> > > +	err = ovl_copy_up(dentry->d_parent);
> > > +	if (err)
> > > +		goto out_iput;
> > > +
> > > +	upperdir = ovl_dentry_upper(dentry->d_parent);
> > > +	mutex_lock_nested(&upperdir->d_inode->i_mutex, I_MUTEX_PARENT);
> > > +
> > > +	newdentry = ovl_upper_create(upperdir, dentry, &stat, link);
> > > +	err = PTR_ERR(newdentry);
> > > +	if (IS_ERR(newdentry))
> > > +		goto out_unlock;
> > > +
> > > +	if (ovl_dentry_is_opaque(dentry) && S_ISDIR(mode)) {
> > > +		err = ovl_set_opaque(newdentry);
> > > +		if (err)
> > > +			goto out_dput;
> > > +	}
> > 
> > Andreas Gruenbacher just convinced me that every single new directory
> > created in the unioned file system should be marked opaque.  "New"
> > means either it replaces a whiteout or has no matching directory on
> > the lower layer.  The theory is that the topmost file system changes
> > should take precedence and override any changes (off-line) in the
> > lower file system.
> 
> That's logical.  However marking new directories opaque is only a half
> solution.  E.g. consider the case when we have /a/b/c/ on the lower fs
> and /a/b/ on the upper, which is not opaque.  Then /a/b/c/ is created
> on the upper fs off-line.  The union logic can't notice that "c"
> should really be opaque and will merge with the contents of the lower
> layer.

Maybe I don't understand.  It seems like directories created when the
file system is *not* union mounted should definitely be merged with
matching directories on the lower layer.

Take the case of /etc/fstab.  The first union mount never touches /etc
and it doesn't exist on the topmost layer.  Then we unmount the upper
layer, mount it somewhere else as a plain mount, and create /etc/ and
/etc/fstab.  When we union mount it back over the lower layer again,
we still want the lower layer /etc/ to be merged with the topmost
/etc/, or else init.d will disappear.

However, if while the file system is union mounted, /etc/ doesn't
exist, and /etc/ is created, a later mount shouldn't merge a newly
created /etc/ on the lower layer.

> The real solution to this problem is to make opaque the default and
> only mark *non* opaque directories.  These are only created on copy-up
> or by explicit admin action on the upper fs.

Again, maybe I'm misunderstanding, but this doesn't make much sense to
me.  Say I create:

/upper/a_dir/upper_file
/lower/a_dir/lower_file

Then when I union mount them, I want a_dir/ to be transparent
automatically and show both upper_file and lower_file, without marking
it manually.

-VAL
