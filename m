Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab0KHN3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 08:29:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45709 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab0KHN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 08:29:17 -0500
Message-ID: <4CD7FB27.9030804@monstr.eu>
Date: Mon, 08 Nov 2010 14:29:11 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: spi-devel-general@lists.sourceforge.net, richard.rojfors@mocean-labs.com,
        john.linn@xilinx.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
References: <20101014161724.18966.42340.stgit@localhost6.localdomain6>
In-Reply-To: <20101014161724.18966.42340.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Grant Likely wrote:
> Since of_platform_bus_type has been merged with the platform_bus_type,
> a single platform driver can now support both use cases.  This patch
> series merges the two halves of the xilinx_spi device driver.
> 
> Compile tested only.  I haven't booted this yet.

I have tested it on sp605 and works well. Have you added that patches
to your repository? Or are they somewhere else? Who is responsible for?

I would like to also discuss one change which is related mmc_spi kernel driver.
Let me describe the problem. Microblaze can use dma in all addresses
that's why dma_mask is setup to 0xffffffff in of_platform_device_create.
Xilinx spi driver doesn't support dma but mmc_spi driver is checking dma_mask in parent device
which is xilinx spi driver.

Here is the corresponding the part of code (Expect dma_mask=zero for no dma operations).
mmc_spi.c:~1395
	if (spi->master->dev.parent->dma_mask) {
		struct device	*dev = spi->master->dev.parent;

		host->dma_dev = dev;


Based on this one our customer came with the following solution to setup
dma_mask in xilinx_spi to zero and then mmc_spi doesn't setup dma operation.

I think that this is nice solution but I would like to be sure that I didn't miss anything.
After that i will create proper patch with description.


diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
index 7adaef6..3612e1b 100644
--- a/drivers/spi/xilinx_spi.c
+++ b/drivers/spi/xilinx_spi.c
@@ -519,6 +519,9 @@ static int __devinit xilinx_spi_probe(struct platform_device *dev)
        }

        platform_set_drvdata(dev, master);
+       /* clear the dma_mask, to try to disable use of dma */
+       dev->dev.dma_mask = 0;
+
        return 0;
 }


Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
