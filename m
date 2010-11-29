Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0K2ULy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:11:54 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44387 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0K2ULw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:11:52 -0500
Message-ID: <4CF408FB.4060905@oracle.com>
Date: Mon, 29 Nov 2010 12:11:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Huang Ying <ying.huang@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for November 29 (aesni-intel)
References: <4CF3F6CB.8080904@oracle.com> <1291058505-9384-1-git-send-email-minipli@googlemail.com> <4CF3FFAE.40906@oracle.com> <45B80502-8597-4650-990F-F23B4FC751B8@googlemail.com> <4CF40504.5060506@oracle.com> <D271AB83-0E5F-4C1C-A4A7-CD0588E6C7B6@googlemail.com>
In-Reply-To: <D271AB83-0E5F-4C1C-A4A7-CD0588E6C7B6@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/10 12:02, Mathias Krause wrote:
> On 29.11.2010, 20:54 Randy Dunlap wrote:
>> On 11/29/10 11:45, Mathias Krause wrote:
>>> On 29.11.2010, 20:31 Randy Dunlap wrote:
>>>> On 11/29/10 11:21, Mathias Krause wrote:
>>>>> On 29.11.2010, 19:54 Randy Dunlap wrote:
>>>>>> On 11/29/10 10:26, Mathias Krause wrote:
>>>>>>> On 29.11.2010, 17:31 Randy Dunlap wrote:
>>>>>>>> On Mon, 29 Nov 2010 14:03:35 +1100 Stephen Rothwell wrote:
>>>>>>>>
>>>>>>>>> Hi all,
>>>>>>>>>
>>>>>>>>> Changes since 20101126:
>>>>>>>>
>>>>>>>>
>>>>>>>> on i386 builds, I get tons of these (and more) errors:
>>>>>>>>
>>>>>>>> arch/x86/crypto/aesni-intel_asm.S:841: Error: bad register name `%r12'
>>>>>>>> arch/x86/crypto/aesni-intel_asm.S:842: Error: bad register name `%r13'
>>>>>>>> arch/x86/crypto/aesni-intel_asm.S:843: Error: bad register name `%r14'
>>>>>>>> arch/x86/crypto/aesni-intel_asm.S:844: Error: bad register name `%rsp'
>>>>>>>> arch/x86/crypto/aesni-intel_asm.S:849: Error: bad register name `%rsp'
>>>>>>>> arch/x86/crypto/aesni-intel_asm.S:850: Error: bad register name `%rsp'
>>>>>>>> arch/x86/crypto/aesni-intel_asm.S:851: Error: bad register name `%r9'
>>>>>>>>
>>>>>>>> even though the kernel .config file says:
>>>>>>>>
>>>>>>>> CONFIG_CRYPTO_AES=m
>>>>>>>> CONFIG_CRYPTO_AES_586=m
>>>>>>>> CONFIG_CRYPTO_AES_NI_INTEL=m
>>>>>>>>
>>>>>>>> Should arch/x86/crypto/aesni-intel_asm.S be testing
>>>>>>>> #ifdef CONFIG_X86_64
>>>>>>>> instead of
>>>>>>>> #ifdef __x86_64__
>>>>>>>> or does that not matter?
>>>>>>>>
>>>>>>>> or is this a toolchain issue?
>>>>>>>
>>>>>>> Well, __x86_64__ should be a build-in define of the compiler while
>>>>>>> CONFIG_X86_64 is defined for 64 bit builds in include/generated/autoconf.h.
>>>>>>> So by using the latter we should be on the safe side but if your compiler
>>>>>>> defines __x86_64__ for 32-bit builds it's simply broken. Also git grep
>>>>>>> showed quite a few more places using __x86_64__ so those would miscompile on
>>>>>>> your toolchain, too.
>>>>>>>
>>>>>>> But it looks like linux-next is just missing
>>>>>>> 559ad0ff1368baea14dbc3207d55b02bd69bda4b from Herbert's git repo at
>>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git.
>>>>>>> That should fix the build issue.
>>>>>>
>>>>>> The build problem still happens when that patch is applied.
>>>>>
>>>>> That's weird. So it must be something with your toolchain.
>>>>> Can you please post the output of the following commands?:
>>>>>
>>>>> $ touch /tmp/null.c; cc -m32 -dD -E /tmp/null.c | grep -E 'x86|i.86'
>>>>
>>>> #define __i386 1
>>>> #define __i386__ 1
>>>> #define i386 1
>>>> #define __i586 1
>>>> #define __i586__ 1
>>>>
>>>>> $ touch /tmp/null.c; cc -m64 -dD -E /tmp/null.c | grep -E 'x86|i.86'
>>>>
>>>> #define __x86_64 1
>>>> #define __x86_64__ 1
>>>>
>>>> So that's not the problem... and the patch below didn't help.
>>>
>>> That's odd. The output of the commands looks good so the x86-64 specific code
>>> should be left out for 32-bit builds. :/
>>>
>>>> Sorry that I even asked about that.  What next?
>>>
>>> Can you please post the full error message. Meanwhile I'm checking out a
>>> linux-next tree, trying to reproduce your problem.
>>>
>>
>> I just built with "make V=1" to see the full commands that are used, but
>> that didn't help me either:
>>
>>  gcc -Wp,-MD,arch/x86/crypto/.aesni-intel_asm.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.4.1/include -I/lnx/src/NEXT/linux-next-20101129/arch/x86/include -Iinclude  -I/lnx/src/NEXT/linux-next-20101129/include -include include/generated/autoconf.h -D__KERNEL__ -D__ASSEMBLY__ -m32 -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DMODULE  -c -o arch/x86/crypto/aesni-intel_asm.o /lnx/src/NEXT/linux-next-20101129/arch/x86/crypto/aesni-intel_asm.S
>>
>>
>> There are 2945 lines like this:
>>
>> linux-next-20101129/arch/x86/crypto/aesni-intel_asm.S:841: Error: bad register name `%r12'
> 
> Well, in my tree (linux-next + 559ad0ff) line 841 is a comment. Albeit without
> 559ad0ff it's a 'push %r12'. So maybe you should apply the patch just once
> more to be sure. ;)

Touche.
What does that patch have to do with aesni-intel??


I'm using the linux-next tarball of 20111129.
However, your s/__x86_64__/CONFIG_X86_64/ patch was applied, so I dropped it.

new output file:
http://oss.oracle.com/~rdunlap/doc/cry4.out


>> It's around 311 KB, so I'll just put it here instead of emailing it:
>> http://oss.oracle.com/~rdunlap/doc/cry32.out


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
