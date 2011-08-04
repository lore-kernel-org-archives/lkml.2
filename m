Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1HDJqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:46:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab1HDJqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:46:18 -0400
Date: Thu, 4 Aug 2011 11:46:16 +0200
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, hch@infradead.org, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com
Subject: Re: [PATCH 2/4] vfs: keep list of mounts for each superblock
Message-ID: <20110804094616.GC17196@quack.suse.cz>
References: <1312368521-7911-1-git-send-email-miklos@szeredi.hu>
 <1312368521-7911-3-git-send-email-miklos@szeredi.hu>
 <20110803221707.GM2203@ZenIV.linux.org.uk>
 <1312449054.6032.22.camel@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312449054.6032.22.camel@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-08-11 11:10:54, Miklos Szeredi wrote:
> On Wed, 2011-08-03 at 23:17 +0100, Al Viro wrote:
> > On Wed, Aug 03, 2011 at 12:48:39PM +0200, Miklos Szeredi wrote:
> > > @@ -696,6 +696,11 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
> > >  	mnt->mnt_sb = root->d_sb;
> > >  	mnt->mnt_mountpoint = mnt->mnt_root;
> > >  	mnt->mnt_parent = mnt;
> > > +
> > > +	br_write_lock(vfsmount_lock);
> > > +	list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
> > > +	br_write_unlock(vfsmount_lock);
> > 
> > Racy.
> > 
> > > @@ -745,6 +750,10 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
> > >  			if (!list_empty(&old->mnt_expire))
> > >  				list_add(&mnt->mnt_expire, &old->mnt_expire);
> > >  		}
> > > +
> > > +		br_write_lock(vfsmount_lock);
> > > +		list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
> > > +		br_write_unlock(vfsmount_lock);
> > 
> > Ditto.  If you expect to be able to find *all* vfsmounts over given sb,
> > this locking is simply wrong.
> 
> I don't understand.  All accesses to mnt_instance/s_mounts are protected
> by vfsmount_lock.  What else is needed?
  I guess Al meant that sb_prepare_remount_readonly() from the next patch
could race with new mountpoint being added to the list and the check is
thus still unreliable? Quickly checking the locking seems to confirm that
since e.g. clone_mnt() does not hold s_umount semaphore (only
namespace_sem?) and do_remount_sb() has it the other way around...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
