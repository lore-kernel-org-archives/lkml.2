Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872Ab0GSWmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 18:42:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab0GSWmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 18:42:13 -0400
Date: Mon, 19 Jul 2010 18:41:53 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 27/38] union-mount: In-kernel file copyup routines
Message-ID: <20100719224152.GC11089@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-28-git-send-email-vaurora@redhat.com> <20100713045619.GI3949@zeus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713045619.GI3949@zeus.themaw.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:56:20PM +0800, Ian Kent wrote:
> On Tue, Jun 15, 2010 at 11:39:57AM -0700, Valerie Aurora wrote:
> > When a file on the read-only layer of a union mount is altered, it
> > must be copied up to the topmost read-write layer.  This patch creates
> > union_copyup() and its supporting routines.
> > 
> > Thanks to Valdis Kletnieks for a bug fix.
> > 
> > Cc: Valdis.Kletnieks@vt.edu
> > ---
> >  fs/union.c |  323 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/union.h |    7 +-
> >  2 files changed, 329 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/union.c b/fs/union.c
> > index 76a6c34..0982446 100644
> > --- a/fs/union.c
> > +++ b/fs/union.c
> > +/**
> > + * do_union_copyup_len - Copy up a file given its path (and its parent's)
> > + *
> > + * @nd: nameidata for topmost parent dir
> > + * @path: path of file to be copied up
> > + * @copy_all: if set, copy all of the file's data and ignore @len
> > + * @len: if @copy_all is not set, number of bytes of file data to copy up
> > + *
> > + * Newly copied up path is returned in @path.
> > + */
> > +
> > +static int do_union_copyup_len(struct nameidata *nd, struct path *path,
> > +			       int copy_all, size_t len)
> > +{
> > +	struct path *parent = &nd->path;
> > +	int error;
> > +
> > +	if (!IS_DIR_UNIONED(parent->dentry))
> > +		return 0;
> > +	if (parent->mnt == path->mnt)
> > +		return 0;
> > +	if (!S_ISREG(path->dentry->d_inode->i_mode) &&
> > +	    !S_ISLNK(path->dentry->d_inode->i_mode))
> > +		return 0;
> > +
> > +	BUG_ON(!S_ISDIR(parent->dentry->d_inode->i_mode));
> > +
> > +	mutex_lock(&parent->dentry->d_inode->i_mutex);
> > +	error = -ENOENT;
> > +	if (IS_DEADDIR(parent->dentry->d_inode))
> > +		goto out_unlock;
> > +
> > +	if (copy_all && S_ISREG(path->dentry->d_inode->i_mode)) {
> > +		error = -EFBIG;
> > +		len = i_size_read(path->dentry->d_inode);
> > +		if (((size_t)len != len) || ((ssize_t)len != len))
> > +			goto out_unlock;
> 
> OK, call me dumb, but what does this comparison of len to len do?

It checks if len (the size of the file to be copied up) will overflow
size_t or ssize_t on this machine.  The file could have been created
on a 64-bit box, and be too big to be manipulated on a 32-bit box.  It
could use a comment, fixed.

-VAL
