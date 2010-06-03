Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab0FCOx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:53:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755627Ab0FCOxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:53:55 -0400
Date: Thu, 3 Jun 2010 07:48:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk@arm.linux.org.uk>
cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-Reply-To: <20100603074548.GA12104@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Continuation on the "ARM MSM updates" thread ]

On Thu, 3 Jun 2010, Russell King wrote:
>
> It'd be nice if you'd copy me...

Yeah, the thread started out as a "I got really bored with lots of msm 
patches", and then just expanded into what I think is wrong with the 
sub-architectures. 

> On the defconfig files, you may not like them - I don't like the
> proliferation of them either.  What I've always wanted to see is
> one defconfig per class of machines - in other words, one mach-XXX.

I can understand that, but at the same time, I do think that the 
"defconfig" file concept as it is now is just broken. To the point of 
being unfixable. It's obviously just a copy of the final .config, and it's 
fundamentally not really readable (and especially not writable) by humans.

And that all actually made some sense way-back-when, back when it was 
originally done - back when our config files were tiny (compared to what 
they are now), and when it ended up being the default input for the 
config. It just doesn't make much sense any more. The Kconfig files 
themselves end up having defaults for the core things, and the non-core 
things are too many to list/edit sanely in that format.

So the original reason I want to remove them is that they are very 
annoying, but the reasoning that then takes that annoyance and makes me 
think seriously about removing them despite the inevitable pain factor is 
that I really don't think we can even use the concept for any better 
model.

Anything better would _have_ to be totally different. And no, I don't 
think your "diffs against a base" model work either, because while it 
would make them smaller, it would still make them basically unreadable and 
uneditable by any human, which means that it's not something we should 
check in - it's a generated file!

And I do think our kernel configurator language already should basically 
have the expressive power to do it *sanely*. We already support including 
other files, which is a requirement for any hierarchical model.

So I _think_ whatever "mach-xyz" file _should_ do something like

	# Kconfig file for OMAP4ABCXYZ chip

	.. set the particulars for this _particular_ chip,
	   ie select the particular drivers on this chip ..

	include "chip-family-details" (ie maybe "base OMAP details")

	include "architecture-family-details" (ie ARM Kconfig)

see? Not one flat file, and very much not something generated.

And I actually suspect we could do it with our current Kconfig file model. 
IOW, in the arch/arm/Kconfig file, I think it should be doable to have 
basically a

	choice
		prompt "ARM platform"

	config ARM_PLATFORM_OMAP
		bool PLATFORM_OMAP

	config ARM_PLATFORM_MSM
		bool PLATFORM_MSM
	...
	endchoice

	if ARK_PLATFORM_OMAP
	 include "Kconfig.omap"	# this will further have choices for OMAP versions
	elif ARM_PLATFORM_...

and then the individual "Kconfig.platform" files could select certain 
options, and then do a "include Kconfig.cpu" which would actually be the 
_current_ top-level arch/arm/Kconfig.

Or something. See? Making it hierarchical (so that each individual 
Kconfig.xyz file only handles a certain level of detail, and it doesn't 
grow unboundedly) and making it fundamentally human readable/writable 
would be a really good thing.

NOTE NOTE NOTE! I'm not at all saying it has to be done like the above 
with the current Kconfig language. The above is more of a "this is how we 
_could_ do it, and it would be a big conceptual improvement". 

And I don't think we can get there from here unless I at some point say "I 
just removed the xyz_defconfig files", at which point people will curse me 
and stumble about until they actually come up with something better.

Of course, if the ARM people do something proactive like the above 
_before_ I remove the defconfig files, I won't complain.

		Linus
