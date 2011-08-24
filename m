Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1HXLMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:12:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42358 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1HXLMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:12:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110824110826.GD23757@pulham.picochip.com>
References: <1314183181-4197-1-git-send-email-jason.hui@linaro.org>
	<20110824110826.GD23757@pulham.picochip.com>
Date: Wed, 24 Aug 2011 19:12:05 +0800
Message-ID: <CAB4PhKdjOpSsEKD6RyajEYajaApB2ifKPMLXwBxGb5WxQGJSfg@mail.gmail.com>
Subject: Re: [PATCH] mtd: check parts pointer before using it
From: Jason Liu <liu.h.jason@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Jason Liu <jason.hui@linaro.org>, linux-arm-kernel@lists.infradead.org,
        dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        David.Woodhouse@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/24 Jamie Iles <jamie@jamieiles.com>:
> Hi Jason,
>
> On Wed, Aug 24, 2011 at 06:53:01PM +0800, Jason Liu wrote:
>> The code has the check for parts but it called after kmemdup,
>> kmemdup(parts, sizeof(*parts) * nr_parts,...)
>> if (!parts)
>>       return -ENOMEM
>>
>> In fact, we need check parts before safely using it.
>>
>> Signed-off-by: Jason Liu <jason.hui@linaro.org>
>> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> Cc: Artem Bityutskiy <artem.bityutskiy@intel.com>
>>
>> ---
>> This patch is based on git://git.infradead.org/users/dedekind/l2-mtd-2.6.git
>> ---
>>  drivers/mtd/mtdcore.c |    4 +---
>>  1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
>> index 09bdbac..ce59ff5 100644
>> --- a/drivers/mtd/mtdcore.c
>> +++ b/drivers/mtd/mtdcore.c
>> @@ -465,12 +465,10 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char **types,
>>       struct mtd_partition *real_parts;
>>
>>       err = parse_mtd_partitions(mtd, types, &real_parts, parser_data);
>> -     if (err <= 0 && nr_parts) {
>> +     if (err <= 0 && nr_parts && !parts) {
>
> I don't think this is right.  Don't we want to check that parts is !=
> NULL?  So
>
>        if (err <= 0 && nr_parts && parts)
>
> instead?  We don't want to kmemdup() NULL.

My bad,  I type it error. Thanks for it.

>
>>               real_parts = kmemdup(parts, sizeof(*parts) * nr_parts,
>>                                    GFP_KERNEL);
>>               err = nr_parts;
>> -             if (!parts)
>> -                     err = -ENOMEM;
>
> I think this hunk should be changed to:
>
>                if (!real_parts)
>                        err = -ENOMEM;
>
> and keep the check so that we're checking kmemdup()'s allocation is
> successful.

Yes, correct. Thanks,

>
> Jamie
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
