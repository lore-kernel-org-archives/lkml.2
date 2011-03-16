Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1CPJzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 05:55:52 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:42575 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097Ab1CPJzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 05:55:47 -0400
Date: Wed, 16 Mar 2011 11:55:42 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: musb as module broken in 2.6.38
Message-ID: <20110316095541.GD2325@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D8018A9.6000800@ahsoftware.de>
 <20110316090327.GA2325@legolas.emea.dhcp.ti.com>
 <4D808729.9060608@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D808729.9060608@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 10:47:21AM +0100, Alexander Holler wrote:
> Am 16.03.2011 10:03, schrieb Felipe Balbi:
> >Hi,
> >
> >On Wed, Mar 16, 2011 at 02:55:53AM +0100, Alexander Holler wrote:
> >>in commit dc09886bfa781e2b442301116c18199519e36f0f the name of the
> >>platform-driver was splitted and musb-omap2430 is used for several
> >>boards (arch/arm/mach-omap2/usb-musb.c).
> >>
> >>But musb_hdrc still uses musb-hdrc as name when
> >>platform_driver_probe() is called. The result is that loading the
> >>driver (when build as a module) doesn't work anymore (it doesn't find
> >>the platform-device).
> >>
> >>Do I miss something or was something forgotten when the glue-layers
> >>for musb got introduced?
> >>
> >>(The driver still works when linked into the kernel, but is
> >>disfunctional when build as a module.)
> >
> >Send me the output you get on console and a snippet of the .config with
> >the MUSB section.
> 
> I don't see the need for it, but here it is:
> 
> ------------
> beagle linux # grep -i MUSB .config
> CONFIG_USB_MUSB_HDRC=m
> # CONFIG_USB_MUSB_TUSB6010 is not set
> CONFIG_USB_MUSB_OMAP2PLUS=y
> # CONFIG_USB_MUSB_AM35X is not set
> # CONFIG_USB_MUSB_HOST is not set
> # CONFIG_USB_MUSB_PERIPHERAL is not set
> CONFIG_USB_MUSB_OTG=y
> CONFIG_USB_GADGET_MUSB_HDRC=y
> CONFIG_USB_MUSB_HDRC_HCD=y
> # CONFIG_MUSB_PIO_ONLY is not set
> CONFIG_USB_MUSB_DEBUG=y
> beagle linux # modprobe musb_hdrc
> FATAL: Error inserting musb_hdrc (/lib/modules/2.6.38-beagleboard-00002-g0017ea0-dirty/kernel/drivers/usb/musb/musb_hdrc.ko):
> No such device
> beagle linux # tail -n 1 /var/log/messages
> Mar 16 10:37:51 beagle kernel: [  177.302825] musb-hdrc: version 6.0,
> musb-dma, otg (peripheral+host), debug=5
> beagle linux # ls /sys/devices/platform/ | grep musb
> musb-omap2430
> ------------
> 
> The problem in detail:
> 
> Through modprobe musb_core.c:musb_init() is called, and this calls
> platform_driver_probe() with a pointer to a struct of platform_device
> where the name is musb-hdrc.
> drivers/base/platform.c:platform_driver_probe() fails with -ENODEV
> because it doesn't find a platform device with the name musb-hdrc
> (list_empty()) which is understandable because the platform-device
> has the name musb-omap2430.

look further, omap2430.c allocates musb-hdrc platform_device. The
problem is a different one.

static int __init omap2430_probe(struct platform_device *pdev)
{
	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
	struct platform_device		*musb;
	struct omap2430_glue		*glue;
	struct clk			*clk;

	int				ret = -ENOMEM;

	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
	if (!glue) {
		dev_err(&pdev->dev, "failed to allocate glue context\n");
		goto err0;
	}

	musb = platform_device_alloc("musb-hdrc", -1);
	if (!musb) {
		dev_err(&pdev->dev, "failed to allocate musb device\n");
		goto err1;
	}


-- 
balbi
