Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1LVSFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:05:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58500 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab1LVSFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:05:21 -0500
Date: Thu, 22 Dec 2011 19:03:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
Message-ID: <20111222180329.GA24544@elte.hu>
References: <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com>
 <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com>
 <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com>
 <alpine.DEB.2.00.1112221154380.11787@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112221154380.11787@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 22 Dec 2011, Tejun Heo wrote:
> 
> > Yeap, and that one too.  Maybe we can finally kill the duplicate
> > confusing static/dynamic accessors too.  I'm planning to get to it in
> > several weeks but if anyone can beat me to it, please go ahead.
> 
> That would be great. I looked at _and and _or and they both still have one
> use case (_xor has none though). But its easy to get rid of the irqsafe
> variants once we are willing to take the additional overhead that comes
> with disabling interrupts for the fallback cases.
> 
> 
> Subject: [percpu] Remove irqsafe_cpu_xxx variants
> 
> We simply say that regular this_cpu use must be safe regardless of preemption
> and interrupt state. That has no material change for x86 and s390 implementations
> of this_cpu operations. However, arches that do not provide their own implementation
> for this_cpu operations will now get code generated that disables interrupts
> instead of preemption.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  arch/s390/include/asm/percpu.h     |   50 ++++-----
>  arch/x86/include/asm/percpu.h      |   28 -----
>  include/linux/netdevice.h          |    4
>  include/linux/netfilter/x_tables.h |    4
>  include/linux/percpu.h             |  190 ++++---------------------------------
>  include/net/snmp.h                 |   14 +-
>  mm/slub.c                          |    6 -
>  net/caif/caif_dev.c                |    4
>  net/caif/cffrml.c                  |    4
>  9 files changed, 65 insertions(+), 239 deletions(-)

While this is progress, i think you have missed the essence of 
Linus's observations: percpu.h is *way* too complex and is 
offering way too many variants. The irqsafe madness was just the 
most blatant problem.

Note that even wit your patch applied linux/percpu.h is 800+ 
lines long, while the total number of usecases is smaller than 
that - and then i havent even considered all the arch percpu.h 
files.

Why not implement Linus's suggestion of just one or two 
__this_cpu() ops and be content with that model?

Thanks,

	Ingo
