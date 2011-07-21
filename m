Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab1GUUtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:49:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60167 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1GUUtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <4E288AA6.7090804@zytor.com>
References: <3ae5ec76a168eaaae63f08a2a1060b91aa0b7759.1310563276.git.luto@mit.edu>
 <tip-433bd805e5fd2c731b3a9025b034f066272d336e@git.kernel.org> <4E288AA6.7090804@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 21 Jul 2011 16:49:07 -0400
X-Google-Sender-Auth: q1__qU92f0iWesY3foShH9WPImA
Message-ID: <CAObL_7HyKSwm9a_7nfdk5E0Noy5zqD=dyaanvxY_iX5XcP1d4Q@mail.gmail.com>
Subject: Re: [tip:x86/vdso] clocksource: Replace vread with generic arch data
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, clemens@ladisch.de,
        linux-tip-commits@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linux Arch Mailing List <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 4:23 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/14/2011 09:24 PM, tip-bot for Andy Lutomirski wrote:
>>
>> diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
>> new file mode 100644
>> index 0000000..a5df33f
>> --- /dev/null
>> +++ b/arch/x86/include/asm/clocksource.h
>> @@ -0,0 +1,16 @@
>> +/* x86-specific clocksource additions */
>> +
>> +#ifndef _ASM_X86_CLOCKSOURCE_H
>> +#define _ASM_X86_CLOCKSOURCE_H
>> +
>> +#ifdef CONFIG_X86_64
>> +
>> +#define __ARCH_HAS_CLOCKSOURCE_DATA
>> +
>> +struct arch_clocksource_data {
>> +     cycle_t (*vread)(void);
>> +};
>> +
>> +#endif /* CONFIG_X86_64 */
>> +
>> +#endif /* _ASM_X86_CLOCKSOURCE_H */
>> --- /dev/null
>> +++ b/include/asm-generic/clocksource.h
>> @@ -0,0 +1,4 @@
>> +/*
>> + * Architectures should override this file to add private userspace
>> + * clock magic if needed.
>> + */
>> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
>> index d4646b4..0fb83c2 100644
>> --- a/include/linux/clocksource.h
>> +++ b/include/linux/clocksource.h
>> @@ -22,6 +22,8 @@
>>  typedef u64 cycle_t;
>>  struct clocksource;
>>
>> +#include <asm/clocksource.h>
>> +
>>  /**
>
> Hi Andy,
>
> I should have spotted this sooner... Ingo pointed out to me that this
> breaks building on any non-x86 architecture.
>
> asm-generic doesn't work quite the way you think it does, here; it's a
> library for architectures to include from, not something that gets
> included on all architectures by default.

Whoops.  If only cross-compiler toolchains were easy to build...

[...]

>
> The easiest way to deal with this is probably to make
> ARCH_HAS_CLOCKSOURCE_DATA here a Kconfig option (autoselected for
> x86-64); the only other would be to add this as generic-y stubs for
> every single architecture.
>
> Cc: Arnd Bergmann who is the asm-generic maintainer for a
> recommendation, and linux-arch.

ARCH_HAS_CLOCKSOURCE_DATA seems reasonable.  It's a little ugly
because it needs:

#ifdef CONFIG_ARCH_HAS_CLOCKSOURCE_DATA
#include <asm/clocksource.h>
#endif


If I don't hear any better suggestions, I'll implement that tomorrow.
Do you want an incremental patch or a replacement?

--Andy
