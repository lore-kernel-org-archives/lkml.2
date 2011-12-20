Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab1LTBxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:53:31 -0500
Received: from slb-smtpout-01.boeing.com ([130.76.64.48]:53398 "EHLO
	slb-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1LTBx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:53:27 -0500
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 19 Dec 2011 19:53:06 -0600
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Thread-Topic: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Thread-Index: Acy+uh+7s6OcvbsgQmKt60qbHHX5ow==
Message-ID: <B187B965-8671-485E-9CAB-7CF3468D2ED6@boeing.com>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <4EE7A31E.7080301@gmail.com>
 <895CF182-4BF7-4DF5-A467-944EC008DBC3@boeing.com>
 <20111214120240.GC25088@sirena.org.uk>
 <E30C4693-0D31-4A9A-9E9D-0FC03C5F6B8A@boeing.com>
 <20111217092044.GC2833@opensource.wolfsonmicro.com>
 <D482A908-020C-43E0-ADFC-33AE213D7257@boeing.com>
 <20111220013819.GV2860@opensource.wolfsonmicro.com>
In-Reply-To: <20111220013819.GV2860@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2011, at 20:38, Mark Brown wrote:
> On Mon, Dec 19, 2011 at 10:56:41AM -0600, Moffett, Kyle D wrote:
>> I still don't understand how the regulator API is supposed to help in my
>> particular case (whole-system poweroff).
> 
> Well, it depends what you need to do.  In the ST-Ericsson case what they
> needed to do was collapse the core supplies for the CPU.  But previously
> you were talking about power domains, not whole system poweroff.
> Usually a power domain is a subset of the full system power.

Well, I have control of 3 separate power domains in the sense that
there are 6 physically separate computers sharing a single supply,
with 2 in each domain (and only 1 of the 6 controlling the shared
supply).

Obviously when the 'control computer' goes off the GPIOs will
fluctuate wildly, so the power supply only responds to the GPIOs as
a signal to cut power, not to re-enable it.  The system is designed
to require user intervention to resupply power after it has shut
itself down.

So I do have separate power domains, but in this particular
hardware build I simply want to shut them all down in a fixed order
(due to the specific arrangement of power supply connections).

Previously I had about 200 lines of code in my machine_poweroff
hook to walk a list of GPIOs in the device tree and turn them all
off in a fixed order.  After looking at that a while I decided it
would be better off as a pseudo-generic driver that could be used
by any DT platform with a GPIO used to shut down system power.

I ended up with the "gpio-poweroff" driver which also makes the
time delays configurable.

Since I noticed that platform_drv also has a device-specific
poweroff hook, I added a boolean DT value to switch between
powering down at machine_poweroff() time and powering down during
the device->poweroff() walk.

I realize that this driver is basically incapable of any kind of
runtime power management but it could be used on X86 platforms
that convert to device-tree.  In particular ones with embedded
controllers and BMC devices would otherwise be using ACPI device
methods to poke a few GPIOs in basically the same fashion.

The benefit is that instead of ACPI AML (bytecode poking magic
IO registers at some undocumented address) you have a standard
GPIO driver and a piece of pseudo-self-documenting device-tree
that basically says "the HW engineers set it up so you set these
GPIOs in that order and it turns off".

Make sense?

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/


