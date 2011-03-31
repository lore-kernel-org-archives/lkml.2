Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab1CaRyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:54:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46797 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1CaRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:54:14 -0400
Message-ID: <4D94BFC1.5070608@monstr.eu>
Date: Thu, 31 Mar 2011 19:54:09 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu> <1301574600-4861-2-git-send-email-monstr@monstr.eu> <20110331164348.GI26709@ponder.secretlab.ca>
In-Reply-To: <20110331164348.GI26709@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> On Thu, Mar 31, 2011 at 02:30:00PM +0200, Michal Simek wrote:
>> Support OF support. "generic-uio" compatible property is used.
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  drivers/uio/uio_pdrv_genirq.c |   60 ++++++++++++++++++++++++++++++++++++++--
>>  1 files changed, 57 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
>> index 7174d51..9e89806 100644
>> --- a/drivers/uio/uio_pdrv_genirq.c
>> +++ b/drivers/uio/uio_pdrv_genirq.c
>> @@ -23,6 +23,10 @@
>>  #include <linux/pm_runtime.h>
>>  #include <linux/slab.h>
>>  
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_address.h>
>> +
>>  #define DRIVER_NAME "uio_pdrv_genirq"
>>  
>>  struct uio_pdrv_genirq_platdata {
>> @@ -92,11 +96,44 @@ static int uio_pdrv_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
>>  static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>>  {
>>  	struct uio_info *uioinfo = pdev->dev.platform_data;
>> -	struct uio_pdrv_genirq_platdata *priv;
>> +	struct uio_pdrv_genirq_platdata *priv = NULL;
>>  	struct uio_mem *uiomem;
>>  	int ret = -EINVAL;
>>  	int i;
>>  
>> +	if (!uioinfo) {
>> +		struct resource r_irq; /* Interrupt resources */
>> +		int rc = 0;
>> +
>> +		rc = of_address_to_resource(pdev->dev.of_node, 0,
>> +							&pdev->resource[0]);
>> +		if (rc) {
>> +			dev_err(&pdev->dev, "invalid address\n");
>> +			goto bad2;
>> +		}
>> +		pdev->num_resources = 1;
> 
> You shouldn't need this anymore.  Device tree sourced platform_devices
> get their resource table populated automatically.  Also, drivers
> should /never/ modify the resource values set in the device because it
> messes up driver rebinding.

done.

> 
>> +
>> +		/* alloc uioinfo for one device */
>> +		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
>> +		if (!uioinfo) {
>> +			ret = -ENOMEM;
>> +			dev_err(&pdev->dev, "unable to kmalloc\n");
>> +			goto bad2;
>> +		}
>> +		uioinfo->name = pdev->dev.of_node->name;
>> +		/* Use version for storing full IP name for identification */
>> +		uioinfo->version = pdev->dev.of_node->full_name;
> 
> Comment on the binding: You should probably use the first entry in the
> compatible list for the name of the device.  Node names should be
> generic and usually they will say what a device does, but not what a
> device actually /is/ (this is the Generic Names recommended practice).
> 
> Modern convention is to rely on the first compatible entry for
> describing what ip block it is.

Is it easy to way to find it out?

M


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
