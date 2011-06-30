Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1F3JDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 05:03:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab1F3JDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:03:08 -0400
MIME-Version: 1.0
In-Reply-To: <201106301122.50800.anarsoul@gmail.com>
References: <1309420175-10301-1-git-send-email-myungjoo.ham@samsung.com>
	<1309420175-10301-2-git-send-email-myungjoo.ham@samsung.com>
	<201106301122.50800.anarsoul@gmail.com>
Date: Thu, 30 Jun 2011 18:03:06 +0900
Message-ID: <BANLkTimwqF3APEbJnTGcO5mh+AnS=N787g@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] Samsung SoC ADC: use regulator (VDD for ADC).
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassi.brar@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Seungwhan Youn <sw.youn@samsung.com>,
        Changhwan Youn <chaos.youn@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 5:22 PM, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> On Thursday 30 June 2011 10:49:30 MyungJoo Ham wrote:
>> This patch allows the Samsung ADC driver to enable VDD regulator at
>> probe and resume and to disable at exit and suspend.
>> In a platform where ADC's VDD regulator is not "always-on", this control
>> is required although this patch does not provide fine-grained power
>> control (turning on the regulator only when being accessed).
>>
>> However, if VDD regulator ("vdd" for the adc device) is not provided,
>> the regulator control will not be activated because there are platforms
>> that do not provide regulator for ADC device.
>>
>> arch_initcall has been modified to module_init in order to allow
>> regulators to be available at probe.
>>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[]
>> +     adc->vdd = regulator_get(dev, "vdd");
>> +     if (IS_ERR(adc->vdd)) {
>> +             dev_err(dev, "operating without regulator \"vdd\" .\n");
>> +             ret = PTR_ERR(adc->vdd);
>> +             goto err_alloc;
>> +     }
>> +
>
> NACK. Make it optional, otherwise it breaks s3c24xx.
>

Ok. Now, I've got the issue I've worried in the previous patch revision.

Anyway, Mark once stated:
--- quote starts ---
On Sun, Jun 19, 2011 at 12:06 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> +     if (IS_ERR_OR_NULL(adc->vdd)) {
>> +             dev_dbg(dev, "operating without regulator %s.\n", S3C_ADC_REGULATOR_NAME);
>> +             adc->vdd = NULL; /* Do not control regulator */
>> +     }
>> +
>
> No, don't do this.  Just unconditionally assume the regulator is present
> if power is essential for use of the device.  The regulator API will
> stub out correctly if it's not in use to allow things to proceed and if
> vdd is genuinely not hooked up then the driver can't function.
--- quote ends ---

Then, how about unconditionally using ADC VDD for TYPE_ADCV3
(S5PC110/S5PV210/Exynos4210) and forget VDD for older ADC types?


Thanks.

- MyungJoo
-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
