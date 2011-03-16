Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1CPUGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:06:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab1CPUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:06:17 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=GKT9XuWGNkgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=enOvQawGAAAA:8 a=WPyIoOwQAAAA:8 a=xCpPCuwOfPYqbEu2z7MA:9 a=zvIpYzOcd0bTzJNfTyUA:7 a=ubvZ7uGlWmhLyrzdn12TX3seY8MA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=bkT6KWdcy0IA:10 a=1DbiqZag68YA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Need ack from sparc maintainer (was: [PATCH 1/4] jump label:
 introduce static_branch() interface)
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        ralf@linux-mips.org, jang@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <2b6c03eb5ff0ed7c4d4a1cc9f1eb0fdff741aead.1300299760.git.jbaron@redhat.com>
References: <cover.1300299760.git.jbaron@redhat.com>
	 <2b6c03eb5ff0ed7c4d4a1cc9f1eb0fdff741aead.1300299760.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 16 Mar 2011 16:06:13 -0400
Message-ID: <1300305973.16880.47.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 15:58 -0400, Jason Baron wrote:
> Introduce:
> 
> static __always_inline bool static_branch(struct jump_label_key *key);
> 
> instead of the old JUMP_LABEL(key, label) macro.
> 
> In this way, jump labels become really easy to use:
> 
> Define:
> 
>         struct jump_label_key jump_key;
> 
> Can be used as:
> 
>         if (static_branch(&jump_key))
>                 do unlikely code
> 
> enable/disale via:
> 
>         jump_label_inc(&jump_key);
>         jump_label_dec(&jump_key);
> 
> that's it!
> 
> For the jump labels disabled case, the static_branch() becomes an
> atomic_read(), and jump_label_inc()/dec() are simply atomic_inc(),
> atomic_dec() operations. We show testing results for this change below.
> 
> Thanks to H. Peter Anvin for suggesting the 'static_branch()' construct.
> 
> Since we now require a 'struct jump_label_key *key', we can store a pointer into
> the jump table addresses. In this way, we can enable/disable jump labels, in
> basically constant time. This change allows us to completely remove the previous
> hashtable scheme. Thanks to Peter Zijlstra for this re-write.
> 
> Testing:
> 
> I ran a series of 'tbench 20' runs 5 times (with reboots) for 3
> configurations, where tracepoints were disabled.
> 
> jump label configured in
> avg: 815.6
> 
> jump label *not* configured in (using atomic reads)
> avg: 800.1
> 
> jump label *not* configured in (regular reads)
> avg: 803.4
> 
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Suggested-by: H. Peter Anvin <hpa@linux.intel.com>
> Tested-by: David Daney <ddaney@caviumnetworks.com>
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
> ---
>  arch/mips/include/asm/jump_label.h  |   22 +-
>  arch/sparc/include/asm/jump_label.h |   25 +-

Hi David,

Can you give your Acked-by for this change.

Thanks,

-- Steve

>  arch/x86/include/asm/alternative.h  |    3 +-
>  arch/x86/include/asm/jump_label.h   |   26 +-
>  arch/x86/kernel/alternative.c       |    2 +-
>  arch/x86/kernel/module.c            |    1 +
>  include/asm-generic/vmlinux.lds.h   |   14 +-
>  include/linux/dynamic_debug.h       |    2 -
>  include/linux/jump_label.h          |   89 ++++---
>  include/linux/jump_label_ref.h      |   44 ---
>  include/linux/perf_event.h          |   26 +-
>  include/linux/tracepoint.h          |   22 +-
>  kernel/jump_label.c                 |  539 ++++++++++++++---------------------
>  kernel/perf_event.c                 |    4 +-
>  kernel/tracepoint.c                 |   23 +-
>  15 files changed, 356 insertions(+), 486 deletions(-)
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


