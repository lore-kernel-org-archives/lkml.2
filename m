Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1CJUyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:54:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35401 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1CJUyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:54:36 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=v1n8UvUeJUkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FJ-O0Z5dBjATENtXZwYA:9 a=MoQl1j82xbRd6Wnv_D0A:7 a=2XJ-r7wPd6RKmi8YImvrLPvVTTkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] jump label: introduce static_branch() interface
From: Steven Rostedt <rostedt@goodmis.org>
To: davem@davemloft.net
Cc: Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        Avi Kivity <avi@redhat.com>, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
References: <cover.1299702291.git.jbaron@redhat.com>
	 <49b4727c7bfee19c2b7284b3339076ed827f3142.1299702291.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 15:54:32 -0500
Message-ID: <1299790472.15854.414.camel@gandalf.stny.rr.com>
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


> diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
> index 427d468..fc73a82 100644
> --- a/arch/sparc/include/asm/jump_label.h
> +++ b/arch/sparc/include/asm/jump_label.h
> @@ -7,17 +7,20 @@
>  
>  #define JUMP_LABEL_NOP_SIZE 4
>  
> -#define JUMP_LABEL(key, label)					\
> -	do {							\
> -		asm goto("1:\n\t"				\
> -			 "nop\n\t"				\
> -			 "nop\n\t"				\
> -			 ".pushsection __jump_table,  \"a\"\n\t"\
> -			 ".align 4\n\t"				\
> -			 ".word 1b, %l[" #label "], %c0\n\t"	\
> -			 ".popsection \n\t"			\
> -			 : :  "i" (key) :  : label);\
> -	} while (0)
> +static __always_inline bool arch_static_branch(struct jump_label_key *key)
> +{
> +		asm goto("1:\n\t"
> +			 "nop\n\t"
> +			 "nop\n\t"
> +			 ".pushsection __jump_table,  \"aw\"\n\t"
> +			 ".align 4\n\t"
> +			 ".word 1b, %l[l_yes], %c0\n\t"
> +			 ".popsection \n\t"
> +			 : :  "i" (key) : : l_yes);
> +	return false;
> +l_yes:
> +	return true;
> +}
>  
>  #endif /* __KERNEL__ */
>  

Hi David,

Can I get your Acked-by for this patch.

Thanks,

-- Steve


