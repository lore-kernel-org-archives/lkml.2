Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134Ab2FHQmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:42:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13766 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FHQl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:41:59 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=szWgSEt-72UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=rF0AoRXoRm3dCDsfetUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339173716.13377.50.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 08 Jun 2012 12:41:56 -0400
In-Reply-To: <4FD223E1.1090707@zytor.com>
References: <20120608135200.371649691@goodmis.org>
	 <20120608135603.699156773@goodmis.org> <4FD223E1.1090707@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 09:10 -0700, H. Peter Anvin wrote:

> Okay, slight interrupt here.

Pun intended?

> 
> The cost of this on real hardware better be zero (which I cannot
> immediately judge.)

Is dec_and_test cheaper than cmpxchg? I would think so.

> 
> Why?  Because cmpxchg has been in every CPU since the i486, the i386 is
> royally crippled on Linux anyway (due to minor architectural defects,
> the main one being the write protect issue) and NMI is almost never used
> on i386 as anything other than a fatal error indication.
> 
> Most "real" NMI users generate the NMI from the local APIC, but the i386
> has no local APIC, and unlike the i486 cannot even have an external
> local APIC to the best of my knowledge.

Yeah, this is why I didn't rush to do this change. But it does seem to
make the code simpler and it may actually speed things up. It replaces a
cmpxchg with a local_dec_and_test, which, I believe, doesn't even lock
the cachelines.

So lets look at the patch in detail, shall we?


>  enum nmi_states {
> -       NMI_NOT_RUNNING,
> +       NMI_NOT_RUNNING = 0,

This change was done more for documenting that the first element must be
zero. Even though C guarantees this. I wanted to point out that we
expect it to be zero and that it being zero really does matter. No
functionality change whats-so-ever.

>         NMI_EXECUTING,
>         NMI_LATCHED,
>  };
> -static DEFINE_PER_CPU(enum nmi_states, nmi_state);
> +static DEFINE_PER_CPU(local_t, nmi_state);

local_t is is just an atomic_long_t, which on i386 is nothing different
than what an enum would be.

>  
>  #define nmi_nesting_preprocess(regs)                                   \
>         do {                                                            \
> -               if (__get_cpu_var(nmi_state) != NMI_NOT_RUNNING) {      \
> -                       __get_cpu_var(nmi_state) = NMI_LATCHED;         \
> +               local_t *__state = &__get_cpu_var(nmi_state);           \
> +               if (local_read(__state) != NMI_NOT_RUNNING) {           \
> +                       local_set(__state, NMI_LATCHED);                \

The above change is probably a little bit of a speed up because we
remove the double '__get_cpu_var()' and replace it with a pointer that
is reused. I haven't looked at the assembly for this, but it is either
the same or better with the patch.

Sure, we could improve this by using this_cpu_var() which may make it
better than the patch. But the patch is currently the same or better
than what is there now.

>                         return;                                         \
>                 }                                                       \
> -       nmi_restart:                                                    \
> -               __get_cpu_var(nmi_state) = NMI_EXECUTING;               \
> -       } while (0)
> +               local_set(__state, NMI_EXECUTING);                      \
> +       } while (0);                                                    \
> +       nmi_restart:

Here it's better or the same than what is there now as we again remove
the reference to getting the pointer. In case gcc doesn't optimize it
nicely. But again we could have switched to this_cpu_write() which could
be better.

The movement of nmi_restart does help too. I'll explain that below.

>  
>  #define nmi_nesting_postprocess()                                      \
>         do {                                                            \
> -               if (cmpxchg(&__get_cpu_var(nmi_state),                  \
> -                   NMI_EXECUTING, NMI_NOT_RUNNING) != NMI_EXECUTING)   \
> +               if (!local_dec_and_test(&__get_cpu_var(nmi_state)))     \

Now this is where I think the patch helps. I'm almost certain that
local_dec_and_test is faster than a cmpxchg by many cycles. Especially
on i386.

>                         goto nmi_restart;                               \

And now that the local_dec_and_test on failure set the state to
NMI_EXECUTING, we can simply jump back to the new location of
nmi_restart instead of having to reset it above.

This also removes the race in case another NMI comes in at this moment
and we lose the latch. But this is a small problem, as we are about to
repeat the NMI anyway, and it would be the same as HW if the NMI came in
just before we finished the last NMI. We only repeat once. This is just
changing where we consider the start of the repeated NMI is (where a new
latch can happen). But functionality wise, it's no different.

-- Steve

>         } while (0)

