Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1FFO43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:56:29 -0400
Received: from r00tworld.com ([212.85.137.150]:43546 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1FFO41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:56:27 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 06 Jun 2011 16:55:12 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Andrew Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DECEA50.12659.12EDEED6@pageexec.freemail.hu>
In-reply-to: <BANLkTimZjqEYHt=MBBthXOoUXcorJz4J1A@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu>, <4DECC07A.8317.124A847C@pageexec.freemail.hu>, <BANLkTimZjqEYHt=MBBthXOoUXcorJz4J1A@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 16:55:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 23:01, Linus Torvalds wrote:

> On Mon, Jun 6, 2011 at 8:56 PM,  <pageexec@freemail.hu> wrote:
> >
> > it's *irrelevant*. this change you propose would go into future kernels,
> > it would not affect existing ones, obviously. therefore anyone possibly
> > affected would have to update his kernel first at which point they have
> > no excuse to not update their libc of whatever flavour as well.
> 
> Christ.
> 
> Heard about that thing called "backwards compatibility"?
> 
> We *require* that those "future kernels" run the old unmodified binaries.

both Andy's and my approach work with 'old unmodified binaries'. by virtue
of those 'new modified binaries' not existing (hint: glibc's intentionally
not changed for static binaries).

all the compatibility talk is about performance impact, not black&white 'runs
or fails'. but more on this 'requirement' of yours below. you just so shot
yourself in the foot, it's not even funny ;).

> Yeah, I know you don't have that requirement,

you don't know jack then. i do allow old binaries to work for every PaX feature
i've ever introduced, even at the non-considerable expense of having to make
special cases for them.

> but anything that actually wants to be considered *relevant* and
> actually merged into a mainline kernel does have that requirement. So
> your argument is utter crap, ignorant, and stupid. 

watch your words Linus, you're about to eat them ;).

> No, we don't update any libraries for a kernel upgrade. Ever. End of story.

then you *must* revert the utterly *wrong* heap/stack gap 'fix' of yours that
you cooked up without any public discussion a year ago and have been 'fixing'
it for various userland breakage ever since.

you know what you did? you *broke* a userland API, namely /proc/pid/maps. you
broke it so badly that it breaks every app that wanted to do its own stack
expansion tracking.

one particular case i'm aware of is the Sun JVM that tries to map a guard page
below what it thinks is the stack. except thanks to your very broken idea of
lying about it in maps, it will actually map *over* the real last page of the
stack, effectively *moving* its lower bound up, without having intended to do
so (and without having done so under earlier kernels).

in other words, a simple userland mmap request can now change *another* map.
*that* is a clear violation of your own principles (not that i think you have
any, your argument style is to throw out random shit whenever you think it
serves your purpose, and not able to defend it when faced with real argumemts).

but that's still not the end of the story. whenever userland code hits that
carelessly hidden guard page, it'll cause a page fault that the JVM's segfault
handler can't identify as its own since the fault didn't occur in what it
thinks is the stack guard page. a really brilliant solution Linus, you must
be very proud of it. what a pity that now you get to revert the whole shit
and implement it properly (i don't need to tell you where you can find such
a working solution, do i).

cheers,

 PaX Team

