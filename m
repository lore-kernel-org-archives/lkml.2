Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1JJRIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:08:18 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:36119 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751866Ab1JJRIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:08:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UwOaNAQVM1m3hrLhEglcAPDsMnXZbUj.wLqM690zmBhNSkW
 Fb29g0yzGxa_y2iGmhFE2JSFYyLw90qpuYOU3puTc.iRSOdrnuXyWZtGsy.A
 h1hnTdHQDNj9WWcsV8Hnw92J6cr1.K0tCrXMCaXVDkYhDkvwrPTmGRvDiRNh
 TmauueZxTwFtcxch0R58mNhqG9_lW5Mb6Bpf4Eoo3kFLeTPNn.8zuUSJH5kB
 udlw_vNDl2LrqtjH2ENxziCKwLzkmrirtVRJawlpZlzhRVElWa6yJyAJ7vZl
 HcFTD7qLl.oTxO9GbB.40E8xhJBWSBWCx.9Q62e4jDYp4u6o8b1NVj7m5qpl
 X_N04e2N59zzMXOiHXa8XE80C4CWuuW0w7OJkfkP49DDxKIVvdL0l7TBVzyp
 vQSm8BTAkvfUvs3njSpJ4eYA-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 10 Oct 2011 12:08:13 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: tj@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
In-Reply-To: <1318237851.27949.190.camel@debian>
Message-ID: <alpine.DEB.2.00.1110101026080.16264@router.home>
References: <1318237851.27949.190.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Alex,Shi wrote:

> index 3470c9d..d1de56c 100644
> --- a/arch/x86/include/asm/percpu.h
> +++ b/arch/x86/include/asm/percpu.h
> @@ -46,7 +46,7 @@
>
>  #ifdef CONFIG_SMP
>  #define __percpu_prefix		"%%"__stringify(__percpu_seg)":"
> -#define __my_cpu_offset		percpu_read(this_cpu_off)
> +#define __my_cpu_offset		this_cpu_read(this_cpu_off)

Should this not be __this_cpu_read() instead?

>   * per-thread variables implemented as per-cpu variables and thus
>   * stable for the duration of the respective task.
>   */
> -#define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
> -#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
> -#define percpu_write(var, val)		percpu_to_op("mov", var, val)
> -#define percpu_add(var, val)		percpu_add_op(var, val)
> -#define percpu_sub(var, val)		percpu_add_op(var, -(val))
> -#define percpu_and(var, val)		percpu_to_op("and", var, val)
> -#define percpu_or(var, val)		percpu_to_op("or", var, val)
> -#define percpu_xor(var, val)		percpu_to_op("xor", var, val)
> -#define percpu_inc(var)		percpu_unary_op("inc", var)
> +#define this_cpu_read(var)		percpu_from_op("mov", var, "m" (var))
> +#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
> +#define this_cpu_write(var, val)	percpu_to_op("mov", var, val)
> +#define this_cpu_add(var, val)		percpu_add_op(var, val)
> +#define this_cpu_sub(var, val)		percpu_add_op(var, -(val))
> +#define this_cpu_and(var, val)		percpu_to_op("and", var, val)
> +#define this_cpu_or(var, val)		percpu_to_op("or", var, val)
> +#define this_cpu_xor(var, val)		percpu_to_op("xor", var, val)
> +#define this_cpu_inc(var)		percpu_unary_op("inc", var)

Why define these operations? They are already defined in the form of
this_cpu_add_1/2/4/8 and include/linux/percpu.h branches out to them.

> @@ -522,7 +522,7 @@ void sock_release(struct socket *sock)
>  	if (rcu_dereference_protected(sock->wq, 1)->fasync_list)
>  		printk(KERN_ERR "sock_release: fasync list not empty!\n");
>
> -	percpu_sub(sockets_in_use, 1);
> +	this_cpu_sub(sockets_in_use, 1);
>  	if (!sock->file) {
>  		iput(SOCK_INODE(sock));
>  		return;

In general __this_cpu_xx operations can be used instead of this_cpu_xx
operations if the context is already preempt safe. There is no change of
the code generated for x86 in those cases. But the fallback code on other
platforms can generate more efficient code.

