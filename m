Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0E1GYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:24:10 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:65202 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750988Ab0E1GYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:24:06 -0400
Date: Fri, 28 May 2010 16:23:42 +1000
From: David McCullough <david_mccullough@mcafee.com>
To: Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH 1/2 v2] FLAT: split the stack & data alignments
Message-ID: <20100528062342.GA20365@mcafee.com>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
 <1274863506-14168-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1274863506-14168-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 May 2010 06:23:43.0712 (UTC) FILETIME=[525AE600:01CAFE2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jivin Mike Frysinger lays it down ...
> The stack and data have different alignment requirements, so don't force
> them to wear the same shoe.  Increase the data alignment to match that
> which the elf2flt linker script has always been using: 0x20 bytes.  Not
> only does this bring the kernel loader in line with the toolchain, but
> it also fixes a swath of gcc tests which try to force larger alignment
> values but randomly fail when the FLAT loader fails to deliver.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: David McCullough <david_mccullough@mcafee.com>

Cheers,
Davidm

> ---
> v2
> 	- split changes & document better
> 
>  fs/binfmt_flat.c |   23 +++++++++++++++--------
>  1 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> index 49566c1..b865622 100644
> --- a/fs/binfmt_flat.c
> +++ b/fs/binfmt_flat.c
> @@ -56,15 +56,22 @@
>  #endif
>  
>  /*
> - * User data (stack, data section and bss) needs to be aligned
> - * for the same reasons as SLAB memory is, and to the same amount.
> - * Avoid duplicating architecture specific code by using the same
> - * macro as with SLAB allocation:
> + * User data (data section and bss) needs to be aligned.
> + * We pick 0x20 here because it is the max value elf2flt has always
> + * used in producing FLAT files, and because it seems to be large
> + * enough to make all the gcc alignment related tests happy.
> + */
> +#define FLAT_DATA_ALIGN	(0x20)
> +
> +/*
> + * User data (stack) also needs to be aligned.
> + * Here we can be a bit looser than the data sections since this
> + * needs to only meet arch ABI requirements.
>   */
>  #ifdef ARCH_SLAB_MINALIGN
> -#define FLAT_DATA_ALIGN	(ARCH_SLAB_MINALIGN)
> +#define FLAT_STACK_ALIGN	(ARCH_SLAB_MINALIGN)
>  #else
> -#define FLAT_DATA_ALIGN	(sizeof(void *))
> +#define FLAT_STACK_ALIGN	(sizeof(void *))
>  #endif
>  
>  #define RELOC_FAILED 0xff00ff01		/* Relocation incorrect somewhere */
> @@ -129,7 +136,7 @@ static unsigned long create_flat_tables(
>  
>  	sp = (unsigned long *)p;
>  	sp -= (envc + argc + 2) + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
> -	sp = (unsigned long *) ((unsigned long)sp & -FLAT_DATA_ALIGN);
> +	sp = (unsigned long *) ((unsigned long)sp & -FLAT_STACK_ALIGN);
>  	argv = sp + 1 + (flat_argvp_envp_on_stack() ? 2 : 0);
>  	envp = argv + (argc + 1);
>  
> @@ -876,7 +883,7 @@ static int load_flat_binary(struct linux_binprm * bprm, struct pt_regs * regs)
>  	stack_len = TOP_OF_ARGS - bprm->p;             /* the strings */
>  	stack_len += (bprm->argc + 1) * sizeof(char *); /* the argv array */
>  	stack_len += (bprm->envc + 1) * sizeof(char *); /* the envp array */
> -	stack_len += FLAT_DATA_ALIGN - 1;  /* reserve for upcoming alignment */
> +	stack_len += FLAT_STACK_ALIGN - 1;  /* reserve for upcoming alignment */
>  	
>  	res = load_flat_file(bprm, &libinfo, 0, &stack_len);
>  	if (IS_ERR_VALUE(res))
> -- 
> 1.7.1
> 
> 
> 

-- 
David McCullough,      david_mccullough@mcafee.com,  Ph:+61 734352815
McAfee - SnapGear      http://www.mcafee.com         http://www.uCdot.org
