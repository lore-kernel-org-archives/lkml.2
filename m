Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1EQMSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:18:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab1EQMSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:18:06 -0400
Date: Tue, 17 May 2011 14:17:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Jones <davej@redhat.com>, Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110517121745.GI13475@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
 <BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
 <BANLkTimjHiaZ+b03FLb1LX=ycv=cAVyJZw@mail.gmail.com>
 <20110512213542.GB17596@elte.hu>
 <BANLkTikPmq=NOt-9t0odVVnrRshM=MsnJw@mail.gmail.com>
 <20110512215023.GA20939@elte.hu>
 <20110512220715.GA7451@redhat.com>
 <20110513085752.GF13647@elte.hu>
 <m2iptezi07.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2iptezi07.fsf@firstfloor.org>
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

> > The x86 kernel is relocatable, so slightly randomizing the position of the 
> > kernel would be feasible with no overhead on the vast majority of exising 
> > distro installs, with just an updated kernel.
> 
> Problem is that we don't have a source of secure randomness early on when the 
> relocation would need to happen.

That's indeed a problem but not a fundamental one: we can read out the current 
time (RTC CMOS is always available on most systems), mix it with the current 
cycle counter value and PRNG mix it.

It could only be recovered if the attacker is local to that box, guesses the 
precise cycle count on that specific hardware (and hardware has small thermal 
variations) and knows the precise boot time to the second as present in the 
RTC.

Note that the amount of randomization would be small to begin with: if we have 
only 3 bits of randomization and can thus make ~90% of kernel exploit attempts 
crash statistically then we have most of the advantages already.

[ For the really paranoid we could add a new flag to the boot protocol and 
  embedd a random seed in the bzImage. This could be re-set upon installation 
  of a new kernel package, so on the next reboot the system gains a unique 
  seed.

  Or we could add a boot parameter to seed things and cut this particular boot 
  parameter from all output like /proc/cmdline or the syslog command line 
  parameters printout. /etc/grub.conf is already inaccessible to unprivileged 
  userspace on most distros so the parameter is hidden. ]

So it's a solvable problem.

> You could either pass it as an option, but that option would be right now too 
> exposed, or just use kexec and boot twice.
> 
> But all of this has drawbacks.
> 
> > When exposing randomized RIPs to user-space we could recalculate all RIPs back 
> > to the 0xffffffff80000000 base, so oopses would have the usual non-randomized 
> > form:
> 
> This would be very confusing because the register and stack contents 
> would have the non relocated addresses.

Well, kernel crashes can expose security relevant details anyway so they better 
be hidden from unprivileged attackers anyway, the important thing is to 
properly decode the symbols. We can keep the rest of the oops in its raw form 
(and thus expose the seed to a privileged user - which we'd do anyway), being 
dependable is important for oopses.

> I bet it would cause a lot of similar problems as the current %kP madness, 
> just more subtle ones.

Well, did you expect me to react to your claim of 'subtle issues'?

If yes (which i assume) then why didn't you outline what you meant with that in 
more detail, why are you forcing me to ask you what you mean precisely?

Thanks,

	Ingo
