Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1EDNU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:20:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47418 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1EDNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TGxPunm8g0KrxwCx7bBEfiZozY/SSZJcetTJSWxvav82vZHPvlq+QWFvEW/urxhzNo
         Zk5aPL7SfanK3jM+xlurkYeOfi6fFEGMkapOiXs1TooWJPCjnDX6o2IPUfg3z3DR92NE
         of2L9bFfbhLmJOYzNxsk31sGwglHSLQsFKVs0=
Date: Wed, 4 May 2011 15:20:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504132022.GA17294@htj.dyndns.org>
References: <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
 <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105041417330.3005@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 04, 2011 at 03:00:37PM +0200, Thomas Gleixner wrote:
> On Wed, 4 May 2011, Tejun Heo wrote:
> > > > And that code runs with preemption enabled. So when the task gets
> > > > preempted _BEFORE_ it has actuallty written back the data, then the
> > > > race window is wide open.
> > 
> > Hmmm... if it's a race caused by preemtion enabled where it shouldn't
> > be, it's most likely the wrong type of this_cpu_cmpxchg_double() being
> > used in SLUB?  ie. __this_cpu_cmpxchg_double() where it should have
> > been this_cpu_cmpxchg_double()?  Christoph?
> 
> No, the problem is that ELAN prevents the cmpxchg8b, but keeps
> CONFIG_CMPXCHG_LOCAL=y which then results in the unprotected code for
> the following reason:
...
> So the question is whether CMPXCHG_LOCAL for x86 wants to depend on
> X86_CMPXCHG64.
> 
> The other solution is to use irqsafe_cpu_cmpxchg_double() instead of
> this_cpu_cmpxchg_double() in slub.c. 

I think this is the root cause.  CMPXCHG_LOCAL is an optimization
flag, indicating that the processor provides fast local cmpxchg, it
doesn't say anything about local synchronization properties and if the
code required irq exclusion, it should have used
irqsafe_cpu_cmpxchg_double() whether the processor supports it
natively or not, so there's the bug.  Pekka, can you please change the
offending cmpxchg_double() to irqsafe variant?

As for CMPXCHG_LOCAL being set spuriously, maybe introduce
CMPXCHG_DOUBLE_LOCAL?  I don't know.  It's pretty nasty to implement
different high-level code paths depending on CPU features.  We can't
even determine whether the feature will be actually available at
compile time.  But, then again, it might incur noticeable slowdown for
cases where the generic implementation is used.  Has anyone measured
the difference against before the whole this_cpu conversion?

Thanks.

-- 
tejun
