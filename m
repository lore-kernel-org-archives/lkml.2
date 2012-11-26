Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2KZG7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:59:54 -0500
Received: from plane.gmane.org ([80.91.229.3]:45895 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab2KZG7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:59:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Woody Wu <narkewoody@gmail.com>
Subject: The ethernet driver doesn't get probed
Date: Mon, 26 Nov 2012 06:59:36 +0000 (UTC)
Message-ID: <slrnkb64p3.2k6.narkewoody@zuhnb712.local.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 59.37.26.98
User-Agent: slrn/0.9.9p1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, List

I enabled an ax88796 Ethernet driver in the kernel configuration menu.
Kernel version is 3.4.19. The arch is ARM and the system type is
Samsung S3C2410.

In my debugging, I found the probe function of the driver did not get
invoked.

This driver is declared as platform_driver

static struct platform_driver axdrv = {
	.driver	= {
		.name		= "ax88796",
		.owner		= THIS_MODULE,
	},
	.probe		= ax_probe,
	.remove		= ax_remove,
	.suspend	= ax_suspend,
	.resume		= ax_resume,
};

module_platform_driver(axdrv);

So, its driver init function actually goes through
platform_driver_register() and then driver_register(), which eventually
call driver_attach() trying to attach the driver to the "platform" bus.
But, on the platform bus, there is no any device that can match the
ax88796 driver, hence the driver failed in attaching.

I discovered the full list of devices found on the platform bus:

    s3c2410-ohci,
    s3c2410-lcd,
    s3c2410-wdt,
    s3c2410-i2c,
    s3c24xx-iis,
    s3c2410-nand,
    s3c24xx_led,
    s3c2410-uart,

You see, in the list, there is no a device looks like ax88796. All these
already existed devices on the platform bus are build-in peripherals on
the SoC of s3c2410, they are compiled into the code by enabling some
kernel configuration options.

My question is, in terms of Linux driver technology, how to enable a
non-PCI and not on-chip device driver? I think the ax_probe function
must be called somehow, is this thinking right? If yes, I think before
the driver get initialized, the corresponding device has to appear on
the bus, but now it seems not.

Thanks in advance.

-- 
woody
I can't go back to yesterday - because I was a different person then.

