Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1AFSHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:07:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43097 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1AFSHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:07:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HNRgcBTgWEnIyvesYjbnsM6hCZh0+MuxRTddR28Q0PBfjigm2TUG9DkTwksYT5ORV8
         VAsVlDX0YHpdd+7rRDGstzWfdI0znkUFfkgdmbWGa1PSVJls3LcRYdvQPvM3vjzx0dps
         730HJKGqzZjIJODO9fyUjJ5yUbe32w9xcqF4o=
MIME-Version: 1.0
In-Reply-To: <4D25FEEE.6070805@bspu.unibel.by>
References: <4D2339F7.3090502@bspu.unibel.by>
	<20110105150226.f4e2f31e.akpm@linux-foundation.org>
	<4D25FEEE.6070805@bspu.unibel.by>
Date: Thu, 6 Jan 2011 13:07:01 -0500
Message-ID: <AANLkTi=tNwiTcdqLjnL+6YmYi51C9-CwvVt9hY0zzhVF@mail.gmail.com>
Subject: Re: [PATCH] fix miscompiling with GCC 4.5 -finline-functions
From: Arnaud Lacombe <lacombar@gmail.com>
To: mahatma@eu.by
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 6, 2011 at 12:42 PM, Dzianis Kahanovich
<mahatma@bspu.unibel.by> wrote:
> Andrew Morton wrote:
>
>>> Fixing broken automatic inlining for GCC 4.5+  (breaks build with
>>> -finline-functions or -O3 on x86_*).
>>>
>>
>> Please always quote the compiler output when addressing build errors
>> and warnings.
>
> Sorry. linux-next, yesterday, gcc version 4.5.1 (Gentoo 4.5.1-r1 p1.4, pie-0.4.5):
>
> make -j5 -s HOSTCC=x86_64-pc-linux-gnu-gcc ARCH=i386
> CROSS_COMPILE=i586-pc-linux-gnu- all -i
> arch/x86/kvm/vmx.c: Assembler messages:
> arch/x86/kvm/vmx.c:4036: Error: symbol `.Llaunched' is already defined
> arch/x86/kvm/vmx.c:4048: Error: symbol `.Lkvm_vmx_return' is already defined
> i586-pc-linux-gnu-ld: cannot find arch/x86/kvm/vmx.o: No such file or directory
> ...
> ERROR: "__bad_udelay" [drivers/media/radio/radio-aimslab.ko] undefined!
>
did you report this to gcc folks ?

Btw, you said it showed with "-O3" or "-finline-functions", but I do
not see any specific option passed to make. Could you remove the "-j5"
switch and add "V=1" to see the full compiler command line ?

Generally speaking, neither "-O3" or "-finline-functions" seems to be
passed by default by kbuild, so I am not sure they are meant to be
supported at all.

 - Arnaud

> I unsure in precise version boundaries, but first found on release tree weeks
> ago and first error only sometimes happened on x86_64 (version related?). On my
> own builds I used -fno-inline-functions in local Makefile's, but this is more
> local fix.
>
>>
>>> --- a/arch/x86/kvm/vmx.c
>>> +++ b/arch/x86/kvm/vmx.c
>>> @@ -569,7 +569,7 @@ static inline void ept_sync_individual_a
>>>      }
>>>  }
>>>
>>> -static unsigned long vmcs_readl(unsigned long field)
>>> +static noinline unsigned long vmcs_readl(unsigned long field)
>>>  {
>>>      unsigned long value = 0;
>>>
>>> --- a/drivers/media/radio/radio-aimslab.c
>>> +++ b/drivers/media/radio/radio-aimslab.c
>>> @@ -71,7 +71,7 @@ static struct rtrack rtrack_card;
>>>
>>>  /* local things */
>>>
>>> -static void sleep_delay(long n)
>>> +static noinline void sleep_delay(long n)
>>>  {
>>>      /* Sleep nicely for 'n' uS */
>>>      int d = n / msecs_to_jiffies(1000);
>>
>> A golden rule is that when a programmer reads some code, he should be
>> able to understand why it's there.  There is no way on this little
>> earth that a programmer will be able to look at this code and say
>> "ah-hah, that must be a workaround for gcc-4.5 -finline-functions!".
>>
>> We fix that problem this way:
>>
>> --- a/arch/x86/kvm/vmx.c~fix-miscompiling-with-gcc-45-finline-functions-fix
>> +++ a/arch/x86/kvm/vmx.c
>> @@ -569,6 +569,7 @@ static inline void ept_sync_individual_a
>>       }
>>  }
>>
>> +/* noinline works around gcc-4.5+ build error with -finline-functions */
>>  static noinline unsigned long vmcs_readl(unsigned long field)
>>  {
>>       unsigned long value = 0;
>> --- a/drivers/media/radio/radio-aimslab.c~fix-miscompiling-with-gcc-45-finline-functions-fix
>> +++ a/drivers/media/radio/radio-aimslab.c
>> @@ -71,6 +71,7 @@ static struct rtrack rtrack_card;
>>
>>  /* local things */
>>
>> +/* noinline works around gcc-4.5+ build error with -finline-functions */
>>  static noinline void sleep_delay(long n)
>>  {
>>       /* Sleep nicely for 'n' uS */
>> _
>>
>>
>>
>
>
> --
> WBR, Dzianis Kahanovich AKA Denis Kaganovich, http://mahatma.bspu.unibel.by/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
