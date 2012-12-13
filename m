Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab2LMRK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:10:26 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43172 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2LMRKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:10:25 -0500
MIME-Version: 1.0
In-Reply-To: <20121213165904.GA18574@gmail.com>
References: <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
 <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com>
 <50C9E692.9070506@gmail.com> <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com>
 <50CA0134.2090608@gmail.com> <CA+55aFyZ2kAQPmZSv_sfHDAR1gusOxO22TRX-kqSim-cZrMscw@mail.gmail.com>
 <20121213165904.GA18574@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Dec 2012 09:10:03 -0800
X-Google-Sender-Auth: FVN-L2UI0miSOJfZmRGClTFqQCs
Message-ID: <CA+55aFwfxRgLqSsa1=4KvhR6E5GdvfGGxTM_0++YepLv5A_U_w@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.8
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 8:59 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> It's not a regression since THAT CODE NEVER WORKED, for
>> chissake! The case of people actually profiling into virtual
>> machines crashes the running VMs, as you say. There's no way
>> in hell we can call it a regression to say "you now have to
>> use a flag if you profile a load with virtualization", since
>> there wasn't any working case to begin with.
>
> Correct.
>
> ::include_guest looks like the more logical flag direction to
> use in any case.

See the email I just sent. The *non*-precise case presumably used to
work (and included the virtualized environment). No?

So the default shouldn't necessarily be "include guest". The default
should presumably be "the user didn't say", and then the kernel does
whatever works best.

If the user actually explicitly says one or the other, we should try
to honor that (and then EOPNOTSUPP may be a "sorry, I really cannot do
that particular combination that you explicitly asked for").

That should make everybody happy. Doing a non-PEBS virtualized perf
run should still work with the old binary.

So there should be two bits: "include guest" (V in the event specifier
unless you already used that for something else) and "host only" (H),
and they should both default to off. Then the kernel can see the three
actual cases.

(Or four cases, if you really want to: you may or may not want to make
the "both V and H set means both, and _only_ V set means 'no host at
all, _only_ virtual environment'. So then ":ppV" would mean
"cycle-accurate for virtual box _only_", while ":ppVH" would mean
"cycle-accurate for both the host and the virtual box". Of course,
considering the PEBS interface, right now neither of those can
actually work, but plain ":V" and ":HV" could work).

The important thing, I think, is that if the user doesn't know or care
about the VM case (because he's not running any!) and doesn't specify,
then the kernel should not say EOPNOTSUPP, and should do whatever
works for that cpu.

                 Linus
