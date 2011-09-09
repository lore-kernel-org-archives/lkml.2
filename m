Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab1IIKFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:05:06 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:42052 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167Ab1IIKFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:05:04 -0400
Message-ID: <4E69E4BF.3030402@atmel.com>
Date: Fri, 09 Sep 2011 12:04:47 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] at91: add code to initialize and manage the
 ISI_MCK for Atmel ISI driver.
References: <1315288601-22384-1-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1109060803590.14818@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109060803590.14818@axis700.grange>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06/09/2011 08:54, Guennadi Liakhovetski :
> On Tue, 6 Sep 2011, Josh Wu wrote:
> 
>> This patch enable the configuration for ISI_MCK, which is provided by programmable clock.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>  drivers/media/video/atmel-isi.c |   60 ++++++++++++++++++++++++++++++++++++++-
>>  include/media/atmel-isi.h       |    4 ++
>>  2 files changed, 63 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c

[..]

>>  /* -----------------------------------------------------------------------*/
>> +/* Initialize ISI_MCK clock, called by atmel_isi_probe() function */
>> +static int initialize_mck(struct platform_device *pdev,
>> +			struct atmel_isi *isi)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct isi_platform_data *pdata = dev->platform_data;
>> +	struct clk *pck_parent;
>> +	int ret;
>> +
>> +	if (!strlen(pdata->pck_name) || !strlen(pdata->pck_parent_name))
>> +		return -EINVAL;
>> +
>> +	/* ISI_MCK is provided by PCK clock */
>> +	isi->mck = clk_get(dev, pdata->pck_name);
> 
> I think, it's still not what Russell meant. Look at 
> drivers/mmc/host/atmel-mci.c:
> 
> 	host->mck = clk_get(&pdev->dev, "mci_clk");
> 
> and in arch/arm/mach-at91/at91sam9g45.c they've got
> 
> 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.0", &mmc0_clk),
> 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.1", &mmc1_clk),
> 
> where
> 
> #define CLKDEV_CON_DEV_ID(_con_id, _dev_id, _clk)	\
> 	{						\
> 		.con_id = _con_id,			\
> 		.dev_id = _dev_id,			\
> 		.clk = _clk,				\
> 	}
> 
> I.e., in the device driver (mmc in this case) you only use the (platform) 
> device instance, whose dev_name(dev) is then matched against one of clock 
> lookups above, and a connection ID, which is used in case your device is 
> using more than one clock. In the ISI case, your pck1 clock, that you seem 
> to need here, doesn't have a clock lookup object, so, you might have to 
> add one, and then use its connection ID.
> 
>> +	if (IS_ERR(isi->mck)) {
>> +		dev_err(dev, "Failed to get PCK: %s\n", pdata->pck_name);
>> +		return PTR_ERR(isi->mck);
>> +	}
>> +
>> +	pck_parent = clk_get(dev, pdata->pck_parent_name);
>> +	if (IS_ERR(pck_parent)) {
>> +		ret = PTR_ERR(pck_parent);
>> +		dev_err(dev, "Failed to get PCK parent: %s\n",
>> +				pdata->pck_parent_name);
>> +		goto err_init_mck;
>> +	}
>> +
>> +	ret = clk_set_parent(isi->mck, pck_parent);
> 
> I'm not entirely sure on this one, but as we had a similar situation with 
> clocks, we decided to extablish the clock hierarchy in the board code, and 
> only deal with the actual device clocks in the driver itself. I.e., we 
> moved all clk_set_parent() and setting up the parent clock into the board. 
> And I do think, this makes more sense, than doing this in the driver, not 
> all users of this driver will need to manage the parent clock, right?

Exactly.

Josh, for the two comments by Guennadi above, you can take
sound/soc/atmel/sam9g20_wm8731.c
as an example of using PCK and parent clocks. You will also find how to
use named clocks and how to set the programmable clocks rate...

>> +	clk_put(pck_parent);
>> +	if (ret)
>> +		goto err_init_mck;
>> +
>> +	ret = clk_set_rate(isi->mck, pdata->isi_mck_hz);
>> +	if (ret < 0)
>> +		goto err_init_mck;
>> +
>> +	return 0;
>> +
>> +err_init_mck:
>> +	clk_put(isi->mck);
>> +	return ret;
>> +}
>> +
>>  static int __devexit atmel_isi_remove(struct platform_device *pdev)
>>  {
>>  	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
>> @@ -897,6 +948,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
>>  			isi->fb_descriptors_phys);
>>  
>>  	iounmap(isi->regs);
>> +	clk_put(isi->mck);
>>  	clk_put(isi->pclk);
>>  	kfree(isi);

[..]

Best regards,
-- 
Nicolas Ferre

