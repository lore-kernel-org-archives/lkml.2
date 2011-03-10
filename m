Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1CJU47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:56:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1CJU46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:56:58 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=v1n8UvUeJUkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FJ-O0Z5dBjATENtXZwYA:9 a=LmoJojtc-SEYK0EblJoA:7 a=3bEtrHdSB4JJpL438IuUcb-1ihMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] jump label: introduce static_branch() interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
References: <cover.1299702291.git.jbaron@redhat.com>
	 <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 15:56:56 -0500
Message-ID: <1299790616.15854.417.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 15:47 -0500, Jason Baron wrote:

>  arch/mips/include/asm/jump_label.h  |   22 +-
>  arch/mips/kernel/jump_label.c       |    2 +-
>  arch/sparc/include/asm/jump_label.h |   25 +-
>  arch/x86/include/asm/alternative.h  |    3 +-
>  arch/x86/include/asm/jump_label.h   |   26 +-
>  arch/x86/kernel/alternative.c       |    2 +-
>  arch/x86/kernel/jump_label.c        |    2 +-
>  arch/x86/kernel/module.c            |    1 +
>  include/asm-generic/vmlinux.lds.h   |   14 +-
>  include/linux/dynamic_debug.h       |    2 -
>  include/linux/jump_label.h          |   86 ++++---
>  include/linux/jump_label_ref.h      |   44 ---
>  include/linux/perf_event.h          |   26 +-
>  include/linux/tracepoint.h          |   22 +-
>  kernel/jump_label.c                 |  537 ++++++++++++++---------------------
>  kernel/perf_event.c                 |    4 +-
>  kernel/tracepoint.c                 |   23 +-
>  17 files changed, 352 insertions(+), 489 deletions(-)
>  delete mode 100644 include/linux/jump_label_ref.h
> 
> diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
> index 7622ccf..1881b31 100644
> --- a/arch/mips/include/asm/jump_label.h
> +++ b/arch/mips/include/asm/jump_label.h
> @@ -20,16 +20,18 @@
>  #define WORD_INSN ".word"
>  #endif
>  
> -#define JUMP_LABEL(key, label)						\
> -	do {								\
> -		asm goto("1:\tnop\n\t"					\
> -			"nop\n\t"					\
> -			".pushsection __jump_table,  \"a\"\n\t"		\
> -			WORD_INSN " 1b, %l[" #label "], %0\n\t"		\
> -			".popsection\n\t"				\
> -			: :  "i" (key) :  : label);			\
> -	} while (0)
> -
> +static __always_inline bool arch_static_branch(struct jump_label_key *key)
> +{
> +	asm goto("1:\tnop\n\t"
> +		"nop\n\t"
> +		".pushsection __jump_table,  \"aw\"\n\t"
> +		WORD_INSN " 1b, %l[l_yes], %0\n\t"
> +		".popsection\n\t"
> +		: :  "i" (key) : : l_yes);
> +	return false;
> +l_yes:
> +	return true;
> +}
>  
>  #endif /* __KERNEL__ */
>  
> diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
> index 6001610..09ac7ca 100644
> --- a/arch/mips/kernel/jump_label.c
> +++ b/arch/mips/kernel/jump_label.c
> @@ -6,11 +6,11 @@
>   * Copyright (c) 2010 Cavium Networks, Inc.
>   */
>  
> -#include <linux/jump_label.h>
>  #include <linux/kernel.h>
>  #include <linux/memory.h>
>  #include <linux/mutex.h>
>  #include <linux/types.h>
> +#include <linux/jump_label.h>
>  #include <linux/cpu.h>
>  
>  #include <asm/cacheflush.h>

Hi Ralf,

Can I get your Acked-by on this patch.

Thanks,

-- Steve


