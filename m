Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab2HOPV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:21:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53117 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2HOPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:21:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 26/31] arm64: Miscellaneous library functions
Date: Wed, 15 Aug 2012 15:21:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-27-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-27-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151521.14663.arnd@arndb.de>
X-Provags-ID: V02:K0:+TD9sq9YcwpvwA11Du8GNdOM7yNljDuqCn5ZF2XgUkk
 nTibRjWvJmuxwCklbVkw6a+aQODaq6PlIRByfDl5H6xzUQffYz
 H15oz/KK5vWNNR2JEF8ySSsY+Q4nWpUHBLqBq0UQSyzUF6nOMK
 94NRvJYOVAy4iQ14R8D7+RGB4usSybha3XdXD1TLzG1Jkzk5r9
 GI5L9BbJmVWlEW14M5HAUVMKTzdm+9q5p2b4ErW3A+AN76CZnA
 /xGN9uAzdWS1/QF53nCzh2rubcS2EENrhNE7ZdbkgifvvX4lyq
 vESJRuAwhB9I/uPdNbeKTTyb/ouv8JkxItPLccQtNQZDT/ez4K
 LosZ9vAe5GZuiQXPxzho=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:

> +
> +/*
> + * Use compiler builtins for simple inline operations.
> + */
> +static inline unsigned long __ffs(unsigned long word)
> +{
> +	return __builtin_ffsl(word) - 1;
> +}
> +
> +static inline int ffs(int x)
> +{
> +	return __builtin_ffs(x);
> +}
> +
> +static inline unsigned long __fls(unsigned long word)
> +{
> +	return BITS_PER_LONG - 1 - __builtin_clzl(word);
> +}
> +
> +static inline int fls(int x)
> +{
> +	return x ? sizeof(x) * BITS_PER_BYTE - __builtin_clz(x) : 0;
> +}

These are all great, but I think whether to use them or not should
depend on the compiler version rather than the architecture in
general. Do we know a minimum gcc version that supports all of the
above? Then we could put that code into the generic files.

If that's not possible, we could still make the implementation
available for other architectures by moving it to

asm-generic/bitops/builtin-__ffs.h
asm-generic/bitops/builtin-ffs.h
asm-generic/bitops/builtin-__fls.h
asm-generic/bitops/builtin-fls.h

> --- /dev/null
> +++ b/arch/arm64/lib/bitops.c
> @@ -0,0 +1,25 @@
> +/*
> + * Copyright (C) 2012 ARM Limited
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/spinlock.h>
> +#include <linux/atomic.h>
> +
> +#ifdef CONFIG_SMP
> +arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
> +       [0 ... (ATOMIC_HASH_SIZE-1)]  = __ARCH_SPIN_LOCK_UNLOCKED
> +};
> +#endif

What?

I suppose this is a leftover from an earlier version using the
generic bitops, right?

	Arnd
