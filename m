Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab2C2BmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:42:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab2C2BmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:42:15 -0400
Date: Wed, 28 Mar 2012 18:46:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-Id: <20120328184602.e6b11a37.akpm@linux-foundation.org>
In-Reply-To: <1332984523.30775.12.camel@joe2Laptop>
References: <20120313182220.GA11500@redhat.com>
	<20120327155149.d41a235b.akpm@linux-foundation.org>
	<20120328001550.GA3077@redhat.com>
	<20120328043951.GA32741@dastard>
	<20120328164720.d1aea752.akpm@linux-foundation.org>
	<20120329005442.GB16008@redhat.com>
	<20120328181023.274401d1.akpm@linux-foundation.org>
	<1332984523.30775.12.camel@joe2Laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 18:28:43 -0700 Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-03-28 at 18:10 -0700, Andrew Morton wrote:
> > On Wed, 28 Mar 2012 20:54:42 -0400 Dave Jones <davej@redhat.com> wrote:
> > >  > Yup.  How does the below look?
> > > Don't see anything immediately wrong with it.
> > > Any thoughts on what to do about the similar problem in setxattr ? (memdup_user)
> []
> > diff -puN fs/xattr.c~fs-xattrc-setxattr-improve-handling-of-allocation-failures fs/xattr.c
> []
> > @@ -334,13 +335,25 @@ setxattr(struct dentry *d, const char __
> []
> > +		kvalue = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> > +		if (!kvalue) {
> > +			vvalue = vmalloc(size);
> []
> > +	if (vvalue)
> > +		vfree(vvalue);
> > +	else
> > +		kfree(kvalue);
> >  	return error;
> 
> These patterns are pretty common, maybe create a standard helper?

Could.  There was some discussion last year and implementations were
tossed around.

I'm a bit apprehensive - kernel code is supposed to be robust, and
large allocations are not robust and vmalloc() is crappy.  Formalising
these things in an API probably won't make anything worse, but will
deprive us of opportunities for ritualistic humiliation and
knuckle-rapping.
