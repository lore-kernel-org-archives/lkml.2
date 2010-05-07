Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0EGOqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:46:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab0EGOqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:46:08 -0400
Date: Fri, 7 May 2010 10:45:58 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 27/39] union-mount: In-kernel copyup routines
Message-ID: <20100507144558.GA23248@shell>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com> <1272928358-20854-28-git-send-email-vaurora@redhat.com> <30882.1272937204@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30882.1272937204@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 09:40:04PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 03 May 2010 16:12:26 PDT, Valerie Aurora said:
> > When a file on the read-only layer of a union mount is altered, it
> > must be copied up to the topmost read-write layer.  This patch creates
> > union_copyup() and its supporting routines.
> > ---
> >  fs/union.c            |  244 +++++++++++++++++++++++++++++++++++++++++++++++
> 
> > +/**
> > + * union_copyup_data - Copy up len bytes of old's data to new
> > + *
> > + * @old: source file
> > + * @new: target file
> > + * @len: number of bytes to copy
> > + */
> > +
> > +static int union_copyup_data(struct path *old, struct vfsmount *new_mnt,
> > +			     struct dentry *new_dentry, size_t len)
> > +{
> > +	struct file *old_file;
> > +	struct file *new_file;
> > +	const struct cred *cred = current_cred();
> > +	loff_t offset = 0;
> > +	long bytes;
> > +	int error;
> 
> Should this be 'int error = 0;' ?
> 
> > +
> > +	if (len == 0)
> > +		return 0;
> > +
> > +	/* Get reference to balance later fput() */
> > +	path_get(old);
> > +	old_file = dentry_open(old->dentry, old->mnt, O_RDONLY, cred);
> > +	if (IS_ERR(old_file))
> > +		return PTR_ERR(old_file);
> > +
> > +	dget(new_dentry);
> > +	mntget(new_mnt);
> > +	new_file = dentry_open(new_dentry, new_mnt, O_WRONLY, cred);
> > +	if (IS_ERR(new_file)) {
> > +		error = PTR_ERR(new_file);
> > +		goto out_fput;
> > +	}
> > +
> > +	bytes = do_splice_direct(old_file, &offset, new_file, len,
> > +				 SPLICE_F_MOVE);
> > +	if (bytes < 0)
> > +		error = bytes;
> > +
> > +	fput(new_file);
> > +out_fput:
> > +	fput(old_file);
> > +	return error;
> > +}
> 
> because otherwise if do_splice_direct() returns a non-negative value,
> we can hit 'return error;' without ever having set error to anything?

Yes, I think you're right.  Thanks!

-VAL
