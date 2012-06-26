Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2FZJ1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:27:49 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:40011 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab2FZJ1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:27:47 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120626090825.GI30406@opensource.wolfsonmicro.com>
References: <1340697707.12992.1.camel@phoenix> <20120626090825.GI30406@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 26 Jun 2012 17:27:26 +0800
Message-ID: <CAF+7xWnJo3VrZ+iH4BJHkTmo5+D9ttZ1n1Tm0KMPQqK1sKD7wQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: arizona-micsupp: Fix choosing selector in arizona_micsupp_map_voltage
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Jun 26, 2012 at 04:01:47PM +0800, Axel Lin wrote:
>
>> +     if (min_uV > 3300000)
>> +             return -EINVAL;
>> +
>
> This is OK but I think we want to factor this out into the caller as
> we're implementing this limits check in a lot of places.

It seems most of the new code are calling list_voltage() in
map_voltage to ensure
the selected voltage are still in bound.
But in this  case, current actually set selector to
ARIZONA_MICSUPP_MAX_SELECTOR in map_voltage() if
min_uV >= 3300000. calling list_voltage() still returns valid voltage
for this case looks wrong to me.

>
>> -     if (min_uV >= 3300000)
>> +     if (min_uV > 3200000)
>>               selector = ARIZONA_MICSUPP_MAX_SELECTOR;
>>       else
>>               selector = DIV_ROUND_UP(min_uV - 1700000, 50000);
>
> This doesn't change anything; with version of the if statement will give
> 3.3V for a voltage between 3.2V and 3.3V as there's no gaps in the
> selector space so if we're over 3.2V we'll round up to 3.3V.

If min_uV is in the range of: 3250001~3269999,
current code uses the equation: selector = DIV_ROUND_UP(min_uV -
1700000, 50000);
Then selector will be 32.
Then arizona_micsupp_list_voltage returns -EINVAL for this case.

With this patch, the selector will be 31 for this case.
