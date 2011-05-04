Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1EDM52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:57:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab1EDM51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:57:27 -0400
Date: Wed, 4 May 2011 14:57:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504125713.GA9978@elte.hu>
References: <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
 <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org>
 <BANLkTikKZhqkcrG8aqUD0tJxZE5zVu0pMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikKZhqkcrG8aqUD0tJxZE5zVu0pMg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> Hi Tejun,
> 
> On Wed, May 4, 2011 at 2:27 PM, Tejun Heo <tj@kernel.org> wrote:
> > Hmmm... if it's a race caused by preemtion enabled where it shouldn't
> > be, it's most likely the wrong type of this_cpu_cmpxchg_double() being
> > used in SLUB?  ie. __this_cpu_cmpxchg_double() where it should have
> > been this_cpu_cmpxchg_double()?  Christoph?
> 
> There's no __this_cpu_cmpxchg_double() usage in mm/slub.c so I don't
> think it's that simple.

Well, AFAICS the problem is:

earth4:~/tip> grep cmpxchg mm/slub.c 

		if (unlikely(!this_cpu_cmpxchg_double(
		if (unlikely(!this_cpu_cmpxchg_double(

Where this macro resolves to:

#  define this_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)     \
        _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)

where:

#define _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)        \
({                                                                      \
        int ret__;                                                      \
        preempt_disable();                                              \
        ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,           \
                        oval1, oval2, nval1, nval2);                    \
        preempt_enable();                                              
where:

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

With is both IRQ and SMP unsafe.

Thanks,

	Ingo
