Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2JPK5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:57:38 -0400
Received: from smtp-out-105.synserver.de ([212.40.185.105]:1088 "EHLO
	smtp-out-105.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2JPK5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:57:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29151
Message-ID: <507D3DE8.3040003@metafoo.de>
Date: Tue, 16 Oct 2012 12:58:48 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linus.walleij@linaro.org
Subject: Re: [PATCH v2 1/4] mfd: add viperboard driver
References: <20120925085559.GL28670@sortiz-mobl> <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de> <507D1D7A.4040205@metafoo.de> <201210161143.19619.poeschel@lemonage.de>
In-Reply-To: <201210161143.19619.poeschel@lemonage.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 11:43 AM, Lars Poeschel wrote:
> On Tuesday 16 October 2012 at 10:40:26, Lars-Peter Clausen wrote:
>> On 10/12/2012 04:34 PM, Lars Poeschel wrote:
>>> [...]
>>> +static void vprbrd_dev_release(struct device *dev)
>>> +{
>>> +	return;
>>
>> A empty release callback is usually a good indicator that something is
>> wrong. The release callback will be called once the last reference to the
>> device has been called, so the memory associated with the device should not
>> be freed before the release callback has been called, otherwise the memory
>> might be accessed after it has been freed...
>>
>>> +}
>>> +
>>> +static void vprbrd_free(struct vprbrd *dev)
>>> +{
>>> +	usb_put_dev(dev->usb_dev);
>>> +	kfree(dev);
>>
>> ..., so this kfree should be moved from here to the release callback.
> 
> Thank you for catching that one!
>  
>> Btw. I'm wondering why is the extra platform device required? Can't you not
>> just use the usb device as the parent device for the mfd cells?
> 
> This is what I first did, but this does not work. You can read about my first 
> thoughts why this is not working here: (To sum it up: The device is housed in 
> an usb_device, not a platform_device and This usb_device has no mfd_cell 
> member.)
> 
> https://lkml.org/lkml/2012/9/28/327
> 
> As I got a bit more deeper I also noticed, that mfd_add_devices (obviously) 
> adds the devices "as childs" to the parent device. mfd_remove_devices then 
> removes ALL "child" devices from the parent, not only those added by 
> mfd_add_devices before. This does not work in the case of the usb parent 
> device, because it has other childs that the usb layer added before (some 
> endpoints and stuff). So I had to construct an "empty" (in sense of childs) 
> mock platform_device between the usb and mfd.

Ah, ok that makes sense. I was a bit confused, because there are other mfd
drivers with for example i2c or spi devices as parents and these work fine,
but I guess this is because non of them registers any additional child
devices. I guess it makes sense to create a mfd cell device type and assign
this type to newly created mfd cells and only unregister a device in
mfd_remove_devices if it has the correct device type.

E.g. something along the lines of:


--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -21,6 +21,10 @@
 #include <linux/irqdomain.h>
 #include <linux/of.h>

+static struct device_type mfd_device_type = {
+	.name = "mfd-cell",
+};
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
@@ -91,6 +95,7 @@ static int mfd_add_device(struct device *parent, int id,
 		goto fail_device;

 	pdev->dev.parent = parent;
+	pdev->dev.type = &mfd_device_type;

 	if (parent->of_node && cell->of_compatible) {
 		for_each_child_of_node(parent->of_node, np) {
@@ -204,10 +209,16 @@ EXPORT_SYMBOL(mfd_add_devices);

 static int mfd_remove_devices_fn(struct device *dev, void *c)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct platform_device *pdev;
+	const struct mfd_cell *cell;
 	atomic_t **usage_count = c;

+	if (dev->type != &mfd_device_type)
+		return 0;
+
+	pdev = to_platform_device(dev);
+	cell = mfd_get_cell(pdev);
+
 	/* find the base address of usage_count pointers (for freeing) */
 	if (!*usage_count || (cell->usage_count < *usage_count))
 		*usage_count = cell->usage_count;
