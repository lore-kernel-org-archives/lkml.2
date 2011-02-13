Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1BMS4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 13:56:41 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33780 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754663Ab1BMS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 13:56:36 -0500
Message-ID: <4D582959.9010505@metafoo.de>
Date: Sun, 13 Feb 2011 19:56:25 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] bq27x00: Cache battery registers
References: <1297539554-13957-1-git-send-email-lars@metafoo.de>	<1297539554-13957-8-git-send-email-lars@metafoo.de> <AANLkTiks6Dy8az8qxNJm4UPzJSRSmFU0b+M6ipjSey3f@mail.gmail.com>
In-Reply-To: <AANLkTiks6Dy8az8qxNJm4UPzJSRSmFU0b+M6ipjSey3f@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/13/2011 04:14 PM, Grazvydas Ignotas wrote:
> On Sat, Feb 12, 2011 at 9:39 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> This patch adds a register cache to the bq27x00 battery driver.
>> Usually multiple, if not all, power_supply properties are queried at once,
>> for example when an uevent is generated. Since some registers are used by
>> multiple properties caching the registers should reduce the number of
>> reads.
>>
>> The cache is valid for 5 seconds this roughly matches the internal update
>> interval of the current register for the bq27000/bq27200.
>>
>> Fast changing properties(*_NOW) which can be obtained by reading a single
>> register are not cached.
>>
>> It will also be used in the follow up patch to check if the battery status
>> has been changed since the last update to emit power_supply_changed events.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> ---
>>  drivers/power/bq27x00_battery.c |  272 +++++++++++++++++++++-----------------
>>  1 files changed, 150 insertions(+), 122 deletions(-)
>>
>> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
>> index 44bc76b..0c94693 100644
>> --- a/drivers/power/bq27x00_battery.c
>> +++ b/drivers/power/bq27x00_battery.c
>> @@ -19,7 +19,6 @@
> 
> <snip>
> 
>> +static void bq27x00_update(struct bq27x00_device_info *di)
>> +{
>> +       struct bq27x00_reg_cache cache = {0, };
>> +       bool is_bq27500 = di->chip == BQ27500;
>> +
>> +       cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
>> +       if (cache.flags >= 0) {
>> +               cache.capacity = bq27x00_battery_read_rsoc(di);
>> +               cache.temperature = bq27x00_read(di, BQ27x00_REG_TEMP, false);
>> +               cache.time_to_empty = bq27x00_battery_read_time(di, BQ27x00_REG_TTE);
>> +               cache.time_to_empty_avg = bq27x00_battery_read_time(di, BQ27x00_REG_TTECP);
>> +               cache.time_to_full = bq27x00_battery_read_time(di, BQ27x00_REG_TTF);
>> +
>> +               if (!is_bq27500)
>> +                       cache.current_now = bq27x00_read(di, BQ27x00_REG_AI, false);
>>        }
>>
> 
> <snip>
> 
>> -static int bq27x00_battery_current(struct bq27x00_device_info *di)
>> +static int bq27x00_battery_current(struct bq27x00_device_info *di,
>> +       union power_supply_propval *val)
>>  {
>> -       int ret;
>> -       int curr = 0;
>> -       int flags = 0;
>> +       int curr;
>>
>> -       ret = bq27x00_read(di, BQ27x00_REG_AI, &curr, false);
>> -       if (ret) {
>> -               dev_err(di->dev, "error reading current\n");
>> -               return 0;
>> -       }
>> +       if (di->chip == BQ27000)
>> +           curr = bq27x00_read(di, BQ27x00_REG_AI, false);
>> +       else
>> +           curr = di->cache.current_now;
> 
> You're updating current_now in cache if it's not bq27500, but
> bypassing cache for bq27000?

Right, that should of course be ' == BQ27500'

> 
> Why do you still want to cache the current while you are no longer
> caching voltage, because it needs 2 register reads I guess?

Yes. I've given it some though and I would rather avoid the chance of returning
bogus values, because the AI register is already updated, but flags still
contains the old state.

- - Lars
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1YKVgACgkQBX4mSR26RiNi6QCfRofHUac7YILVEA1LI9jZFodA
thcAnR6mTEN4/Mo+PUUuuqpa7msdRwyo
=YAr6
-----END PGP SIGNATURE-----
