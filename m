Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1FFL6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:58:43 -0400
Received: from r00tworld.com ([212.85.137.150]:59014 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1FFL6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:58:39 -0400
From: pageexec@freemail.hu
To: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 06 Jun 2011 13:56:42 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DECC07A.8317.124A847C@pageexec.freemail.hu>
In-reply-to: <BANLkTikv3hyDsimi7YDVny1-1k2937NAkg@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu>, <4DECA101.5994.11CF924E@pageexec.freemail.hu>, <BANLkTikv3hyDsimi7YDVny1-1k2937NAkg@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 13:57:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 7:19, Andrew Lutomirski wrote:

> On Mon, Jun 6, 2011 at 5:42 AM,  <pageexec@freemail.hu> wrote:
> > as i said in private already, for security there's only one real solution
> > here: make the vsyscall page non-executable (as i did in PaX years ago)
> > and move or redirect every entry point to the vdso. yes, that kills the
> > fast path performance until glibc stops using the vsyscall page.
> 
> I'm still unconvinced.
> 
> I would be happy to submit a version where the entire sequence is just
> int 0xcc and the kernel emulates the ret instruction as well.  But I'm
> not convinced that using a page fault to emulate the vsyscalls is any
> better,

> and it's less flexible

why? as in, what kind of flexibility do you need that int xx can provide but a page
fault cannot?

> slower

vs. int xx? it's the same kind of cpu exception (lots of cycles to transition to
kernel mode), and the vsyscall address checks can be moved arbitrarily close
to the entry point, if that really matters.

> and it could impact a fast path in the kernel.

a page fault is never a fast path, after all the cpu has just taken an exception
(vs. the syscall/sysenter style actually fast user->kernel transition) and is
about to make page table changes (and possibly TLB flushes).

> > another thing to consider for using the int xx redirection scheme (speaking
> > of which, it should just be an int3):
> 
> Why?  0xcd 0xcc traps no matter what offset you enter it at.

but you're wasting/abusing an IDT entry for no real gain (and it's lots of code
for such a little change). also placing sw interrupts among hw ones is what can
result in (ab)use like this:

http://www.invisiblethingslab.com/resources/2011/Software%20Attacks%20on%20Intel%20VT-d.pdf

(yes, a highly theoretical case but since you were wondering about explot writers... ;)

> > it enables new kinds of 'nop sled'
> > sequences that IDS/IPS systems will be unaware of, not exactly a win for
> > the security conscious/aware people who this change is supposed to serve.
> 
> I think that's only because the patch allows int 0xcc to exist at any
> address.  That's only because not doing so will apparently break one
> particular commercial program.

well, that's one you know about now (from a small userbase that tracks very
recent lkml discussions), but you don't know what else out there uses the same
tricks...

> I don't think that making the page NX is viable until at least 2012.
> We really want to wait for that glibc release.

sure, if for mainline users performance impact is that much more important
then timing the nx approach for later is no problem (i'll just have to do
more work till then to revert/adapt this in PaX ;).

> (Yes, I know that not everyone uses glibc.  But the only remotely
> relevant alternative out there that I can find that would be affected
> is Go, and I'm sure that'll get fixed up in short order.)

i don't understand why people are so 'worked up' about glibc or not glibc.

it's *irrelevant*. this change you propose would go into future kernels,
it would not affect existing ones, obviously. therefore anyone possibly
affected would have to update his kernel first at which point they have
no excuse to not update their libc of whatever flavour as well.

in other words, it's at most a distro issue (in that they have to be actively
aware of not forgetting about the libc update for this future kernel), no
existing user will care or be affected.

