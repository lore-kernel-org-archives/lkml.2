Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab1BYU2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:28:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58884 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab1BYU2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:28:39 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=9ezeExTAcuIA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VEHg06Ss6gfFTxLn4dMA:9 a=UDBuzWyQ-3EmFpOaIlvRFSh_h8wA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 25 Feb 2011 15:28:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V3 3/5] Generic support for
 this_cpu_cmpxchg_double
Message-ID: <20110225202837.GC23161@home.goodmis.org>
References: <20110225173850.486326452@linux.com>
 <20110225174155.786331687@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225174155.786331687@linux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 11:38:53AM -0600, Christoph Lameter wrote:
>  
> +/*
> + * Special handling for cmpxchg_double. cmpxchg_double is passed two
> + * percpu variables. The first has to be aligned to a double word
> + * boundary and the second has to follow directly thereafter.
> + */
> +#define __pcpu_double_call_return_int(stem, pcp1, pcp2, ...)		\
> +({									\
> +	int ret__;							\
> +	__verify_pcpu_ptr(&pcp1);					\
> +	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));		\
> +	VM_BUG_ON((unsigned long)(&pcp2) != (unsigned long)(&pcp1) + sizeof(pcp1));\
> +	VM_BUG_ON(sizeof(pcp1) != sizeof(pcp2));			\

Since this is a macro, and it looks like all these are constants (sizeof
and addresses), couldn't you just do a BUILD_BUG_ON() instead?

-- Steve


> +	switch(sizeof(pcp1)) {						\
> +	case 1: ret__ = stem##1(pcp1, pcp2, __VA_ARGS__);break;		\
> +	case 2: ret__ = stem##2(pcp1, pcp2, __VA_ARGS__);break;		\
> +	case 4: ret__ = stem##4(pcp1, pcp2, __VA_ARGS__);break;		\
> +	case 8: ret__ = stem##8(pcp1, pcp2, __VA_ARGS__);break;		\
> +	default:							\
> +		__bad_size_call_parameter();break;			\
> +	}								\
> +	ret__;								\
> +})
> +
