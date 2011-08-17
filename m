Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1HQUj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:39:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab1HQUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 03/36] Hexagon: Add bitops support
Date: Wed, 17 Aug 2011 21:19 +0200
Message-ID: <3654942.CdI694lZOj@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163520.145693358@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163520.145693358@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4I9dHLmgz5+Zo60lpiuyOzu0i0cDk4sNxl3Mx2tCPRD
 htl8j9H6NapAFHLtiXpvqH64xu9E8/W/tYBcl+OY8msDGz4e/3
 s+PwJTifxHQ+xP4rZhNLeNzhZ0f/T/B4NYXYc83Qr+bQNrhYWL
 7fZLJaoYHg/C/3oKv+2BqAPih6E5zcB8stUBMn0sSTZybfvM82
 lTmqW5w6d+MnxWadA4i3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:00 Richard Kuo wrote:

> +
> +#ifdef CONFIG_HEXAGON_BITOPS
> +#include <asm/bitops/ffz.h>
> +#include <asm/bitops/fls.h>
> +#include <asm/bitops/ffs.h>
> +#include <asm/bitops/__ffs.h>
> +#include <asm/bitops/__fls.h>
> +#else
> +#include <asm-generic/bitops/ffz.h>
> +#include <asm-generic/bitops/fls.h>
> +#include <asm-generic/bitops/ffs.h>
> +#include <asm-generic/bitops/__ffs.h>
> +#define __fls(x) (fls(x) - 1)
> +#endif

Is there a particular reason why this is configurable? Also, I see no reaons
to split these up into lots of files. Just put all of them into one file.

> +/*
> + * __ffs - find first bit in word.
> + * @word: The word to search
> + *
> + * Undefined if no bit exists, so code should check against 0 first.
> + *
> + * bits_per_long assumed to be 32
> + * numbering starts at 0 I think (instead of 1 like ffs)
> + */
> +static inline unsigned long __ffs(unsigned long word)
> +{
> +	int num;
> +
> +	asm volatile("%0 = ct0(%1);\n"
> +		: "=&r" (num)
> +		: "r" (word));
> +
> +	return num;
> +}

I think this should not be marked volatile: If the result is unused,
there is no need to compute the value either. Same for __fls, ffs,
ffz, and fls.

> +/*
> + * ffs - find first bit set
> + * @x: the word to search
> + *
> + * This is defined the same way as
> + * the libc and compiler builtin ffs routines, therefore
> + * differs in spirit from the above ffz (man ffs).
> + */
> +static inline int ffs(int x)
> +{

The type is normally 'long', not 'int'. They are obviously the
same length on 32 bit machines, but you might get bogus compiler
warnings from this. Same for ffz and fls.

	Arnd
