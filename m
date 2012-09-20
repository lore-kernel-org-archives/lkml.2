Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2ITPaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:30:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63813 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2ITPav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:30:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
Date: Thu, 20 Sep 2012 15:30:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lior Amsalem <alior@marvell.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <50559737.8000705@gmail.com> <CACRpkdY-Nyn73EJLvE1RsL4hgMRm6hALtnS-eKAXU7edot2V9A@mail.gmail.com>
In-Reply-To: <CACRpkdY-Nyn73EJLvE1RsL4hgMRm6hALtnS-eKAXU7edot2V9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209201530.40974.arnd@arndb.de>
X-Provags-ID: V02:K0:0oFvDzA6Qy1PzX295eg++oBYWLpbDZDLtSgrIxwDA9q
 qZyzpVEzdBuUm6P/dozPzLbbzWlS/jljq0hC/qF2DjW3qrzz84
 iagtNUvv2XwA9iCl860vlMTENv1fkTAB/zGpS5ag3oekMhbF+3
 MdGaHrsJw1yHutWVmIgRJIaHfuhWQ/x8Xvyk4+frme/et/u3E/
 WeVQvpO9qARpjH4Tw4hWJTpiKfaRc5FpEnqP3gdvC3i4PB014C
 HVDc/Y4RLRfbVWPCW5pD7w2zZY0MMfMdNHZoTtZykHnvm6lqCj
 WNiaL0k7Za4+J+BfWQeaSUeVVME6VDLajEu25nqPl7pY68RBRt
 +gk5IolFN2fLHBjbbM/o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2012, Linus Walleij wrote:
> You found the weak spot between two consolidation tracks.
> 
> Getting rid of a broadcast autodetect functions from say
> <mach/foo-id-probe.h> is nominally done by passing the data
> to the driver as platform data instead, and only using
> these functions in the mach-foo folder when populating
> platform data, and thus it can be made into a local
> header, say mach-foo/foo-id-probe.h
> 
> So the machine/arch code reads these registers to
> populate the platform data and device drivers only
> look at the platform data, which has some enum or
> bool indicating what hardware it's running on, cool.
> 
> But according to the other consolidation track, platform
> data should go into device tree bindings.
> 
> So the conclusion is that the DT must contain the data
> about the platform, so it's not auto-probed by the kernel.
> (I.e. the kernel reads no registers to figure out what hardware
> this is, that stuff comes from the device tree.)
> 
> DT purists will say that the boot loader should ask the chipset
> what it is with the same register writes and populate the
> DT accordingly, instead of loading a precompiled blob.
> Some may even ponder the crazy concept of amending the
> DT in the kernel at early boot.
> 
> But in practice someone will give up, encode the stuff in
> the static device tree and autoprobing of the platform
> goes out the window.

In general, I would prefer probing hardware by asking the hardware itself
rather than duplicating the information in the device tree. We do this
whenever we can, e.g. on PCI or USB, but we cannot normally do the same
on embedded buses like AHB, I2C or SPI, so we have to use the device
tree to provide some or all of the information.

A corner case is the one where you have different versions of the same
IP block (e.g. the pinctrl) and the kernel cannot find out which one it
is by looking at registers inside it or on the parent bus, but only
by looking at other hardware (CPU core revision, or PCI device ID of
the root complex). We have a precedent of at91 doing this, but I don't
like it too much because that still means having to change the driver
again if you get a new SoC with the same IP block but a different version
register, or if the block gets reused in something (e.g. by a different
vendor) that doesn't even have the other block that's used for
identification. To avoid that, I'd prefer using separate "compatible"
values, at least if the hardware is already described in separate .dtsi
files.

	Arnd
