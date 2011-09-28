Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1I1D4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 23:56:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4467 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1I1D4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 23:56:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 27 Sep 2011 20:56:04 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 27 Sep 2011 20:56:02 -0700
Subject: RE: [PATCH 0/4] arm/tegra: Convert gpio & pinmux to platform devices
Thread-Topic: [PATCH 0/4] arm/tegra: Convert gpio & pinmux to platform
 devices
Thread-Index: Acx8Jd/GPrw4GvdyTri0WIiA7nO9mwBa0bFA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173955572E@HQMAIL01.nvidia.com>
References: <1316725567-17881-1-git-send-email-swarren@nvidia.com>
 <201109231848.52318.arnd@arndb.de>
In-Reply-To: <201109231848.52318.arnd@arndb.de>
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

Arnd Bergmann wrote at Friday, September 23, 2011 10:49 AM:
> On Thursday 22 September 2011, Stephen Warren wrote:
> >
> > This series converts the Tegra GPIO and pinmux drivers to be regular
> > platform devices.
> 
> Looks good overall.

Thanks.

> > The series is extracted from an earlier series I posted that augmented
> > these drivers to initialize HW state from the device-tree. I'm holding
> > off on that aspect of the changes, since it's not entirely clear to me
> > whether the new pinmux API should drive the initial pinmux state setup
> > via "system hog" definitions, or whether pinmux drivers should indeed
> > do their own thing.
> 
> I think at least you should try to do an ioremap of the pinmux register
> area in the pinmux probe function and make sure that it's called early
> enough, if at all possible.
> 
> Right now, there is an empty probe() function, which is a bit silly,
> and the pg_readl()/pg_writel() functions use hardcoded register
> addresses.

For GPIO, calling ioremap() should be pretty easy.

For pinmux, there are complications: The pinmux HW doesn't have a dedicated
address range, but rather the registers are somewhat scattered in groups
throughout the "APB_MISC" address range. APB_MISC also includes strapping,
JTAG configuration, and USB PHY registers, all of which exist between the
various groups of pinmux registers. On Tegra30, there's slightly less of
this, yet in turn this means that the number of chunks of address space used
by the pinmux module differs from Tegra20.

Right now, the pinmux driver data tables (which define the set of pin groups
known to the pinmux driver) all store register addresses as offsets from the
base of this APB_MISC region for simplicity.

What are your thoughts here; should I go ahead and update the pinmux driver
to ioremap() each of these chunks individually, and update the data tables
to be a tuple (chunk ID, offset_from_chunk), or leave things as is?

Thanks.

-- 
nvpublic

