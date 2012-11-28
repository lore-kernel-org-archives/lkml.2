Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab2K1CJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:09:44 -0500
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:35263 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab2K1CJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:09:43 -0500
Message-ID: <50B572B7.6010205@marvell.com>
Date: Wed, 28 Nov 2012 10:11:03 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 6/7] mfd: max8925: support dt for backlight
References: <1352188034-9982-1-git-send-email-qingx@marvell.com> <CAN1soZw5RDN+wRacR1YTMqQfy5SNAg_KzGDt+77846M8Qk_7sw@mail.gmail.com>
In-Reply-To: <CAN1soZw5RDN+wRacR1YTMqQfy5SNAg_KzGDt+77846M8Qk_7sw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2012 02:09:30.0527 (UTC) FILETIME=[66B8D2F0:01CDCD0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 05:08 PM, Haojian Zhuang wrote:
> On Tue, Nov 6, 2012 at 3:47 PM, Qing Xu <qingx@marvell.com> wrote:
>> From: Qing Xu <qingx@marvell.com>
>>
>> Signed-off-by: Qing Xu <qingx@marvell.com>
>> ---
>>   drivers/video/backlight/max8925_bl.c |   31 ++++++++++++++++++++++++++++++-
>>   1 files changed, 30 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
>> index f72ba54..7de02ed 100644
>> --- a/drivers/video/backlight/max8925_bl.c
>> +++ b/drivers/video/backlight/max8925_bl.c
>> @@ -101,6 +101,29 @@ static const struct backlight_ops max8925_backlight_ops = {
>>          .get_brightness = max8925_backlight_get_brightness,
>>   };
>>
>> +#ifdef CONFIG_OF
>> +static int max8925_backlight_dt_init(struct platform_device *pdev,
>> +                             struct max8925_backlight_pdata *pdata)
>> +{
>> +       struct device_node *nproot = pdev->dev.parent->of_node, *np;
>> +       int dual_string;
>> +
>> +       if (!nproot)
>> +               return -ENODEV;
>> +       np = of_find_node_by_name(nproot, "backlight");
>> +       if (!np) {
>> +               dev_err(&pdev->dev, "failed to find backlight node\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       of_property_read_u32(np, "dual-string", &dual_string);
> Please use the property like "maxium,max8925-dual-string" at here. It's used
> to avoid naming conflict.

patch updated in v2, and dts patch update in v3

>> +       pdata->dual_string = dual_string;
>> +       return 0;
>> +}
>> +#else
>> +#define max8925_backlight_dt_init(x, y)        (-1)
>> +#endif
>> +
>>   static int __devinit max8925_backlight_probe(struct platform_device *pdev)
>>   {
>>          struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
>> @@ -150,6 +173,13 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
>>          platform_set_drvdata(pdev, bl);
>>
>>          value = 0;
>> +       if (pdev->dev.parent->of_node && !pdata) {
>> +               pdata = devm_kzalloc(&pdev->dev,
>> +                                    sizeof(struct max8925_backlight_pdata),
>> +                                    GFP_KERNEL);
>> +               max8925_backlight_dt_init(pdev, pdata);
>> +       }
>> +
>>          if (pdata) {
>>                  if (pdata->lxw_scl)
>>                          value |= (1 << 7);
>> @@ -161,7 +191,6 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
>>          ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 0xfe, value);
>>          if (ret < 0)
>>                  goto out_brt;
>> -
>>          backlight_update_status(bl);
>>          return 0;
>>   out_brt:
>> --
>> 1.7.0.4
>>

