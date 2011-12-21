Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1LUPQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:16:30 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:46586 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752886Ab1LUPQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:16:28 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ciQc8TgVM1mIwyPYhIyB9Y1XdXRmuL8TTzsVLOO87s7j6je
 _Xp_SI5_geNa5UANKYc0lz90WuyAj141dUMC9hMDof.V7zZWiSCfbTRqdExn
 bQ1rZO82byu_tXUCZUAXcqVVyI.NIZS0_XefHVX.QErb9aSMh0C.DFACDvVo
 .eIM7DfcU.aaZigFc1iH4ABfDdEJTtNgouTjo5GJc2seb6hHNUgU2yqdtu40
 avhu8V_g5cRY664QQ2bVloPs3d5VArdnIyygu5nTLCbDKwKu17GCurPbt47I
 EjBiQeMVyg97btgpFbSnASUE2FNSVpB_ne5kIfWZ57QVzFsBHw5TiLAZZ5WK
 lfje8R_XatDr_eYx70WhEqZx.GXH4sLRLtZMrid.ztdI_rw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Dec 2011 09:16:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
In-Reply-To: <20111220202854.GH10752@google.com>
Message-ID: <alpine.DEB.2.00.1112210851230.9601@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain> <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com> <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com> <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com> <20111220202854.GH10752@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Tejun Heo wrote:

> the usage, I think (or at least hope) dropping preemption protected
> ones wouldn't hurt much but it might be worthwhile to keep
> __this_cpu_*() - the ones which expect the caller to take care of
> synchronization - w/ assertion on irq disabled.

__this_cpu ops are generally the most useless. You can basically do the
same thing by open coding it. But then on x86 you'd miss out on generating
a simple inc seg:var instruction that does not impact registers. Plus you
avoid the necessity of calculating the address first. Instead of one
instruction you'd have 5.

Dropping preemption protected ones is going to be difficult given their
use in key subsystems.

> > Christoph, what do you think?  What would be the minimal set that you
> can work with?

If you just talking about the slub allocator and the this_cpu_cmpxchg
variants there then the irqsafe variants of cmpxchg and cmpxchg_double are
sufficient there.

However, the this_cpu ops are widely used in many subsystems for keeping
statistics. Their main role is to keep the overhead of incrementing/adding
to counters as minimal as possible. Changes there would cause instructions
to be generated that are longer in size and also would cause higher
latency of execution. Generally the irqsafe variants are not needed for
counters so we may be able to toss those.

this_cpu ops are not sloppy unless one intentionally uses __this_cpu_xxx
in a non preempt safe context which was the case for the vmstat counters
for awhile.

The amount of this_cpu functions may be excessive because I tried to cover
all possible use cases rather than actuallly used forms in the kernel. So
a lot of things could be weeded out. this_cpu ops is a way to experiment
with different forms of synchronization that are particular important for
fastpaths implementing per cpu caching. This could be of relevance to many
of the allocators in the future.

The way that the cmpxchg things are used is also similar to transactional
memory that is becoming available in the next generation of processors by
Intel and that is already available in the current generation of powerpc
processors by IBM. It is a way to avoid locking overhead.
