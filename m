Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1CQSz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:55:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46095 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab1CQSzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BK8DuC9KDpj1M1xTL9i++PWTGjji1NLCR/vAm8E+hCYyLGzYWaW/GaRwwVVOVZPghM
         GDAgEVeNJmENC7mO5YGw3bzVR1/241n9przAVIQjG5QB3tzeiUagu+2Emv9Zkd7btHZ5
         Beq5jb328X79Q2nF+EkZqJbSUgd5Sgn9FwtDs=
Subject: Re: Poll about irqsafe_cpu_add and others
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1103171338350.18529@router.home>
References: <1300371834.6315.93.camel@edumazet-laptop>
	 <20110317.081420.71114992.davem@davemloft.net>
	 <alpine.DEB.2.00.1103171016270.12540@router.home>
	 <1300380801.6315.306.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1103171245430.16620@router.home>
	 <1300386569.6315.404.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1103171338350.18529@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 19:55:39 +0100
Message-ID: <1300388139.6315.418.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 mars 2011 à 13:42 -0500, Christoph Lameter a écrit :
> On Thu, 17 Mar 2011, Eric Dumazet wrote:
> 
> > By the way, I noticed :
> >
> > DECLARE_PER_CPU(u64, xt_u64);
> > __this_cpu_add(xt_u64, 2) translates to following x86_32 code :
> >
> > 	mov	$xt_u64,%eax
> > 	add	%fs:0x0,%eax
> > 	addl	$0x2,(%eax)
> > 	adcl	$0x0,0x4(%eax)
> >
> >
> > I wonder why we dont use :
> >
> > 	addl	$0x2,%fs:xt_u64
> > 	addcl	$0x0,%fs:xt_u64+4
> 
> The compiler is fed the following
> 
> 	*__this_cpu_ptr(xt_u64) += 2
> 
> __this_cpu_ptr makes it:
> 
> 	*(xt_u64 + __my_cpu_offset) += 2
> 
> So the compiler calculates the address first and then increments it.
> 
> The compiler could optimize this I think. Wonder why that does not happen.

Compiler is really forced to compute addr, thats why.

Hmm, we should not fallback to generic ops I think, but tweak 

percpu_add_op() { 
...
	case 8: 
#if CONFIG_X86_64_SMP
                if (pao_ID__ == 1)                                      \
                        asm("incq "__percpu_arg(0) : "+m" (var));       \
                else if (pao_ID__ == -1)                                \
                        asm("decq "__percpu_arg(0) : "+m" (var));       \
                else                                                    \
                        asm("addq %1, "__percpu_arg(0)                  \
                            : "+m" (var)                                \
                            : "re" ((pao_T__)(val)));                   \
                break;                                                  \

#else
                asm("addl %1, "__percpu_arg(0)                  	\
                            : "+m" (var)                                \
                            : "ri" ((u32)(val)));                   	\
		asm("adcl %1, "__percpu_arg(0) 				\
			: "+m" ((char *)var+4)				\
			: "ri" ((u32)(val>>32));			\
                break;                                                  \

#endif
....
}






