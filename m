Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1CYTWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:22:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab1CYTWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:22:30 -0400
Date: Fri, 25 Mar 2011 20:21:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110325192145.GA22960@elte.hu>
References: <20110324200010.GB7957@elte.hu>
 <1300999682.2714.23.camel@edumazet-laptop>
 <20110324205422.GB2393@elte.hu>
 <1301000557.2714.33.camel@edumazet-laptop>
 <m2oc50kxg0.fsf@firstfloor.org>
 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
 <20110324235654.GM21838@one.firstfloor.org>
 <20110325092227.GA13640@elte.hu>
 <1301048476.2250.181.camel@laptop>
 <20110325171519.GO21838@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325171519.GO21838@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > Also seriously complicated by the kexec case where the previous kernel
> > didn't clean up PMU state. There is simply no sane way to detect if its
> 
> That's a good point, but we can easily stop the PMU before kexec.

Wrong - there's lots of existing Linux versions out there that will kexec with 
PMU state active. We cannot change them retroactively.

> > actually used and by whoem.
> 
> You check if the counter is enabled. If it's already enabled it's used by 
> someone else.

Wrong - or it can be enabled if it was left enabled accidentally. We treat PMU 
state like we treat other CPU state.

> > The whole PMU 'sharing' concept championed by Andi is utter crap.
> 
> Why? It's the same thing as having some less counters.

Wrong again - 25% or 50% of the events stolen with no user choice is a pretty 
big deal.

Consider the example in this thread: cachemiss profiling done via perf, which 
needs two events. If one of the generic counters is 'stolen' by a BIOS and 
Linux accepts this silently then it means the loss of real functionality.

In other words, '25% of a specific hardware functionality stolen by the BIOS' 
(or more) is absolutely not acceptable.

> [...] You need to already support that for architectural perfmon with 
> variable counters anyways or for sharing with oprofile.

Wrong, that's different - multiplexing the PMU is obviously done within the OS. 
It's evidently user configurable - users can use oprofile or perf - and the 
user can still fully utilise the PMU to the extent he wishes to - it's his 
hardware.

It is not possible for the kernel to stop the BIOS from using the PMU though, 
so it's not 'sharing' no matter what 'protocol' is used, it's 'stealing'.

> > As for simply using it despite the BIOS corrupting it, that might not
> > always work, the BIOS might simply over-write your state because it
> > one-sidedly declares to own the MSRs (observed behaviour).
> 
> Yes, that doesn't work. If someone else is active you have to step back.
> 
> > Its all a big clusterfuck and really the best way (IMO) is what we have
> > now to put pressure on and force the BIOS vendors to play nice.
> 
> It just results in users like Eric being screwed.  I doubt that any
> BIOS writer ever heard about it. Congratulations for a great plan.

I'd encourage you to think through this topic instead of making derisive 
comments about others ...

Thanks,

	Ingo
