Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab2BXOvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:51:42 -0500
Received: from multi.imgtec.com ([194.200.65.239]:41781 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2BXOvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:51:33 -0500
Message-ID: <4F47A3F3.5030504@imgtec.com>
Date: Fri, 24 Feb 2012 14:51:31 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] asm-generic/unistd.h: handle symbol prefixes in
 cond_syscall
References: <4F47981F.4020305@imgtec.com> <201202241424.07319.arnd@arndb.de>
In-Reply-To: <201202241424.07319.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2012 14:51:31.0673 (UTC) FILETIME=[CBCF8C90:01CCF303]
X-SEF-Processed: 7_3_0_01181__2012_02_24_14_51_32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd

Thanks for taking a look.

On 24/02/12 14:24, Arnd Bergmann wrote:
> On Friday 24 February 2012, James Hogan wrote:
>> Some architectures have symbol prefixes and set CONFIG_SYMBOL_PREFIX,
>> but this wasn't taken into account by the generic cond_syscall. It's
>> easy enough to fix in a generic fashion, so add the symbol prefix to
>> symbol names in cond_syscall when CONFIG_SYMBOL_PREFIX is set.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> ---
>>  include/asm-generic/unistd.h |    9 ++++++++-
>>  1 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
>> index 2292d1a..c9a5ba4 100644
>> --- a/include/asm-generic/unistd.h
>> +++ b/include/asm-generic/unistd.h
>> @@ -924,7 +924,14 @@ __SYSCALL(__NR_fork, sys_ni_syscall)
>>   * but it doesn't work on all toolchains, so we just do it by hand
>>   */
>>  #ifndef cond_syscall
>> -#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
>> +#ifdef CONFIG_SYMBOL_PREFIX
>> +#define __SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
>> +#else
>> +#define __SYMBOL_PREFIX
>> +#endif
>> +#define cond_syscall(x) asm(".weak\t" __SYMBOL_PREFIX #x "\n\t" \
>> +                           ".set\t" __SYMBOL_PREFIX #x "," \
>> +                           __SYMBOL_PREFIX "sys_ni_syscall")
>>  #endif
> 
> Our trend is to move away from arch specific Kconfig symbols and __ARCH_HAS_*
> macros towards just defining whatever you need in the architecture as an
> override for the generic definition.
> 
> Just provide your own unistd.h that does
> 
> #define cond_syscall(x) asm(".weak\t." #x "\n\t.set\t." #x ",.sys_ni_syscall")
> #include <asm-generic/unistd.h>

Okay, no problem.

> BTW, are you planning to submit arch/metag for inclusion? I've looked at
> the code recently and it appears that you are on the right track overall,
> and it shouldn't be too hard to get to the same quality level as
> arch/openrisc.

At this stage I'm just (in my own time) trying to get it closer to the
standard required for new architectures so that when the time comes
there's less to do.

I've been looking at your initial comments for other architecture
submissions and they've been very helpful, but if you do have any
arch/metag specific suggestions I'd certainly welcome them.

Thanks
James

