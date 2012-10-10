Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2JJJzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:55:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38646 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2JJJzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:55:50 -0400
Date: Wed, 10 Oct 2012 10:55:44 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121010095544.GB2131@linaro.org>
References: <20121001175647.GD2100@linaro.org>
 <20121001183543.GC22342@obsidianresearch.com>
 <20121002102346.GB2108@linaro.org>
 <20121002174759.GC23733@obsidianresearch.com>
 <20121003104335.GA2254@linaro.org>
 <20121003184437.GB12231@obsidianresearch.com>
 <20121004113637.GA2117@linaro.org>
 <20121004175907.GB2994@obsidianresearch.com>
 <20121008104649.GD2302@linaro.org>
 <20121009182514.GF4124@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009182514.GF4124@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 12:25:14PM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 08, 2012 at 11:46:49AM +0100, Dave Martin wrote:
> 
> > > Yes, but we still need rely on complex code like I2C/MTD to create a
> > > correct DTB, which again puts us back to patching the kernel for that
> > > functionality.
> > 
> > I'm still confused as to where this complexity is coming from.
> > 
> > If you need to run some complex I2C and MTD code to generate the DT, what
> > is that code doing?  If it is probing to get the information, then can you
> > avoid putting the info in the DT at all?  Primarily the DT is to describe
> > those aspects of the hardware which can't be probed.
> 
> At manufacturing the unit is programmed with a small datastructure that
> contains all the unique ID's (MAC addresses, etc), manufacturing
> variations (ie vendor A or B was used for a socket) and other
> ancillary data.

As a side comment, some things such as MAC addresses can be probed and
set from userspace after kernel boot, assuming that you have a way
to fetch the device description blob from userspace.  If it's accessible
via MTD I'm guessing you may have some chance of doing that.

Identifying the board variant is harder to defer though.

> So a fair amount of I2C and MTD stack is required just to fetch this
> structure - a full CFI probe, for instance, is needed in the NOR flash
> case just to locate the structure.
> 
> Once read, things like MAC addresses are copied into the DTB, and
> certain sections of the DTB are NOP'd out - we have stanzas for chip
> vendor A and vendor B, the one that was not put on the board is
> replaced with NOP.
> 
> Similar to the A/B fix, a further fixup is done based on a runtime
> probe of the programmable devices to learn their current
> configuration/memory map.
> 
> It seems desirable to present a complete/correct DTB to the kernel,
> it doesn't seem there are great places to hook in custom discovery
> procedures.
> 
> From a maintenance perspective we already have to test/etc the kernel
> code for all of this, we don't want to do that twice by duplicating
> this stuff outside the kernel.

OK, that gives me a good understanding of what you're trying to achieve
here.

However, I worry that if you have to run hardware-dependent code in
order to fetch or generate parts of the DT, then we have a chicken-
and-egg problem with no guaranteed solution with the frameworks that
exist today -- although I am not familiar with how DT gets used on
all other arches, so you might have counterexamples I'm not aware of.

At least in ARM-land, the DT is inherently monolithic and static: the
DT is not expected to change once you enter the kernel.

Of course, more or less anything can be done with local patches, but
merging such functionality in a clean way might be a challenge.

> > Otherwise, you that have a few static configurations: you could have one
> > pre-baked DT per hardware platform, and choose the correct one once you
> > have detected the platform.
> 
> We do that too, for instance the PPC kernel we build supports 4
> different circuit boards, each served by a separate DTB, that needs a
> fixup pass.
> 
> I think the biggest DTB describes about 49 devices..
>   
> > > Where the 'dev tree provider' would use the stored bootloader
> > > registers and any other information to return the proper DTB. 
> > 
> > It would need developing a bit, but something like that might be
> > possible -- it should probably be discussed via devicetree-discuss.
> > 
> > If it is doing anything less trivial than picking a pre-baked DT, the
> > rationale would need to be carefully argued.
> 
> I'm not sure there is a great interest in this? What are other folks
> working on production embedded stuff doing? I suppose that will be
> more clear as device tree is rolled out.

For now, the architecturally simplest solution still seems to me to be
to write your own boot shim which customises the DT before booting the 
kernel. As discussed, this can continue to look like a simple ELF image
from the bootloader's point of view -- but I appreciate that it will
involve effort and some duplication of some low-level driver components.

If we could do dynamic DT properly (either fully dynamic, or dynamic
in a more constrained way as in your suggested patch), that would
provided an architected way to solve this problem from within the kernel.

This could certainly be worth raising on devicetree-discuss.

Your problem is unlikely to affect people outside the embedded space
too much, but it doesn't sound likely to be unique.

Cheers
---Dave
