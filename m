Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1JMLyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:54:33 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:17008 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab1JMLyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:54:32 -0400
Message-ID: <4E96D161.8050602@atmel.com>
Date: Thu, 13 Oct 2011 13:54:09 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] dmaengine: at_hdmac: add device tree support
References: <f91f267b82ac0f0459c11a7bdf3ab0ea8758656a.1318438197.git.nicolas.ferre@atmel.com> <6a7ec87c53609bbb517b199a9b48a5322a625aa1.1318438197.git.nicolas.ferre@atmel.com> <20111013003422.GE14042@ponder.secretlab.ca>
In-Reply-To: <20111013003422.GE14042@ponder.secretlab.ca>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 02:34 AM, Grant Likely :
> On Wed, Oct 12, 2011 at 06:57:12PM +0200, Nicolas Ferre wrote:
>> Add device tree probe support for atmel at_hdmac DMA driver.
>> Bindings are added to specify DMA controller configuration.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  .../devicetree/bindings/dma/atmel-dma.txt          |   14 +++++++++
>>  drivers/dma/at_hdmac.c                             |   30 +++++++++++++++++++-
>>  2 files changed, 43 insertions(+), 1 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/dma/atmel-dma.txt
>>
>> diff --git a/Documentation/devicetree/bindings/dma/atmel-dma.txt b/Documentation/devicetree/bindings/dma/atmel-dma.txt
>> new file mode 100644
>> index 0000000..3c046ee
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/dma/atmel-dma.txt
>> @@ -0,0 +1,14 @@
>> +* Atmel Direct Memory Access Controller (DMA)
>> +
>> +Required properties:
>> +- compatible: Should be "atmel,<chip>-dma"
>> +- reg: Should contain DMA registers location and length
>> +- interrupts: Should contain DMA interrupt
>> +
>> +Examples:
>> +
>> +dma@ffffec00 {
>> +	compatible = "atmel,at91sam9g45-dma";
>> +	reg = <0xffffec00 0x200>;
>> +	interrupts = <21>;
>> +};
>> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
>> index d1869c5..42bd64c 100644
>> --- a/drivers/dma/at_hdmac.c
>> +++ b/drivers/dma/at_hdmac.c
>> @@ -23,6 +23,8 @@
>>  #include <linux/module.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/slab.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>>  
>>  #include "at_hdmac_regs.h"
>>  
>> @@ -1175,6 +1177,20 @@ static void atc_free_chan_resources(struct dma_chan *chan)
>>  
>>  /*--  Module Management  -----------------------------------------------*/
>>  
>> +#if defined(CONFIG_OF)
>> +static const struct of_device_id atmel_dma_dt_ids[] = {
>> +	{
>> +		.compatible = "atmel,at91sam9rl-dma",
>> +		.data = (void *)ATDMA_DEVTYPE_SAM9RL
>> +	}, {
>> +		.compatible = "atmel,at91sam9g45-dma",
>> +		.data = (void *)ATDMA_DEVTYPE_SAM9G45
>> +	}, { /* sentinel */ }
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, atmel_dma_dt_ids);
>> +#endif
>> +
>>  static struct platform_device_id atdma_devtypes[] = {
>>  	{
>>  		.name = "at91sam9rl_dma",
>> @@ -1187,6 +1203,17 @@ static struct platform_device_id atdma_devtypes[] = {
>>  	}
>>  };
>>  
>> +static inline enum atdma_devtype __init at_dma_get_driver_data(
>> +					struct platform_device *pdev)
>> +{
>> +	if (pdev->dev.of_node) {
>> +		const struct of_device_id *match;
>> +		match = of_match_node(atmel_dma_dt_ids, pdev->dev.of_node);
> 
> You'll need to check the return value.  It is possible (though
> unlikely) to have a device with an of_node but still happens to get
> bound via the platform_driver id_table.  In which case match would be
> NULL here.

Ok, I add:

                if (match == NULL)
                        return ATDMA_DEVTYPE_UNDEFINED;

Which will take care about this case.


> Otherwise, you can add my a-b after fixing that bug.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Thanks a lot for your reviews Grant,

Bye,
-- 
Nicolas Ferre
