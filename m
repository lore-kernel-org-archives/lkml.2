Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1GRTFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:05:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47531 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1GRTFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:05:06 -0400
MIME-Version: 1.0
In-Reply-To: <CACVxJT-0=cpieN52g2LZ1W+PPmpL-kR9nHCk53bBSR=Js1cbRA@mail.gmail.com>
References: <e01fb9d779703004bf2f217ec7a2c3e7220610b9.1310977380.git.andriy.shevchenko@linux.intel.com>
	<5e634c6aaeea13b4a1a541fad0b776180ccfd80b.1310977380.git.andriy.shevchenko@linux.intel.com>
	<CACVxJT-0=cpieN52g2LZ1W+PPmpL-kR9nHCk53bBSR=Js1cbRA@mail.gmail.com>
Date: Mon, 18 Jul 2011 22:05:05 +0300
Message-ID: <CAHp75VeGFB+j+2T7JmARw5pCkgo7Kz0HXde7mKrTsaGhSSN05g@mail.gmail.com>
Subject: Re: [PATCH 2/2] lib: call native hex_to_bin() inside _kstrtoull()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6IJ5HYm005039

Anyway, I wrote the small performance test case (you can see it in a
new series), which shows significant reduction of the performance
(~12%). So, just drop this patch.

On Mon, Jul 18, 2011 at 1:31 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Mon, Jul 18, 2011 at 11:23 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> --- a/lib/kstrtox.c
>> +++ b/lib/kstrtox.c
>> @@ -39,25 +39,18 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
>>        acc = 0;
>>        ok = 0;
>>        while (*s) {
>> -               unsigned int val;
>> +               int val;
>>
>> -               if ('0' <= *s && *s <= '9')
>> -                       val = *s - '0';
>> -               else if ('a' <= TOLOWER(*s) && TOLOWER(*s) <= 'f')
>> -                       val = TOLOWER(*s) - 'a' + 10;
>> -               else if (*s == '\n' && *(s + 1) == '\0')
>> +               if (unlikely(*s == '\n' && *(s + 1) == '\0'))
>>                        break;
>> -               else
>> -                       return -EINVAL;
>>
>> -               if (val >= base)
>> +               val = hex_to_bin(*s++);
>> +               if (val >= base || val < 0)
>>                        return -EINVAL;
>>                if (acc > div_u64(ULLONG_MAX - val, base))
>>                        return -ERANGE;
>>                acc = acc * base + val;
>>                ok = 1;
>> -
>> -               s++;
>>        }
>>        if (!ok)
>>                return -EINVAL;
>
> 1. unlikely() and s++ move don't have anything to do with changes
> 2. I don't understand desire to use some half-thought out API,
>   in fact, restricting to radix 16 is arbitrary.
>   Without such restriction hex_to_bin doesn't make sense.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
With Best Regards,
Andy Shevchenko
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
