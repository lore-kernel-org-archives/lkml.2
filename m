Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab0K0O6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 09:58:12 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41304 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752384Ab0K0O6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 09:58:09 -0500
Date: Sat, 27 Nov 2010 09:58:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thisops uV2 03/10] percpu: Generic support for
	this_cpu_add,sub,dec,inc_return
Message-ID: <20101127145806.GD15365@Krystal>
References: <20101126210937.383047168@linux.com> <20101126210950.722391707@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126210950.722391707@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:53:08 up 3 days, 19:56,  3 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> Introduce generic support for this_cpu_add_return etc.
> 
> The fallback is to realize these operations with __this_cpu_ops.
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  include/linux/percpu.h |   70 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> Index: linux-2.6/include/linux/percpu.h
> ===================================================================
> --- linux-2.6.orig/include/linux/percpu.h	2010-11-23 17:29:46.000000000 -0600
> +++ linux-2.6/include/linux/percpu.h	2010-11-23 17:31:14.000000000 -0600
> @@ -240,6 +240,20 @@ extern void __bad_size_call_parameter(vo
>  	pscr_ret__;							\
>  })
>  
> +#define __pcpu_size_call_return2(stem, variable, ...)			\
> +({	typeof(variable) pscr_ret__;					\

isn't it usual to do ?

( {                               \
  typeof(variable) pscr_ret__;    \

instead ?


> +	__verify_pcpu_ptr(&(variable));					\
> +	switch(sizeof(variable)) {					\
> +	case 1: pscr_ret__ = stem##1(variable, __VA_ARGS__);break;	\

;break; at the EOL seems a bit odd. Maybe moving it to the next line ?

> +	case 2: pscr_ret__ = stem##2(variable, __VA_ARGS__);break;	\
> +	case 4: pscr_ret__ = stem##4(variable, __VA_ARGS__);break;	\
> +	case 8: pscr_ret__ = stem##8(variable, __VA_ARGS__);break;	\
> +	default:							\
> +		__bad_size_call_parameter();break;			\
> +	}								\
> +	pscr_ret__;							\
> +})
> +
>  #define __pcpu_size_call(stem, variable, ...)				\
>  do {									\
>  	__verify_pcpu_ptr(&(variable));					\
> @@ -529,6 +543,62 @@ do {									\
>  # define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
>  #endif
>  
> +#define _this_cpu_generic_add_return(pcp, val)				\
> +({	typeof(pcp) ret__;						\

add newline after opening ({    \  ?

> +	preempt_disable();						\
> +	__this_cpu_add((pcp), val);					\

Hrm, you are inconsistent between your macros. Here you use "(pcp), " but above:
"(variable, ". I think the extra () are not needed in this case, so you might
want to consider removing these from (pcp).

> +	ret__ = __this_cpu_read((pcp));					\

Same here.

> +	preempt_enable();						\
> +	ret__;								\
> +})
> +
> +#ifndef this_cpu_add_return
> +# ifndef this_cpu_add_return_1
> +#  define this_cpu_add_return_1(pcp, val)	_this_cpu_generic_add_return(pcp, val)
> +# endif
> +# ifndef this_cpu_add_return_2
> +#  define this_cpu_add_return_2(pcp, val)	_this_cpu_generic_add_return(pcp, val)
> +# endif
> +# ifndef this_cpu_add_return_4
> +#  define this_cpu_add_return_4(pcp, val)	_this_cpu_generic_add_return(pcp, val)
> +# endif
> +# ifndef this_cpu_add_return_8
> +#  define this_cpu_add_return_8(pcp, val)	_this_cpu_generic_add_return(pcp, val)
> +# endif
> +# define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, (pcp), val)

Same here.

> +#endif
> +
> +#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
> +#define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
> +#define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
> +
> +#define __this_cpu_generic_add_return(pcp, val)				\
> +({	typeof(pcp) ret__;						\
> +	__this_cpu_add((pcp), val);					\
> +	ret__ = __this_cpu_read((pcp));					\

Same for above 2 lines.

> +	ret__;								\
> +})
> +
> +#ifndef __this_cpu_add_return
> +# ifndef __this_cpu_add_return_1
> +#  define __this_cpu_add_return_1(pcp, val)	__this_cpu_generic_add_return(pcp, val)
> +# endif
> +# ifndef __this_cpu_add_return_2
> +#  define __this_cpu_add_return_2(pcp, val)	__this_cpu_generic_add_return(pcp, val)
> +# endif
> +# ifndef __this_cpu_add_return_4
> +#  define __this_cpu_add_return_4(pcp, val)	__this_cpu_generic_add_return(pcp, val)
> +# endif
> +# ifndef __this_cpu_add_return_8
> +#  define __this_cpu_add_return_8(pcp, val)	__this_cpu_generic_add_return(pcp, val)
> +# endif
> +# define __this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, (pcp), val)

Same here.

Other than that:

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks,

Mathieu

> +#endif
> +
> +#define __this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))
> +#define __this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
> +#define __this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
> +
>  /*
>   * IRQ safe versions of the per cpu RMW operations. Note that these operations
>   * are *not* safe against modification of the same variable from another
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
