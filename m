Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab2BJJtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 04:49:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab2BJJtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 04:49:00 -0500
Date: Fri, 10 Feb 2012 10:48:58 +0100
From: Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, mpatocka@redhat.com
Subject: Re: [PATCH 1/2] vfs: Provide function to get superblock and wait
 for it to thaw
Message-ID: <20120210094858.GC10509@quack.suse.cz>
References: <1328654267-18855-1-git-send-email-jack@suse.cz>
 <1328654267-18855-2-git-send-email-jack@suse.cz>
 <20120208232049.GC7479@dastard>
 <20120208232705.GF1696@quack.suse.cz>
 <20120208234703.GG1696@quack.suse.cz>
 <4F33F640.7040508@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F33F640.7040508@sandeen.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 09-02-12 10:37:20, Eric Sandeen wrote:
> On 2/8/12 5:47 PM, Jan Kara wrote:
> > On Thu 09-02-12 00:27:05, Jan Kara wrote:
> >> On Thu 09-02-12 10:20:49, Dave Chinner wrote:
> >>> The thawed parameter appears to be unused and the waiting for frozen
> >>> filesystems appears to happen for all callers. Is this intentional?
> >>   Ah, sorry. Obviously that's a bug. Thanks for spotting it. I'll fix it
> >> up.
> >   Attached is a fixed version.
> > 
> > 								Honza
> 
> > From 5dce7adb0c281612a14fa3dd8c8d5ef3f5eb3666 Mon Sep 17 00:00:00 2001
> > From: Jan Kara <jack@suse.cz>
> > Date: Tue, 7 Feb 2012 22:59:06 +0100
> > Subject: [PATCH 1/2] vfs: Provide function to get superblock and wait for it to thaw
> > 
> > In quota code we need to find a superblock corresponding to a device and wait
> > for superblock to be unfrozen. However this waiting has to happen without
> > s_umount semaphore because that is required for superblock to thaw. So provide
> > a function in VFS for this to keep dances with s_umount where they belong.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/super.c         |   47 +++++++++++++++++++++++++++++++++++------------
> >  include/linux/fs.h |    1 +
> >  2 files changed, 36 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index 6015c02..e15aaa9 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -593,15 +593,7 @@ void iterate_supers_type(struct file_system_type *type,
> >  
> >  EXPORT_SYMBOL(iterate_supers_type);
> >  
> > -/**
> > - *	get_super - get the superblock of a device
> > - *	@bdev: device to get the superblock for
> > - *	
> > - *	Scans the superblock list and finds the superblock of the file system
> > - *	mounted on the device given. %NULL is returned if no match is found.
> > - */
> 
> > -
> > -struct super_block *get_super(struct block_device *bdev)
> > +static struct super_block *__get_super(struct block_device *bdev, bool thawed)
> >  {
> >  	struct super_block *sb;
> >  
> > @@ -618,9 +610,13 @@ rescan:
> >  			spin_unlock(&sb_lock);
> >  			down_read(&sb->s_umount);
> >  			/* still alive? */
> > -			if (sb->s_root && (sb->s_flags & MS_BORN))
> > -				return sb;
> > -			up_read(&sb->s_umount);
> > +			if (sb->s_root && (sb->s_flags & MS_BORN)) {
> > +				if (!thawed || sb->s_frozen == SB_UNFROZEN)
> 
> I guess this has the same race we are worried about elsewhere (sb gets
> frozen immediately after we check) but probably can't fix that yet.
  As Mikulas said, this is OK. We return to the caller with s_umount held
thus freezing cannot happen in parallel. That's why I'm sending this as a
separate patch set...

> would "wait_for_thaw" vs. "thaw" be any clearer?  Nitpicky I guess but the
> meaning of "thawed" isn't immediately clear here.  If it's already thawed?  If
> we want to wait for it it to be thawed?  You can figure it out from the callers
> but maybe a comment or a different name might help.  No big deal.
  How about "wait_thaw". That should be explicit enough...

>  
> > +					return sb;
> > +				up_read(&sb->s_umount);
> > +				vfs_check_frozen(sb, SB_FREEZE_WRITE);
> > +			} else
> > +				up_read(&sb->s_umount);
> >  			/* nope, got unmounted */
> >  			spin_lock(&sb_lock);
> >  			__put_super(sb);
> > @@ -631,9 +627,36 @@ rescan:
> >  	return NULL;
> >  }
> >  
> > +/**
> > + *	get_super - get the superblock of a device
> > + *	@bdev: device to get the superblock for
> > + *
> > + *	Scans the superblock list and finds the superblock of the file system
> > + *	mounted on the device given. %NULL is returned if no match is found.
> > + */
> 
> I think it'd be nice to explicitly say in the comment that this may
> return a frozen superblock.
  Will do.

> > +struct super_block *get_super(struct block_device *bdev)
> > +{
> > +	return __get_super(bdev, false);
> > +}
> >  EXPORT_SYMBOL(get_super);
> >  
> >  /**
> > + *	get_super_thawed - get thawed superblock of a device
> > + *	@bdev: device to get the superblock for
> > + *
> > + *	Scans the superblock list and finds the superblock of the file system
> > + *	mounted on the device given once the superblock is thawed. %NULL is
> > + *	returned if no match is found.
> > + */
> 
> And to explicitly say that this one will not return until the sb is unfrozen?
  It is written in the comment ("once the superblock is thawed"). But the
sentence looks ugly when I read it now so I'll try to reformulate it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
