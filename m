Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2HDGtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 02:49:15 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35166 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2HDGtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 02:49:14 -0400
Date: Sat, 4 Aug 2012 02:49:10 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, linux@arm.linux.org.uk,
        will.deacon@arm.com
Subject: Re: [PATCH 04/22] ARM: LPAE: support 64-bit virt/phys patching
In-Reply-To: <1343775898-28345-5-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208040226060.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-5-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Cyril Chemparathy wrote:

> This patch adds support for 64-bit physical addresses in virt_to_phys
> patching.  This does not do real 64-bit add/sub, but instead patches in the
> upper 32-bits of the phys_offset directly into the output of virt_to_phys.

You should explain _why_ you do not a real aadd/sub.  I did deduce it 
but that might not be obvious to everyone.  Also this subtlety should be 
commented in the code as well.

> In addition to adding 64-bit support, this patch also adds a set_phys_offset()
> helper that is needed on architectures that need to modify PHYS_OFFSET during
> initialization.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> ---
>  arch/arm/include/asm/memory.h |   22 +++++++++++++++-------
>  arch/arm/kernel/head.S        |    6 ++++++
>  arch/arm/kernel/setup.c       |   14 ++++++++++++++
>  3 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 4a0108f..110495c 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -153,23 +153,31 @@
>  #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
>  
>  extern unsigned long __pv_phys_offset;
> -#define PHYS_OFFSET __pv_phys_offset
> -
> +extern unsigned long __pv_phys_offset_high;

As mentioned previously, this is just too ugly.  Please make 
__pv_phys_offset into a phys_addr_t instead and mask the low/high parts 
as needed in __virt_to_phys().

>  extern unsigned long __pv_offset;
>  
> +extern void set_phys_offset(phys_addr_t po);
> +
> +#define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)
> +
>  static inline phys_addr_t __virt_to_phys(unsigned long x)
>  {
> -	unsigned long t;
> -	early_patch_imm8(x, t, "add", __pv_offset);
> -	return t;
> +	unsigned long tlo, thi = 0;
> +
> +	early_patch_imm8(x, tlo, "add", __pv_offset);
> +	if (sizeof(phys_addr_t) > 4)
> +		early_patch_imm8(0, thi, "add", __pv_phys_offset_high);

Given the high part is always the same, isn't there a better way than an 
add with 0 that could be done here?  The add will force a load of 0 in a 
register needlessly just to add a constant value to it.  Your new 
patching framework ought to be able to patch a mov (or a mvn) 
instruction directly.


Nicolas
