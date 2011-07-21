Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1GUU0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:26:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60466 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab1GUU0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:26:41 -0400
Message-ID: <4E288AA6.7090804@zytor.com>
Date: Thu, 21 Jul 2011 13:23:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, johnstul@us.ibm.com, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        clemens@ladisch.de
CC: linux-tip-commits@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [tip:x86/vdso] clocksource: Replace vread with generic arch data
References: <3ae5ec76a168eaaae63f08a2a1060b91aa0b7759.1310563276.git.luto@mit.edu> <tip-433bd805e5fd2c731b3a9025b034f066272d336e@git.kernel.org>
In-Reply-To: <tip-433bd805e5fd2c731b3a9025b034f066272d336e@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 09:24 PM, tip-bot for Andy Lutomirski wrote:
> 
> diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
> new file mode 100644
> index 0000000..a5df33f
> --- /dev/null
> +++ b/arch/x86/include/asm/clocksource.h
> @@ -0,0 +1,16 @@
> +/* x86-specific clocksource additions */
> +
> +#ifndef _ASM_X86_CLOCKSOURCE_H
> +#define _ASM_X86_CLOCKSOURCE_H
> +
> +#ifdef CONFIG_X86_64
> +
> +#define __ARCH_HAS_CLOCKSOURCE_DATA
> +
> +struct arch_clocksource_data {
> +	cycle_t (*vread)(void);
> +};
> +
> +#endif /* CONFIG_X86_64 */
> +
> +#endif /* _ASM_X86_CLOCKSOURCE_H */
> --- /dev/null
> +++ b/include/asm-generic/clocksource.h
> @@ -0,0 +1,4 @@
> +/*
> + * Architectures should override this file to add private userspace
> + * clock magic if needed.
> + */
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index d4646b4..0fb83c2 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -22,6 +22,8 @@
>  typedef u64 cycle_t;
>  struct clocksource;
>  
> +#include <asm/clocksource.h>
> +
>  /**

Hi Andy,

I should have spotted this sooner... Ingo pointed out to me that this
breaks building on any non-x86 architecture.

asm-generic doesn't work quite the way you think it does, here; it's a
library for architectures to include from, not something that gets
included on all architectures by default.

To make a file from asm-generic appear in asm/ it needs to at least
appear in a generic-y statement in a Makefile; however, that is kind of
pointless in the case of an empty file.

One could argue that it would be nice if we had such a fallback
director, of if asm-generic was such a fallback directory, but currently
it is not.

The easiest way to deal with this is probably to make
ARCH_HAS_CLOCKSOURCE_DATA here a Kconfig option (autoselected for
x86-64); the only other would be to add this as generic-y stubs for
every single architecture.

Cc: Arnd Bergmann who is the asm-generic maintainer for a
recommendation, and linux-arch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

