Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2BQA1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:27:00 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49323 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab2BQA07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:26:59 -0500
X-Sasl-enc: b+Eb2FJEMgOypYWfKbZ9FYk/hn2p/ZLhwhWTLXkAwwvt 1329438418
Date: Thu, 16 Feb 2012 16:24:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: Add overflow protection to kref
Message-ID: <20120217002405.GB7746@kroah.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216204515.GH20420@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 12:45:15PM -0800, Kees Cook wrote:
> Hi,
> 
> [This should probably be discussed on LKML for an even wider audience, so
> I've added a CC for it there.]
> 
> On Thu, Feb 16, 2012 at 09:02:13AM -0500, David Windsor wrote:
> > Hi,
> > 
> > We are attempting to add various grsecurity/PAX features to upstream
> > Ubuntu kernels.
> 
> This didn't parse quite right for me. I think you meant that the intent
> is to get these features into the upstream Linux kernel, with potential
> staging in Ubuntu kernels.
> 
> (Also s/PAX/PaX/g)
> 
> > The PAX folks added refcount overflow protection by inserting
> > architecture-specific code in the increment paths of atomic_t.  For
> > instance:
> > 
> > static inline void atomic_inc(atomic_t *v)
> >  {
> > 	asm volatile(LOCK_PREFIX "incl %0\n"
> > 
> > #ifdef CONFIG_PAX_REFCOUNT
> > 		     "jno 0f\n"
> > 		     LOCK_PREFIX "decl %0\n"
> > 		     "int $4\n0:\n"
> > 		     _ASM_EXTABLE(0b, 0b)
> > #endif
> > 
> > 		     : "+m" (v->counter));
> > }
> > 
> > There are two distinct classes of users we need to consider here:
> > those who use atomic_t for reference counters and those who use
> > atomic_t for keeping track of statistics, like performance counters,
> > etc.; it makes little sense to overflow a performance counter, so we
> > shouldn't subject those users to the same protections as imposed on
> > actual reference counters.  The solution implemented by PAX is to
> > create a family of *_unchecked() functions and to patch
> > statistics-based users of atomic_t to use this interface.
> > 
> > PAX refcount overflow protection was developed before kref was
> > created.  I'd like to move overflow protection out of atomic_t and
> > into kref and gradually migrate atomic_t users to kref, leaving
> > atomic_t for those users who don't need overflow protection (e.g.
> > statistics-based counters).
> 
> For people new to this, can you give an overview of what attacks are foiled
> by adding overflow protection?
> 
> > I realize that there are many users of atomic_t needing overflow
> > protection, but the move to kref seems like the right thing to do in
> > this case.
> > 
> > Leaving the semantics of overflow detection aside for the moment, what
> > are everyone's thoughts on adding overflow protection to kref rather
> > than to atomic_t?
> 
> Why was kref introduced? Or rather, how is kref currently different from
> atomic_t?

a kref is to handle reference counting for an object, so you don't have
to constantly "roll your own" all the time using an atomic_t or
whatever.  It's the basis for the struct kobject and other object
reference counting structures in the kernel for a very long time now.

And in all that time, I've never seen an instance where you can overflow
the reference count, so I'm hard pressed to see how changing kref in
this manner will help anything at all.

So no, I don't recommend changing this logic at all in kref.

Now if there are instances in the kernel where a "raw" atomic_t is being
used for object reference counting, moving that to use 'struct kref'
would be gladly appreciated, but that's kind of outside the scope of
what you are attempting to do here.

sorry,

greg k-h
