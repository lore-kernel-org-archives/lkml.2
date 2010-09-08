Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0IHVmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:42:54 -0400
Received: from cobra.newdream.net ([66.33.216.30]:55574 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab0IHVmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:42:47 -0400
Date: Wed, 8 Sep 2010 14:44:02 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] vfs: introduce FS_IOC_SYNCFS to sync a single super
In-Reply-To: <20100826170142.e029cff5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.1009081428520.28999@cobra.newdream.net>
References: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
 <20100826170142.e029cff5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, Andrew Morton wrote:
> On Mon, 9 Aug 2010 07:33:57 -0700 (PDT)
> Sage Weil <sage@newdream.net> wrote:
> 
> > Currently the only way to sync a single super_block (and not all of them 
> > via sync(2)) is via the BLKFLSBUF ioctl on the block device.  That also 
> > invalidates the bdev mapping, which isn't usually desireable
> 
> Actually you can do
> 
> 	mount -o remount /dev/whatever
> 
> and it will sync the fs and retain caches.
> 
> > and it 
> > doesn't work for non-block file systems.
> 
> And I guess remount will do that also.

Good to know.

> >  The ability to sync a single 
> > mount can be useful for both applications and administrators (e.g., when 
> > other mounts on the system are hung).
> > 
> > Introduce a simple ioctl to sync the super associated with an open file.
> > Pass any error returned by sync_filesystem() back to the user.
> > 
> 
> The changelog forgot to tell us why this is a useful thing to add. 
> What is the use-case?

Two use cases:

 * An admin who wants to sync only one mount (e.g., 'sync /mnt/foo').  
I tend to need this on boxes with lots of NFS mounts where something gets 
hung up, I want to reboot, but want to make sure my local fs is synced 
first.  The remount trick handles this, although I doubt many are aware of 
that side-effect, and I'm not sure we should suggest they rely on it.

 * My use case is the Ceph storage daemon, which writes gobs of stuff to a 
single super and periodically wants to make sure it's synced so that it's 
application-level journal can be trimmed.  fsync() on individual files 
isn't practical (leads to bad IO patterns, ).  Ideally, this should 
be usable by a non-privileged user (just like sync(2)).

> > ---
> >  fs/ioctl.c         |    9 +++++++++
> >  include/linux/fs.h |    1 +
> >  2 files changed, 10 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 2d140a7..2aabb19 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -593,6 +593,15 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
> >     case FS_IOC_FIEMAP:
> >             return ioctl_fiemap(filp, arg);
> >
> > +   case FS_IOC_SYNCFS:
> > +   {
> > +           struct super_block *sb = filp->f_dentry->d_sb;
> > +           down_read(&sb->s_umount);
> > +           error = sync_filesystem(sb);
> > +           up_read(&sb->s_umount);
> > +           break;
> > +   }
> > +
>
> `mount -o remount' is surely a Linux-specific side-effect and there's
> really no guarantee that Linux will always retain that side-effect. 
> OTOH FS_IOC_SYNCFS is linux-specific.

The key difference I see is that mount -o remount is root-only, whereas 
sync(2) and FS_IOC_SYNCFS are not.  Also, it seems like a bad idea for 
applications to rely on the current remount side effect, particularly for 
something as important as data integrity.

> If we're going to add something like this then it will need to be
> documented in manpages.  Supposedly, a cc to linux-api@vger.kernel.org
> will help make all that happen, but I'm not sure who if anyone is
> answering the phone over there?

Where would this go in manpages?  ioctl_list(2)?  I'm happy to prepare a 
patch for that as well.

Thanks!
sage
