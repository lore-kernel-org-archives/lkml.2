Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1K2BXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 20:23:34 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44000 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1K2BXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 20:23:33 -0500
X-AuditID: cbfee60b-b7d02ae000002393-e3-4ed434132b03
Date: Tue, 29 Nov 2011 01:23:31 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/4] max17042: Move power suppply registration to a worker
 thread
To: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Jason.Wortham@maxim-ic.com" <Jason.Wortham@maxim-ic.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111129011938934@myungjoo.ham
Msgkey: 20111129011938934@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111129011938934@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <4160559.99391322529810526.JavaMail.weblogic@epml27>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAT1NkdK003899

Sender : dirk.brandewie@gmail.com<dirk.brandewie@gmail.com>
Date : 2011-11-29 04:49 (GMT+09:00)
Title : [PATCH 1/4] max17042: Move power suppply registration to a worker thread
> 
> From: Dirk Brandewie 
> 
> This patch move the final registration of the battery to a worker
> thread in preperation for adding the POR proceedure recommended by
> maxim. This is needed since the Maxim init proceedure requires two
> long delays totaling 850ms. This patch will reduce the impact on
> system boot time.  The battery will not be available to the power
> supply subsystem until the init proceedure is complete
> 
> Signed-off-by: Dirk Brandewie 

Hello.

Could you please move "ret = power_supply_register(&client->dev, &chip->battery);" back to max17042_probe()?

That will enable other depending devices to probe without much concerning about synchronizing probe time.

For the data availability, max17042 can return -EAGAIN with its property function when its init function is not complete.


Cheers!
MyungJoo.

> ---
> drivers/power/max17042_battery.c |   53 +++++++++++++++++++++++---------------
> 1 files changed, 32 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
> index 9f0183c..33fdce0 100644
> --- a/drivers/power/max17042_battery.c
> +++ b/drivers/power/max17042_battery.c
> @@ -34,6 +34,7 @@ struct max17042_chip {
> struct i2c_client *client;
> struct power_supply battery;
> struct max17042_platform_data *pdata;
> + struct work_struct work;
> };
> 
> static int max17042_write_reg(struct i2c_client *client, u8 reg, u16 value)
> @@ -180,12 +181,40 @@ static int max17042_get_property(struct power_supply *psy,
> return 0;
> }
> 
> +static void max17042_init_worker(struct work_struct *work)
> +{
> + struct max17042_chip *chip = container_of(work,
> + struct max17042_chip, work);
> + struct i2c_client *client = chip->client;
> + int ret;
> +
> +
> + /* Initialize registers according to values from the platform data */
> + if (chip->pdata->init_data)
> + max17042_set_reg(client, chip->pdata->init_data,
> + chip->pdata->num_init_data);
> +
> + if (!chip->pdata->enable_current_sense) {
> + max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
> + max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
> + max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
> + } else {
> + if (chip->pdata->r_sns == 0)
> + chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
> + }
> +
> + ret = power_supply_register(&client->dev, &chip->battery);
> + if (ret) {
> + dev_err(&client->dev, "failed: power supply register ");
> + kfree(chip);
> + }
> +}
> +
> static int __devinit max17042_probe(struct i2c_client *client,
> const struct i2c_device_id *id)
> {
> struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> struct max17042_chip *chip;
> - int ret;
> 
> if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
> return -EIO;
> @@ -210,26 +239,8 @@ static int __devinit max17042_probe(struct i2c_client *client,
> if (!chip->pdata->enable_current_sense)
> chip->battery.num_properties -= 2;
> 
> - ret = power_supply_register(&client->dev, &chip->battery);
> - if (ret) {
> - dev_err(&client->dev, "failed: power supply register ");
> - kfree(chip);
> - return ret;
> - }
> -
> - /* Initialize registers according to values from the platform data */
> - if (chip->pdata->init_data)
> - max17042_set_reg(client, chip->pdata->init_data,
> - chip->pdata->num_init_data);
> -
> - if (!chip->pdata->enable_current_sense) {
> - max17042_write_reg(client, MAX17042_CGAIN, 0x0000);
> - max17042_write_reg(client, MAX17042_MiscCFG, 0x0003);
> - max17042_write_reg(client, MAX17042_LearnCFG, 0x0007);
> - } else {
> - if (chip->pdata->r_sns == 0)
> - chip->pdata->r_sns = MAX17042_DEFAULT_SNS_RESISTOR;
> - }
> + INIT_WORK(&chip->work, max17042_init_worker);
> + schedule_work(&chip->work);
> 
> return 0;
> }
> -- 
> 1.7.7.3
> 
> 




 MyungJoo Ham (ÇÔ¸íÁÖ)

Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
