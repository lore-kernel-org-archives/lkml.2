Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab2C1Ej4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 00:39:56 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6389 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804Ab2C1Ejz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 00:39:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJOVck95LEyG/2dsb2JhbAA/BrhngQiCCQEBBToNDzMIAxguFCUDIQESG4durAmOHBOKW4UuYwSVYIlQhl6Cew
Date: Wed, 28 Mar 2012 15:39:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-ID: <20120328043951.GA32741@dastard>
References: <20120313182220.GA11500@redhat.com>
 <20120327155149.d41a235b.akpm@linux-foundation.org>
 <20120328001550.GA3077@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328001550.GA3077@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 08:15:50PM -0400, Dave Jones wrote:
> On Tue, Mar 27, 2012 at 03:51:49PM -0700, Andrew Morton wrote:
>  > On Tue, 13 Mar 2012 14:22:20 -0400
>  > Dave Jones <davej@redhat.com> wrote:
>  > 
>  > > This size is user controllable, and so it's trivial for someone to trigger a
>  > > stream of order:4 page allocation errors.
>  > > 
>  > > Signed-off-by: Dave Jones <davej@redhat.com>
>  > > 
>  > > --- 
>  > > There's also a similar problem in setxattr, but I'm not sure how we want
>  > > to pass NOWARN down to memdup_user. Thoughts ?
>  > > 
>  > > diff --git a/fs/xattr.c b/fs/xattr.c
>  > > index 82f4337..544df90 100644
>  > > --- a/fs/xattr.c
>  > > +++ b/fs/xattr.c
>  > > @@ -496,7 +496,7 @@ listxattr(struct dentry *d, char __user *list, size_t size)
>  > >  	if (size) {
>  > >  		if (size > XATTR_LIST_MAX)
>  > >  			size = XATTR_LIST_MAX;
>  > > -		klist = kmalloc(size, GFP_KERNEL);
>  > > +		klist = kmalloc(size, __GFP_NOWARN | GFP_KERNEL);
>  > >  		if (!klist)
>  > >  			return -ENOMEM;
>  > >  	}
>  > 
>  > hm.  The patch is good, but one would hope that it isn't "trivial" to
>  > trigger a page allocation failure for a kmalloc(65536, GFP_KERNEL) -
>  > the VM is supposed to be able to handle that.
>  > 
>  > Is it really *that* easy, or is Something Unusual happening with that
>  > machine?
> 
> Well, the unusual thing was that I was fuzzing system calls for a few hours.
> 
> My fuzzing tool was able to trigger these very easily after an hour or two
> of uptime and memory had fragmented a little, so yeah, quite trivial.

We've recently been seeing reports of xfsdump trigging a similar
allocation failures in the XFS attr code when we are doing hundreds
of thousands of attribute lookups to back them up.

ad650f5 xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get

I think that falling back to vmalloc here is much better solution
than failing to retreive the attribute - it will work no matter how
fragmented memory gets. That means we don't get incomplete
backups occurring after days or months of uptime and successful
backups...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
