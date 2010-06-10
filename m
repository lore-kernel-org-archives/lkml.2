Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0FJEga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 00:36:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42488 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab0FJEg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 00:36:29 -0400
Message-ID: <4C106BB3.7090107@zytor.com>
Date: Wed, 09 Jun 2010 21:36:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, x86@kernel.org
Subject: Re: [PATCH] x86: OLPC: add support for calling into OpenFirmware
 (v2)
References: <20100610001419.7487d5f7@dev.queued.net>
In-Reply-To: <20100610001419.7487d5f7@dev.queued.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 09:14 PM, Andres Salomon wrote:
> 
> Add support for saving OFW's cif, and later calling into it to run OFW
> commands.  OFW remains resident in memory, living within virtual range
> 0xff800000 - 0xffc00000.  A single page directory entry points to the
> pgdir that OFW actually uses, so rather than saving the entire page
> table, we save that one entry (and restore it for the call into OFW).
> 
> This is currently only used by the OLPC XO; however, there's nothing
> restricting OFW's usage on other (x86) platforms.

... well, except for the fact that the protocol is insane, and not used
by anything else ...

> diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
> index 86b1506..5cba9eb 100644
> --- a/arch/x86/include/asm/setup.h
> +++ b/arch/x86/include/asm/setup.h
> @@ -21,6 +21,7 @@
>  #define OLD_CL_MAGIC		0xA33F
>  #define OLD_CL_ADDRESS		0x020	/* Relative to real mode data */
>  #define NEW_CL_POINTER		0x228	/* Relative to real mode data */
> +#define OLPC_OFW_INFO_OFFSET	0xB0	/* Relative to real mode data */

This should be added to struct boot_params as well as the various
documentation files.  I note also that this interrupts one of the
largest available spans we have in this structure, but I guess there is
very little that can be done about that.

> +#ifdef CONFIG_OLPC_OPENFIRMWARE
> +	movl $0x0, pa(olpc_ofw_cif)
> +

We just cleared BSS -- there is no point in doing this.

> +	/* Did OpenFirmware boot us? */
> +	movl $pa(boot_params) + OLPC_OFW_INFO_OFFSET, %ebp
> +	cmpl $0x2057464F, (%ebp)	/* Magic number "OFW " */
> +	jne 3f
> +

This stuff is in high memory, or otherwise protected in the memory map,
no?  If so, there is absolutely no point in doing this this early; it
can be done in C code just fine.  The only thing that needs to be done
is to same the value of %cr3 on entry (and not even the offset value of
%cr3).

> +	/* Save the callback address for calling into OFW from linux */
> +	mov 0x8(%ebp), %eax
> +	mov %eax, pa(olpc_ofw_cif)

Again, please put the definition of the entire structure into struct
boot_params as well as in the relevant documentation files.

It's really too bad that you didn't re-use the location used for struct
efi_info since that is mutually exclusive and has a signature.

I won't pick on you for not using the platform ID since that is a rather
new invention, but it would have been beneficial rather than ad hoc
inventions all along...

> +/* setup and do actual call into OFW */
> +static int setup_ofw(int *ofw_args)
> +{
> +	pgd_t *base, *pde;
> +	pgdval_t oldval;
> +	int ret;
> +
> +	/* temporarily clobber %cr3[OLPC_OFW_PDE_NR] w/ olpc_ofw_pgd */
> +	base = __va(read_cr3());
> +	pde = &base[OLPC_OFW_PDE_NR];
> +	oldval = pgd_val(*pde);
> +	set_pgd(pde, __pgd(olpc_ofw_pgd));
> +	flush_tlb();
> +
> +	/* call into ofw */
> +	ret = olpc_ofw_cif(ofw_args);
> +
> +	/* restore %cr3[OLPC_OFW_PDE_NR] */
> +	set_pgd(pde, __pgd(oldval));
> +	flush_tlb();
> +
> +	return ret;
> +}

Why are you still mucking around with swapping %cr3s?  Once you have
claimed top of the virtual address space, you can install your PGD
permanently.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

