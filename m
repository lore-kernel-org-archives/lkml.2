Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0IXR5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:57:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab0IXR5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:57:10 -0400
Date: Fri, 24 Sep 2010 13:56:54 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruen@suse.de>,
        alias ram Ram Pai <linuxram@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
Message-ID: <20100924175653.GB25129@shell>
References: <20100920180404.939991832@szeredi.hu> <20100920180447.854260354@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920180447.854260354@szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 08:04:10PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This overlay filesystem is a hybrid of entirely filesystem based
> (unionfs, aufs) and entierly VFS based (union mounts) solutions.

[...]

> +static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
> +			     const char *link)
> +{
> +	int err;
> +	struct dentry *newdentry;
> +	struct dentry *upperdir;
> +	struct inode *inode;
> +	struct kstat stat = {
> +		.mode = mode,
> +		.rdev = rdev,
> +	};
> +
> +	err = -ENOMEM;
> +	inode = ovl_new_inode(dentry->d_sb, mode);
> +	if (!inode)
> +		goto out;
> +
> +	err = ovl_copy_up(dentry->d_parent);
> +	if (err)
> +		goto out_iput;
> +
> +	upperdir = ovl_dentry_upper(dentry->d_parent);
> +	mutex_lock_nested(&upperdir->d_inode->i_mutex, I_MUTEX_PARENT);
> +
> +	newdentry = ovl_upper_create(upperdir, dentry, &stat, link);
> +	err = PTR_ERR(newdentry);
> +	if (IS_ERR(newdentry))
> +		goto out_unlock;
> +
> +	if (ovl_dentry_is_opaque(dentry) && S_ISDIR(mode)) {
> +		err = ovl_set_opaque(newdentry);
> +		if (err)
> +			goto out_dput;
> +	}

Andreas Gruenbacher just convinced me that every single new directory
created in the unioned file system should be marked opaque.  "New"
means either it replaces a whiteout or has no matching directory on
the lower layer.  The theory is that the topmost file system changes
should take precedence and override any changes (off-line) in the
lower file system.

What do you think?

-VAL
