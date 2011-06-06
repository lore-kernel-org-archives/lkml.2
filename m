Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1FFKiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:38:16 -0400
Received: from r00tworld.com ([212.85.137.150]:46650 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab1FFKiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:38:14 -0400
X-Greylist: delayed 2860 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jun 2011 06:38:14 EDT
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>, Andrew Lutomirski <luto@mit.edu>
Date: Mon, 06 Jun 2011 11:42:25 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DECA101.5994.11CF924E@pageexec.freemail.hu>
In-reply-to: <BANLkTikQB6=Te6=E7DRmeD5+G4TESuy--w@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu>, <20110605193001.GB3971@elte.hu>, <BANLkTikQB6=Te6=E7DRmeD5+G4TESuy--w@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 11:43:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Jun 2011 at 16:01, Andrew Lutomirski wrote:

> On Sun, Jun 5, 2011 at 3:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
[...]
> > ffffffffff60012a <vread_hpet>:
> > ffffffffff60012a:       55                      push   %rbp
> > ffffffffff60012b:       48 89 e5                mov    %rsp,%rbp
> > ffffffffff60012e:       8b 04 25 f0 f0 5f ff    mov    0xffffffffff5ff0f0,%eax
> > ffffffffff600135:       89 c0                   mov    %eax,%eax
> > ffffffffff600137:       5d                      pop    %rbp
> > ffffffffff600138:       c3                      retq
> >
> > There's no obvious syscall instruction in them that i can see. No
> > 0x0f 0x05 pattern (even misaligned), no 0xcd-anything.
> 
> I can't see any problem, but exploit writers are exceedingly clever,
> and maybe someone has a use for a piece of the code that isn't a
> syscall.  Just as a completely artificial example, here's some buggy
> code:

what you're describing here is a classical ret2libc (in modern marketing
speak, ROP) attack. in general, having an executable ret insn (with an
optional pop even) at a fixed address is very useful, especially for the
all too classical case of stack overflows where the attacker may already
know of a 'good' function pointer somewhere on the stack but in order to
have the cpu reach it, he needs to pop enough bytes off of it. guess what
they'll use this ret at a fixed address for...

as i said in private already, for security there's only one real solution
here: make the vsyscall page non-executable (as i did in PaX years ago)
and move or redirect every entry point to the vdso. yes, that kills the
fast path performance until glibc stops using the vsyscall page.

another thing to consider for using the int xx redirection scheme (speaking
of which, it should just be an int3): it enables new kinds of 'nop sled'
sequences that IDS/IPS systems will be unaware of, not exactly a win for
the security conscious/aware people who this change is supposed to serve.

> I have no problem with that suggestion, except that once the current
> series makes it into -tip I intend to move vread_tsc and vread_hpet to
> the vDSO.  So leaving them alone for now saves work, and they'll be
> more maintainable later if they're written in C.

imho, moving everything to and executing from the vdso page is the only
viable solution if you really want to fix the security aspect of the
vsyscall mess. it's worked fine for PaX for years now ;).

