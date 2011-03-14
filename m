Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1CNJPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:15:24 -0400
Received: from www.tglx.de ([62.245.132.106]:47886 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab1CNJPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:15:21 -0400
Date: Mon, 14 Mar 2011 10:13:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Michel Lespinasse <walken@google.com>, Darren Hart <darren@dvhart.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] futex: do not pagefault_disable in
 futex_atomic_cmpxchg_inatomic()
In-Reply-To: <AANLkTinXxCMVozx-NKEVXJLNrB1V93VEAJ8FiHQHXY_=@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103140913010.2787@localhost6.localdomain6>
References: <20110307021127.GB31188@google.com> <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6> <20110309112550.GA3050@google.com> <alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6> <20110311021654.GA26122@google.com>
 <20110311024731.GB26122@google.com> <AANLkTinXxCMVozx-NKEVXJLNrB1V93VEAJ8FiHQHXY_=@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Mar 2011, Linus Torvalds wrote:
> On Thu, Mar 10, 2011 at 6:47 PM, Michel Lespinasse <walken@google.com> wrote:
> > kernel/futex.c disables page faults before calling
> > futex_atomic_cmpxchg_inatomic(), so there is no need to do it again
> > within that function.
> 
> This seems totally bogus.
> 
> Even the comment is crap.
> 
> Sure, the callers may disable preemption, but that has NOTHING to do
> with "pagefault_disable()". Th epagefault_[en/dis]able functions will
> touch the preempt count EVEN IF PREEMPTION ISN'T EVEN ENABLED!
> 
> So what the f*ck does that "Note that preemption is disabled.." crap even mean?
> 
> The thing is made even worse by the fact that as far as I can tell,
> the comment simply isn't true at all (even if you were to ignore the
> fundamental confusion about preemption vs the pagefault
> disable/enable). Not all callers of futex_atomic_cmpxchg_inatomic() do
> anything of the sort, whether it's preemptibility _or_ the proper
> pagefault_disable/enable(). Just look at the exit_robust_list() ->
> handle_futex_death(), for example.
> 
> This kind of patch is the kind that personally makes me want to put
> you on a spam-list. Misleading commit messages with bogus and
> fundamentally incorrect added comments in the code. WTF?
> 
> Did I miss some patch that changed that, or is this really as horribly
> bad as I think it is? I see it already made it into -tip.

That's my fault. 

I really checked the call sites of futex_atomic_cmpxchg_inatomic() and
totally failed to see the one in handle_futex_death() which does not
use the helper function cmpxchg_futex_value_locked(). That helper
function is safe and does the right thing:

	pagefault_disable();
	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
	pagefault_enable();

So, that means we have all call sites covered except one, which needs
to be fixed _AND_ also pushed into stable as all arch implementations
except ARM rely on the caller doing the pagefault_disable().

And I missed the bogus comment as well. Sigh.

Thanks,

	tglx
