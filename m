Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab1AaSAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:00:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44854 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1AaSAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=NWI/5cE1KdxkBwPDMTCnaVI+gs6wxF7I575NROyjUDRFVTaq0RajZ6jSRE19gLWWxq
         da+//Sc9IQfujIHRNuzygz0fP+AW2XUPIxmoKqjmpgF7JrQWzolgAUWgm2xticq4xJhC
         YY3mdqIWGfwaIw3IW8HKPdyyHgIPoVi/mvra4=
MIME-Version: 1.0
In-Reply-To: <20110131154626.GD3819@enneenne.com>
References: <20110131135417.GC3883@oksana.dev.rtsoft.ru> <20110131154626.GD3819@enneenne.com>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Mon, 31 Jan 2011 19:00:03 +0100
Message-ID: <AANLkTinh952XiJDUwBABRVjVnMK0CGt7edp4M_gtk88f@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Some fixes
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/31 Rodolfo Giometti <giometti@enneenne.com>:
> On Mon, Jan 31, 2011 at 04:54:17PM +0300, Anton Vorontsov wrote:
>> The same is for this patch.
>>
>> Comments, Reviewed-by or Acked-by?
>>
>> p.s. FWIW, I already asked Pali to factor out bq27x00_battery_time()
>>      fix to a separate patch.
>>
>> ----- Forwarded message from Pali Rohár <pali.rohar@gmail.com> -----
>>
>> Date: Wed, 26 Jan 2011 21:42:39 +0100
>> From: Pali Rohár <pali.rohar@gmail.com>
>> To: Anton Vorontsov <cbouatmailru@gmail.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Subject: Re: [PATCH] bq27x00_battery
>>
>> This patch fix reporting correct (devided by resistor sense) values on
>> bq27000/bq27200 batteries.
>>
>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> Tested-by: Pali Rohár <pali.rohar@gmail.com>
>>
>> --- a/drivers/power/bq27x00_battery.c 2011-01-26 21:30:40.000000000 +0100
>> +++ b/drivers/power/bq27x00_battery.c 2011-01-26 21:32:34.000000000 +0100
>> @@ -37,10 +37,11 @@
>>  #define BQ27x00_REG_TTF                      0x18
>>  #define BQ27x00_REG_TTECP            0x26
>>
>> +#define BQ27000_RS                   20 /* Resistor sense */
>>  #define BQ27000_REG_RSOC             0x0B /* Relative State-of-Charge */
>>  #define BQ27000_FLAG_CHGS            BIT(7)
>>
>> -#define BQ27500_REG_SOC                      0x2c
>> +#define BQ27500_REG_SOC                      0x2C
>>  #define BQ27500_FLAG_DSC             BIT(0)
>>  #define BQ27500_FLAG_FC                      BIT(9)
>>
>> @@ -112,7 +113,7 @@ static int bq27x00_battery_temperature(s
>>  }
>>
>>  /*
>> - * Return the battery Voltage in milivolts
>> + * Return the battery Voltage in µV
>>   * Or < 0 if something fails.
>>   */
>>  static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
>> @@ -130,7 +131,7 @@ static int bq27x00_battery_voltage(struc
>>  }
>
> Ok, but I think we should change the function name adding _mV...
>
>>
>>  /*
>> - * Return the battery average current
>> + * Return the battery average current in µA
>>   * Note that current can be negative signed as well
>>   * Or 0 if something fails.
>>   */
>> @@ -149,6 +150,7 @@ static int bq27x00_battery_current(struc
>>       if (di->chip == BQ27500) {
>>               /* bq27500 returns signed value */
>>               curr = (int)(s16)curr;
>> +             curr *= 1000;
>>       } else {
>>               ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
>>               if (ret < 0) {
>> @@ -159,9 +161,10 @@ static int bq27x00_battery_current(struc
>>                       dev_dbg(di->dev, "negative current!\n");
>>                       curr = -curr;
>>               }
>> +             curr = curr * 3570 / BQ27000_RS;
>>       }
>>
>> -     return curr * 1000;
>> +     return curr;
>>  }
>
> And here _mA.
>
>>  /*
>> @@ -233,7 +236,7 @@ static int bq27x00_battery_time(struct b
>>       }
>>
>>       if (tval == 65535)
>> -             return -ENODATA;
>> +             tval = 0;
>>
>>       val->intval = tval * 60;
>>       return 0;
>>
>> ----- End forwarded message -----
>
> Ciao,
>
> Rodolfo
>
> --
>
> GNU/Linux Solutions                  e-mail: giometti@enneenne.com
> Linux Device Driver                          giometti@linux.it
> Embedded Systems                     phone:  +39 349 2432127
> UNIX programming                     skype:  rodolfo.giometti
> Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
>

Why rename to _mA/_mV? Functions return values in µA/µV (units from
Documentation/power/power_supply_class.txt)

-- 
Pali Rohár
pali.rohar@gmail.com
