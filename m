Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab2C2FgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:36:13 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:58149 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974Ab2C2FgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:36:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJLzc095LEyG/2dsb2JhbABFuQmBCIIJAQEFOhwjEAgDDgouFCUDIROICbpVE5EMBJVgiVCGXoJ7
Date: Thu, 29 Mar 2012 16:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dave Jones <davej@redhat.com>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-ID: <20120329053556.GM5091@dastard>
References: <20120313182220.GA11500@redhat.com>
 <20120327155149.d41a235b.akpm@linux-foundation.org>
 <20120328001550.GA3077@redhat.com>
 <20120328043951.GA32741@dastard>
 <20120328164720.d1aea752.akpm@linux-foundation.org>
 <20120329005442.GB16008@redhat.com>
 <20120328181023.274401d1.akpm@linux-foundation.org>
 <1332984523.30775.12.camel@joe2Laptop>
 <20120328184602.e6b11a37.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328184602.e6b11a37.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 06:46:02PM -0700, Andrew Morton wrote:
> On Wed, 28 Mar 2012 18:28:43 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > On Wed, 2012-03-28 at 18:10 -0700, Andrew Morton wrote:
> > > On Wed, 28 Mar 2012 20:54:42 -0400 Dave Jones <davej@redhat.com> wrote:
> > > >  > Yup.  How does the below look?
> > > > Don't see anything immediately wrong with it.
> > > > Any thoughts on what to do about the similar problem in setxattr ? (memdup_user)
> > []
> > > diff -puN fs/xattr.c~fs-xattrc-setxattr-improve-handling-of-allocation-failures fs/xattr.c
> > []
> > > @@ -334,13 +335,25 @@ setxattr(struct dentry *d, const char __
> > []
> > > +		kvalue = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> > > +		if (!kvalue) {
> > > +			vvalue = vmalloc(size);
> > []
> > > +	if (vvalue)
> > > +		vfree(vvalue);
> > > +	else
> > > +		kfree(kvalue);
> > >  	return error;
> > 
> > These patterns are pretty common, maybe create a standard helper?
> 
> Could.  There was some discussion last year and implementations were
> tossed around.
> 
> I'm a bit apprehensive - kernel code is supposed to be robust, and
> large allocations are not robust and vmalloc() is crappy.  Formalising
> these things in an API probably won't make anything worse, but will
> deprive us of opportunities for ritualistic humiliation and
> knuckle-rapping.

I did a sweep of this recently, considering helpers for exactly such
an allocation and replacing the existing per-filesystem wrappers for
it. IIRC, there are wrappper functions in ext4, gfs2, and ntfs, XFS
now open codes it in a couple of places, there's alloc_fdmem(), cgroup
pidlists and the network code does it in several places, etc. 
Even some drivers are doing this.  It's a widespread pattern.

The easiest way to find the trivial wrappers is to grep for
is_vmalloc_addr, because all the wrapper functions use this code to
determine what to do:

	if (is_vmalloc_addr(p))
		vfree(p)
	else
		kfree(p)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
