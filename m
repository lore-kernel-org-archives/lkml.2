Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab2C1AWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:22:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab2C1AWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:22:40 -0400
Date: Tue, 27 Mar 2012 17:26:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-Id: <20120327172622.827fd6ab.akpm@linux-foundation.org>
In-Reply-To: <20120328001550.GA3077@redhat.com>
References: <20120313182220.GA11500@redhat.com>
	<20120327155149.d41a235b.akpm@linux-foundation.org>
	<20120328001550.GA3077@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012 20:15:50 -0400 Dave Jones <davej@redhat.com> wrote:

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
> 

/*
 * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
 * costly to service.  That is between allocation orders which should
 * coelesce naturally under reasonable reclaim pressure and those which
 * will not.
 */
#define PAGE_ALLOC_COSTLY_ORDER 3


Death to magic numbers :(
