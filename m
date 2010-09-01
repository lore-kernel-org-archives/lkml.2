Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab0IAVnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 17:43:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab0IAVm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 17:42:59 -0400
Date: Wed, 1 Sep 2010 17:42:38 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 5/5] union: hybrid union filesystem prototype
Message-ID: <20100901214238.GC15849@shell>
References: <20100826183340.027591901@szeredi.hu> <20100826183507.402136609@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826183507.402136609@szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 08:33:45PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This union filesystem is a hybrid of entirely filesystem based
> (unionfs, aufs) and entierly VFS based (union mounts) solutions.

This is elegant and readable code.  I am still reviewing it but have a
few comments now.

> +static int union_upper_create(struct dentry *dentry, struct iattr *attr,
> +			      dev_t rdev, const char *link, struct path *src)
> +{
> +	int err;
> +	int attr_update = ATTR_UID | ATTR_GID | ATTR_ATIME_SET | ATTR_MTIME_SET;
> +	struct dentry *parent = dget_parent(dentry);
> +	struct union_entry *ue = dentry->d_fsdata;
> +	struct union_entry *pue = parent->d_fsdata;
> +	struct inode *upperdir = pue->upperpath.dentry->d_inode;
> +	struct dentry *newdentry;
> +	struct path newpath;
> +
> +	mutex_lock_nested(&upperdir->i_mutex, I_MUTEX_PARENT);
> +
> +	/*
> +	 * Using upper filesystem locking to protect against copy up
> +	 * racing with rename (rename means the copy up was already
> +	 * successful).
> +	 */
> +	err = -EEXIST;
> +	if (dentry->d_parent != parent)
> +		goto out_unlock;
> +
> +	newdentry = union_lookup_create(ue, pue, &dentry->d_name);
> +	err = PTR_ERR(newdentry);
> +	if (IS_ERR(newdentry))
> +		goto out_unlock;
> +
> +	newpath.dentry = newdentry;
> +	newpath.mnt = pue->upperpath.mnt;
> +
> +	switch (attr->ia_mode & S_IFMT) {
> +	case S_IFREG:
> +		if (src)
> +			WARN_ON(!(attr->ia_valid & ATTR_SIZE));
> +		else
> +			WARN_ON((attr->ia_valid & ATTR_SIZE));
> +
> +		err = vfs_create(upperdir, newdentry, attr->ia_mode, NULL);

Passing a NULL namiedata pointer to vfs_create() is a convenient
temporary hack, but unfortunately NFS, ceph, etc. still use the
nameidata passed to vfs_create() and other ops.

The way union mounts gets a valid nameidata is by doing the create in
the VFS before calling file system ops that may trigger a copyup,
while we still have the original nameidata.  This is one of the major
reasons union mounts lives in the VFS.

A lot of my conversations about union mounts with Al go like this:

Al: "Rewrite it this way."
Val: "But then how do we get the nameidata?"
Al: "Arrrrrrrrrrrrrggggh."

Can you think of a way to construct a good nameidata for these
implicit copyups?  That might be a solution.

-VAL
