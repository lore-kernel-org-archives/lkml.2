Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1AFRnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:43:08 -0500
Received: from mail.bspu.unibel.by ([195.50.2.21]:42366 "EHLO mail.bspu.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751233Ab1AFRnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:43:07 -0500
Message-ID: <4D25FEEE.6070805@bspu.unibel.by>
Date: Thu, 06 Jan 2011 19:42:06 +0200
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b7pre) Gecko/20101123 Firefox/4.0b7pre SeaMonkey/2.1b1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mahatma@eu.by, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix miscompiling with GCC 4.5 -finline-functions
References: <4D2339F7.3090502@bspu.unibel.by> <20110105150226.f4e2f31e.akpm@linux-foundation.org>
In-Reply-To: <20110105150226.f4e2f31e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> Fixing broken automatic inlining for GCC 4.5+  (breaks build with
>> -finline-functions or -O3 on x86_*).
>>
> 
> Please always quote the compiler output when addressing build errors
> and warnings.

Sorry. linux-next, yesterday, gcc version 4.5.1 (Gentoo 4.5.1-r1 p1.4, pie-0.4.5):

make -j5 -s HOSTCC=x86_64-pc-linux-gnu-gcc ARCH=i386
CROSS_COMPILE=i586-pc-linux-gnu- all -i
arch/x86/kvm/vmx.c: Assembler messages:
arch/x86/kvm/vmx.c:4036: Error: symbol `.Llaunched' is already defined
arch/x86/kvm/vmx.c:4048: Error: symbol `.Lkvm_vmx_return' is already defined
i586-pc-linux-gnu-ld: cannot find arch/x86/kvm/vmx.o: No such file or directory
...
ERROR: "__bad_udelay" [drivers/media/radio/radio-aimslab.ko] undefined!

I unsure in precise version boundaries, but first found on release tree weeks
ago and first error only sometimes happened on x86_64 (version related?). On my
own builds I used -fno-inline-functions in local Makefile's, but this is more
local fix.

> 
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -569,7 +569,7 @@ static inline void ept_sync_individual_a
>>  	}
>>  }
>>
>> -static unsigned long vmcs_readl(unsigned long field)
>> +static noinline unsigned long vmcs_readl(unsigned long field)
>>  {
>>  	unsigned long value = 0;
>>
>> --- a/drivers/media/radio/radio-aimslab.c
>> +++ b/drivers/media/radio/radio-aimslab.c
>> @@ -71,7 +71,7 @@ static struct rtrack rtrack_card;
>>
>>  /* local things */
>>
>> -static void sleep_delay(long n)
>> +static noinline void sleep_delay(long n)
>>  {
>>  	/* Sleep nicely for 'n' uS */
>>  	int d = n / msecs_to_jiffies(1000);
> 
> A golden rule is that when a programmer reads some code, he should be
> able to understand why it's there.  There is no way on this little
> earth that a programmer will be able to look at this code and say
> "ah-hah, that must be a workaround for gcc-4.5 -finline-functions!".
> 
> We fix that problem this way:
> 
> --- a/arch/x86/kvm/vmx.c~fix-miscompiling-with-gcc-45-finline-functions-fix
> +++ a/arch/x86/kvm/vmx.c
> @@ -569,6 +569,7 @@ static inline void ept_sync_individual_a
>  	}
>  }
>  
> +/* noinline works around gcc-4.5+ build error with -finline-functions */
>  static noinline unsigned long vmcs_readl(unsigned long field)
>  {
>  	unsigned long value = 0;
> --- a/drivers/media/radio/radio-aimslab.c~fix-miscompiling-with-gcc-45-finline-functions-fix
> +++ a/drivers/media/radio/radio-aimslab.c
> @@ -71,6 +71,7 @@ static struct rtrack rtrack_card;
>  
>  /* local things */
>  
> +/* noinline works around gcc-4.5+ build error with -finline-functions */
>  static noinline void sleep_delay(long n)
>  {
>  	/* Sleep nicely for 'n' uS */
> _
> 
> 
> 


-- 
WBR, Dzianis Kahanovich AKA Denis Kaganovich, http://mahatma.bspu.unibel.by/
