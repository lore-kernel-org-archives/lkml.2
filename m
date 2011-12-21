Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1LURFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:05:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61834 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1LURFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:05:41 -0500
Date: Wed, 21 Dec 2011 09:05:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
Message-ID: <20111221170535.GB9213@google.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com>
 <alpine.DEB.2.00.1112210851230.9601@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112210851230.9601@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Wed, Dec 21, 2011 at 09:16:24AM -0600, Christoph Lameter wrote:
> __this_cpu ops are generally the most useless. You can basically do the
> same thing by open coding it. But then on x86 you'd miss out on generating
> a simple inc seg:var instruction that does not impact registers. Plus you
> avoid the necessity of calculating the address first. Instead of one
> instruction you'd have 5.
>
> Dropping preemption protected ones is going to be difficult given their
> use in key subsystems.

The thing is that irqsafe ones are the "complete" ones.  We can use
irqsafe ones instead of preempt safe ones but not the other way.  This
matters only if flipping irq is noticeably more expensive than
inc/dec'ing preempt count but I suspect there are enough such
machines.  (cc'ing arch) Does anyone have better insight here?  How
much more expensive are local irq save/restore compared to inc/dec'ing
preempt count on various archs?

> > > Christoph, what do you think?  What would be the minimal set that you
> > can work with?
> 
> If you just talking about the slub allocator and the this_cpu_cmpxchg
> variants there then the irqsafe variants of cmpxchg and cmpxchg_double are
> sufficient there.
> 
> However, the this_cpu ops are widely used in many subsystems for keeping
> statistics. Their main role is to keep the overhead of incrementing/adding
> to counters as minimal as possible. Changes there would cause instructions
> to be generated that are longer in size and also would cause higher
> latency of execution. Generally the irqsafe variants are not needed for
> counters so we may be able to toss those.
> 
> this_cpu ops are not sloppy unless one intentionally uses __this_cpu_xxx
> in a non preempt safe context which was the case for the vmstat counters
> for awhile.
> 
> The amount of this_cpu functions may be excessive because I tried to cover
> all possible use cases rather than actuallly used forms in the kernel. So
> a lot of things could be weeded out. this_cpu ops is a way to experiment
> with different forms of synchronization that are particular important for
> fastpaths implementing per cpu caching. This could be of relevance to many
> of the allocators in the future.
> 
> The way that the cmpxchg things are used is also similar to transactional
> memory that is becoming available in the next generation of processors by
> Intel and that is already available in the current generation of powerpc
> processors by IBM. It is a way to avoid locking overhead.

Hmmm... how about removing the ones which aren't currently in use?
percpu API in general needs a lot more clean up but I think that would
be a good starting point.

Thanks.

-- 
tejun
