Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1AGOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:09:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1AGOJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:09:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCHv1 04/12] unicore32 core architecture: low level entry and setup code
Date: Fri, 7 Jan 2011 01:04:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <00cc01cba464$16e6a410$44b3ec30$@mprc.pku.edu.cn>
In-Reply-To: <00cc01cba464$16e6a410$44b3ec30$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070104.57770.arnd@arndb.de>
X-Provags-ID: V02:K0:8bi4JYlnI8eC/JR4x+TZ9P3LkPydr059biKcjTzfS0k
 oscXVimxA0VMbqlZE0mPSAkCkeFpbhaKCOo6S6i5G3hf00xHGW
 nz++ESE6rw932nQjmZRITRGkFkt5IO7DBhFUtjRHwFII1ftI6P
 7UzYb8PgfqplweTv2Ay3+oq9QA8AaVOnTHXq0IumlElqZ7gLz2
 o29+gjeTH3V6LQmKfE2cw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 December 2010, Guan Xuetao wrote:
> +#ifdef __KERNEL__
> +
> +/*
> + * Memory map description
> + */
> +# define NR_BANKS 8
> +
> +struct membank {
> +	unsigned long start;
> +	unsigned long size;
> +	unsigned int highmem;
> +};
> +
> +struct meminfo {
> +	int nr_banks;
> +	struct membank bank[NR_BANKS];
> +};
> +
> +extern struct meminfo meminfo;
> +
> +#define for_each_bank(iter, mi)				\
> +	for (iter = 0; iter < (mi)->nr_banks; iter++)
> +
> +#define bank_pfn_start(bank)	__phys_to_pfn((bank)->start)
> +#define bank_pfn_end(bank)	__phys_to_pfn((bank)->start + (bank)->size)
> +#define bank_pfn_size(bank)	((bank)->size >> PAGE_SHIFT)
> +#define bank_phys_start(bank)	((bank)->start)
> +#define bank_phys_end(bank)	((bank)->start + (bank)->size)
> +#define bank_phys_size(bank)	((bank)->size)

The membank stuff looks like a variation of the generic memblock interfaces.

> +/*
> + * Handle all unrecognised system calls.
> + *  0x9f0000 - 0x9fffff are some more esoteric system calls
> + */
> +#define NR(x) ((__UNICORE_NR_##x) - __UNICORE_NR_BASE)
> +asmlinkage int uc32_syscall(int no, struct pt_regs *regs)
> +{
> +	if ((no >> 16) != (__UNICORE_NR_BASE >> 16))
> +		return -ENOSYS;
> +
> +	switch (no & 0xffff) {
> +	/*
> +	 * Flush a region from virtual address 'r0' to virtual address 'r1'
> +	 * _exclusive_.  There is no alignment requirement on either address;
> +	 * user space does not need to know the hardware cache layout.
> +	 *
> +	 * r2 contains flags.  It should ALWAYS be passed as ZERO until it
> +	 * is defined to be something else.  For now we ignore it, but may
> +	 * the fires of hell burn in your belly if you break this rule. ;)
> +	 *
> +	 * (at a later date, we may want to allow this call to not flush
> +	 * various aspects of the cache.  Passing '0' will guarantee that
> +	 * everything necessary gets flushed to maintain consistency in
> +	 * the specified region).
> +	 */
> +	case NR(cacheflush):
> +		do_cache_op(regs->UCreg_00, regs->UCreg_01, regs->UCreg_02);
> +		return 0;
> +
> +	case NR(cmpxchg):
> +		return do_cmpxchg_op(regs);
> +
> +	default:
> +		return -ENOSYS;
> +	}
> +}

With the generic system cal interface, this function should be replaced
with straight system calls for each of the subfunctions.

Just use things definitions like

#define __NR_cacheflush __NR_arch_specific_syscall
__SYSCALL(__NR_cacheflush, sys_uc32_cacheflush)
#define __NR_cmpxchg __NR_arch_specific_syscall+1
__SYSCALL(__NR_cmpxchg, sys_uc32_cacheflush

in your asm/unistd.h file.

	Arnd

