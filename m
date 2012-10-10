Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2JJEbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 00:31:51 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29769 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2JJEbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 00:31:48 -0400
From: Randy Wright <rwright@filesys1.fc.hp.com>
Message-Id: <201210100431.q9A4Vg6h005678@filesys1.fc.hp.com>
Subject: Re: [PATCH RFC] function probe_roms accessing improper addresses
To: mjg59@srcf.ucam.org (Matthew Garrett)
Date: Tue, 9 Oct 2012 22:31:42 -0600 (MDT)
Cc: rwright@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com (H. Peter Anvin), tmac@hp.com
Reply-To: rwright@hp.com
In-Reply-To: <20121004192256.GA6521@srcf.ucam.org> from "Matthew Garrett" at Oct 4, 2012 08:22:56 pm
Organization: Hewlett-Packard/Mission Critical Open Source Development Lab
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Date: Thu, 4 Oct 2012 20:22:56 +0100
> From: Matthew Garrett <mjg59@srcf.ucam.org>
> To: rwright@hp.com
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH RFC] function probe_roms accessing improper addresses
>  on UEFI systems
> Message-ID: <20121004192256.GA6521@srcf.ucam.org>
> References: <201210032353.q93NrkNi018443@filesys1.fc.hp.com>
> 
> On Wed, Oct 03, 2012 at 05:53:46PM -0600, Randy Wright wrote:
> 
> > The following proposed patch takes advantage of the fact that on EFI
> > systems, the memory map provides a better description of the physical
> > space than on pre-EFI legacy systems. If the efi_enabled state variable
> > indicates the kernel is running on an UEFI system, the patch will use
> > information from the UEFI memory map so as not to access addresses that
> > should avoided according to the UEFI specification.
> 
> This turns out to be awkward. Some (mostly older) EFI platforms still 
> only provide the video ROM through the 0xc0000 window, and that's 
> sometimes needed even if the platform isn't using int10 for anything 
> (for instance, some Intel graphics machines only provide the VBT through 
> the video ROM and don't provide that via the PCI BAR). And, of course, 
> they have an EFI memory map that just shows a hole there.
> 
> So we can't distinguish between the two cases easily. The only thing I 
> can think of would be to push that policy out to the graphics drivers 
> and have them trigger a scan only if they can't get the required 
> information from any other source. I suspect that this patch as is would 
> break graphics on a reasonable number of EFI platforms.
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

Hi Matthew, 

I appreciate your description of the problems with my approach, as well
as the reply from hpa@zytor.com (H. Peter Anvin) in response to my mention
of this patch in another thread.  His reply contained a couple of
suggestions that initially appeal to me more than an approach requiring
a change to a set of video drivers, the size of which I don't quite
know how to scope.  In that other thread, hpa said:

| One option would be to quirk it; obviously there is some piece of
| hardware which does cause this #MC and hopefully we could use that to
| detect that specific regions should be excluded; another option would be
| to trap the #MC during ROM probing.

I definitely see the appeal of trapping the #MC and triggering a
solution from that, if it can be made to work. I've spent some time
evaluating that, and I see these issues:

1. I don't believe the kernel's MC handler is initialized early enough
to handle a machine check occurring as early as probe_roms.  Probe_roms
is called very early in boot.  I see this as the call stack:
  start_kernel->setup_arch->probe_roms
Whereas the machine check initialization for x86 appears to come later:
  start_kernel->check_bugs->identify_boot_cpu->identify_cpu->mcheck_cpu_init
At present, I do not want to tackle such a major reordering of
intialization as would be required to change this.

2. For all platforms, is the setup of chipset and cpu address decoding
robust enough to allow the OS to handle the resulting machine check and
recover?  I've worked with some platforms in the past where this was not
always the case, the result being that for some unpopulated address
ranges, the resulting machine check would not be recoverable.

Because of the above difficulties with the MC handler idea, I have
focused my thoughts more on the quirk idea that hpa mentioned. I've been
investigating some existing examples in the kernel, and trying to
understand some of the issues involved with designing a new one.

1. Can the interface be chosen to present the needed interface to all callers? 
I recognize this as a challenge if a single interface is to be used both
in early boot (e.g. probe_roms) and later runtime (e.g.
devmem_is_allowed).  Something like a new member added to the
x86_platform_ops structure?

2. How can it automatically be activated for platforms that need it? I
see quite a few quirks selected by cpu id, but that's probably not
appropriate here.  Again, activating it by hitting the #MC in probe_roms
would be cool, but I see it as involving a major reordering of
initialization code.  So I'm left thinking about something in keying off
the dmi platform strings, which fortunately are initialized thusly:
  start_kernel->setup_arch->dmi_scan_machine
convenient, as it's just before probe_roms is called.

3. Can it be activated on demand for testing on other platforms? A
kernel boot command line parameter could be added, for example. How does
the community feel about adding more of those?

What are other design issues I'm overlooking?

Are there are existing quirks that strike you as particularly
good models for this case?  

--
Randy Wright            Hewlett-Packard Company
Phone: (970) 898-0998   Mail: rwright@hp.com
