Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab2JLVYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:24:15 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:48687 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab2JLVYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:24:13 -0400
Date: Fri, 12 Oct 2012 15:24:06 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121012212406.GN4124@obsidianresearch.com>
References: <20121001183543.GC22342@obsidianresearch.com>
 <20121002102346.GB2108@linaro.org>
 <20121002174759.GC23733@obsidianresearch.com>
 <20121003104335.GA2254@linaro.org>
 <20121003184437.GB12231@obsidianresearch.com>
 <20121004113637.GA2117@linaro.org>
 <20121004175907.GB2994@obsidianresearch.com>
 <20121008104649.GD2302@linaro.org>
 <20121009182514.GF4124@obsidianresearch.com>
 <20121010095544.GB2131@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010095544.GB2131@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 10:55:44AM +0100, Dave Martin wrote:

> As a side comment, some things such as MAC addresses can be probed and
> set from userspace after kernel boot, assuming that you have a way
> to fetch the device description blob from userspace.  If it's accessible
> via MTD I'm guessing you may have some chance of doing that.

Yes, there is a whole wack of other data in this structure (serial
numbers, etc) that are captured and used by userspace, so access is
always made possible.

Setting the MAC via userspace is interesting, I will bear that in
mind. However, we have several development-support boot scenarios that
enable the ethernet before the userspace code to fetch the data
structure is loaded - one of interest has the kernel's initramfs
perform a NBD mount of the actual application filesystem. So having
the kernel tend to this is very convenient.
 
> However, I worry that if you have to run hardware-dependent code in
> order to fetch or generate parts of the DT, then we have a chicken-
> and-egg problem with no guaranteed solution with the frameworks that
> exist today -- although I am not familiar with how DT gets used on
> all other arches, so you might have counterexamples I'm not aware of.

Certainly, in some cases, (like what I have done) such kernels are
non-generic and could only work with the hardware they are intended
for.

However, if you assume the bootloader provides a dtb (even an
incomplete one would do) then fixups/replacements/whatever could be
run based on tags in the dtb without creating a chicken-and-egg
problem.

> At least in ARM-land, the DT is inherently monolithic and static: the
> DT is not expected to change once you enter the kernel.

Sort of, it is the same on all arches, the DT block is expected to
remain valid, but all the of_node pointers go directly into the block
so you can alter values but not the structure without breaking any
invariants. As an example our DTBs all have mac address blocks, with a
0 value. The fixup simply overwrites with the correct value before the
ethernet driver reads from it.

> > I'm not sure there is a great interest in this? What are other folks
> > working on production embedded stuff doing? I suppose that will be
> > more clear as device tree is rolled out.
> 
> For now, the architecturally simplest solution still seems to me to be
> to write your own boot shim which customises the DT before booting the 
> kernel. As discussed, this can continue to look like a simple ELF image
> from the bootloader's point of view -- but I appreciate that it will
> involve effort and some duplication of some low-level driver components.

I admit, I am a bit conflicted. Viewing from the kernel perspective, I
definitely think this kind of very low level extremely board specific
stuff should not be in the kernel. That could be a maintenance
nightmare. However, as an OEM, I need the smallest, simplest boot
loader possible so I want to push this into the kernel to lighten my
development load.

> Your problem is unlikely to affect people outside the embedded space
> too much, but it doesn't sound likely to be unique.

Agreed..

This thread has left the original topic, what do you think I should do
with the linker patch?

Jason
