Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1JKBSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 21:18:45 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:49518 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1JKBSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 21:18:43 -0400
Date: Mon, 10 Oct 2011 19:18:42 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <alpine.DEB.2.00.1110101455590.5205@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.1110101851570.5205@utopia.booyaka.com>
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com> <CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com> <alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
 <CAP05o4KLAnNHcvNbNWqJFN710JMNAy2emYzCt2xHF+m-Kvwveg@mail.gmail.com> <CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com> <alpine.DEB.2.00.1110101455590.5205@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, 10 Oct 2011, Paul Walmsley wrote:

> Basically, the existing OMAP USB subsystem MFD driver should create a TLL 
> device.  Then the existing Linux driver probing system can associate the 
> TLL driver with the TLL device.

This part isn't right.  After staring at the OMAP34xx TRM, it looks like 
the TLL modules have a separate interconnect port.  See for example the 
OMAP34xx TRM Rev. ZR Table 2-3 "L4-Core Memory Space Mapping".

So then the TLL device should be created by the code in 
arch/arm/mach-omap2/usb-host.c, as one of Keshava's patches does.  And 
indeed we have separate hwmods for the TLL IP blocks -- although both the 
OMAP3 and OMAP4 hwmod data that was posted are missing important fields.

So drivers/omap-usb-host.c shouldn't create a new TLL device.  You just 
need to pull all of the TLL code and data out of that MFD driver into a 
new TLL driver under drivers/usb somewhere.

Then you'll need some way for the EHCI/OHCI code to figure out which 
USBTLL device handles each port.  I'd suggest that, unless there is some 
explicit Linux USB core support for associating a TLL port with a host 
controller port, that the code in arch/arm/mach-omap2/usb-host.c register 
the USBTLL device first (the opposite of what it does now), then pass 
the pointer to the USBTLL's struct device via platform_data to 
drivers/mfd/omap-usb-host.c.  Then that can either be passed via 
platform_data to the EHCI/OHCI drivers, or the EHCI/OHCI drivers can call 
a drivers/mfd/omap-usb-host.c function to retrieve that struct device 
pointer.


- Paul
