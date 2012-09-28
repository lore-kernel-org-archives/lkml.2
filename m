Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab2I1Nbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:31:42 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:33600 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757996Ab2I1Nbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120928125840.GL31006@arwen.pp.htv.fi>
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
	<1348836795-4783-3-git-send-email-kishon@ti.com>
	<20120928125840.GL31006@arwen.pp.htv.fi>
Date: Fri, 28 Sep 2012 19:01:30 +0530
Message-ID: <CAAe_U6Js7jA4qhT7xGmhNHKLBHt=rnN2=MK-tT3QCmVTktQgtQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] usb: dwc3-omap: use runtime API's to enable clocks
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 28, 2012 at 6:28 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Sep 28, 2012 at 06:23:11PM +0530, Kishon Vijay Abraham I wrote:
>> Before accessing any register, runtime API's should be invoked to enable
>> the clocks. runtime API's are added here to prevent abort during register
>> access.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  drivers/usb/dwc3/dwc3-omap.c |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
>> index 34578de..6a0e17f 100644
>> --- a/drivers/usb/dwc3/dwc3-omap.c
>> +++ b/drivers/usb/dwc3/dwc3-omap.c
>> @@ -43,6 +43,7 @@
>>  #include <linux/spinlock.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/platform_data/dwc3-omap.h>
>> +#include <linux/pm_runtime.h>
>>  #include <linux/dma-mapping.h>
>>  #include <linux/ioport.h>
>>  #include <linux/io.h>
>> @@ -281,6 +282,13 @@ static int __devinit dwc3_omap_probe(struct platform_device *pdev)
>>       omap->irq       = irq;
>>       omap->base      = base;
>>
>> +     pm_runtime_enable(dev);
>> +     ret = pm_runtime_get_sync(dev);
>> +     if (ret < 0) {
>> +             dev_err(dev, "get_sync failed with err %d\n", ret);
>> +                     goto err1;
>> +     }
>> +
>>       reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
>>
>>       utmi_mode = of_get_property(node, "utmi-mode", &size);
>> @@ -354,6 +362,8 @@ err1:
>>  static int __devexit dwc3_omap_remove(struct platform_device *pdev)
>>  {
>>       device_for_each_child(&pdev->dev, NULL, dwc3_remove_core);
>> +     pm_runtime_put(&pdev->dev);
>> +     pm_runtime_disable(&pdev->dev);
>
> You're going to disable pm_runtime here, so it's better to use
> pm_runtime_put_sync(), I guess ??

sure. Will post a patch fixing it.

Thanks
Kishon
