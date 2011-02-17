Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1BQDtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:49:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59827 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754254Ab1BQDtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 22:49:17 -0500
Date: Thu, 17 Feb 2011 03:49:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ryan@bluewatersys.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110217034914.GB5194@opensource.wolfsonmicro.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171112.07101.manningc2@actrix.gen.nz> <20110217014808.GD5824@sirena.org.uk> <201102171531.03924.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102171531.03924.manningc2@actrix.gen.nz>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 03:31:03PM +1300, Charles Manning wrote:
> On Thursday 17 February 2011 14:48:08 Mark Brown wrote:
> > On Thu, Feb 17, 2011 at 11:12:06AM +1300, Charles Manning wrote:

> > Even for embedded systems people do end up wanting to do things like
> > using the same kernel on multiple systems which may have different
> > hardware configurations (distros and reference boards are the obvious
> > examples, but I've worked on systems where multiple generations and
> > builds of the product were in active use and similar enough to be
> > maintained from the same kernel).  Even with single system kernels
> > there's still an issue with things like reference boards where users are
> > doing things like picking up a new upstream kernel rather than the
> > vendor BSP.

> Every one of the "stupid compile time options" is there because someone that 
> actually **uses** yaffs wanted it. None are there just for fun. The 

The fact that users have asked for something doesn't mean that the
particular implementation that was chosen to meet the need makes sense.
Having lots of compile time options is terribly common in many embedded
systems but that doesn't mean it's a good idea to do things this way.

> compile-time switches are very limited - mostly just there to set up default 
> runtime flags that can be overridden at runtime. Some of them are there to 
> work around bugs and limitations in the mtd.

If these are just setting overridable defaults then that sounds like
stuff that doesn't need to be in the kernel in the first place, they're
just as trivial to tweak in userspace as with in kernel defines..  For the
hardware workarounds having this in the kernel seems reasonable, we just
need to figure out a way to propagate it from the machine driver to the
filesystem.

> Even with BSPs, there will often be some board tuning to, do things like set 
> up the mtd partitions.

> Picking up an new kernel is easy, so long as the mtd code has not been broken 
> in the interum. 

You're missing the use case here - I'm talking about the situation where
you completely ignore the vendor BSP and go direct to mainline without
reference to the vendor provided stuff.  The user may not even have the
vendor provided BSP to look at.

> > I'm not sure exactly how you'd do this for a filesystem but this is
> > starting to sound a lot like platform data...  Though presumably if the
> > data isn't stored on the device currently it'd be a simple matter of
> > programming (if wasteful) to add it.

> NB flash file system - not file system! Working via mtd is different to 
> working via blocks.

I do have *some* familiarity with embedded systems.  The fact that the
device is a flash device doesn't stop you recording metadata on it -
obviously you've got some data on there to record the metadata for stuff
like directory layout.  If some of this is needed to even read the
device then it can't go on the device, but otherwise it could be
included somehow.

> Most of the required data is passed through mtd and you don't need any special 
> platform data beyond the nand setup in the board tuning file.

Plus the #define based configuration the code is currently doing;
clearly some additional configuration is required.  I rather suspect the
issue here arises from some combination of the cross platform stuff
resulting in things that are clearly not idiomatic for Linux and people
not being able to figure out how to propagate the data into Linux so
just bodging it with ifdefs.

This sort of stuff is really common when taking old code into mainline -
people do all sorts of things that aren't suitable for mainline, often
around configurability, and we really need to take a step back and
userstand what the underlying goal is and how to express it in an
idiomatic fashion.
