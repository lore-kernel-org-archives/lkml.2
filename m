Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1CQTVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:21:40 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:20790 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755286Ab1CQTVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:21:38 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _Aaw_ZoVM1m4xHWQImFfMeEQ3QzLEHeAuOPr6qboweIvnR.
 ha7tnmlhjauzIU8xwyLlfJcQEdCBB_W9CODUFkoT_lb4woGFBva_sVY0Vn70
 vnZLncQkixqYd0Q5G9t00lwid_wugUJl1mBasqPr0DtIxotl2_rBUUfw5pHi
 JPQg_Mlk1A_CEoYSQiVboeJB0SqbSzj34MXMyQ8UnSLkMfZFpuYnPrTgrdfT
 g6InEDx_WEIUgqXQXiA7QxFW169ypcw59YODH8kcRwvylF5d1NWBJTHBoc_z
 snVnzKd1Q2H4JL9Koctth96hrC7U13bMt9GoMsFhzDab8lvK2
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 17 Mar 2011 14:21:33 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: Poll about irqsafe_cpu_add and others
In-Reply-To: <1300388139.6315.418.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1103171419280.18529@router.home>
References: <1300371834.6315.93.camel@edumazet-laptop>  <20110317.081420.71114992.davem@davemloft.net>  <alpine.DEB.2.00.1103171016270.12540@router.home>  <1300380801.6315.306.camel@edumazet-laptop>  <alpine.DEB.2.00.1103171245430.16620@router.home> 
 <1300386569.6315.404.camel@edumazet-laptop>  <alpine.DEB.2.00.1103171338350.18529@router.home> <1300388139.6315.418.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Eric Dumazet wrote:

> > > I wonder why we dont use :
> > >
> > > 	addl	$0x2,%fs:xt_u64
> > > 	addcl	$0x0,%fs:xt_u64+4
> >
> > The compiler is fed the following
> >
> > 	*__this_cpu_ptr(xt_u64) += 2
> >
> > __this_cpu_ptr makes it:
> >
> > 	*(xt_u64 + __my_cpu_offset) += 2
> >
> > So the compiler calculates the address first and then increments it.
> >
> > The compiler could optimize this I think. Wonder why that does not happen.
>
> Compiler is really forced to compute addr, thats why.
>
> Hmm, we should not fallback to generic ops I think, but tweak
>
> percpu_add_op() {

percpu_add_op() is not used. This is a 64 bit operation on a 32 bit
machine thus we fall back to this_cpu_generic_to_op()

#define __this_cpu_generic_to_op(pcp, val, op)                          \
do {                                                                    \
        *__this_cpu_ptr(&(pcp)) op val;                                 \
} while (0)


