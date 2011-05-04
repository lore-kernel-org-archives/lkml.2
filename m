Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1EDNBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:01:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:47056 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1EDNBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:01:05 -0400
Date: Wed, 4 May 2011 15:00:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <20110504112746.GE8007@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1105041417330.3005@ionos>
References: <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com> <web-516990066@zbackend1.aha.ru> <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com> <20110503190822.GA20520@elte.hu> <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <20110504083559.GB25724@elte.hu>
 <alpine.LFD.2.02.1105041124080.3005@ionos> <20110504101932.GA3392@elte.hu> <alpine.LFD.2.02.1105041233280.3005@ionos> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Tejun Heo wrote:
> > > And that code runs with preemption enabled. So when the task gets
> > > preempted _BEFORE_ it has actuallty written back the data, then the
> > > race window is wide open.
> 
> Hmmm... if it's a race caused by preemtion enabled where it shouldn't
> be, it's most likely the wrong type of this_cpu_cmpxchg_double() being
> used in SLUB?  ie. __this_cpu_cmpxchg_double() where it should have
> been this_cpu_cmpxchg_double()?  Christoph?

No, the problem is that ELAN prevents the cmpxchg8b, but keeps
CONFIG_CMPXCHG_LOCAL=y which then results in the unprotected code for
the following reason:

this_cpu_cmpxchg_double() 

-> __pcpu_double_call_return_bool 

-> this_cpu_cmpxchg_double_4

Which on x86 expands to 

-> percpu_cmpxchg8b_double() when CONFIG_X86_CMPXCHG64=y

With CONFIG_X86_CMPXCHG64=n it expands to the default:

_this_cpu_generic_cmpxchg_double() in linux/percpu.h

#define _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)        \
({                                                                      \
        int ret__;                                                      \
        preempt_disable();                                              \
        ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,           \
                        oval1, oval2, nval1, nval2);                    \
        preempt_enable();                                               \
        ret__;                                                          \
})

And:

#define __this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)       \
({                                                                      \
        int __ret = 0;                                                  \
        if (__this_cpu_read(pcp1) == (oval1) &&                         \
                         __this_cpu_read(pcp2)  == (oval2)) {           \
                __this_cpu_write(pcp1, (nval1));                        \
                __this_cpu_write(pcp2, (nval2));                        \
                __ret = 1;                                              \
        }                                                               \
        (__ret);                                                        \
})

So now that failing config has CONFIG_PREEMPT=n which makes
preempt_disable / enable a nop. 

So preemption is not the problem, but what about interrupts and
softirqs ?

So the question is whether CMPXCHG_LOCAL for x86 wants to depend on
X86_CMPXCHG64.

The other solution is to use irqsafe_cpu_cmpxchg_double() instead of
this_cpu_cmpxchg_double() in slub.c. 

This will not hurt the X86_CMPXCHG64=y case, but keep the expansion to
the above __this_cpu_generic_cmpxchg_double working. 

Which makes me even wonder some more whether we need that whole
CMPXCHG_LOCAL #ifdeffery in slub.c at all.

Thanks,

	tglx
