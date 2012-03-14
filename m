Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296Ab2CNVUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:20:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53783 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759794Ab2CNVUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:20:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203142152580.2466@ionos>
References: <1331764535-21079-1-git-send-email-levinsasha928@gmail.com> <alpine.LFD.2.02.1203142152580.2466@ionos>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 14 Mar 2012 23:19:51 +0200
Message-ID: <CA+1xoqcqPMni_YPfwrwYcao0ts-KXvZHX-2hkkYz15nH0UbOoA@mail.gmail.com>
Subject: Re: [PATCH] ntp: Fix integer overflow when setting time
To: Thomas Gleixner <tglx@linutronix.de>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:16 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 14 Mar 2012, Sasha Levin wrote:
>
>> On 64bit machines, the difference between 'time_reftime' and current time
>> is 8 bits, this variable is used as the divisor in div_s64() to calculate
>> the frequency, but div_s64() assumes the divisor is 32bits.
>
> Why is that delta 8 bits????
>
>> This means that we are able to trigger a division by zero if the difference
>> has 0's in it's lower bytes. This way it would skip the sanity checks before
>> the div_64s() but when it gets to that div it would get truncated and
>> become 0.
>
> This does not make sense at all.
>
> So what I assume you are talking about is, that the divisor (i.e. the
> delta) is greater than (1 << 32) - 1 and all 32 lower bits are 0, right ?

Yup, exactly.

>> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
>> index 17fb1b9..efe894a 100644
>> --- a/kernel/time/ntp.c
>> +++ b/kernel/time/ntp.c
>> @@ -289,7 +289,7 @@ static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
>>
>>       time_status |= STA_MODE;
>>
>> -     return div_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
>> +     return div64_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
>
> This needs a comment and it would be nice to avoid the 64 division on
> 32bit machines. Something like:
>
> #if BITS_PER_LONG == 64
> # define div64_long(x,y)        div64_s64(x,y)
> #else
> # define div64_long(x,y)        div_s64(x,y)
> #endif

I'll change that.

> Nice catch, though it took me a while to grok the changelog, as the 8
> bit case is catched by the MINSEC check. Please be more careful about
> that.

Sorry about that, I suck at writing changelogs :(

> Thanks,
>
>        tglx
