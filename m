Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2DSLtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:49:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab2DSLtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:49:06 -0400
Date: Thu, 19 Apr 2012 13:49:01 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Karel Zak <kzak@redhat.com>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        mbroz@redhat.com, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fs: print warning when mount flags was ignored
In-Reply-To: <20120419102857.GA13436@x2.net.home>
Message-ID: <alpine.LFD.2.00.1204191253490.21613@dhcp-27-109.brq.redhat.com>
References: <1334826475-11606-1-git-send-email-lczerner@redhat.com> <20120419102857.GA13436@x2.net.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012, Karel Zak wrote:

> On Thu, Apr 19, 2012 at 11:07:55AM +0200, Lukas Czerner wrote:
> > Some mount flags can conflict with each other so they can not be
> > handled together. Currently when conflicting flags are specified,
> > some of them are silently ignored putting user in believe that
> > they was handled correctly.
> 
> Unfortunately, it's not so simple ;-)
> 
> > -	if (flags & MS_REMOUNT)
> > +	if (flags & MS_REMOUNT) {
> >  		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
> >  				    data_page);
> > -	else if (flags & MS_BIND)
> > +		flags &= ~MS_REMOUNT;
> 
> This is incorrect, the flags may also include many others flags. For
> example MS_REMOUNT|MS_BIND|MS_RDONLY is valid (see do_remoun() code).

ah, right we can specify more flags to be consumed by do_remount and
others. Well, then we can just mask them all out like this:

	flags &= ~(MS_REMOUNT | MS_BIND );

> 
> And it's normal that for "mount -o remount" the mount command reads
> flags from mtab/fstab so it includes for example MS_RELATIME, ...

Yes, but MS_RELATIME is masked out from flags and it is used in
mnt_flags which are handled by remount. That makes me wonder why we even
have MS_RELATIME flag, since it is not used anywhere.

> 
> > +	} else if (flags & MS_BIND) {
> >  		retval = do_loopback(&path, dev_name, flags & MS_REC);
> > -	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
> > +		flags &= ~MS_BIND;
> 
>  what about MS_REC ?

Ok, we should put MS_REC into the mix since the do_remount does not use
it.

	flags &= ~(MS_BIND | MS_REC);

> 
> > +	} else if (flags & (MS_SHARED | MS_PRIVATE |
> > +			    MS_SLAVE | MS_UNBINDABLE)) {
> >  		retval = do_change_type(&path, flags);
> > -	else if (flags & MS_MOVE)
> > +		flags &= ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE);
> 
>  what about MS_REC ?

	flags &= ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE |
		   MS_REC);
> 
>  Note that do_change_type() already checks for unexpected flags and
>  returns -EINVAL if more flags are specified.

I am not sure how this is related. Each of those function should
probably do that but do_change_type() is actually the only one
doing so.

> 
> > +	} else if (flags & MS_MOVE) {
> >  		retval = do_move_mount(&path, dev_name);
> > -	else
> > +		flags &= ~MS_MOVE;
> > +	} else
> >  		retval = do_new_mount(&path, type_page, flags, mnt_flags,
> >  				      dev_name, data_page);
> > +
> > +	flags &= (MS_REMOUNT | MS_BIND | MS_SHARED | MS_PRIVATE |
> > +		  MS_SLAVE | MS_UNBINDABLE | MS_MOVE);

	flags &= (MS_REMOUNT | MS_BIND | MS_SHARED | MS_PRIVATE |
		  MS_SLAVE | MS_UNBINDABLE | MS_MOVE | MS_REC);

> > +
> > +	if (!retval && flags)
> > +		printk(KERN_WARNING "%s(%u): (%s -> %s) Conflicting mount flags"
> > +				    " specified. These flags has been "
> > +				    "ignored: %#.8lx\n", __func__, current->pid,
> > +				    dev_name, dir_name, flags);

But then, we'll might ignoring mnt_flags silently since they are masked
out earlier. Well, maybe we could mas them out only do_remount() and
do_new_mount().

>     Karel

Thanks!
-Lukas
