Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1A0Fn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 00:43:56 -0500
Received: from relais.videotron.ca ([24.201.245.36]:33485 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1A0Fnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 00:43:55 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_IagkMlEi2Tgl5TRpDbbxWA)"
Date: Thu, 27 Jan 2011 00:43:54 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Sachin Verma <imschnvrm@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabin Vincent <rabin@rab.in>, Alexander Holler <holler@ahsoftware.de>,
        Dave Martin <dave.martin@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        catalin.marinas@arm.com
Subject: Re: ARM: relocation out of range (when loading a module)
In-reply-to: <AANLkTikLwTdV2B5Dyp_adCxgWcE-+Wb6uiN5MBfnA1_K@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1101270030220.8580@xanadu.home>
References: <4D2B4CE4.9080309@ahsoftware.de>
 <alpine.LFD.2.00.1101101722470.9794@xanadu.home>
 <4D2BFA08.5030104@ahsoftware.de>
 <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com>
 <20110111155930.GH11039@n2100.arm.linux.org.uk>
 <4D2D1942.4050905@ahsoftware.de>
 <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com>
 <alpine.LFD.2.00.1101121314470.25498@xanadu.home>
 <20110112184258.GH11039@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1101121350350.25498@xanadu.home>
 <AANLkTikLwTdV2B5Dyp_adCxgWcE-+Wb6uiN5MBfnA1_K@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_IagkMlEi2Tgl5TRpDbbxWA)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

On Tue, 25 Jan 2011, Sachin Verma wrote:

> Hello,
> 
> On Thu, Jan 13, 2011 at 12:25 AM, Nicolas Pitre
> <nicolas.pitre@linaro.org> wrote:
> > On Wed, 12 Jan 2011, Russell King - ARM Linux wrote:
> >
> >> As the overall feeling at the time was "don't use large initrds" it's
> >> something I've never really cared about - and I'm still of the opinion
> >> that 16MB of compressed initrd/initramfs is rather silly.
> >
> > It is... but we have more than 32MB of RAM total now, and people are
> > running standard distributions on ARM these days, such as Fedora or
> > Ubuntu, including their corresponding initrd that may contain lots of
> > modules, splashscreen data, etc.  So it might be a good idea to think
> > about fixing this limitation before it comes back again.
> >
> 
> in fact it is not just the initrd/initramfs size, i am facing issues
> with loading modules on MMU-less envt(Cortex M3).
> I have 128MB of Physical RAM and i am using a 4MB initrd to boot my
> system. when i try to load kernel modules i get relocation errors.
> As MMU-less systems are allowing modules to be loaded anywhere from
> RAM and not from any predefined limits of MODULES_VADDR and
> MODULES_END.
> 
> Do you have any pointers on how to tackle this situation for MMU less
> environments?

The MMU-less kernel should still favor allocations close to the kernel 
text for modules, and anything else away from the kernel going 
downwards.

Otherwise a veneer should be created by the module symbol resolver such 
that if the branch distance to reach, say, printk is too large, then the 
following code would have to be dynamically generated right next to the 
module:

	ldr	pc, [pc, #-4]
	.word	<far_away_symbol>

Then, in your module, you patch the branch relocation for printk so that 
it branches to the code above instead, and then store the address of 
printk at the location represented by the .word directive.


Nicolas

--Boundary_(ID_IagkMlEi2Tgl5TRpDbbxWA)--
