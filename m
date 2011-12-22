Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1LVQFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 11:05:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43211 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1LVQFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 11:05:06 -0500
Date: Thu, 22 Dec 2011 08:05:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
Message-ID: <20111222160501.GD17084@google.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com>
 <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com>
 <CA+55aFyr69__vsorCXKZ7UezvXkCkZaot3=5b5xSHaYBEJ2ZKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyr69__vsorCXKZ7UezvXkCkZaot3=5b5xSHaYBEJ2ZKQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Wed, Dec 21, 2011 at 06:19:34PM -0800, Linus Torvalds wrote:
> On Wed, Dec 21, 2011 at 9:05 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > machines.  (cc'ing arch) Does anyone have better insight here?  How
> > much more expensive are local irq save/restore compared to inc/dec'ing
> > preempt count on various archs?
> 
> I think powerpc does sw irq disable, so it's pretty much the same.
> 
> However, on *most* architectures, if the stupid generic "disable
> interrupts and then do the op" is too expensive, they could easily
> just do an architecture-specific "safe" version. Especially if they
> only need to do cmpxchg and add.
> 
> Many architectures can do those safely with load-locked,
> store-conditional (ie atomic_add), and do so quickly. Sure, there are
> broken cases wher ethat is really slow (original alpha is an example
> of that), but I think it's fairly rare.
>
> So both arm (in v6+) and powerpc should be able to just use the
> "atomic_add" version, with no real downside.

Hmmm... right, if actual atomic ops are used we don't need to
guarantee that percpu address translation and operation happen on the
same CPU.  The end result would be correct regardless.  Atomic ops
wouldn't be as efficient as local single op as in x86 but it shouldn't
be too expensive when vast majority of operations are happening on
cachelines which are already exclusively owned.

> So I really suspect that we could just say: "make the irq-safe version
> be the *only* version", and no architecture will really care. Sure, it
> can be more expensive, but it usually isn't. Only when done badly and
> stupidly is it nasty.

Yeah, I don't think there's any cross-architecture way of making
this_cpu ops universally faster than explicit irq/preempt_disable -
get_addr - do one or more ops - irq/preempt_enable.  Many archs can't
even load address offset with single instruction after all.  Even on
x86, with enough number of ops, the segment prefix and full address on
each op would become more expensive than explicit sequence.  Given
that, I think just providing irqsafe version and let all other cases
use the explicit ones is a good tradeoff.

Alright, I'll do that for the 3.4 merge window.

Thanks.

-- 
tejun
