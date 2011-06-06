Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab1FFSGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:06:20 -0400
Received: from r00tworld.com ([212.85.137.150]:43291 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab1FFSGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:06:17 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Mon, 06 Jun 2011 20:04:49 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <4DED16C1.24309.139B86C7@pageexec.freemail.hu>
In-reply-to: <20110606124743.GB22375@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DECB7E8.5549.12290923@pageexec.freemail.hu>, <20110606124743.GB22375@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 20:05:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 14:47, Ingo Molnar wrote:

> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> > [...] does that mean that you guys would accept a patch that would 
> > map the vdso at a fixed address for old times's sake? if not, on 
> > what grounds would you refuse it? see, you can't have it both ways.
> 
> You can actually do that by enabling CONFIG_COMPAT_VDSO=y.

as you noted later, we're talking about amd64 here. but ignoring that,
let's see what you've just shown here.

1. why does CONFIG_COMPAT_VDSO exist?

because you guys realized some time in the past, after several public
exploits, that keeping known code at fixed addresses wasn't the brightest
of ideas. so you implemented without much if any resistance vdso
randomization and kept a backwards compatibility option for userland
that knew better and relied on those fixed addresses.

sound familiar? security issue with known code/addresses triggering move
to randomization? right in this patch series! why lie about it then and
paint it something else than what it is? oh yes, covering up security
related fixes/changes is a long held tradition in kernel circles.

2. who enables CONFIG_COMPAT_VDSO?

RHEL? Fedora? SLES? Debian? Ubuntu? (i don't know, i'm asking)

and whoever enables them, what do you think they're more likely to get in
return? some random and rare old binaries that still run for a minuscule
subset of users or every run-of-the-mill exploit working against *every*
user, metasploit style (did you know that it has a specific target for
the i386 compat vdso)?

so once again, tell me whether the randomized placement of the vdso wasn't
about security (in which case can we please have it back at a fixed mmap'd
address, since it doesn't matter for security you have no reason to refuse ;).

> > the fixed address of the vsyscall page *is* a very real security 
> > problem, it should have never been accepted as such and it's high 
> > time it went away finally in 2011AD.
> 
> It's only a security problem if there's a security hole elsewhere.

it's not an 'if', there *is* a security hole 'elsewhere', else the CVE
list had been abandoned long ago and noone would be doing proactive
security measures such as intrusion prevention mechanisms.

so it *is* a security problem.

> The thing is, and i'm not sure whether you realize or recognize it, 
> but these measures *are* two-edged swords.

they aren't, see below why.

> Yes, the upside is that they reduce the risks associated with 
> security holes - but only statistically so.

not sure what 'these measures' are here (if you mean ASLR related ones,
please say so), some are randomization based (so their impact on security
is probabilistic), some aren't (their impact is deterministic).

> The downside is that having such a measure in place makes it somewhat 
> less likely that those bugs will be found and fixed in the future:

i'm not sure i follow you here, it seems to me that you're mixing up
bug finding/fixing with exploit development and prevention measures.

these things are orthogonal to each other and neither affects the other
unless they're perfect (which neither side is). i.e., if we could find
all bugs, intrusion prevention and exploit writing would die out. or if
we could exploit all bugs under any circumstances, intrusion prevention
would die out. or if we could defeat all exploit techniques, exploit
writing would die out, etc. but there's no such perfection in the real
world.

so you can go find and fix bugs without ever writing exploits for them
or without ever implementing countermeasures against exploit techniques
for a given bug class (actually, it's not even correct to put it this way,
exploit techniques are orthogonal to bug classes, a bug can be exploited
by several techniques and an exploit technique can be used against different
kinds of bugs, so prevention mechanisms like ASLR are against techniques,
not bugs, for the latter we have to do some kind of analysis/instrumentation).

also not finding or fixing bugs in the presence of intrusion prevention
mechanisms means that an exploited bug is (usually) transformed into a
some kind of denial of service problem, not something you can go easy
about if you have paying customers and/or vocal users. so having such
measures is not reason to become lax about finding and/or fixing bugs.
what these measures buy you (your customers/users, that is) are time
and reduced risk of getting owned.

> if a bug is not exploitable then people like Spender wont spend time
> exploiting and making a big deal out of them, right? 

i'm not sure i get this example, if a bug is not exploitable, how could
anyone possibly spend time on, well, exploiting it?

btw, what's with this being fixed on specific individuals, circus and
what not? do you seriously base your decision about fixing bugs whether
you hear about them in the news? or are your collective egos being hurt
by showing the world what kind of facade you put up when you talk about
'full disclosure' but cover up security fixes? also, i never understood
the circus part, can you tell me what exactly you find in the security
world as 'circus'? specific examples will do.

> And yes, it might be embarrasing to see easy exploits and we might 
> roll eyes at the associated self-promotion circus but it will be one 
> more bug found, the reasons for the bug will be examined, potentially 
> avoiding a whole class of similar bugs *for sure*.

it's a nice theory, it has never worked anywhere (just look at OpenBSD ;).
show me a single class of bugs that you think you'd fixed in linux. for
that you'd have to know about them, try CWE (not to be confused with CVE)
in google.

in the meantime i can tell you what you did not fix *for sure*:

- use-after-free bugs
- double free bugs
- heap buffer overflows
- stack buffer overflows
- stack overflows (yes, it's not the buffer overflow kind)
- refcount overflows (as a subset of user-after-free bugs)
- integer overflows and wraparounds
- information leaking from heap/stack areas
- bugs resulting from undefined behaviour in C
- resource exhaustion bugs
- etc

> Can you guarantee that security bugs will be found and fixed with the 
> same kind of intensity even if we make their exploitation (much) 
> harder? I don't think you can make such a guarantee.

why would *i* have to guarantee anything? i'm not santa claus or something ;).
i'm not even into the business of finding & fixing bugs, i, at most, fix stuff
i (or users) run across while developing PaX but i don't go out of my way and
audit the kernel (or anything else) for bugs. life's too short and i placed my
bets long ago on intrusion prevention ;).

but if you're speaking of a hypothetical 'you', i think i explained above why
these processes are independent. also this particular feature (getting rid of
the vsyscall) is a very small dent in the exploit writers arsenal, it's an
anti-script kiddie measure at most and a feature box you can tick off when you
talk about 'full ASLR'. real exploit writers will continue to find info leaking
bugs, use brute forcing, heap/JIT spraying, and other techniques.

> So as long as we are trading bugs-fixed-for-sure against statistical 
> safety we have to be mindful of the downsides of such a tradeoff ...

while i'm still trying to put together the argument you're making, i hope you're
not saying that leaving users in exploitable conditions is actually *better*
for security...

