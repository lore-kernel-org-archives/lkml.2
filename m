Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2LLNjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 08:39:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52019 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab2LLNi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 08:38:58 -0500
Date: Wed, 12 Dec 2012 14:38:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121212133853.GC8760@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"mingo@kernel.org" <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@linux.intel.com" <hpa@linux.intel.com>,
	"linux-tip-commits@vger.kernel.org" <linux-tip-commits@vger.kernel.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
References: <CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com>
 <50C763C2.5020603@zytor.com>
 <CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com>
 <20121211170605.GD28827@liondog.tnic>
 <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
 <50C76F9E.4080001@zytor.com>
 <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com>
 <50C7C859.60405@zytor.com>
 <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com>
 <50C82ABF.3020907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C82ABF.3020907@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:57:03PM -0800, H. Peter Anvin wrote:
> @@ -372,46 +394,21 @@ ENTRY(name)
>  	i = i + 1 ;					\
>  	.endr
>  
> -	.data
> -	/*
> -	 * This default setting generates an ident mapping at address 0x100000
> -	 * and a mapping for the kernel that precisely maps virtual address
> -	 * 0xffffffff80000000 to physical address 0x000000. (always using
> -	 * 2Mbyte large pages provided by PAE mode)
> -	 */
> -NEXT_PAGE(init_level4_pgt)
> -	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE

We completely lost level3_ident_pgt, causing:

arch/x86/built-in.o: In function `setup_real_mode':
/home/boris/kernel/linux-2.6/arch/x86/realmode/init.c:81: undefined reference to `level3_ident_pgt'
make: *** [vmlinux] Error 1

> -	.org	init_level4_pgt + L4_PAGE_OFFSET*8, 0
> -	.quad	level3_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
> -	.org	init_level4_pgt + L4_START_KERNEL*8, 0
> -	/* (2^48-(2*1024*1024*1024))/(2^39) = 511 */
> +	__INITDATA
> +NEXT_PAGE(early_level4_pgt)
> +	.fill	511,8,0
>  	.quad	level3_kernel_pgt - __START_KERNEL_map + _PAGE_TABLE
>  
> -NEXT_PAGE(level3_ident_pgt)
> -	.quad	level2_ident_pgt - __START_KERNEL_map + _KERNPG_TABLE
> -	.fill	511,8,0
> +NEXT_PAGE(early_dynamic_pgts)
> +	.fill	512*EARLY_DYNAMIC_PAGE_TABLES,8,0
>  
> +	.data
>  NEXT_PAGE(level3_kernel_pgt)
>  	.fill	L3_START_KERNEL,8,0
>  	/* (2^48-(2*1024*1024*1024)-((2^39)*511))/(2^30) = 510 */
>  	.quad	level2_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
>  	.quad	level2_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
>  
> -NEXT_PAGE(level2_fixmap_pgt)
> -	.fill	506,8,0
> -	.quad	level1_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
> -	/* 8MB reserved for vsyscalls + a 2MB hole = 4 + 1 entries */
> -	.fill	5,8,0
> -
> -NEXT_PAGE(level1_fixmap_pgt)
> -	.fill	512,8,0

You still need that NEXT_PAGE(level1_fixmap_pgt) thing:

arch/x86/kernel/head_64.o: In function `level2_fixmap_pgt':
(.data+0x2fd0): undefined reference to `level1_fixmap_pgt'

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
