Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1FVFAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 01:00:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40435 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab1FVFAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 01:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vN8PPkBchpKvNvtJbGinSRPvXWYJlCCi6CXJyB2NYF2GqQ4lQofF8YMalqtrGZPZr2
         jcTk2PSk0eVVU5hhLeo7j4aIcuw9Ace5KJ/BxcTRPqcZU8YWCLxMBKk/TGhCVcnYrov6
         WfHwz7AQwgcw9VvokJ7SdYXk1iQ/hFoLfiPpU=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20110621105033.GF22177@opensource.wolfsonmicro.com>
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>
	<1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
	<1308622033-2521-5-git-send-email-myungjoo.ham@samsung.com>
	<20110621105033.GF22177@opensource.wolfsonmicro.com>
Date: Wed, 22 Jun 2011 14:00:37 +0900
X-Google-Sender-Auth: 322NXtn_BoISfsqZJFbe9VZZps0
Message-ID: <BANLkTi=eBAGCADe1MTdtQ4XnBVpHK+uUNA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] Exynos4 NURI: support for NTC thermistor
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, dg77.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 7:50 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jun 21, 2011 at 11:07:13AM +0900, MyungJoo Ham wrote:
>
>> +#include <linux/platform_data/ntc_thermistor.h>
>
> This doesn't appear to be in mainline.

Right, not just yet. I should've added comment about the patch just
being applied to "next".

I've added it as it was told to be applied to "next" in lm-sensors by
Guenter Roeck yesterday.
http://comments.gmane.org/gmane.linux.drivers.sensors/26475

Should I surround them with "#ifdef CONFIG_NTC_THERMISTOR"?

>
>> +/* NTC Thermistor */
>> +static struct platform_device nuri_ncp15wb473_thermistor;
>> +static int read_thermistor_uV(void)
>
> Blank line between these two.
>

got it.

>> +{
>> +     static struct s3c_adc_client *adc;
>> +     int val;
>> +     s64 converted;
>> +
>> +     if (!adc) {
>> +             adc = s3c_adc_register(&nuri_ncp15wb473_thermistor,
>> +                             NULL, NULL, 0);
>> +             if (IS_ERR_OR_NULL(adc)) {
>> +                     pr_err("%s: Cannot get adc.\n", __func__);
>> +                     return adc ? PTR_ERR(adc) : -ENODEV;
>> +             }
>> +     }
>
> Why not do this in an initcall or in the device registration?  This
> looks like working around a limitation of the ntc_thermistor driver
> which should be fixed as part of a mainline merge for that.

Um... I think I can put this away to a common plat-samsung/dev-ntc.c
as I've seen many S5PC110/S5PV210/Exynos4 devices using NTC attached
to the CPU's ADC ports.

However, I won't be able to put that part into the NTC driver because
using S3C-ADC is plat-samsung specific method and NTC thermistor
itself is a general thermistor device not specific to S3C. Maybe, I
can do so after we've got a common ADC framework.

>
>> +
>> +     if (IS_ERR_OR_NULL(adc))
>> +             return adc ? PTR_ERR(adc) : -ENODEV;
>> +
>> +     val = s3c_adc_read(adc, 6);
>> +
>> +     converted = 3300000LL * (s64) val;
>> +     converted >>= 12;
>> +
>> +     pr_emerg("%s: %d -> %llduV\n", __func__, val, converted);
>
> This looks like debug that was left in by mistake.
>

Oh.. yes.. thanks. I need to remove that.


-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
