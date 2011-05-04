Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1EDNDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:03:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:47070 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1EDNDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:03:02 -0400
Date: Wed, 4 May 2011 15:02:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110504125713.GA9978@elte.hu>
Message-ID: <alpine.LFD.2.02.1105041501300.3005@ionos>
References: <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu> <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <BANLkTikKZhqkcrG8aqUD0tJxZE5zVu0pMg@mail.gmail.com> <20110504125713.GA9978@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-875984856-1304514158=:3005"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-875984856-1304514158=:3005
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 4 May 2011, Ingo Molnar wrote:
> * Pekka Enberg <penberg@kernel.org> wrote:
> 
> > Hi Tejun,
> > 
> > On Wed, May 4, 2011 at 2:27 PM, Tejun Heo <tj@kernel.org> wrote:
> > > Hmmm... if it's a race caused by preemtion enabled where it shouldn't
> > > be, it's most likely the wrong type of this_cpu_cmpxchg_double() being
> > > used in SLUB?  ie. __this_cpu_cmpxchg_double() where it should have
> > > been this_cpu_cmpxchg_double()?  Christoph?
> > 
> > There's no __this_cpu_cmpxchg_double() usage in mm/slub.c so I don't
> > think it's that simple.
> 
> Well, AFAICS the problem is:
> 
> earth4:~/tip> grep cmpxchg mm/slub.c 
> 
> 		if (unlikely(!this_cpu_cmpxchg_double(
> 		if (unlikely(!this_cpu_cmpxchg_double(
> 
> Where this macro resolves to:
> 
> #  define this_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)     \
>         _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
> 
> where:
> 
> #define _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)        \
> ({                                                                      \
>         int ret__;                                                      \
>         preempt_disable();                                              \
>         ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,           \
>                         oval1, oval2, nval1, nval2);                    \
>         preempt_enable();                                              
> where:
> 
> #define __this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)       \
> ({                                                                      \
>         int __ret = 0;                                                  \
>         if (__this_cpu_read(pcp1) == (oval1) &&                         \
>                          __this_cpu_read(pcp2)  == (oval2)) {           \
>                 __this_cpu_write(pcp1, (nval1));                        \
>                 __this_cpu_write(pcp2, (nval2));                        \
>                 __ret = 1;                                              \
>         }                                                               \
>         (__ret);                                                        \
> })
> 
> With is both IRQ and SMP unsafe.

SMP is not an issue because that's cpu local access, but it's
irq/softirq unsafe. See my other mail.

Thanks,

	tglx


--8323328-875984856-1304514158=:3005--
