Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1IVDYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 23:24:32 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:6948 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab1IVDYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 23:24:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] [media] at91: add code to initialize and manage the ISI_MCK for Atmel ISI driver.
Date: Thu, 22 Sep 2011 11:23:54 +0800
Message-ID: <4C79549CB6F772498162A641D92D532802CC5FEC@penmb01.corp.atmel.com>
In-Reply-To: <4E69E4BF.3030402@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] [media] at91: add code to initialize and manage the ISI_MCK for Atmel ISI driver.
Thread-Index: Acxu1/ntLyarh3FdQUmf9kuOk9wu2gJ/ei2A
References: <1315288601-22384-1-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1109060803590.14818@axis700.grange> <4E69E4BF.3030402@atmel.com>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-media@vger.kernel.org>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Sep 2011 03:23:59.0633 (UTC) FILETIME=[11A68810:01CC78D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Nicolas

On Friday, September 09, 2011 6:05 PM, Nicolas Ferre wrote:

> Le 06/09/2011 08:54, Guennadi Liakhovetski :
>> On Tue, 6 Sep 2011, Josh Wu wrote:
>> 
>>> This patch enable the configuration for ISI_MCK, which is provided by programmable clock.
>>>
>>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>>> ---
>>>  drivers/media/video/atmel-isi.c |   60 ++++++++++++++++++++++++++++++++++++++-
>>>  include/media/atmel-isi.h       |    4 ++
>>>  2 files changed, 63 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/media/video/atmel-isi.c 
>>> b/drivers/media/video/atmel-isi.c

> [..]

>>>  /* 
>>> ---------------------------------------------------------------------
>>> --*/
>>> +/* Initialize ISI_MCK clock, called by atmel_isi_probe() function */ 
>>> +static int initialize_mck(struct platform_device *pdev,
>>> +			struct atmel_isi *isi)
>>> +{
>>> +	struct device *dev = &pdev->dev;
>>> +	struct isi_platform_data *pdata = dev->platform_data;
>>> +	struct clk *pck_parent;
>>> +	int ret;
>>> +
>>> +	if (!strlen(pdata->pck_name) || !strlen(pdata->pck_parent_name))
>>> +		return -EINVAL;
>>> +
>>> +	/* ISI_MCK is provided by PCK clock */
>>> +	isi->mck = clk_get(dev, pdata->pck_name);
>> 
>> I think, it's still not what Russell meant. Look at
>> drivers/mmc/host/atmel-mci.c:
>> 
>> 	host->mck = clk_get(&pdev->dev, "mci_clk");
>> 
>> and in arch/arm/mach-at91/at91sam9g45.c they've got
>> 
>> 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.0", &mmc0_clk),
>> 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.1", &mmc1_clk),
>> 
>> where
>> 
>> #define CLKDEV_CON_DEV_ID(_con_id, _dev_id, _clk)	\
>> 	{						\
>> 		.con_id = _con_id,			\
>> 		.dev_id = _dev_id,			\
>> 		.clk = _clk,				\
>> 	}
>> 
>> I.e., in the device driver (mmc in this case) you only use the 
>> (platform) device instance, whose dev_name(dev) is then matched 
>> against one of clock lookups above, and a connection ID, which is used 
>> in case your device is using more than one clock. In the ISI case, 
>> your pck1 clock, that you seem to need here, doesn't have a clock 
>> lookup object, so, you might have to add one, and then use its connection ID.
>> 
>>> +	if (IS_ERR(isi->mck)) {
>>> +		dev_err(dev, "Failed to get PCK: %s\n", pdata->pck_name);
>>> +		return PTR_ERR(isi->mck);
>>> +	}
>>> +
>>> +	pck_parent = clk_get(dev, pdata->pck_parent_name);
>>> +	if (IS_ERR(pck_parent)) {
>>> +		ret = PTR_ERR(pck_parent);
>>> +		dev_err(dev, "Failed to get PCK parent: %s\n",
>>> +				pdata->pck_parent_name);
>>> +		goto err_init_mck;
>>> +	}
>>> +
>>> +	ret = clk_set_parent(isi->mck, pck_parent);
>> 
>> I'm not entirely sure on this one, but as we had a similar situation 
>> with clocks, we decided to extablish the clock hierarchy in the board 
>> code, and only deal with the actual device clocks in the driver 
>> itself. I.e., we moved all clk_set_parent() and setting up the parent clock into the board.
>> And I do think, this makes more sense, than doing this in the driver, 
>> not all users of this driver will need to manage the parent clock, right?

> Exactly.
>
> Josh, for the two comments by Guennadi above, you can take sound/soc/atmel/sam9g20_wm8731.c as an example of using PCK and parent clocks. You will also find how to use named clocks and how to set the programmable clocks rate...

According to sam9g20_wm8731.c file, and combined Guennadi and J.C's advices, I'd like to only add clk_set_rate() and enable/disble isi_mck code in ISI driver. 
Also I will define isi_mck clock in soc chip file(at91sam9g45.c).
Then I will move all setting up the parent clock code into the at91sam9g45_devices.c, where there are code to add Atmel ISI device.

I will generate the new version patch for it soon.

>>> +	clk_put(pck_parent);
>>> +	if (ret)
>>> +		goto err_init_mck;
>>> +
>>> +	ret = clk_set_rate(isi->mck, pdata->isi_mck_hz);
>>> +	if (ret < 0)
>>> +		goto err_init_mck;
>>> +
>>> +	return 0;
>>> +
>>> +err_init_mck:
>>> +	clk_put(isi->mck);
>>> +	return ret;
>>> +}
>>> +
>>>  static int __devexit atmel_isi_remove(struct platform_device *pdev)  
>>> {
>>>  	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev); 
>>> @@ -897,6 +948,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
>>>  			isi->fb_descriptors_phys);
>>>  
>>>  	iounmap(isi->regs);
>>> +	clk_put(isi->mck);
>>>  	clk_put(isi->pclk);
>>>  	kfree(isi);

> [..]

> Best regards,
> --
> Nicolas Ferre

Best Regards,
Josh Wu
