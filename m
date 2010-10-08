Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab0JHGWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 02:22:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38023 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab0JHGWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 02:22:05 -0400
X-User-Agent: K-9 Mail for Android
References: <1286502453-7043-1-git-send-email-yakui.zhao@intel.com> <tip-68f4d5a00adaab33b136fce2c72d5c377b39b0b0@git.kernel.org> <4CAEB1BA.2030604@kernel.org>
In-Reply-To: <4CAEB1BA.2030604@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/setup] x86, setup: Use string copy operation to optimze copy in kernel compression
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 07 Oct 2010 23:21:37 -0700
To: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, yakui.zhao@intel.com, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Message-ID: <95a57ba2-94d7-4115-b9b3-d4b595ad9552@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost certainly still faster than bytewise copy!

"Yinghai Lu" <yinghai@kernel.org> wrote:

>On 10/07/2010 10:40 PM, tip-bot for Zhao Yakui wrote:
>> Commit-ID:  68f4d5a00adaab33b136fce2c72d5c377b39b0b0
>> Gitweb:     http://git.kernel.org/tip/68f4d5a00adaab33b136fce2c72d5c377b39b0b0
>> Author:     Zhao Yakui <yakui.zhao@intel.com>
>> AuthorDate: Fri, 8 Oct 2010 09:47:33 +0800
>> Committer:  H. Peter Anvin <hpa@zytor.com>
>> CommitDate: Thu, 7 Oct 2010 21:23:09 -0700
>> 
>> x86, setup: Use string copy operation to optimze copy in kernel compression
>> 
>> The kernel decompression code parses the ELF header and then copies
>> the segment to the corresponding destination.  Currently it uses slow
>> byte-copy code.  This patch makes it use the string copy operations
>> instead.
>> 
>> In the test the copy performance can be improved very significantly after using
>> the string copy operation mechanism.
>>         1. The copy time can be reduced from 150ms to 20ms on one Atom machine
>> 	2. The copy time can be reduced about 80% on another machine
>> 		The time is reduced from 7ms to 1.5ms when using 32-bit kernel.
>> 		The time is reduced from 10ms to 2ms when using 64-bit kernel.
>> 
>> Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>> LKML-Reference: <1286502453-7043-1-git-send-email-yakui.zhao@intel.com>
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>> ---
>>  arch/x86/boot/compressed/misc.c |   29 +++++++++++++++++++++++------
>>  1 files changed, 23 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
>> index 8f7bef8..23f315c 100644
>> --- a/arch/x86/boot/compressed/misc.c
>> +++ b/arch/x86/boot/compressed/misc.c
>> @@ -229,18 +229,35 @@ void *memset(void *s, int c, size_t n)
>>  		ss[i] = c;
>>  	return s;
>>  }
>> -
>> +#ifdef CONFIG_X86_32
>>  void *memcpy(void *dest, const void *src, size_t n)
>>  {
>> -	int i;
>> -	const char *s = src;
>> -	char *d = dest;
>> +	int d0, d1, d2;
>> +	asm volatile(
>> +		"rep ; movsl\n\t"
>> +		"movl %4,%%ecx\n\t"
>> +		"rep ; movsb\n\t"
>> +		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
>> +		: "0" (n >> 2), "g" (n & 3), "1" (dest), "2" (src)
>> +		: "memory");
>>  
>> -	for (i = 0; i < n; i++)
>> -		d[i] = s[i];
>>  	return dest;
>>  }
>> +#else
>> +void *memcpy(void *dest, const void *src, size_t n)
>> +{
>> +	long d0, d1, d2;
>> +	asm volatile(
>> +		"rep ; movsq\n\t"
>> +		"movq %4,%%rcx\n\t"
>> +		"rep ; movsb\n\t"
>> +		: "=&c" (d0), "=&D" (d1), "=&S" (d2)
>> +		: "0" (n >> 3), "g" (n & 7), "1" (dest), "2" (src)
>> +		: "memory");
>>  
>> +	return dest;
>> +}
>> +#endif
>>  
>>  static void error(char *x)
>>  {
>
>wonder if it would have problem with some old AMD K8 systems.
>
>in amd.c
>
>        /* On C+ stepping K8 rep microcode works well for copy/memset */
>        if (c->x86 == 0xf) {
>                u32 level;
>
>                level = cpuid_eax(1);
>                if ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>                        set_cpu_cap(c, X86_FEATURE_REP_GOOD);
>...
>
>        }
>        if (c->x86 >= 0x10)
>                set_cpu_cap(c, X86_FEATURE_REP_GOOD);
>
>Yinghai

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
