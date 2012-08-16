Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2HPKfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:35:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53518 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab2HPKfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120816112507.01b7c0f0@pixies.home.jungo.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
 <1345043331.3393.151.camel@sauron.fi.intel.com> <20120816112507.01b7c0f0@pixies.home.jungo.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 16 Aug 2012 12:35:23 +0200
Message-ID: <CACQ1gAi+dDFBrLM0-cVAsFu6_7B3=ij9Lqm3W+SHCxTRSE9kww@mail.gmail.com>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get bad_peb_limit
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: dedekind1@gmail.com, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/16 Shmulik Ladkani <shmulik.ladkani@gmail.com>:
> Hi Artem, Richard,
>
> On Wed, 15 Aug 2012 18:08:51 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
>> 1. Invalid blocks are block that contain one or more bad bits beyond
>> ECC.
>
> I would remove this one sentence from the log, it is misleading; invalid
> blocks are not necessarily related to ECC.
I agree (even if this sentence is from a nand datasheet !)

>
>>               if (CONFIG_MTD_UBI_BEB_LIMIT > 0) {
>> -                     int percent = CONFIG_MTD_UBI_BEB_LIMIT;
>> -                     int limit = mult_frac(ubi->peb_count, percent, 100);
>> +                     int per1024 = CONFIG_MTD_UBI_BEB_LIMIT;
>> +                     int limit, device_pebs;
>> +                     uint64_t device_size;
>> +
>> +                     /*
>> +                      * Here we are using size of the entire flash chip and
>> +                      * not just the MTD partition size because the maximum
>> +                      * number of bad eraseblocks is a percentage of the
>> +                      * whole device and bad eraseblocks are not fairly
>> +                      * distributed over the flash chip. So the worst case
>> +                      * is that all the bad eraseblocks of the chip are in
>> +                      * the MTD partition we are attaching (ubi->mtd).
>> +                      */
>> +                     device_size = mtd_get_device_size(ubi->mtd);
>> +                     device_pebs = mtd_div_by_eb(device_size, ubi->mtd);
>> +                     limit = mult_frac(device_pebs, per1024, 1024);
>>
>>                       /* Round it up */
>> -                     if (mult_frac(limit, 100, percent) < ubi->peb_count)
>> +                     if (mult_frac(limit, 1024, per1024) < ubi->peb_count)
>
> Oops... should be:
>
> +                       if (mult_frac(limit, 1024, per1024) < device_pebs)
>
> Regards,
> Shmulik
Ok, I'll change that, may be in a separate patch, as it's a bug fix.
I'll add your signoff.

thanks !


-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
