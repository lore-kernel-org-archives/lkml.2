Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1CNJPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:15:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10679 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab1CNJPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:15:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c00NdR1TJtLWEYI7qV/F9WLeLwMCAI3M+ID5L8UkoyqZ3Pxk64/WFh7EI4mUm13wBq
         klMLBPsUqLdUdGrpFcdQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTinXxCMVozx-NKEVXJLNrB1V93VEAJ8FiHQHXY_=@mail.gmail.com>
References: <20110307021127.GB31188@google.com>
	<alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
	<20110309112550.GA3050@google.com>
	<alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
	<20110311021654.GA26122@google.com>
	<20110311024731.GB26122@google.com>
	<AANLkTinXxCMVozx-NKEVXJLNrB1V93VEAJ8FiHQHXY_=@mail.gmail.com>
Date: Mon, 14 Mar 2011 02:15:29 -0700
Message-ID: <AANLkTimvFc3=e_bEZLbob6MEeUHrarqLU42o7R2VYbce@mail.gmail.com>
Subject: Re: [PATCH 1/3] futex: do not pagefault_disable in futex_atomic_cmpxchg_inatomic()
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <darren@dvhart.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 3:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 10, 2011 at 6:47 PM, Michel Lespinasse <walken@google.com> wrote:
>> kernel/futex.c disables page faults before calling
>> futex_atomic_cmpxchg_inatomic(), so there is no need to do it again
>> within that function.
>
> This seems totally bogus.
>
> Even the comment is crap.
>
> Sure, the callers may disable preemption, but that has NOTHING to do
> with "pagefault_disable()". Th epagefault_[en/dis]able functions will
> touch the preempt count EVEN IF PREEMPTION ISN'T EVEN ENABLED!

I understand pagefault_disable() and preempt_disable() are different
concepts, but their implementations have a lot in common...

> So what the f*ck does that "Note that preemption is disabled.." crap even mean?

I was thinking that if cmpxchg_futex_value_locked() already raised the
preempt count, it seemed redundant to do it again (and then decrement
it back) in a nested way within futex_atomic_cmpxchg_inatomic on arm.

> The thing is made even worse by the fact that as far as I can tell,
> the comment simply isn't true at all (even if you were to ignore the
> fundamental confusion about preemption vs the pagefault
> disable/enable). Not all callers of futex_atomic_cmpxchg_inatomic() do
> anything of the sort, whether it's preemptibility _or_ the proper
> pagefault_disable/enable(). Just look at the exit_robust_list() ->
> handle_futex_death(), for example.

You got me there - clearly I f*cked up. What really irks me is that I
have a retrospectively bogus memory of actually looking at that call
site and seeing a pagefault_disable there... But as is now obvious,
it's never been there :/

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
