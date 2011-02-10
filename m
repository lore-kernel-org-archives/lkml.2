Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab1BJPog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 10:44:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54681 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1BJPof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 10:44:35 -0500
Date: Thu, 10 Feb 2011 15:43:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Sachin Verma <imschnvrm@gmail.com>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>,
        Dave Martin <dave.martin@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        catalin.marinas@arm.com
Subject: Re: ARM: relocation out of range (when loading a module)
Message-ID: <20110210154322.GE1742@n2100.arm.linux.org.uk>
References: <4D2BFA08.5030104@ahsoftware.de> <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com> <20110111155930.GH11039@n2100.arm.linux.org.uk> <4D2D1942.4050905@ahsoftware.de> <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com> <alpine.LFD.2.00.1101121314470.25498@xanadu.home> <20110112184258.GH11039@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1101121350350.25498@xanadu.home> <AANLkTikLwTdV2B5Dyp_adCxgWcE-+Wb6uiN5MBfnA1_K@mail.gmail.com> <alpine.LFD.2.00.1101270030220.8580@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101270030220.8580@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 12:43:54AM -0500, Nicolas Pitre wrote:
> The MMU-less kernel should still favor allocations close to the kernel 
> text for modules, and anything else away from the kernel going 
> downwards.
> 
> Otherwise a veneer should be created by the module symbol resolver such 
> that if the branch distance to reach, say, printk is too large, then the 
> following code would have to be dynamically generated right next to the 
> module:
> 
> 	ldr	pc, [pc, #-4]
> 	.word	<far_away_symbol>
> 
> Then, in your module, you patch the branch relocation for printk so that 
> it branches to the code above instead, and then store the address of 
> printk at the location represented by the .word directive.

What you're suggesting is what we used to do with the old user-space
module tools, which would've been nice to carry forwards to the new
module code.  I never found a way to do it.

The problems:
1. Where do you create those veneers?
2. How many veneers do you allocate space for?
3. How do you determine that you need a veneer?

While you can say "next to the module" for (1), you can only do that at
the point in time when the space for the module is allocated, and you
need to know at that point how much space you require.

For (2), you could always allocate space for one veneer per symbol present
in the module, but that's very wasteful.

(3) is almost impossible to know ahead of time as you don't have the
relocations, realistically you have to allocate one veneer per symbol,
and as you don't know whether it's a data or code symbol, you'll have
to allocate one veneer for every symbol in a module.

I really don't like it, and I don't see that this is sanely solvable
without giving architectures much more control over module loading,
which I don't think will ever happen.  It's probably simpler to build
modules with whatever that magic option is to tell GCC to always generate
'far call' veneers for everything rather than trying to 'fix' the kernel
module loader.
