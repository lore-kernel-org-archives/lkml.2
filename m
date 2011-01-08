Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1AHBFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 20:05:51 -0500
Received: from mail.bspu.unibel.by ([195.50.2.21]:35275 "EHLO mail.bspu.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752573Ab1AHBFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 20:05:50 -0500
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sat, 08 Jan 2011 03:05:13 +0200
From: Denis Kaganovich <mahatma@bspu.unibel.by>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix miscompiling with GCC 4.5 -finline-functions
In-Reply-To: <AANLkTi=tNwiTcdqLjnL+6YmYi51C9-CwvVt9hY0zzhVF@mail.gmail.com>
References: <4D2339F7.3090502@bspu.unibel.by>
 <20110105150226.f4e2f31e.akpm@linux-foundation.org>
 <4D25FEEE.6070805@bspu.unibel.by>
 <AANLkTi=tNwiTcdqLjnL+6YmYi51C9-CwvVt9hY0zzhVF@mail.gmail.com>
Message-ID: <176462e99c17ec5f1ebe4bba212cca99@bspu.unibel.by>
User-Agent: Roundcube Webmail/0.5-beta
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Thu, 6 Jan 2011 13:07:01 -0500, Arnaud Lacombe wrote:
> On Thu, Jan 6, 2011 at 12:42 PM, Dzianis Kahanovich
> <mahatma@bspu.unibel.by> wrote:
>> Andrew Morton wrote:
>>
>>>> Fixing broken automatic inlining for GCC 4.5+  (breaks build with
>>>> -finline-functions or -O3 on x86_*).
>>>>
>>>
>>> Please always quote the compiler output when addressing build 
>>> errors
>>> and warnings.
>>
>> Sorry. linux-next, yesterday, gcc version 4.5.1 (Gentoo 4.5.1-r1 
>> p1.4, pie-0.4.5):
>>
>> make -j5 -s HOSTCC=x86_64-pc-linux-gnu-gcc ARCH=i386
>> CROSS_COMPILE=i586-pc-linux-gnu- all -i
>> arch/x86/kvm/vmx.c: Assembler messages:
>> arch/x86/kvm/vmx.c:4036: Error: symbol `.Llaunched' is already 
>> defined
>> arch/x86/kvm/vmx.c:4048: Error: symbol `.Lkvm_vmx_return' is already 
>> defined
>> i586-pc-linux-gnu-ld: cannot find arch/x86/kvm/vmx.o: No such file 
>> or directory
>> ...
>> ERROR: "__bad_udelay" [drivers/media/radio/radio-aimslab.ko] 
>> undefined!
>>
> did you report this to gcc folks ?
>
> Btw, you said it showed with "-O3" or "-finline-functions", but I do
> not see any specific option passed to make. Could you remove the 
> "-j5"
> switch and add "V=1" to see the full compiler command line ?

 Yes, big sorry. Distilling output again I found - there are problem of 
 conjunction of "-finline-function -ftracer". Time ago I report similar 
 problem about -ftracer in gcc bugzilla ("make defconfig && make all" 
 with -ftracer, in various places in various versions).

 BUT: First time (weeks ago) "-ftracer" must be first candidate for me 
 to strip. Or I got this error first time without -ftracer or it is some 
 kind of my own bug. Just fyi.

 But output anymore ;) for first bug only:

 make HOSTCC=x86_64-pc-linux-gnu-gcc ARCH=i386 
 CROSS_COMPILE=i586-pc-linux-gnu- all
 ...
   i586-pc-linux-gnu-gcc -Wp,-MD,arch/x86/kvm/.vmx.o.d  -nostdinc 
 -isystem /usr/lib/gcc/i586-pc-linux-gnu/4.5.1/include 
 -I/var/tmp/portage/sys-kernel/next-sources-9999/work/linux-9999/arch/x86/include 
 -Iinclude  -include include/generated/autoconf.h -D__KERNEL__ -Wall 
 -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing 
 -fno-common -Werror-implicit-function-declaration -Wno-format-security 
 -fno-delete-null-pointer-checks -O2 -finline-functions -ftracer -m32 
 -msoft-float -mregparm=3 -freg-struct-return 
 -mpreferred-stack-boundary=2 -Wa, -ffreestanding -DCONFIG_AS_CFI=1 
 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -pipe 
 -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx 
 -mno-sse2 -mno-3dnow -Wframe-larger-than=2048 -fno-stack-protector 
 -fomit-frame-pointer -Wdeclaration-after-statement -Wno-pointer-sign 
 -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO -Ivirt/kvm 
 -Iarch/x86/kvm -I.  -DMODULE  -D"KBUILD_STR(s)=#s" 
 -D"KBUILD_BASENAME=KBUILD_STR(vmx)"  
 -D"KBUILD_MODNAME=KBUILD_STR(kvm_intel)" -c -o arch/x86/kvm/vmx.o 
 arch/x86/kvm/vmx.c
 arch/x86/kvm/vmx.c: Assembler messages:
 arch/x86/kvm/vmx.c:4036: Error: symbol `.Llaunched' is already defined
 arch/x86/kvm/vmx.c:4048: Error: symbol `.Lkvm_vmx_return' is already 
 defined


>
> Generally speaking, neither "-O3" or "-finline-functions" seems to be
> passed by default by kbuild, so I am not sure they are meant to be
> supported at all.

 I know, -O3 is "uncommon" subject. Just I see "noinline" wide used, 
 then sometimes sources adopted to auto-inlining. But -ftracer even more 
 ncommon subject? yes & sorry...

>
>  - Arnaud
>
>> I unsure in precise version boundaries, but first found on release 
>> tree weeks
>> ago and first error only sometimes happened on x86_64 (version 
>> related?). On my
>> own builds I used -fno-inline-functions in local Makefile's, but 
>> this is more
>> local fix.
>>
>>>
>>>> --- a/arch/x86/kvm/vmx.c
>>>> +++ b/arch/x86/kvm/vmx.c
>>>> @@ -569,7 +569,7 @@ static inline void ept_sync_individual_a
>>>>      }
>>>>  }
>>>>
>>>> -static unsigned long vmcs_readl(unsigned long field)
>>>> +static noinline unsigned long vmcs_readl(unsigned long field)
>>>>  {
>>>>      unsigned long value = 0;
>>>>
>>>> --- a/drivers/media/radio/radio-aimslab.c
>>>> +++ b/drivers/media/radio/radio-aimslab.c
>>>> @@ -71,7 +71,7 @@ static struct rtrack rtrack_card;
>>>>
>>>>  /* local things */
>>>>
>>>> -static void sleep_delay(long n)
>>>> +static noinline void sleep_delay(long n)
>>>>  {
>>>>      /* Sleep nicely for 'n' uS */
>>>>      int d = n / msecs_to_jiffies(1000);
>>>
>>> A golden rule is that when a programmer reads some code, he should 
>>> be
>>> able to understand why it's there.  There is no way on this little
>>> earth that a programmer will be able to look at this code and say
>>> "ah-hah, that must be a workaround for gcc-4.5 
>>> -finline-functions!".
>>>
>>> We fix that problem this way:
>>>
>>> --- 
>>> a/arch/x86/kvm/vmx.c~fix-miscompiling-with-gcc-45-finline-functions-fix
>>> +++ a/arch/x86/kvm/vmx.c
>>> @@ -569,6 +569,7 @@ static inline void ept_sync_individual_a
>>>       }
>>>  }
>>>
>>> +/* noinline works around gcc-4.5+ build error with 
>>> -finline-functions */
>>>  static noinline unsigned long vmcs_readl(unsigned long field)
>>>  {
>>>       unsigned long value = 0;
>>> --- 
>>> a/drivers/media/radio/radio-aimslab.c~fix-miscompiling-with-gcc-45-finline-functions-fix
>>> +++ a/drivers/media/radio/radio-aimslab.c
>>> @@ -71,6 +71,7 @@ static struct rtrack rtrack_card;
>>>
>>>  /* local things */
>>>
>>> +/* noinline works around gcc-4.5+ build error with 
>>> -finline-functions */
>>>  static noinline void sleep_delay(long n)
>>>  {
>>>       /* Sleep nicely for 'n' uS */
>>> _
>>>
>>>
>>>
>>

