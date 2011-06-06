Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab1FFTMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:12:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1FFTMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:12:51 -0400
Date: Mon, 6 Jun 2011 21:12:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to
 COMPAT_VSYSCALLS
Message-ID: <20110606191218.GB20123@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECB7E8.5549.12290923@pageexec.freemail.hu>
 <20110606124743.GB22375@elte.hu>
 <4DED16C1.24309.139B86C7@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED16C1.24309.139B86C7@pageexec.freemail.hu>
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


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> On 6 Jun 2011 at 14:47, Ingo Molnar wrote:
> 
> > * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> > > [...] does that mean that you guys would accept a patch that would 
> > > map the vdso at a fixed address for old times's sake? if not, on 
> > > what grounds would you refuse it? see, you can't have it both ways.
> > 
> > You can actually do that by enabling CONFIG_COMPAT_VDSO=y.

> [...]
> 
> 2. who enables CONFIG_COMPAT_VDSO?
> 
> RHEL? Fedora? SLES? Debian? Ubuntu? (i don't know, i'm asking)

Fedora has not enabled it for a long time.

> and whoever enables them, what do you think they're more likely to 
> get in return? some random and rare old binaries that still run for 
> a minuscule subset of users or every run-of-the-mill exploit 
> working against *every* user, metasploit style (did you know that 
> it has a specific target for the i386 compat vdso)?

That's what binary compatibility means, yes.

> so once again, tell me whether the randomized placement of the vdso 
> wasn't about security (in which case can we please have it back at 
> a fixed mmap'd address, since it doesn't matter for security you 
> have no reason to refuse ;).

It's a statistical security measure, and was such a measure from the 
day it was committed:

 | commit e6e5494cb23d1933735ee47cc674ffe1c4afed6f
 | Author: Ingo Molnar <mingo@elte.hu>
 | Date:   Tue Jun 27 02:53:50 2006 -0700
 |
 |    [PATCH] vdso: randomize the i386 vDSO by moving it into a vma
 |    
 |    Move the i386 VDSO down into a vma and thus randomize it.
 |    
 |    Besides the security implications, this feature also helps debuggers, which
 |    can COW a vma-backed VDSO just like a normal DSO and can thus do
 |    single-stepping and other debugging features.

So what's your point?

> > > the fixed address of the vsyscall page *is* a very real 
> > > security problem, it should have never been accepted as such 
> > > and it's high time it went away finally in 2011AD.
> > 
> > It's only a security problem if there's a security hole 
> > elsewhere.
> 
> it's not an 'if', there *is* a security hole 'elsewhere', else the 
> CVE list had been abandoned long ago and noone would be doing 
> proactive security measures such as intrusion prevention 
> mechanisms.
> 
> so it *is* a security problem.

Two arguments.

Firstly, you generalize too much, it's only a security problem if you 
actually have an attack surface:

  Many Linux systems don't have any: non-networked appliances that 
  are not physically connected to any hostile medium.

  For such a system a gaping root hole bug is *not even a bug*, while 
  a rare memory leak that you'd shrug off on a desktop might be a 
  showstopper.

Secondly, and more importantly, we try to maintain the kernel in a 
way so that it can converge to a no bugs state in the long run.

You can only do that by making sure that even in the very last 
stages, when there are virtually no bugs left, the incentives and 
mechanisms are still there to fix even those bugs.

If we add obstruction features that turn bugs into less severe 
statistical bugs then that automatically reduces the speed of 
convergence.

We might still do it, but you have to see and acknowledge that it's a 
*cost*. You seem to argue that it's a bona fide bug and that the fix 
is deterministic that it "needs fixing" - and that is wrong on both 
counts.

You generally seem to assume that security is an absolute goal with 
no costs attached.

> > The thing is, and i'm not sure whether you realize or recognize 
> > it, but these measures *are* two-edged swords.
> 
> they aren't, see below why.
> 
> > Yes, the upside is that they reduce the risks associated with 
> > security holes - but only statistically so.
> 
> not sure what 'these measures' are here (if you mean ASLR related 
> ones, please say so), some are randomization based (so their impact 
> on security is probabilistic), some aren't (their impact is 
> deterministic).

Which of these changes are deterministic?

Removing a syscall or a RET from a fixed address is *still* only a 
probabilistic fix: the attacker can still do brute-force attacks 
against the many executable pages in user-space, even if everything 
is ASLR obfuscated.

> > The downside is that having such a measure in place makes it 
> > somewhat less likely that those bugs will be found and fixed in 
> > the future:
> 
> i'm not sure i follow you here, it seems to me that you're mixing 
> up bug finding/fixing with exploit development and prevention 
> measures.

It helps if you read the bit i provided after the colon:

  > > if a bug is not exploitable then people like Spender wont spend 
  > > time exploiting and making a big deal out of them, right?

If a bug is hidden via ASLR (and *all* of the changes in this thread 
had only that effect) and can not be exploited using the simple fixed 
address techniques disabled by these patches, then people like you or 
Spender wont spend time exploiting them, right?

But it can still be exploited brute-force: just cycle through the 
possible addresses until you find the right instruction that elevates 
privileges.

> > And yes, it might be embarrasing to see easy exploits and we 
> > might roll eyes at the associated self-promotion circus but it 
> > will be one more bug found, the reasons for the bug will be 
> > examined, potentially avoiding a whole class of similar bugs *for 
> > sure*.
> 
> it's a nice theory, it has never worked anywhere (just look at 
> OpenBSD ;). show me a single class of bugs that you think you'd 
> fixed in linux. [...]

For example after this meta-fix:

  c41d68a: compat: Make compat_alloc_user_space() incorporate the access_ok()

We certainly have eliminated the class of bugs where we'd return 
out-of-bounds pointers allocated via compat_alloc_user_space() and 
exploited via large or negative 'len' values.

> > Can you guarantee that security bugs will be found and fixed with 
> > the same kind of intensity even if we make their exploitation 
> > (much) harder? I don't think you can make such a guarantee.
> 
> why would *i* have to guarantee anything? [...]

It was an generic/indefinite 'you'.

To understand my point you need to look at the context i replied to:

 > > > the fixed address of the vsyscall page *is* a very real 
 > > > security problem, it should have never been accepted as such 
 > > > and it's high time it went away finally in 2011AD.

You claimed that it is a very real security problem. I pointed out 
that this is not a real primary fix for some security bug but a 
statistical method that makes exploits of other bugs harder (but not 
impossible), and as such it has the cost of making *real* fixes 
slower to arrive.

I don't think this was a terribly complicated argument, yet you do 
not even seem to acknowledge that it exists.

Thanks,

	Ingo
