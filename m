Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2FLQSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:18:17 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:38067 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2FLQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:18:14 -0400
Date: Tue, 12 Jun 2012 19:18:04 +0300
From: Lasse Collin <lasse.collin@tukaani.org>
To: T Makphaibulchoke <tmac@hp.com>
Cc: linux@arm.linux.org.uk, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        linux390@de.ibm.com, lethal@linux-sh.org, hpa@zytor.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kaloz@openwrt.org, nicolas.pitre@linaro.org, jj@chaosbits.net,
        matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] lib/decompress_unxz.c: removing all memory helper
 functions
Message-ID: <20120612191804.4211462a@tukaani.org>
In-Reply-To: <1339470307-28223-1-git-send-email-tmac@hp.com>
References: <1339470307-28223-1-git-send-email-tmac@hp.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-11 T Makphaibulchoke wrote:
> --- /dev/null
> +++ b/lib/boot/mem.c
> @@ -0,0 +1,58 @@
> +/*
> + * Small subset of simple memory helper functions required by different
> + * compressors for preboot environment.
> + */
> +
> +#include <linux/string.h>
> +
> +#ifndef __HAVE_PREBOOT_ARCH_MEMCPY
> +void *memcpy(void *__dest, __const void *__src, size_t __n)
> +{
> +	return __builtin_memcpy(__dest, __src, __n);
> +}
> +#endif

GCC will replace __builtin_memcpy above with a call to memcpy, creating
an infinite loop. I confirmed this on x86_64 by first uncommenting the
memcpy from arch/x86/boot/compressed/string.c.

You need to provide a memcpy implementation yourself without using
__builtin functions. For example, copy the memcpy implementation from
lib/string.c.

> +#ifndef __HAVE_PREBOOT_ARCH_MEMMOVE
> +void *memmove(void *__dest, __const void *__src, size_t count)
> +{
> +	unsigned char *d = __dest;
> +	const unsigned char *s = __src;
> +
> +	if (__dest == __src)
> +		return __dest;
> +
> +	if (__dest < __src)
> +		return memcpy(__dest, __src, count);
> +
> +	while (count--)
> +		d[count] = s[count];
> +	return __dest;
> +}
> +#endif

The use of memcpy when __dest < __src is OK with some memcpy
implementations, but in a generic case it isn't guaranteed to work.
I think it would be better to just copy memmove from lib/string.c.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
