Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab0I3Vrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 17:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485Ab0I3Vrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:47:37 -0400
Date: Thu, 30 Sep 2010 17:47:16 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
        npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 23/34] union-mount: Prevent topmost file system from being mounted elsewhere
Message-ID: <20100930214716.GC490@shell>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com> <1284675145-4391-24-git-send-email-vaurora@redhat.com> <E1P1FaG-0001wr-Nn@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1P1FaG-0001wr-Nn@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:37:48AM +0200, Miklos Szeredi wrote:
> On Thu, 16 Sep 2010, Valerie Aurora wrote:
> > The device underlying the topmost read-write layer of a file system
> > cannot be mounted anywhere else on the system.  We keep a pointer to
> > the union stack in the dentry of the topmost directory, so that dentry
> > can't be part of a different mount, since dentries are shared between
> > different mounts of the same device.
> > 
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  fs/namespace.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index 61256e6..26efaf3 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -1998,6 +1998,11 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
> >  	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
> >  		goto unlock;
> >  
> > +	/* Top layers of union mounts can't be mounted elsewhere */
> > +	err = -EBUSY;
> > +	if (newmnt->mnt_sb->s_union_lower_mnts)
> > +		goto unlock;
> > +
> 
> This is insufficient: the super block may be mounted elsewhere later.
> And no, preventing bind mounts is not enough.

My mistake, that's a bug in the comment/commit message - s/mount/union
mount/.  The patch that prevents not-union mounts is:

    union-mount: Create check_topmost_union_mnt()
    
    check_topmost_union_mnt() checks that the topmost layer of a proposed
    union mount is read-write, supports fallthrus and whiteouts, and isn't
    mounted elsewhere.

And the patch that prevents bind mounts is:

    union-mount: Prevent bind mounts of union mounts
    
    Prevent bind mounts of parts of union mounts.
    
    XXX - Bind mounting parts of union mounts is probably easy to
    implement, but requires some careful thought about corner cases,
    extensive testing, and some refactoring of the code.

If you see any problems in those patches, I'd appreciate the comment.

> BTW, what about CLONE_NEWNS?  I think it's a rather big limitation if
> that doesn't work...

Great segue - I think the same code will make both CLONE_NEWNS and
bind mounts work.  We can allow multiple mounts of a union if it's the
exact same stack in each mount.  I will work on this.

-VAL
