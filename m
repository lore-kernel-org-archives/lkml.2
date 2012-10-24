Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517Ab2JXKZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:25:42 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35243 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab2JXKZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:25:40 -0400
Date: Wed, 24 Oct 2012 12:25:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: Improve 64 bit __phys_addr call performance
Message-ID: <20121024102533.GA10447@gmail.com>
References: <20121009185057.15478.86075.stgit@gitlad.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009185057.15478.86075.stgit@gitlad.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Duyck <alexander.h.duyck@intel.com> wrote:

> This patch is meant to improve overall system performance when 
> making use of the __phys_addr call on 64 bit x86 systems.  To 
> do this I have implemented several changes.
> 
> First if CONFIG_DEBUG_VIRTUAL is not defined __phys_addr is 
> made an inline, similar to how this is currently handled in 32 
> bit.  However in order to do this it is required to export 
> phys_base so that it is available if __phys_addr is used in 
> kernel modules.
> 
> The second change was to streamline the code by making use of 
> the carry flag on an add operation instead of performing a 
> compare on a 64 bit value.  The advantage to this is that it 
> allows us to reduce the overall size of the call. On my Xeon 
> E5 system the entire __phys_addr inline call consumes 30 bytes 
> and 5 instructions.  I also applied similar logic to the debug 
> version of the function.  My testing shows that the debug 
> version of the function with this patch applied is slightly 
> faster than the non-debug version without the patch.
> 
> Finally, when building the kernel with the first two changes 
> applied I saw build warnings about __START_KERNEL_map and 
> PAGE_OFFSET constants not fitting in their type.  In order to 
> resolve the build warning I changed their type from UL to ULL.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> ---
> 
>  arch/x86/include/asm/page_64_types.h |   16 ++++++++++++++--
>  arch/x86/kernel/x8664_ksyms_64.c     |    3 +++
>  arch/x86/mm/physaddr.c               |   20 ++++++++++++++------
>  3 files changed, 31 insertions(+), 8 deletions(-)

> +#ifdef CONFIG_DEBUG_VIRTUAL
>  extern unsigned long __phys_addr(unsigned long);
> +#else
> +static inline unsigned long __phys_addr(unsigned long x)
> +{
> +	unsigned long y = x - __START_KERNEL_map;
> +
> +	/* use the carry flag to determine if x was < __START_KERNEL_map */
> +	x = y + ((x > y) ? phys_base : (__START_KERNEL_map - PAGE_OFFSET));
> +
> +	return x;
> +}

This is a rather frequently used primitive. By how much does 
this patch increase a 'make defconfig' kernel's vmlinux, as 
measured via 'size vmlinux'?

Thanks,

	Ingo
