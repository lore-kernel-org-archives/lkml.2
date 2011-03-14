Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1CNAzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 20:55:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54027 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab1CNAzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 20:55:46 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinXxCMVozx-NKEVXJLNrB1V93VEAJ8FiHQHXY_=@mail.gmail.com>
References: <20110307021127.GB31188@google.com>
	<alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
	<20110309112550.GA3050@google.com>
	<alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
	<20110311021654.GA26122@google.com>
	<20110311024731.GB26122@google.com>
	<AANLkTinXxCMVozx-NKEVXJLNrB1V93VEAJ8FiHQHXY_=@mail.gmail.com>
Date: Sun, 13 Mar 2011 17:55:45 -0700
X-Google-Sender-Auth: S8EvMZxM7jbCibGoEa92H6pwcMI
Message-ID: <AANLkTinmxcjRUj-JRtmO3JSAGWoiW+ec7JzTBpL32C=t@mail.gmail.com>
Subject: Re: [PATCH 1/3] futex: do not pagefault_disable in futex_atomic_cmpxchg_inatomic()
From: Darren Hart <darren@dvhart.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have to apologize. These landed right as I was leaving for OSTS and
I didn't have time to review them properly.  I wondered about the
preempt vs pagefault disable and wondered how exit_robust_list() was
covered in Michel's comments (perhaps somewhere higher up the call
chain). I leaned on the review of others when I should have raised the
questions even if I didn't have the time to dig into them myself.
Linus shouldn't have had to raise those questions, I'll do better at
this in the future.

I noticed that my name is the only one in futex.c with an email
address in the header - that email address is no longer valid, and it
delayed the patches getting to my inbox - I will submit a patch to fix
that. I should catch them sooner now, regardless, with improved LKML
filters.

Thanks,

Darren Hart


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
>
>                              Linus
>



-- 
Darren Hart
