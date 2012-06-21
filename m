Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab2FUCot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:44:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:15167 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab2FUCos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:44:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="183001280"
Message-ID: <4FE28A4D.7060302@linux.intel.com>
Date: Wed, 20 Jun 2012 19:43:25 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Eric Miao <eric.miao@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: RFC: pca953 new platform specific changes
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on support for a device which combines a pair of PCA9555
gpio chips with an LIS331DLH accelerometer on an I2C bus.

I'm awaiting some documentation to confirm, but as I understand it the
accelerometer connects one of its interrupt lines to one of the pins on
the first PCA9555, which is then connected to SMB ALERT, which if I
understand is somehow tied to an ACPI GPE (0x0B)).

I have a hacked together set of patches to support this device which do
some horrible things to the pca953x driver. I'm trying to clean these up
and handle the platform changes properly in order to get them
upstreamed. I'd like to let you know what I'm attempting up front in
case you have any preference regarding the implementation as I'm new to
the GPIO subsystem and driver writing.

Key:
o Platform specific properties
  [ ] My approach to support them

For this platform:
o Only IO 0,1,3,4,6, and 15 can be written to on the first PCA555 (0x20)
  [ ] Add output bitbmask to platform data
  [ ] Don't allow the output_direction function to vary from this if
      provided
o All pins have a specified function
  [ ] Add Pin names to platform data
o Pin assignments vary slightly based on board revision, read from 2nd
  PCA555
  [ ] ? Provide a function to perform the test to the platform data ?
o The accelerometer needs to have its interrupt line set to open-drain
  The current hack does this in a new pca53x detect function
  [ ] ? Move this to a platform data function for the accelerometer ?
o This device needs a GPE handler rather than a traditional irq thread
  [ ] Provide GPE or IRQ data in the platform data, choose which to
      setup based on that (rather large blocks of ifdefs per platform
      in the driver).
o Only the fist PCA555 has accessory input lines on this device, so the
  second should not get an interrupt handler setup.
  [ ] Setup different platform data based on I2C device address with
      appropriate GPE/IRQ data in the platform data setup

Does this approach seem appropriate?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

