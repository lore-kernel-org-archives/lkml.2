Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0IQEeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 00:34:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35597 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0IQEeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 00:34:08 -0400
Date: Thu, 16 Sep 2010 21:34:01 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Ram Pai <ram.n.pai@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/34] VFS: Add CL_NO_SLAVE flag to
 clone_mnt()/copy_tree()
Message-ID: <20100917043401.GD8926@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
 <1284675145-4391-4-git-send-email-vaurora@redhat.com>
 <AANLkTim1bbGrrPcFHThx3XOm8GmudQFSmFUs3NAXT5yC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim1bbGrrPcFHThx3XOm8GmudQFSmFUs3NAXT5yC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 05:09:58PM -0700, Ram Pai wrote:
> On Thu, Sep 16, 2010 at 3:11 PM, Valerie Aurora <vaurora@redhat.com> wrote:
> 
> > Passing the CL_NO_SLAVE flag to clone_mnt() causes the clone
> > to fail if the source mnt is a slave.
> >
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  fs/namespace.c |    3 +++
> >  fs/pnode.h     |    1 +
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index eeb4c22..6956062 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -565,6 +565,9 @@ static struct vfsmount *clone_mnt(struct vfsmount *old,
> > struct dentry *root,
> >        if ((flag & CL_NO_SHARED) && (IS_MNT_SHARED(old)))
> >                return ERR_PTR(-EINVAL);
> >
> > +       if ((flag & CL_NO_SLAVE) && (IS_MNT_SLAVE(old)))
> > +               return ERR_PTR(-EINVAL);
> > +
> >
> 
> 
> its been a while and my memory may have corroded.  But I dont think this
> check is needed. Because cloning a 'slave mount' makes the mount a 'private
> mount' and not a 'slave mount'.

There is one case where a 'slave mount' when cloned can generate a 'slave mount', and
that is when the 'slave mount' is also a 'shared mount'. So the above check has to
be

       if ((flag & CL_NO_SLAVE) && (IS_MNT_SLAVE(old) && IS_MNT_SHARED(old)))
               return ERR_PTR(-EINVAL);

RP
