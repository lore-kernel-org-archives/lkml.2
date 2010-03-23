Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0CWPDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab0CWPD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:03:29 -0400
Date: Tue, 23 Mar 2010 11:03:01 -0400
From: Josef Bacik <josef@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
	ioctl
Message-ID: <20100323150301.GD2381@localhost.localdomain>
References: <20100323142200.GA2381@localhost.localdomain> <20100323142843.GG30031@ZenIV.linux.org.uk> <20100323143456.GC2381@localhost.localdomain> <20100323144828.GH30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323144828.GH30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 02:48:28PM +0000, Al Viro wrote:
> On Tue, Mar 23, 2010 at 10:34:56AM -0400, Josef Bacik wrote:
> > +++ b/fs/block_dev.c
> > @@ -245,35 +245,13 @@ struct super_block *freeze_bdev(struct block_device *bdev)
> >  	sb = get_active_super(bdev);
> 
> sb is an active locked reference
> 
> > +	error = freeze_super(sb, 1);
> > +	if (error) {
> > +		bdev->bd_fsfreeze_count--;
> > +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> > +		return ERR_PTR(error);
> >  	}
> > -	up_write(&sb->s_umount);
> >  
> >   out:
> >  	sync_blockdev(bdev);
> 
> >  static int ioctl_fsfreeze(struct file *filp)
> >  {
> >  	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> 
> sb is an active reference
> 

I don't understand how this is an active reference?  We are talking about
s_active right?

> > +	ret = freeze_super(sb, 0);
> > +
> > +	return ret;
> >  }
> 
> > +int freeze_super(struct super_block *sb, int locked)
> > +{
> > +	int ret;
> > +
> > +	if (!locked) {
> > +		spin_lock(&sb_lock);
> > +		ret = grab_super(sb);
> 
> What in hell for?  We already hold an active reference here.  That's leaving
> aside the obvious comments about argument-dependent locking state...

We need to have an active (s_active++) reference to the super throughout the
freeze to make sure somebody doesn't come along and umount the fs until after we
do the thaw.  Now, most of this code is copy and pasted, so I don't claim to
understand why it was done this way to begin with, I was just trying to not
change as much as possible.  But from what I can tell, we _need_ to have the
active reference on the sb until we thaw.  Freeze_bdev already gets this active
reference via get_active_super(), but from what I can tell the ioctl_fsfreeze
doesn't have an active reference, hence the locked argument, so we can do a
grab_super and get the active reference.  Would you prefer that I have a
__freeze_super that expects the sb to already have an active reference, and then
make freeze_super do the grab_super instead?  Thanks,

Josef
