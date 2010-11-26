Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0KZQcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:32:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:60185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab0KZQcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:32:04 -0500
Message-ID: <4CEFE0E8.5050207@kernel.org>
Date: Fri, 26 Nov 2010 17:31:36 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [thiscpuops upgrade 03/10] percpu: Generic support for this_cpu_add,sub,dec,inc_return
References: <20101123235139.908255844@linux.com> <20101123235157.644134695@linux.com>
In-Reply-To: <20101123235157.644134695@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 16:31:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 12:51 AM, Christoph Lameter wrote:
> Introduce generic support for this_cpu_add_return etc.
> 
> The fallback is to realize these operations with __this_cpu_ops.
> 
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
> +	__verify_pcpu_ptr(&(variable));					\
> +	switch(sizeof(variable)) {					\
> +	case 1: pscr_ret__ = stem##1(variable, __VA_ARGS__);break;	\
> +	case 2: pscr_ret__ = stem##2(variable, __VA_ARGS__);break;	\
> +	case 4: pscr_ret__ = stem##4(variable, __VA_ARGS__);break;	\
> +	case 8: pscr_ret__ = stem##8(variable, __VA_ARGS__);break;	\
> +	default:							\
> +		__bad_size_call_parameter();break;			\
> +	}								\
> +	pscr_ret__;							\
> +})

If we're gonna do __VA_ARGS__, can't we just replace
__pcpu_size_call_return()?  Other than that, looks good to me.

Thanks.

-- 
tejun
