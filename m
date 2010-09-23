Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0IWGHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:07:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49580 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0IWGHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:07:06 -0400
Date: Thu, 23 Sep 2010 03:07:03 -0300
From: Grant Likely <grant.likely@secretlab.ca>
To: Alan Cox <alan@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923060703.GB11198@angua.secretlab.ca>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
 <20100920150431.GD31167@sirena.org.uk>
 <20100920152726.68ac2d84@linux.intel.com>
 <20100920152705.GJ3414@rakim.wolfsonmicro.main>
 <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
 <20100922231514.5e9967c7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922231514.5e9967c7@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 11:15:14PM +0100, Alan Cox wrote:
> > Okay, before I start a long rant I'll start with this disclaimer; at
> > least this patch is isolated to the mrst platform so that it doesn't
> > impact the rest of the kernel.  Feel free to take the stance that this
> > is platform specific code and therefore will never have to handle the
> > general-case of multiple machines.  In that case each machine will
> > need to have a separate copy of this functionality, but at least the
> > damage is contained. </disclaim>
> 
> Simple answer to this. It's intended that SFI will be used on certain
> Intel MID platforms. I am hopeful that something more sensible will
> happen with future firmware for future platforms but for existing MID
> platforms its not negotiable, we either support SFI or we don't run on
> them.
> 
> > This will be an utter nightmare to maintain over the long term.  It
> 
> Intel will be maintaining it. While I can't speak for Intel on the
> matter my personal way of seeing this is "our turd, our shovel" and its
> localised so there will be no funny smells elsewhere.
> 
> > combines the worst parts of both static device tables and firmware
> > data parsers.  From the former it uses large statically allocated
> > tables that cannot be either extended or freed at runtime which is
> > unfriendly for multiplatform kernels.
> 
> I know this. I've been managing it internally for a while. I have a
> deeper understanding than I want but the SFI side is fixed and better
> firmware design is a thing that you talk about now for products 'n'
> years down the line because of the way all the
> design/bringup/development for plaforms works.
> 
> In truth SFI is closer to being a device enumeration than a
> configuration description.
> 
> > adding another.  It is already an uphill battle to convince device
> > driver maintainers that adding device tree parsing code (appropriately
> > contained) to .probe() hooks is the right thing to do.  Asking them to
> > also support SFI hooks (plus the next firmware-interface-of-the-month)
> > is likely to end in a revolt.
> 
> You need to look at the code again. There is *no* SFI specific hookery
> in drivers. In fact I have been going around removing that from code as
> we submit drivers upstream  - and rightfully if I didn't the i??c
> maintainers and the like would reject the code.

Heh; impedance mismatch.  Let me clarify...

I'm in full agreement that SFI platforms exist now and must be
supported (firmware replacement is not an option).  I also understand
that this patch is fully contained withing the moorestown platform
code.  It is obvious that pains were taken to ensure zero impact on
existing device drivers (hence my original disclaimer).

My point is that an isolated translation layer becomes
(exponentially?) more difficult to maintain for each additional
platform that depends on it.  Support must be explicitly added for
every device that gets attached to a moorestown system in a way that
cannot be modularized and has the potential to become very large.

How to interpret device specific data, including interpreting the
binding name, really does belong in device driver.  The SFI data
should be exported to the driver where intelligent decisions can be
made.

I think we both agree that calling a new API from drivers for each and
every firmware interface is a path of madness.  Instead, I was
suggesting dumping the SFI data into device tree properties and using
the existing API with an SFI-specific namespace, however...

I just spent some time looking closer at what SFI is providing and
reading the spec.  Wow.  Okay, I take it all back.  I don't see how
any of this code could ever be made generic.  The spec seems to only
cover the data structure, and relationships between devices seem to be
left to whatever convention the firmware writer feels like using, or
am I missing something?

>From what I've seen tonight, dumping SFI data verbatim into a device
tree isn't an option because SFI doesn't naturally group device data.
I withdraw the suggestion.  So, I guess I agree.  There doesn't seem
to be any way around machine-specific SFI translation code, regardless
of whether it translates into direct registrations, or into a device
tree.


> If a driver wants device tree the SFI parser would ideally supply it
> with device tree. If the entire kernel goes device tree I will whoop
> with joy and make SFI use it.

:-)

> > Since data in the tree is free-form key-value properties, any
> > device-specific SFI data can be imported into the tree verbatim to
> > eliminate the risk that critical data will get discarded in the
> > translation process.  Well understood properties, like address ranges,
> > IRQs and GPIOs would be straight forward to translate into the device
> > tree form to make it parsable by common code.
> 
> In the idea world SFI would be replaced with a self describing
> expandable data format that translated neatly into whatever we needed,
> and the kernel drivers we are re-using would have corresponding
> interfaces. Lots of people understand this, but it simply won't happen
> for these existing SFI platforms.
> 
> In the real world they don't - yet, but if they do we'll be happy to
> join the revolution.
> 
> Alan
