Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0FCFgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 01:36:37 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:27709 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751747Ab0FCFge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 01:36:34 -0400
Date: Thu, 3 Jun 2010 06:36:25 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Linux Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
Message-ID: <20100603053625.GA23483@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry if this message gets unthreaded, my mbox for linux-kernel got
 corrupted so i've had to hand edit the headers]

> - x86 has its drivers elsewhere, and they are _discoverable_ and not 
>   hardcoded to some platform. They have often also been useful (to say 
>   the least) to other architecture platforms. That's not always truefor
>   all of them (we do have drivers/platform/x86, but at least that's 
>   maintained separately and is nowhere near the mess that is ARM)

There are some common drivers for ARM specific hardware under
arch/arm/common but there's not a lot of that. I have been trying to
ensure that new support re-uses common driver code. I was one of
the people who worked with Piere to break the SDHCI reliance on PCI
so that it could be re-used on platform device based systems such as
the new Samsung SoC. I have also been trying to ensure that new
support is carefully considered.

Unfortunately we often run into the following problems;

- The "Our hacked driver has been customer-tested and patched so often
  that it must be the one that gets submitted" argument... trying to get
  them to realised that firstly, it isn't of the necessary quality or
  has been already done elsewhere is very difficult.

- Often the hardware teams don't tell you where the blocks that have
  been included come from some common source. This makes the task of
  identifying a common driver difficult (they just make their own
  driver from the 'documentation' that the hardware guys hack).
  
  I've been subject to this on at-least one occasion and currently
  considering renaming the s3c-hsotg driver to dw-hsotg (it turns
  out to be a block that was bought in from Synopsys' DesignWare)

- There is also a problem that as soon as the hardware that has even
  a small divergence from the common case that they need a special
  driver for it (against, see the SDHCI case where there's a couple
  of extra configuration register to control clocks, etc.)

When Harald Welte and I looked into some of these development
practices we started to try and educate the developers about this. As
an example we looked the clock structure we used to modle the clock
trees in the SoCs, and found that in certain of their branches there
where 4 copies of the same code, each with its own subtle bugs...

I have been trying very hard to make sure that these things are kept
under control, but unfortunately it can be a hard task and until it
hits these big companies in the pocket it very difficult to get them
to actually pay for this.

As for the churn under arch/arm, then there are a few reasons for this
and the size of the code involved.

- Firstly the implemetations of the ARM architecture can vary wildly
  depending on the implementor (and there can be several different
  implementing teams within one company). There is very little direct
  recommendation or specification from ARM on how the system around
  the core is layed out.

  This means that there are a variety of different interupt controlers
  involved, and even when a standard one is used (ARM VIC) then the
  interrupt routing and base addresses of the control registers change
  between SoCs.

  There is also a huge variety of memory layouts, the base of SDRAM
  and peripheral layout can change between individual SoCs, let alone
  families of them.

- Secondly there has been an rush to get as many header files in
  defining as many registers as possible for all the hardware, even
  if it turns out later to be a common block or not used.

  I have been trying to remove as many #defines in headers where the
  result is only used once in the code to try and help the spiraling
  size of the project.

- Thirdly the core of these devices is also widly different, there is
  often far more complexity in how the SoC's bus and clock layouts are
  put together.

  It is not like PCI where each device has a xMHZ clock and integrated
  PLL if needed. There are complex heirarchies of PLLs and clocks,
  which then need to be exported to the drivers to use, and often the
  clock gating is also integrated into the centralised clock control
  units instead of in the device.

  Also, since there is often very little support for any dynamic bus
  discovery, a lot of the device information is dependant on knowing
  which SoC you are running on (unlike PCI where there's a specific
  configuration header).

  Note, there are moves to try and get device trees supported on ARM
  to try and solve the previous paragraph, but we have an awfully big
  history to sort out, and it only really pushes that part of the
  problem out of the kernel onto the device manfactueres (who can
  barely get a bootloader to pass in a couple of registers).

So apart from that, another source for the churn is that when we
do identify common parts, thigns need to get move and older systems
updated to use them. These devices seem to evolve at such a rate it
is difficult to predict what we'll see 6 months down the line.

The next problem is that if we don't get some support in each merge
window, then the size of the task for the next one keeps growing and
growing. It is already a problem just for the Samsung range of SoCs
where we only really have core functionality for most of the SoCs;
There are still drivers needed for some of the Security, Multimedia
and connectivity subsystems to be sorted out.

I have been trying my best to keep control of these issues, but it is
very difficult and it isn't my daytime job :(

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
