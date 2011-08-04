Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1HDJ7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:59:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab1HDJ66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:58:58 -0400
Subject: Re: [PATCH 2/4] vfs: keep list of mounts for each superblock
From: Miklos Szeredi <mszeredi@suse.cz>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com
In-Reply-To: <20110804094616.GC17196@quack.suse.cz>
References: <1312368521-7911-1-git-send-email-miklos@szeredi.hu>
	 <1312368521-7911-3-git-send-email-miklos@szeredi.hu>
	 <20110803221707.GM2203@ZenIV.linux.org.uk>
	 <1312449054.6032.22.camel@tucsk.pomaz.szeredi.hu>
	 <20110804094616.GC17196@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 11:58:56 +0200
Message-ID: <1312451936.6032.32.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 11:46 +0200, Jan Kara wrote:
> On Thu 04-08-11 11:10:54, Miklos Szeredi wrote:
> > On Wed, 2011-08-03 at 23:17 +0100, Al Viro wrote:
> > > On Wed, Aug 03, 2011 at 12:48:39PM +0200, Miklos Szeredi wrote:
> > > > @@ -696,6 +696,11 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
> > > >  	mnt->mnt_sb = root->d_sb;
> > > >  	mnt->mnt_mountpoint = mnt->mnt_root;
> > > >  	mnt->mnt_parent = mnt;
> > > > +
> > > > +	br_write_lock(vfsmount_lock);
> > > > +	list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
> > > > +	br_write_unlock(vfsmount_lock);
> > > 
> > > Racy.
> > > 
> > > > @@ -745,6 +750,10 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
> > > >  			if (!list_empty(&old->mnt_expire))
> > > >  				list_add(&mnt->mnt_expire, &old->mnt_expire);
> > > >  		}
> > > > +
> > > > +		br_write_lock(vfsmount_lock);
> > > > +		list_add_tail(&mnt->mnt_instance, &mnt->mnt_sb->s_mounts);
> > > > +		br_write_unlock(vfsmount_lock);
> > > 
> > > Ditto.  If you expect to be able to find *all* vfsmounts over given sb,
> > > this locking is simply wrong.
> > 
> > I don't understand.  All accesses to mnt_instance/s_mounts are protected
> > by vfsmount_lock.  What else is needed?

>   I guess Al meant that sb_prepare_remount_readonly() from the next patch
> could race with new mountpoint being added to the list and the check is
> thus still unreliable?

If sb_prepare_remount_readonly() is successfull, it sets
->s_readonly_remount, indicating that remounting is in progress, which
will cause mnt_want_write() to return -EROFS for any mount regardless
whether they were added before or after sb_prepare_remount_readonly().

So it doesn't matter if the clone or new mount races with remount.

The drawback of this approach is that transient EROFS errors may be
returned even if the filesystem remount fails for some reason and so the
filesystem will not become read-only.  But this, I think, is an
acceptable compromise.

>  Quickly checking the locking seems to confirm that
> since e.g. clone_mnt() does not hold s_umount semaphore (only
> namespace_sem?) and do_remount_sb() has it the other way around...

Yeah, and I think I came to the conclusion that that kind of exclusion
is not realistically doable.

Thanks,
Miklos

