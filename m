Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab1C1NpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:45:05 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:20378 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754217Ab1C1Nox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:44:53 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .W9VZ7EVM1mXmcp4.RJ62W7TEhYcpNROOsK_O6NebBbOqO9
 XUV8eY76ZDVEfhvLjHM8YPGDdfzwbAwxBxoimjHho4AGh_iZm5QbXGjpXfe5
 O4xPT71_XhsAw8dBHsu26ksjlG1bo67vjKADy6q83KPDcS0N70yJfdyNJ8Qr
 zrNS4dU4aIP_RuUZfji5Z3vR6M1Yshmq1odO518fzi7QQaa1HnP9TP1BE0zC
 uxxKb7YMJFr6FHTcRqZwMye4kD6grV_ZQ113kbQonDiEASlAC3Bs6.ET1LmK
 4QTk_FAdKrcpNT_z0LTs8zOI72pgUkMyTdUim9dqsVLdh1WJYgatoKnYjwxd
 zJaG7bop_p.CLuoQLjYATbQ--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 28 Mar 2011 08:44:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Disable the lockless allocator
In-Reply-To: <20110328063656.GA29462@elte.hu>
Message-ID: <alpine.DEB.2.00.1103280844320.7590@router.home>
References: <1301161507.2979.105.camel@edumazet-laptop> <alpine.DEB.2.00.1103261406420.24195@router.home> <alpine.DEB.2.00.1103261428200.25375@router.home> <alpine.DEB.2.00.1103261440160.25375@router.home> <AANLkTinTzKQkRcE2JvP_BpR0YMj82gppAmNo7RqgftCG@mail.gmail.com>
 <alpine.DEB.2.00.1103262028170.1004@router.home> <alpine.DEB.2.00.1103262054410.1373@router.home> <4D9026C8.6060905@cs.helsinki.fi> <20110328061929.GA24328@elte.hu> <AANLkTinpCa6GBjP3+fdantvOdbktqW8m_D0fGkAnCXYk@mail.gmail.com>
 <20110328063656.GA29462@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Ingo Molnar wrote:

> I think we might still be missing the hunk below - or is it now not needed
> anymore?

Its not needed anymore.

>
> Thanks,
>
> 	Ingo
>
> -------------->
> >From 53c0eceb7bf64f2a89c59ae4f14a676fa4128462 Mon Sep 17 00:00:00 2001
> From: Christoph Lameter <cl@linux.com>
> Date: Sat, 26 Mar 2011 14:49:56 -0500
> Subject: [PATCH] per_cpu: Fix cmpxchg_double() for !SMP
>
> cmpxchg_double() should only be provided for SMP. In the UP case
> the GS register is not defined and the function will fail.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: torvalds@linux-foundation.org
> Cc: tj@kernel.org
> Cc: npiggin@kernel.dk
> Cc: rientjes@google.com
> Cc: linux-mm@kvack.org
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> LKML-Reference: <alpine.DEB.2.00.1103261440160.25375@router.home>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/percpu.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
> index a09e1f0..52330a4 100644
> --- a/arch/x86/include/asm/percpu.h
> +++ b/arch/x86/include/asm/percpu.h
> @@ -507,6 +507,7 @@ do {									\
>   * it in software.  The address used in the cmpxchg16 instruction must be
>   * aligned to a 16 byte boundary.
>   */
> +#ifdef CONFIG_SMP
>  #define percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)			\
>  ({									\
>  	char __ret;							\
> @@ -529,6 +530,7 @@ do {									\
>  #define irqsafe_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
>
>  #endif
> +#endif
>
>  /* This is not atomic against other CPUs -- CPU preemption needs to be off */
>  #define x86_test_and_clear_bit_percpu(bit, var)				\
>
