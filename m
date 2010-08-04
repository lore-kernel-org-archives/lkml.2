Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0HDWAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:00:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab0HDWAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:00:04 -0400
Date: Wed, 4 Aug 2010 17:59:43 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/38] union-mount: Support for mounting union mount file systems
Message-ID: <20100804215943.GA29353@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-22-git-send-email-vaurora@redhat.com> <20100713044701.GF3949@zeus.themaw.net> <20100716210226.GD21201@shell> <1279595537.2979.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279595537.2979.10.camel@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 11:12:17AM +0800, Ian Kent wrote:
> On Fri, 2010-07-16 at 17:02 -0400, Valerie Aurora wrote:
> > On Tue, Jul 13, 2010 at 12:47:02PM +0800, Ian Kent wrote:
> > > On Tue, Jun 15, 2010 at 11:39:51AM -0700, Valerie Aurora wrote:
> > > > +
> > > > +static int
> > > > +check_mnt_union(struct path *mntpnt, struct vfsmount *topmost_mnt, int mnt_flags)
> > > > +{
> > > > +	struct vfsmount *lower_mnt = mntpnt->mnt;
> > > > +
> > > > +	if (!(mnt_flags & MNT_UNION))
> > > > +		return 0;
> > > > +
> > > > +#ifndef CONFIG_UNION_MOUNT
> > > > +	return -EINVAL;
> > > > +#endif
> > > > +	if (!(lower_mnt->mnt_sb->s_flags & MS_RDONLY))
> > > > +		return -EBUSY;
> > > > +
> > > > +	if (!list_empty(&lower_mnt->mnt_mounts))
> > > > +		return -EBUSY;
> > > > +
> > > > +	if (!IS_ROOT(mntpnt->dentry))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (mnt_flags & MNT_READONLY)
> > > > +		return -EROFS;
> > > > +
> > > > +	if (!(topmost_mnt->mnt_sb->s_flags & MS_WHITEOUT))
> > > > +		return -EINVAL;
> > > > +
> > > 
> > > Is there a need to check fallthru, umm ... that probably doesn't
> > > apply for the ROOT(), right?
> > 
> > Actually, that's on my todo list - right now I'm assuming MS_WHITEOUT
> > implies fallthru support as well.  But it doesn't.
> > 
> > We're a little short on MS_* flags.  I'm thinking of just checking
> > ->whiteout and ->fallthru for non-NULL on the root dir and getting rid
> > of MS_WHITEOUT entirely.  Thoughts?
> 
> Checking for the methods is a good idea I think, since they are assumed
> to be present by the code, at least in some places.
> 
> Although it shouldn't happen, it is possible for a file system to create
> the root dentry with these methods defined but other dentrys without
> them defined, so a file system implementation error could cause some
> unpleasant crashes. Maybe requiring the flags to indicate support would
> help avoid unpleasant implementation problems like this, not sure
> really. 
> 
> Also not sure if a method existence check should always be made prior to
> use, regardless.

I went for MS_WHITEOUT and MS_FALLTHRU, and added the checks for the
ops being non-null.

-VAL
