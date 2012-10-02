Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2JBRsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:48:10 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:59513 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab2JBRsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:48:08 -0400
Date: Tue, 2 Oct 2012 11:47:59 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121002174759.GC23733@obsidianresearch.com>
References: <20120930232116.GC30637@obsidianresearch.com>
 <20121001153952.GB2100@linaro.org>
 <20121001160639.GA31620@obsidianresearch.com>
 <20121001175647.GD2100@linaro.org>
 <20121001183543.GC22342@obsidianresearch.com>
 <20121002102346.GB2108@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002102346.GB2108@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:23:46AM +0100, Dave Martin wrote:

> > Well, no, it boots ELFs, so it can boot anything, with any memory
> > layout. A 2nd stage loader would be required to boot standard kernels,
> > that loader would be an ELF with 1 section for the 2nd stage, 1
> > section for the zImage and 1 section for the initrd, with proper load
> > headers.
> 
> Don't you already have to treat Linux as a special case though?  How
> do you know where to load ATAGs, DT and/or initramfs, and how to
> initalise the registers?  None of that is part of any ELF specification,
> and would be inappropriate if you boot any non-linux images.

Experience with our PPC systems has been that linking the DTB into
vmlinux is the way to go - so we have a trivally small,
non-upstreamble change (for PPC and ARM) to put the DTB(s) in vmlinux
and capture the CPU registers values (entry call function arguments)
that are set from the bootloader. 

Some DTB fixup code (supported by the OF kernel routines) in vmlinux
edits the DTB chosen node to include the information from the
bootloader.

>From there any other DTB fixups (eg fetching a MAC address from I2C)
plus other register initializations are done in Linux (typically by
the upstream drivers, though not 100%), with the MMU on, with full
kernel services. This is a much easier development environment :)

All in all it is basically about 100 lines of code to do what I've
described in vmlinux. This is dramatically less code than would be
required if we tried to conform to the standard vmlinux boot protocol.

> As you observe, GNU ld behaviour in this area tends to be rather patchily
> specified, buggy or both.  That does argue in favour of reusing the
> same techniques already used for other arches, though.

It is good to know PHDRS seems to be working better now, maybe things
can migrate someday!

> A question does occur to me: do your changes work with XIP_KERNEL?
> I'm not very familiar with XIP_KERNEL myself, so I'm currently not
> clear on whether there's an impact here.

I looked at the XIP defines and they didn't seem to conflict. Since
this change only effects the values in the LOAD headers, not the
actual image I doubt it has any impact.

> Beyond this, I think the approach doesn't look unreasonable.

Great, should I do anything further to get this patch into mainline.
 
> You store vmlinux.gz in a cramfs?  Is that a typo, or have you already
> compressed the kernel twice?

The compression can either be intrisic to cramfs or a raw elf that has
been gzip'd.

Jason
