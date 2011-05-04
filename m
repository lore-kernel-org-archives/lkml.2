Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1EDOTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:19:47 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:41154 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750852Ab1EDOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:19:46 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: VMvVpCgVM1npc81A.CI4q2MtpDR1yIuQstiKhcOtA0.w8zU
 dz18HAnaCrJOBYDHkDGooCXijRIrEDQWEZp9C9.x8wROAmsR0KAr.g68YnzD
 TXj0kIdT9qXuPcwXzdpjoOOuLxfptO8VjEN7pVU186fcUCDPTXp16Ax7bu07
 PWSYnyRKhZJW3TsLeMWrgAM8YxsMx3hiRSShpoKL_Z8zYvd4QDzpw593r1CT
 OX.lgP1gujRSo_CTYyYaCyemtFA_GkTgXZejST9p6U8aQO.5QqvmrVgmFbgl
 AANuy_HrgtliOPukYjLnn5Ih4w4PXGXnoxQ5S_28KYoAMGb.E
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 09:19:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <alpine.LFD.2.02.1105041539050.3005@ionos>
Message-ID: <alpine.DEB.2.00.1105040917450.5495@router.home>
References: <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Thomas Gleixner wrote:

> Index: linux-2.6/include/linux/percpu.h
> ===================================================================
> --- linux-2.6.orig/include/linux/percpu.h
> +++ linux-2.6/include/linux/percpu.h
> @@ -948,7 +948,7 @@ do {									\
>  	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
>  # endif
>  # define irqsafe_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
> -	__pcpu_double_call_return_int(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
> +	__pcpu_double_call_return_bool(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
>  #endif
>
>  #endif /* __LINUX_PERCPU_H */

Looking at the same thing here testing a similar patch. This should go
separately as a bug fix.

> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c
> +++ linux-2.6/mm/slub.c
> @@ -1940,7 +1940,7 @@ redo:
>  		 * Since this is without lock semantics the protection is only against
>  		 * code executing on this cpu *not* from access by other cpus.
>  		 */
> -		if (unlikely(!this_cpu_cmpxchg_double(
> +		if (unlikely(!irqsafe_cpu_cmpxchg_double(
>  				s->cpu_slab->freelist, s->cpu_slab->tid,
>  				object, tid,
>  				get_freepointer(s, object), next_tid(tid)))) {
> @@ -2145,7 +2145,7 @@ redo:
>  		set_freepointer(s, object, c->freelist);
>
>  #ifdef CONFIG_CMPXCHG_LOCAL
> -		if (unlikely(!this_cpu_cmpxchg_double(
> +		if (unlikely(!irqsafe_cpu_cmpxchg_double(
>  				s->cpu_slab->freelist, s->cpu_slab->tid,
>  				c->freelist, tid,
>  				object, next_tid(tid)))) {
>

Ok as a basic fix since it does not change the code generated for the
common x86 and other.

My version also takes out the CONFIG_CMPXCHG_LOCAL.

We could make the above two patches and then make the CONFIG_CMPXCHG_LOCAL
removal a separate one (since it requires some benchmarking).

