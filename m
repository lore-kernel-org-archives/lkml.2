Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0IVPXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:23:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:53350 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab0IVPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:22:58 -0400
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
From: David Woodhouse <dwmw2@infradead.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
	 <20100920150431.GD31167@sirena.org.uk>
	 <20100920152726.68ac2d84@linux.intel.com>
	 <20100920152705.GJ3414@rakim.wolfsonmicro.main>
	 <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 16:22:13 +0100
Message-ID: <1285168933.4498.119.camel@i7.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.33.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 01:03 -0300, Grant Likely wrote:
> Shudder.
>
> Okay, before I start a long rant I'll start with this disclaimer; at
> least this patch is isolated to the mrst platform so that it doesn't
> impact the rest of the kernel.  Feel free to take the stance that this
> is platform specific code and therefore will never have to handle the
> general-case of multiple machines.  In that case each machine will
> need to have a separate copy of this functionality, but at least the
> damage is contained. </disclaim>
> 
> This will be an utter nightmare to maintain over the long term.  It
> combines the worst parts of both static device tables and firmware
> data parsers.  From the former it uses large statically allocated
> tables that cannot be either extended or freed at runtime which is
> unfriendly for multiplatform kernels.
> 
> From the latter it takes the approach of abstracting all the details
> of the firmware interface away from the device drivers which forces
> the abstraction layer to encode every possible permutation and
> combination of devices in a hunk of code that cannot be modularized
> and will become larger and larger for each new device that is
> supported.  The lesson was learned with OF that the device driver is
> the only place where it makes sense to decode device specific data
> (addresses and irqs can have common code decoders, but the binding
> name and extra data is device driver specific).  Trying to do it
> anywhere else is insanity.
> 
> That being said, there already is a defined method for passing in
> external data about the machine layout.  I'm certainly not keen on
> adding another.  It is already an uphill battle to convince device
> driver maintainers that adding device tree parsing code (appropriately
> contained) to .probe() hooks is the right thing to do.  Asking them to
> also support SFI hooks (plus the next firmware-interface-of-the-month)
> is likely to end in a revolt.
> 
> Both tglx and dwmw2 [cc'd] have stated that they they are in favor of
> standardizing on OF device tree for x86 embedded.  dwmw2 suggested
> translating data in other formats into the device tree during early
> boot so that existing OF routines can be used to parse the data by
> device drivers.  That would keep the support code in the device
> drivers where it belongs without creating new SFI-specific device
> infrastructure.  It also eliminates the statically allocated tables
> and board specific hacks.
> 
> Since data in the tree is free-form key-value properties, any
> device-specific SFI data can be imported into the tree verbatim to
> eliminate the risk that critical data will get discarded in the
> translation process.  Well understood properties, like address ranges,
> IRQs and GPIOs would be straight forward to translate into the device
> tree form to make it parsable by common code.

What Grant said.

This patch (and SFI in general) seems like entirely the wrong approach.
You're gratuitously reinventing the wheel, and your proposed replacement
isn't even round.

As Grant says, we already have a defined method for passing this kind of
information to the kernel. We have well-thought-out bindings for various
different types of devices -- which have been designed to ensure that
we're describing the *hardware* and not specifically tied to
implementation details in the current Linux driver setup.

It makes *no* sense to add probe support for your 'special' platform
devices to drivers which already have (or will need anyway) proper
device-tree support.

Seriously, just convert whatever crap you have into a device-tree at
early boot (or preferably in the bootloader, and *beat* the firmware
idiots until they provide it natively), and don't pollute the kernel any
more than you have to with this idiocy.

-- 
dwmw2

