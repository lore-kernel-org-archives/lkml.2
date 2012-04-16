Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2DPOOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:14:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab2DPOOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:14:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2 1/3] USB: Add driver for NXP ISP1301 USB transceiver
Date: Mon, 16 Apr 2012 14:14:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org
References: <1334582166-5485-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1334582166-5485-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204161414.14624.arnd@arndb.de>
X-Provags-ID: V02:K0:xJMP4kcETyUq1t84pRhsz+cjIPDeLkCVNeaBdOxY8RF
 73lT724Ina+FrH1PAWjI1ZVbHSmN1mvqUvXlayuYQvz1Dmb1aQ
 aCjdClqsbwoa7t1LMWkDrDyqCjaFZAQ52us/iUlPtGcwiD1qnO
 bUbS1Jy3Wj+/RamQKC0nnyTFMCuAW6bQSvSWhdLMK0YXBreeTH
 xUxP6B2YRBT4IIQXAbsJRGvghLmfofmF7d0sPlzLPl40bj6JY5
 nUy5u5MBXkv0WjY+ldlULpa/N9BLTmKpnfMDg/3mO8Qhut7kjO
 d1LkdctxQuw/6u81QN+OW4TFrgN8Qhb5tZ4euWy85V9hcreqzH
 /C2xyl4cuXsVvma+psVc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2012, Roland Stigge wrote:
> This very-lowlevel driver registers the NXP ISP1301 chip via the I2C subsystem.
> The chip is the USB transceiver shared by ohci-nxp, lpc32xx_udc (gadget) and
> isp1301_omap.
> 
> Following patches let the respective USB host and gadget drivers use this
> driver, instead of duplicating ISP1301 handling.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

All three patches:

Acked-by: Arnd Bergmann <arnd@arndb.de>

> This driver needs to be probe()d before the respective USB driver using it. For
> modules, this is handled via the module dependency. When linking statically, it
> is done via linking order in the Makefile (misc/ before host/ and the gadget/).

You can easily avoid the link order restriction now by returning -EPROBE_DEFER
from the probe function of the device that needs this one.

> Currently, only one ISP1301 chip is supported. To support multiple instances,
> we would need a mechanism to identify the respective chips via DT (and static
> resources or platform data) to be referenced by the higher level USB driver at
> isp1301_get_client(). Any suggestions?

Put a phandle into the usb device node, like:

       isp1301: usb-transceiver@23 {
		compatible = "nxp,isp1301";
		reg = <23>;
	};

       usbd@31020000 {
               compatible = "nxp,lpc32xx-udc";
               reg = <0x31020000 0x300>;
               interrupt-parent = <&mic>;
               interrupts = <0x3d 0>, <0x3e 0>, <0x3c 0>, <0x3a 0>;
	       transceiver = <&isp1301>;
               status = "disable";
       };

Then add a device_node argument to the isp1301_get_client() function
and change the function to use bus_find_device() with a match function
that compares the driver pointer.

Alternatively (and much more complex), you could add a generic usb-transceiver
abstraction that does this and also hides the register accesses behind
hardware independent function calls.

	Arnd
