Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1GGMYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:24:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:48733 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab1GGMYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:24:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,493,1304319600"; 
   d="scan'208";a="27397809"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Weil, Oren jer" <oren.jer.weil@intel.com>
Date: Thu, 7 Jul 2011 15:23:36 +0300
Subject: RE: [staging] mei: Enable msi when supported
Thread-Topic: [staging] mei: Enable msi when supported
Thread-Index: Acw8mY+4GtAHi2TwRD+96wB4yMfUywABXt3Q
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401C711335D@hasmsx504.ger.corp.intel.com>
References: <4E159945.8050900@gmail.com>
In-Reply-To: <4E159945.8050900@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Maarten Lankhorst [mailto:m.b.lankhorst@gmail.com]
> Sent: Thursday, July 07, 2011 2:32 PM
> To: Winkler, Tomas
> Cc: devel@linuxdriverproject.org; Linux Kernel Mailing List
> Subject: [staging] mei: Enable msi when supported
> 
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> ---
> Tested suspend/resume, driver (re/un)loading. Comments welcome. :)

Sounds good, but I believe in case where MSI is enabled we also can kill the quick handler.
Let me check before I ack this.


> 
> diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c index
> bfd1b46..58106bf 100644
> --- a/drivers/staging/mei/main.c
> +++ b/drivers/staging/mei/main.c
> @@ -121,6 +121,7 @@ static int __devinit mei_probe(struct pci_dev *pdev,
> {
>  	struct mei_device *dev;
>  	int err;
> +	unsigned long flags = 0;
> 
>  	mutex_lock(&mei_mutex);
>  	if (mei_device) {
> @@ -154,11 +155,13 @@ static int __devinit mei_probe(struct pci_dev
> *pdev,
>  		err = -ENOMEM;
>  		goto free_device;
>  	}
> +	if (pci_enable_msi(pdev) < 0)
> +		flags |= IRQF_SHARED;
>  	/* request and enable interrupt   */
>  	err = request_threaded_irq(pdev->irq,
>  			mei_interrupt_quick_handler,
>  			mei_interrupt_thread_handler,
> -			IRQF_SHARED, mei_driver_name, dev);
> +			flags, mei_driver_name, dev);
>  	if (err) {
>  		printk(KERN_ERR "mei: request_threaded_irq failure. irq =
> %d\n",
>  		       pdev->irq);
> @@ -186,6 +189,7 @@ release_irq:
>  	mei_disable_interrupts(dev);
>  	flush_scheduled_work();
>  	free_irq(pdev->irq, dev);
> +	pci_disable_msi(pdev);
>  unmap_memory:
>  	pci_iounmap(pdev, dev->mem_addr);
>  free_device:
> @@ -250,6 +254,7 @@ static void __devexit mei_remove(struct pci_dev
> *pdev)
>  	mei_disable_interrupts(dev);
> 
>  	free_irq(pdev->irq, dev);
> +	pci_disable_msi(pdev);
>  	pci_set_drvdata(pdev, NULL);
> 
>  	if (dev->mem_addr)
> @@ -1103,7 +1108,7 @@ static int mei_pci_suspend(struct device *device)
>  	mutex_unlock(&dev->device_lock);
> 
>  	free_irq(pdev->irq, dev);
> -
> +	pci_disable_msi(pdev);
> 
>  	return err;
>  }
> @@ -1113,16 +1118,19 @@ static int mei_pci_resume(struct device *device)
>  	struct pci_dev *pdev = to_pci_dev(device);
>  	struct mei_device *dev;
>  	int err;
> +	unsigned long flags = 0;
> 
>  	dev = pci_get_drvdata(pdev);
>  	if (!dev)
>  		return -ENODEV;
> 
> +	if (pci_enable_msi(pdev) < 0)
> +		flags |= IRQF_SHARED;
>  	/* request and enable interrupt   */
>  	err = request_threaded_irq(pdev->irq,
>  			mei_interrupt_quick_handler,
>  			mei_interrupt_thread_handler,
> -			IRQF_SHARED, mei_driver_name, dev);
> +			flags, mei_driver_name, dev);
>  	if (err) {
>  		printk(KERN_ERR "mei: Request_irq failure. irq = %d\n",
>  		       pdev->irq);
> 

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

