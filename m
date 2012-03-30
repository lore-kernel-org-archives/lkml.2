Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762Ab2C3XJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:09:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761456Ab2C3VEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:04:13 -0400
Message-Id: <20120330195725.429450620@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Ramneek Mehresh <ramneek.mehresh@freescale.com>,
        Peter Chen <peter.chen@freescale.com>
Subject: [ 023/108] usb: Fix build error due to dma_mask is not at pdev_archdata at ARM
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit e90fc3cb087ce5c5f81e814358222cd6d197b5db upstream.

When build i.mx platform with imx_v6_v7_defconfig, and after adding
USB Gadget support, it has below build error:

CC      drivers/usb/host/fsl-mph-dr-of.o
drivers/usb/host/fsl-mph-dr-of.c: In function 'fsl_usb2_device_register':
drivers/usb/host/fsl-mph-dr-of.c:97: error: 'struct pdev_archdata'
has no member named 'dma_mask'

It has discussed at: http://www.spinics.net/lists/linux-usb/msg57302.html

For PowerPC, there is dma_mask at struct pdev_archdata, but there is
no dma_mask at struct pdev_archdata for ARM. The pdev_archdata is
related to specific platform, it should NOT be accessed by
cross platform drivers, like USB.

The code for pdev_archdata should be useless, as for PowerPC,
it has already gotten the value for pdev->dev.dma_mask at function
arch_setup_pdev_archdata of arch/powerpc/kernel/setup-common.c.

Tested-by: Ramneek Mehresh <ramneek.mehresh@freescale.com>
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/fsl-mph-dr-of.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/host/fsl-mph-dr-of.c
+++ b/drivers/usb/host/fsl-mph-dr-of.c
@@ -93,7 +93,6 @@ struct platform_device * __devinit fsl_u
 	pdev->dev.parent = &ofdev->dev;
 
 	pdev->dev.coherent_dma_mask = ofdev->dev.coherent_dma_mask;
-	pdev->dev.dma_mask = &pdev->archdata.dma_mask;
 	*pdev->dev.dma_mask = *ofdev->dev.dma_mask;
 
 	retval = platform_device_add_data(pdev, pdata, sizeof(*pdata));


