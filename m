Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab0ENCWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:22:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:45196 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab0ENCWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:22:06 -0400
Subject: Re: [PATCH 05/35] x86, lmb: Add lmb_find_area_size()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273796396-29649-6-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-6-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:20:21 +1000
Message-ID: <1273803621.21352.368.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> size is returned according free range.
> Will be used to find free ranges for early_memtest and memory corruption check

Please provide a better explanation of what these functions do. It's
very unclear from the code (which looks like it could be a lot simpler),
and the name of the function is totally obscure as well.

We have asked you how many times to improve on your changeset comments
at the -very-least- ? Explain what functions do and why they do it, and
when I say explain, I don't mean 2 lines of rot13. I mean actual
sentences that a human being can read and have a chance to understand.

Also, I would appreciate if you picked up the habit of adding docbook
doco for any API function you add, even if it's in the x86 "internal"
file.

Cheers,
Ben.

> Do not mess it up with mm/lmb.c yet.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/lmb.h |    8 ++++
>  arch/x86/mm/Makefile       |    2 +
>  arch/x86/mm/lmb.c          |   88 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/include/asm/lmb.h
>  create mode 100644 arch/x86/mm/lmb.c
> 
> diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
> new file mode 100644
> index 0000000..aa3a66e
> --- /dev/null
> +++ b/arch/x86/include/asm/lmb.h
> @@ -0,0 +1,8 @@
> +#ifndef _X86_LMB_H
> +#define _X86_LMB_H
> +
> +#define ARCH_DISCARD_LMB
> +
> +u64 lmb_find_area_size(u64 start, u64 *sizep, u64 align);
> +
> +#endif
> diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
> index a4c7683..8ab0505 100644
> --- a/arch/x86/mm/Makefile
> +++ b/arch/x86/mm/Makefile
> @@ -26,4 +26,6 @@ obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
>  obj-$(CONFIG_K8_NUMA)		+= k8topology_64.o
>  obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
>  
> +obj-$(CONFIG_HAVE_LMB)		+= lmb.o
> +
>  obj-$(CONFIG_MEMTEST)		+= memtest.o
> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
> new file mode 100644
> index 0000000..9d26eed
> --- /dev/null
> +++ b/arch/x86/mm/lmb.c
> @@ -0,0 +1,88 @@
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/bitops.h>
> +#include <linux/lmb.h>
> +#include <linux/bootmem.h>
> +#include <linux/mm.h>
> +#include <linux/range.h>
> +
> +/* Check for already reserved areas */
> +static inline bool __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
> +{
> +	int i;
> +	u64 addr = *addrp, last;
> +	u64 size = *sizep;
> +	bool changed = false;
> +again:
> +	last = addr + size;
> +	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.regions[i].size; i++) {
> +		struct lmb_region *r = &lmb.reserved.regions[i];
> +		if (last > r->base && addr < r->base) {
> +			size = r->base - addr;
> +			changed = true;
> +			goto again;
> +		}
> +		if (last > (r->base + r->size) && addr < (r->base + r->size)) {
> +			addr = round_up(r->base + r->size, align);
> +			size = last - addr;
> +			changed = true;
> +			goto again;
> +		}
> +		if (last <= (r->base + r->size) && addr >= r->base) {
> +			(*sizep)++;
> +			return false;
> +		}
> +	}
> +	if (changed) {
> +		*addrp = addr;
> +		*sizep = size;
> +	}
> +	return changed;
> +}
> +
> +static u64 __init __lmb_find_area_size(u64 ei_start, u64 ei_last, u64 start,
> +			 u64 *sizep, u64 align)
> +{
> +	u64 addr, last;
> +
> +	addr = round_up(ei_start, align);
> +	if (addr < start)
> +		addr = round_up(start, align);
> +	if (addr >= ei_last)
> +		goto out;
> +	*sizep = ei_last - addr;
> +	while (bad_addr_size(&addr, sizep, align) && addr + *sizep <= ei_last)
> +		;
> +	last = addr + *sizep;
> +	if (last > ei_last)
> +		goto out;
> +
> +	return addr;
> +
> +out:
> +	return LMB_ERROR;
> +}
> +
> +/*
> + * Find next free range after *start
> + */
> +u64 __init lmb_find_area_size(u64 start, u64 *sizep, u64 align)
> +{
> +	int i;
> +
> +	for (i = 0; i < lmb.memory.cnt; i++) {
> +		u64 ei_start = lmb.memory.regions[i].base;
> +		u64 ei_last = ei_start + lmb.memory.regions[i].size;
> +		u64 addr;
> +
> +		addr = __lmb_find_area_size(ei_start, ei_last, start,
> +					 sizep, align);
> +
> +		if (addr != LMB_ERROR)
> +			return addr;
> +	}
> +
> +	return LMB_ERROR;
> +}
> +


