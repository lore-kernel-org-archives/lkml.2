Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2L2TZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 14:25:27 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:60404 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2L2TZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 14:25:25 -0500
MIME-Version: 1.0
In-Reply-To: <20121227182401.GA6306@opensource.wolfsonmicro.com>
References: <1356083238-6932-1-git-send-email-andrew.smirnov@gmail.com>
	<1356083238-6932-4-git-send-email-andrew.smirnov@gmail.com>
	<20121227182401.GA6306@opensource.wolfsonmicro.com>
Date: Sat, 29 Dec 2012 11:18:11 -0800
Message-ID: <CAHQ1cqEMOJ-EWAFz9C0TjLypW7dVO0Aq0HM+sMdjrMYOqzc1Jg@mail.gmail.com>
Subject: Re: [PATCH 3/3] Add "no-bus" option for regmap API
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "andrey.smirnov@convergeddevices.net" 
	<andrey.smirnov@convergeddevices.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -     int (*reg_read)(struct regmap *map, unsigned int reg, unsigned int *val);
>> -     int (*reg_write)(struct regmap *map, unsigned int reg, unsigned int val);
>> +     int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
>> +     int (*reg_write)(void *context, unsigned int reg, unsigned int val);
>
> I'd be inclined to just do this in the initial refectoring patches
> rather than rerefactoring here.

I agree. I realized that I would have to have those parameters as
"void *" only after I made first two commits and since I knew that the
first version of the patch would have other problems decided to
postpone fixing this till the second version of the patch.

>
>> +     if (!bus || !bus->fast_io) {
>>               mutex_init(&map->mutex);
>>               map->lock = regmap_lock_mutex;
>>               map->unlock = regmap_unlock_mutex;
>> +     } else {
>> +             spin_lock_init(&map->spinlock);
>> +             map->lock = regmap_lock_spinlock;
>> +             map->unlock = regmap_unlock_spinlock;
>
> It's not immediately obvious to me that no-bus should be forced to use
> mutexes - is there any great reason for tying the two together?

No reason. I'll add provisions for configuring.

>
>> +     if (!bus) {
>> +             map->cache_registers = true;
>> +             goto skip_format_initialization;
>> +     } else {
>> +             map->reg_read = _regmap_bus_read;
>> +     }
>
> Not sure I understand cache_registers here.  Why has this flag been
> added?

As of now when the write operation is performed("_regmap_write" is
being called) the caching is handled either in "_regmap_write" or in
"_regmap_raw_write". The decision which one of the two places it will
be done at is made based on the availability of the
"map->format.format_write". With the addition of "no-bus"
configuration "map->format.format_write" is no longer a valid
criterion for that decision and since caching writes makes sense for
"no-bus" configuration too, I added this variable to serve as flag so
that caching would be handled in "_regmap_write" for "no-bus"
configuration and for busses with "map->format.format_write" and in
"_regmap_raw_write" for all the other cases.


>> + * @reg_read: Optional callback that if filled will be used to perform
>> + *            all the reads from the registers.
>> + * @reg_write: Optional callback that if filled will be used to perform
>> + *             all the writes to the registers.
>
> I'd probably add some comment about not using this in conjunction with
> SPI or I2C.

Will do.
