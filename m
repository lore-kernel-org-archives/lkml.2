Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab0GPVC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 17:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771Ab0GPVC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 17:02:57 -0400
Date: Fri, 16 Jul 2010 17:02:27 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/38] union-mount: Support for mounting union mount file systems
Message-ID: <20100716210226.GD21201@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-22-git-send-email-vaurora@redhat.com> <20100713044701.GF3949@zeus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713044701.GF3949@zeus.themaw.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:47:02PM +0800, Ian Kent wrote:
> On Tue, Jun 15, 2010 at 11:39:51AM -0700, Valerie Aurora wrote:
> > +
> > +static int
> > +check_mnt_union(struct path *mntpnt, struct vfsmount *topmost_mnt, int mnt_flags)
> > +{
> > +	struct vfsmount *lower_mnt = mntpnt->mnt;
> > +
> > +	if (!(mnt_flags & MNT_UNION))
> > +		return 0;
> > +
> > +#ifndef CONFIG_UNION_MOUNT
> > +	return -EINVAL;
> > +#endif
> > +	if (!(lower_mnt->mnt_sb->s_flags & MS_RDONLY))
> > +		return -EBUSY;
> > +
> > +	if (!list_empty(&lower_mnt->mnt_mounts))
> > +		return -EBUSY;
> > +
> > +	if (!IS_ROOT(mntpnt->dentry))
> > +		return -EINVAL;
> > +
> > +	if (mnt_flags & MNT_READONLY)
> > +		return -EROFS;
> > +
> > +	if (!(topmost_mnt->mnt_sb->s_flags & MS_WHITEOUT))
> > +		return -EINVAL;
> > +
> 
> Is there a need to check fallthru, umm ... that probably doesn't
> apply for the ROOT(), right?

Actually, that's on my todo list - right now I'm assuming MS_WHITEOUT
implies fallthru support as well.  But it doesn't.

We're a little short on MS_* flags.  I'm thinking of just checking
->whiteout and ->fallthru for non-NULL on the root dir and getting rid
of MS_WHITEOUT entirely.  Thoughts?

-VAL
