Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0IIFWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 01:22:37 -0400
Received: from kroah.org ([198.145.64.141]:35802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab0IIFWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 01:22:22 -0400
Date: Wed, 8 Sep 2010 20:51:33 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, kconfig and hal fixes
Message-ID: <20100909035133.GD3723@kroah.com>
References: <5BFACB1451C1459BA8562A5561D0A4E6@stanford.edu> <1283386101.17399.10.camel@odc-laptop> <1283467434.4378.11.camel@odc-laptop> <1283887330.7250.6.camel@odc-laptop> <20100907235704.GC12823@kroah.com> <04CAA605B7EE4630B1EB550AAAD0B746@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04CAA605B7EE4630B1EB550AAAD0B746@stanford.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 01:56:09PM -0700, David Cross wrote:
> 
> From: Greg KH [mailto:greg@kroah.com] 
> 
> On Tue, Sep 07, 2010 at 12:22:10PM -0700, David Cross wrote:
> 
> > First off, what's with the "Re:" of the Subject?  What are you
> > responding to here?
> I will removed that going forward when submitting patches, it does seem
> appropriate on this response, so am leaving it in.

Yes, of course it is correct here :)

> > > This patch contains the kconfig changes necessary to fix build errors
> > > that could come up in the linux-next version. It also includes an
> > > additional HAL layer for the west bridge CRAM interface.
> 
> > Again, one patch per change, please break this up.
> 
> Can I break it up as 1) moving PNAND HAL layer + Kconfig changes and

Wait, look, you had a "and" in there.  Why?

Why not just do:
	- move PNAND HAL layer
	- Kconfig changes
as individual patches.

Each one does only one thing.  Again, please try to remember that.

> 2) CRAM HAL layer inclusion or is this still too tightly coupled? The
> issue that I am having is that I was working on these drivers while
> waiting on inclusion in the staging area in order to incorporate all
> of the feedback I have gotten so far. As such, I now either have to
> artificially break up the patches or start with a clean kernel and
> start sequentially hand coding them again. I think this latter might
> be what you want, but this is really time-consuming to do at this
> point. 

Well, it shouldn't take all that long of time, as you know what you want
to accomplish.  It's also how kernel development works, you usually go
off and do a bunch of work, then step back and figure out how to break
it up into logical chunks to submit it.  Everyone does it.  After time
you will get used to doing things in logical steps so you don't have to
redo things, but that takes a bit of time.

> While I definitely understand the need for this type of review of patches
> for changes to the kernel itself, it is hard for me to understand why the
> same rigor needs to apply to this driver in the staging area.

There is no difference here for what type of patches I can accept in the
staging area.  Staging is for code that doesn't meet the "normal"
acceptance guidelines, but that does not mean that the proper
development process does not also apply here at all.  It's a matter of
both cleaning up the code, and cleaning up the developers who are
working on the code at the same time :)

> As you gmentioned, it needs a lot of work to meet the standards for
> acceptance. I have done a fair amount of work to move it closer. Do I
> really need to undo and repeat all of that in order to clean up
> "BROKEN" code in the staging area of the linux-next tree? 

It's marked "BROKEN" because it breaks the build.  Once that is fixed we
can remove that marking, that's the only thing keeping it that way.

> > > The inclusion
> > > of this interface support did require the reorganization of some of the
> > > existing code, which is part of the reason for the size of the patch.
> > > Moving files and directories makes this patch seem larger than it really
> > > is.
> 
> > If you use git you can send a patch that properly shows only what
> > changes even if the file is moved.  Care to do that?
> 
> I have not used git so far, other than to pull from repositories. I probably
> could, but it will take me some time to learn. Is this "nice to have" or do
> I need to do it to get this patch applied?

What are you using to develop your patches?  If you don't use git, you
can use quilt, or some other type of patch management system.  But it
might be worth spending a few hours to get up and running on one of them
as this is going to be something you use a lot in the future, and it
will help you get work done much faster and be able to work with the
rest of the community better as well.

Trust me, taking the time to learn git is worth it in the end.

> > > The Kconfig changes are closely related to the inclusion of the CRAM
> > > HAL layer, and as such this patch is difficult to logically separate. 
> 
> > Why is it necessary?
> 
> The HAL layer in general or this specific HAL layer?

Any HAL layer.

> One of the reasons for needing memory interface options is the
> allocation of pins on a given platform. For example, if CLE was used
> as a GPIO for some other purpose, it is nice to have the option to
> move to an SRAM like interface. Also, I needed to develop this for
> unrelated reasons. As such, making minor structural changes such that
> new HALs could be easily incorporated in an intuitive manner seemed to
> be a plus. I also hoped that it would make the structure and rationale
> behind the initial driver structure more intuitive to the kernel
> maintainers.

Note that almost no other driver in the kernel needs such a layer.  What
you do is have a "backend" that talks to either GPIO or SRAM or
something else.  Then, at runtime, you can pick the one you need/want
depending on the hardware the code is running on, and everything "just
works".

Remember, the goal is to be able to build your driver once for any
platform it might run on.  Don't rely on Kconfig options to select the
hardware types, that's not the correct way to do things in the end at
all.

> > > The linux-next tree does not seem to have a config for the zoom2, and
> > > trying to build it for that board seems to make the compilation break.
> 
> > Why should the driver care about which arch it is built for?  It should
> > build on _all_ arches, right?
> 
> It should build on all architectures that have an appropriate HAL
> implemented. Otherwise, if you don't have a method for low level
> communication with west bridge, why would you want to build the driver?

Testing that the build isn't broken?  Building one image to run on lots
of different platforms?  Distros really need this and there is a large
unification effort for ARM to get this to work for that platform right
now.  PPC has done this a lot already as well.

Hope this helps,

greg k-h
