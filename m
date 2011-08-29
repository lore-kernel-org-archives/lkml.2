Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab1H2Eb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 00:31:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59532 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab1H2Eby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 00:31:54 -0400
Date: Mon, 29 Aug 2011 14:31:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the driver-core tree with the arm-soc
 tree
Message-Id: <20110829143150.78ade5470cf62a83ad9b56f1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/arm/plat-mxc/devices.c between commit 160a84cfc975 ("ARM: mxc: drop
now unused function mxc_register_device") from the arm-soc tree and
commit 0e392412f334 ("ARM: mxc: convert device creation to use
platform_device_register_full") from the driver-core tree.

Just context changes.  I fixed it up (see below) anc can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-mxc/devices.c
index 5aaa8c5,a34b2ae..0000000
--- a/arch/arm/plat-mxc/devices.c
+++ b/arch/arm/plat-mxc/devices.c
@@@ -23,59 -23,20 +23,6 @@@
  #include <linux/platform_device.h>
  #include <mach/common.h>
  
- struct platform_device *__init imx_add_platform_device_dmamask(
- 		const char *name, int id,
- 		const struct resource *res, unsigned int num_resources,
- 		const void *data, size_t size_data, u64 dmamask)
- {
- 	int ret = -ENOMEM;
- 	struct platform_device *pdev;
- 
- 	pdev = platform_device_alloc(name, id);
- 	if (!pdev)
- 		goto err;
- 
- 	if (dmamask) {
- 		/*
- 		 * This memory isn't freed when the device is put,
- 		 * I don't have a nice idea for that though.  Conceptually
- 		 * dma_mask in struct device should not be a pointer.
- 		 * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
- 		 */
- 		pdev->dev.dma_mask =
- 			kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
- 		if (!pdev->dev.dma_mask)
- 			/* ret is still -ENOMEM; */
- 			goto err;
- 
- 		*pdev->dev.dma_mask = dmamask;
- 		pdev->dev.coherent_dma_mask = dmamask;
- 	}
- 
- 	if (res) {
- 		ret = platform_device_add_resources(pdev, res, num_resources);
- 		if (ret)
- 			goto err;
- 	}
- 
- 	if (data) {
- 		ret = platform_device_add_data(pdev, data, size_data);
- 		if (ret)
- 			goto err;
- 	}
- 
- 	ret = platform_device_add(pdev);
- 	if (ret) {
- err:
- 		if (dmamask)
- 			kfree(pdev->dev.dma_mask);
- 		platform_device_put(pdev);
- 		return ERR_PTR(ret);
- 	}
- 
- 	return pdev;
- }
- 
 -int __init mxc_register_device(struct platform_device *pdev, void *data)
 -{
 -	int ret;
 -
 -	pdev->dev.platform_data = data;
 -
 -	ret = platform_device_register(pdev);
 -	if (ret)
 -		pr_debug("Unable to register platform device '%s': %d\n",
 -			 pdev->name, ret);
 -
 -	return ret;
 -}
 -
  struct device mxc_aips_bus = {
  	.init_name	= "mxc_aips",
  	.parent		= &platform_bus,
