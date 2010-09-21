Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0IUKLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 06:11:09 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48204 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0IUKLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 06:11:08 -0400
Date: Tue, 21 Sep 2010 11:11:05 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: wuzhangjin@gmail.com, linux-mips@linux-mips.org, alex@digriz.org.uk,
        manuel.lauss@googlemail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix vmlinuz to flush the caches after kernel
 decompression
Message-ID: <20100921101105.GA32343@linux-mips.org>
References: <4c7e1a3a.c83ddf0a.5918.ffffcf6a@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c7e1a3a.c83ddf0a.5918.ffffcf6a@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 12:17:43PM +0300, Shmulik Ladkani wrote:

> Flush caches after kernel decompression.
> 
> When writing instructions, the D-cache should be written-back, and I-cache
> should be invalidated.

Correct - but it's also a can of worms which is why I intentionally
ignored the issue so far.  An I-cache is refilled from L2/L3 (if available)
or memory.  The large amounts of data written by the CPU during
decompression of the kernel virtually guarantee that all code will be
written back to L2/L3 or memory and the I-cache has been flushed by
firmware before the decompressor was entered.

Does this assumption fail for you?

The real can of worms is SMP - none of the other processors have been
detected etc.  At this early stage we just don't know if and how to flush
caches of other processors.  The only good news is that we know they
don't have any not written back kernel code in their D-caches.

> The patch implements L1 cache flushing, for r4k style caches - suitable for
> all MIPS32 CPUs (and probably for other CPUs too).

No - you only compile the code for MIPS32 CPUs and check for MIPS_CONF_M
which - at least with this meaning - only exists on MIPS32 and MIPS64 CPUs.

> +#define INDEX_BASE CKSEG0
> +
> +extern void puts(const char *s);
> +extern void puthex(unsigned long long val);
> +
> +#define cache_op(op, addr)			\
> +	__asm__ __volatile__(			\
> +	"	.set push		\n"	\
> +	"	.set noreorder		\n"	\
> +	"	.set mips3		\n"	\
> +	"	cache %1, 0(%0)		\n"	\
> +	"	.set pop		\n"	\
> +	:					\
> +	: "r" (addr), "i" (op))

This duplicates the definition of arch/mips/include/asm/r4kcache.h.  Why?

> +#define cache_all_index_op(cachesz, linesz, op) do {			\
> +	unsigned long addr = INDEX_BASE;				\
> +	for (; addr < INDEX_BASE + (cachesz); addr += (linesz))		\
> +		cache_op(op, addr);					\
> +} while (0)

For consistence in formatting please move the "do {" to the beginning of
the next line.

> +void cache_flush(void)
> +{
> +	volatile unsigned long config1;

I don't know why you're using volatile here - but it won't work as you
intended.  Just drop the keyword.

> +	unsigned long tmp;
> +	unsigned long line_size;
> +	unsigned long ways;
> +	unsigned long sets;
> +	unsigned long cache_size;

Make these int variables.  The code here is fine for MIPS64 as well but
there is no point in having 64-bit variables and multiplies.

> +	if (!(read_c0_config() & MIPS_CONF_M)) {
> +		puts("cache_flush error: Config1 unavailable\n");
> +		return;
> +	}
> +	config1 = read_c0_config1();
> +
> +	/* calculate D-cache line-size and cache-size, then writeback */
> +	tmp = (config1 >> 10) & 7;
> +	if (tmp) {
> +		line_size = 2 << tmp;
> +		sets = 64 << ((config1 >> 13) & 7);
> +		ways = 1 + ((config1 >> 7) & 7);
> +		cache_size = sets * ways * line_size;
> +		dcache_writeback(cache_size, line_size);
> +	}
> +
> +	/* calculate I-cache line-size and cache-size, then invalidate */
> +	tmp = (config1 >> 19) & 7;
> +	if (tmp) {
> +		line_size = 2 << tmp;
> +		sets = 64 << ((config1 >> 22) & 7);
> +		ways = 1 + ((config1 >> 16) & 7);
> +		cache_size = sets * ways * line_size;
> +		icache_invalidate(cache_size, line_size);
> +	}

Eww...  You copied (my ...) old sin from c-r4k.c and use all the magic
numbers.

Anyway, does this actually fix a bug for you or is it more a theoretical
convern?

  Ralf
