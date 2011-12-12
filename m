Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab1LLGAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 01:00:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60697 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1LLGAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 01:00:42 -0500
X-AuditID: cbfee60c-b7ce9ae0000078f9-9a-4ee5988403e2
Date: Mon, 12 Dec 2011 06:00:36 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Fwd: Re: [PATCH v2 1/6] max17042: Move power suppply registration to a
 worker thread
To: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Jason.Wortham@maxim-ic.com" <Jason.Wortham@maxim-ic.com>,
        myungjoo.ham@gmail.com
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111212055619511@myungjoo.ham
Msgkey: 20111212055619511@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111212014141375@myungjoo.ham
X-ParentMTR: 20111212014141375@myungjoo.ham
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <18429425.482911323669636188.JavaMail.weblogic@epml15>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBC60w2c016441

> Sender : dirk.brandewie@gmail.com<dirk.brandewie@gmail.com>
> Date : 2011-12-10 03:08 (GMT+09:00)
> Title : [PATCH v2 1/6] max17042: Move power suppply registration to a worker thread
> > From: Dirk Brandewie <dirk.brandewie@gmail.com>
> > 
> > This patch move the final registration of the battery to a worker
> > thread in preperation for adding the POR proceedure recommended by
> > maxim. This is needed since the Maxim init proceedure requires two
> > long delays totaling 850ms. This patch will reduce the impact on
> > system boot time.  The battery will not be available to the power
> > supply subsystem until the init proceedure is complete
> > 
> > Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> The commit message is not updated for v2 patchset. 
> 
> Besides, (sorry to report this now, I've just reminded this.) MAX17042 has a POR status bit according to the manual describing STATUS register (0x00). You need to do POR reset only when it is actually POR to MAX17042, not to CPU. At normal CPU shutdown/boot-up, POR procedure is not required as MAX17042 is not "rebooted". It is required only when the battery is suspected to be replaced. Thus, I tihink scheduling work and waiting for init_complete is required if POR is true.

Reading the code again, I've found that the patch actually skips POR sequence (most of max17042_init_chip()) if POR of STATUS is not set. So please never mind the second paragraph.

However, still, when POR is not set, I think the probe function would be better if it does not schedule a work, but set the required registers and irq and return with everything ready (init_complete = 1).

> 
> Cheers!
> MyungJoo
> 
> > ---
> >  drivers/power/max17042_battery.c |   48 ++++++++++++++++++++++++++------------
> >  1 files changed, 33 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
> > index 9f0183c..16f3934 100644
> > --- a/drivers/power/max17042_battery.c
> > +++ b/drivers/power/max17042_battery.c
> > @@ -34,6 +34,8 @@ struct max17042_chip {
> >  	struct i2c_client *client;
> >  	struct power_supply battery;
> >  	struct max17042_platform_data *pdata;
> > +	struct work_struct work;
> > +	int    init_complete;
> >  };
> >  
> >  static int max17042_write_reg(struct i2c_client *client, u8 reg, u16 value)
> > @@ -86,6 +88,9 @@ static int max17042_get_property(struct power_supply *psy,
> >  	struct max17042_chip *chip = container_of(psy,
> >  				struct max17042_chip, battery);
> >  
> > +	if (!chip->init_complete)
> > +		return -EAGAIN;
> > +
> >  	switch (psp) {
> >  	case POWER_SUPPLY_PROP_PRESENT:
> >  		val->intval = max17042_read_reg(chip->client,
> > @@ -180,6 +185,31 @@ static int max17042_get_property(struct power_supply *psy,
> >  	return 0;
> >  }
> >  
> > +static void max17042_init_worker(struct work_struct *work)
> > +{
> > +	struct max17042_chip *chip = container_of(work,
> > +				struct max17042_chip, work);
> > +	struct i2c_client *client = chip->client;
> > +	int ret;
> > +
> > +
> > +	/* Initialize registers according to values from the platform data */
> > +	if (chip->pdata->init_data)
> > +		max17042_set_reg(client, chip->pdata->init_data,
> > +				 chip->pdata->num_init_data);
> > +
> > +	if (!chip->pdata->enable_current_sense) {
> > +		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
> > +		max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
> > +		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
> > +	} else {
> > +		if (chip->pdata->r_sns == 0)
> > +			chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
> > +	}
> > +
> > +	chip->init_complete = 1;
> > +}
> > +
> >  static int __devinit max17042_probe(struct i2c_client *client,
> >  			const struct i2c_device_id *id)
> >  {
> > @@ -214,24 +244,12 @@ static int __devinit max17042_probe(struct i2c_client *client,
> >  	if (ret) {
> >  		dev_err(&client->dev, "failed: power supply register\n");
> >  		kfree(chip);
> > -		return ret;
> > -	}
> > -
> > -	/* Initialize registers according to values from the platform data */
> > -	if (chip->pdata->init_data)
> > -		max17042_set_reg(client, chip->pdata->init_data,
> > -				 chip->pdata->num_init_data);
> > -
> > -	if (!chip->pdata->enable_current_sense) {
> > -		max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
> > -		max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
> > -		max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
> >  	} else {
> > -		if (chip->pdata->r_sns == 0)
> > -			chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
> > +		INIT_WORK(&chip->work, max17042_init_worker);
> > +		schedule_work(&chip->work);
> >  	}
> >  
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  static int __devexit max17042_remove(struct i2c_client *client)
> > -- 
> > 1.7.7.3
> > 
> 
> 
> 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
