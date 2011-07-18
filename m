Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1GRS5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:57:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49788 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1GRS5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:57:02 -0400
MIME-Version: 1.0
In-Reply-To: <1311012230.3193.35.camel@localhost.localdomain>
References: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<201107182041.EHB78622.VOFSHFMOOFtLJQ@I-love.SAKURA.ne.jp>
	<1310991796.3903.6.camel@smile>
	<201107182148.AGD21306.FOLtJVMSOOFQHF@I-love.SAKURA.ne.jp>
	<1311012230.3193.35.camel@localhost.localdomain>
Date: Mon, 18 Jul 2011 21:57:00 +0300
Message-ID: <CAHp75VcXNQKej_n4cOB8-gYDSL8MuGrv=Fs8=zdEKGp53DCtSA@mail.gmail.com>
Subject: Re: [PATCH] Add error check to hex2bin().
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-security-module@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 9:03 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Mon, 2011-07-18 at 21:48 +0900, Tetsuo Handa wrote:
>> Currently, security/keys/ is the only user of hex2bin().
>> Should I keep hex2bin() unmodified in case of bad input?
>> If so, I'd like to make it as hex2bin_safe().
>
>> ----------------------------------------
>> [PATCH] Add error check to hex2bin().
>>
>> Since converting 2 hexadecimal letters into a byte with error checks is
>> commonly used, we can replace multiple hex_to_bin() calls with single hex2bin()
>> call by changing hex2bin() to do error checks.
>>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I=love.SAKURA.ne.jp>
>> ---
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 953352a..186e9fc 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -374,7 +374,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>>  }
>>
>>  extern int hex_to_bin(char ch);
>> -extern void hex2bin(u8 *dst, const char *src, size_t count);
>> +extern bool hex2bin(u8 *dst, const char *src, size_t count);
>>
>>  /*
>>   * General tracing related utility functions - trace_printk(),
>> diff --git a/lib/hexdump.c b/lib/hexdump.c
>> index f5fe6ba..1524002 100644
>> --- a/lib/hexdump.c
>> +++ b/lib/hexdump.c
>> @@ -38,14 +38,22 @@ EXPORT_SYMBOL(hex_to_bin);
>>   * @dst: binary result
>>   * @src: ascii hexadecimal string
>>   * @count: result length
>> + *
>> + * Returns true on success, false in case of bad input.
>>   */
>> -void hex2bin(u8 *dst, const char *src, size_t count)
>> +bool hex2bin(u8 *dst, const char *src, size_t count)
>>  {
>>       while (count--) {
>> -             *dst = hex_to_bin(*src++) << 4;
>> -             *dst += hex_to_bin(*src++);
>> -             dst++;
>> +             int c = hex_to_bin(*src++);
>> +             int d;
>
> Missing blank line here.
>
>> +             if (c < 0)
>> +                     return false;
>> +             d = hex_to_bin(*src++);
>> +             if (d < 0)
>> +                     return false;
>> +             *dst++ = (c << 4) | d;
>>       }
>> +     return true;
>>  }
>>  EXPORT_SYMBOL(hex2bin);
>
> We probably don't need to define a separate 'safe' function.
There is an opponent on any  approach. Although, small and fast error
route could be good.

>
> Instead of changing the existing code to short circuit out and return a
> value, does only adding the return value work?  Something like:
>
>        bool ret = true;
>        int c, d;
>
>        while (count--) {
>                c = hex_to_bin(*src++);
>                d = hex_to_bin(*src++);
Here is a performance issue, yeah. The user prefers to know about an
error as soon as possible.

>                *dst++ = (c << 4) | d;
>
>                if (c < 0 || d < 0)
>                        ret = false;
The ret value is redundant, and here you continue to fill the result
array by something arbitrary (might be wrong data).

>        }
>        return ret;
>
> thanks,
>
> Mimi
>
>> In message "Re: [PATCH] net: can: remove custom hex_to_bin()",
>> Andy Shevchenko wrote:
>> > On Mon, 2011-07-18 at 20:41 +0900, Tetsuo Handa wrote:
>> > > Andy Shevchenko wrote:
>> > > >         for (i = 0, dlc_pos++; i < cf.can_dlc; i++) {
>> > > > -
>> > > > -               tmp = asc2nibble(sl->rbuff[dlc_pos++]);
>> > > > -               if (tmp > 0x0F)
>> > > > +               tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
>> > > > +               if (tmp < 0)
>> > > >                         return;
>> > > >                 cf.data[i] = (tmp << 4);
>> > > > -               tmp = asc2nibble(sl->rbuff[dlc_pos++]);
>> > > > -               if (tmp > 0x0F)
>> > > > +               tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
>> > > > +               if (tmp < 0)
>> > > >                         return;
>> > > >                 cf.data[i] |= tmp;
>> > > >         }
>> > >
>> > > What about changing
>> > >
>> > >   void hex2bin(u8 *dst, const char *src, size_t count)
>> > >
>> > > to
>> > >
>> > >   bool hex2bin(u8 *dst, const char *src, size_t count)
>> > >
>> > > in order to do error checks like
>> > >
>> > > bool hex2bin_with_validation(u8 *dst, const char *src, size_t count)
>> > > {
>> > >   while (count--) {
>> > >           int c = hex_to_bin(*src++);
>> > >           int d;
>> > >           if (c < 0)
>> > >                   return false;
>> > >           d = hex_to_bin(*src++)
>> > >           if (d < 0)
>> > >                   return false;
>> > >           *dst++ = (c << 4) | d;
>> > >   }
>> > >   return true;
>> > > }
>> > >
>> > > and use hex2bin() rather than hex_to_bin()?
>> > Perhaps, good idea. Could you submit a patch?
>> >
>> > --
>> > Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> > Intel Finland Oy
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
With Best Regards,
Andy Shevchenko
