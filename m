Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1JJVtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:49:12 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:51928 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1JJVtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:49:11 -0400
Date: Mon, 10 Oct 2011 15:49:09 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <20111010090330.GE6685@legolas.emea.dhcp.ti.com>
Message-ID: <alpine.DEB.2.00.1110101509580.5205@utopia.booyaka.com>
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com> <CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com> <alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
 <CAP05o4KLAnNHcvNbNWqJFN710JMNAy2emYzCt2xHF+m-Kvwveg@mail.gmail.com> <CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com> <20111010090330.GE6685@legolas.emea.dhcp.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On Mon, 10 Oct 2011, Felipe Balbi wrote:

> On Mon, Oct 10, 2011 at 02:22:23PM +0530, Munegowda, Keshava wrote:
>
> > Here is the highlights of the change in the design of  USB Host which
> > we can do after kernel 3.2 release;
> > 
> > 1. separate the TLL changes  from UHH
> > 2. The TLL is be a new platform driver in ./drivers/mfd
> > 3. the TLL platform driver will export apis  for enable/disable clocks
> > and settings.
> 
> TLL should control its clocks through pm_runtime APIs like anything
> else. If you really must export APIs to be used by UHH, you need to have
> an API so that you can claim/release a TLL channel and get/put for
> increasing/decreasing PM counters.
> 
> I still think though, you should try to avoid exporting OMAP-specific
> APIs all over the place. Ideally, we would be able to have some way of
> saying that UHH and TLL are closely related... something like having the
> ability to say e.g. two devices are sibblings of each other, so that we
> could ask for a sibbling to wakeup/sleep depending if we need it or not.
> 
> Dunno, maybe I'm drifting here, but I don't think exposing OMAP-specific
> APIs is wise.

I'm not an USBHOST expert, but I don't think any special sibling 
relationships or OMAP subarchitecture-specific APIs are needed.  The OMAP 
EHCI/OHCI drivers just need to call a couple of functions in the OMAP TLL 
driver.  Linux already handles function call dependencies between 
loadable modules transparently (see "man 8 depmod" and EXPORT_SYMBOL).

Looks to me like the TLL IP block is only needed for OHCI and some EHCI 
port modes[1].  The TLL doesn't seem to need much care and feeding.  
Currently it's programmed during init[2] and then you just enable it when 
the port is in use[3] and disable it when it is no longer in use[4].  
Looks to me like the TLL init function could be rolled into the enable 
function.

So then you'd just create a TLL driver with something like these two 
symbols exported:

omap_usbhost_tll_enable_port();
omap_usbhost_tll_disable_port(); 

The first function would be called from drivers/usb/host/ehci-omap.c or 
drivers/usb/host/ohci-omap3.c during omap_usbhs_enable().  It would take 
the TLL configuration for that port and would reserve it while it is in 
use.  It would call pm_runtime_get_sync() to ensure its clocks were on, 
etc.

The second function would be called from drivers/usb/host/ehci-omap.c or
drivers/usb/host/ohci-omap3.c during omap_usbhs_disable().  It would 
release an already in-use TLL port and would call pm_runtime_put_sync() to 
allow its clocks to be cut, etc.

So it doesn't seem like any extraordinary Linux support is needed to 
handle this cleanly.  But maybe I'm missing something?


- Paul

All references are as of Linux v3.1-rc9.

1. drivers/mfd/omap-usb-host.c:887,
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/mfd/omap-usb-host.c;h=86e14583a08276fd7f76dddd3afe3433f1dfa9a8;hb=976d167615b64e14bc1491ca51d424e2ba9a5e84#l887

2. drivers/mfd/omap-usb-host.c:894,
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/mfd/omap-usb-host.c;h=86e14583a08276fd7f76dddd3afe3433f1dfa9a8;hb=976d167615b64e14bc1491ca51d424e2ba9a5e84#l894

3. drivers/mfd/omap-usb-host.c:845,
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/mfd/omap-usb-host.c;h=86e14583a08276fd7f76dddd3afe3433f1dfa9a8;hb=976d167615b64e14bc1491ca51d424e2ba9a5e84#l845

4. drivers/mfd/omap-usb-host.c:999,
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/mfd/omap-usb-host.c;h=86e14583a08276fd7f76dddd3afe3433f1dfa9a8;hb=976d167615b64e14bc1491ca51d424e2ba9a5e84#l999

