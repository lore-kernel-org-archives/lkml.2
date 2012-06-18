Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2FRVKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 17:10:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64893 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2FRVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 17:10:19 -0400
Date: Mon, 18 Jun 2012 17:10:15 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Michal Simek <monstr@monstr.eu>
cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Subject: Re: [RFC PATCH 7/8] ARM: vmlinux.lds: Setup physical load address
 not virtual
In-Reply-To: <4FDF804A.5080404@monstr.eu>
Message-ID: <alpine.LFD.2.02.1206181655410.23555@xanadu.home>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu> <1340019011-18642-8-git-send-email-monstr@monstr.eu> <alpine.LFD.2.02.1206181000540.23555@xanadu.home> <CAHTX3dJS9zNejv-oLGpbZdXdkJndwR1pcBd9yn3OAobGy3ZLjA@mail.gmail.com>
 <alpine.LFD.2.02.1206181433130.23555@xanadu.home> <4FDF804A.5080404@monstr.eu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Michal Simek wrote:

> On 06/18/2012 09:02 PM, Nicolas Pitre wrote:
> > On Mon, 18 Jun 2012, Michal Simek wrote:
> > 
> > > 2012/6/18 Nicolas Pitre<nicolas.pitre@linaro.org>
> > > 
> > > > On Mon, 18 Jun 2012, Michal Simek wrote:
> > > > 
> > > > > Setup correct virtual and physical address in ELF LOAD section.
> > > > 
> > > > We are moving to a single kernel binary for multiple targets, including
> > > > targets with different physical load addresses.  The kernel code figures
> > > > out at run time what the actual physical address is when
> > > > CONFIG_ARM_PATCH_PHYS_VIRT is set which is the default these days.  In
> > > > other words, we don't know the physical offset at build time in that
> > > > case and CONFIG_PHYS_OFFSET is simply not defined.
> > > > 
> > > 
> > > ok. good to know and nice features. In that case I expect that you are
> > > using any binary format and you copy it to memory and run it. Code
> > > find out where it runs and based on that setup things.
> > 
> > Exact.
> 
> ok. One more question about this feature. What is the alignment for 
> it? I mean I have done the similar feature for Xilinx ppc440 and 
> alignment depends on MMU TLB size.

Currently the alignment is 16MB as this is the granularity that a single 
add or sub instruction can cover with an immediate argument.  This is 
highly specific to the ARM instruction set.  At some point we needed 2MB 
alignment which required two adds or subs, but that requirement has now 
been removed.

> > If you want to use the ELF image, then you need to hardcode the physical
> > memory location in its header, and that's something we want to get away
> > from because it prevents a single kernel binary image from being used on
> > different targets with different memory layouts.  Same issue with
> > u-Boot's legacy uImage format.
> 
> And are you able to get these information away from ELF? Or you just 
> need to set it up to any default value. I would expect to 0x0.

We just don't use the ELF image format with bootloaders.

> > > I haven't played with CONFIG_ARM_PATCH_PHYS_VIRT option but what is elf
> > > entry point for this case?
> > 
> > For the kernel image itself it is the kernel virtual address.
> 
> Is it used somewhere? Or is it just setup to virtual address and no 
> code use it? I mean that kernel virtual entry point.

Nothing uses it.  The official ARM kernel image format is a binary image 
and its entry point is the very beginning of it.

> I expect that if CONFIG_ARM_PATCH_PHYS_VIRT=y then CONFIG_PHYS_OFFSET 
> is not setup Then LOAD_OFFSET should be equal to CONFIG_PAGE_OFFSET.

No. CONFIG_PAGE_OFFSET is the virtual address that the kernel uses for 
the beginning of its memory view.  That is not where the kernel is 
loaded.


Nicolas
