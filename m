Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1FFLTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:19:30 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63242 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab1FFLT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=v9eOS9XDjkF3/mXKrSyKpN+K05mwRgpfUKIdr5CfSxo16VlcUV1qxhbiwbELb7gSmK
         cQu1pTDxRQl83aSPBKRFyzwGW4yDYysCbSk1i1NUimv1ux/X5d/yWwEfiwvsemfWpduS
         5b1fHWlndfccuqCEcodGNKi1NE7ehxCl6SesM=
MIME-Version: 1.0
In-Reply-To: <4DECA101.5994.11CF924E@pageexec.freemail.hu>
References: <cover.1307292171.git.luto@mit.edu> <20110605193001.GB3971@elte.hu>
 <BANLkTikQB6=Te6=E7DRmeD5+G4TESuy--w@mail.gmail.com> <4DECA101.5994.11CF924E@pageexec.freemail.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 6 Jun 2011 07:19:08 -0400
X-Google-Sender-Auth: HjvzJWS24eHGItsB9lEoUj9bIXM
Message-ID: <BANLkTikv3hyDsimi7YDVny1-1k2937NAkg@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
To: pageexec@freemail.hu
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 5:42 AM,  <pageexec@freemail.hu> wrote:
>>
>> I can't see any problem, but exploit writers are exceedingly clever,
>> and maybe someone has a use for a piece of the code that isn't a
>> syscall.  Just as a completely artificial example, here's some buggy
>> code:
>
> what you're describing here is a classical ret2libc (in modern marketing
> speak, ROP) attack. in general, having an executable ret insn (with an
> optional pop even) at a fixed address is very useful, especially for the
> all too classical case of stack overflows where the attacker may already
> know of a 'good' function pointer somewhere on the stack but in order to
> have the cpu reach it, he needs to pop enough bytes off of it. guess what
> they'll use this ret at a fixed address for...

I'm even more convinced now that exploit writers are exceedingly clever.

>
> as i said in private already, for security there's only one real solution
> here: make the vsyscall page non-executable (as i did in PaX years ago)
> and move or redirect every entry point to the vdso. yes, that kills the
> fast path performance until glibc stops using the vsyscall page.

I'm still unconvinced.

I would be happy to submit a version where the entire sequence is just
int 0xcc and the kernel emulates the ret instruction as well.  But I'm
not convinced that using a page fault to emulate the vsyscalls is any
better, and it's less flexible, slower, and it could impact a fast
path in the kernel.

>
> another thing to consider for using the int xx redirection scheme (speaking
> of which, it should just be an int3):

Why?  0xcd 0xcc traps no matter what offset you enter it at.

> it enables new kinds of 'nop sled'
> sequences that IDS/IPS systems will be unaware of, not exactly a win for
> the security conscious/aware people who this change is supposed to serve.

I think that's only because the patch allows int 0xcc to exist at any
address.  That's only because not doing so will apparently break one
particular commercial program.

I'm happy to break said program, and it sounds like the maintainer
will fix it up quickly.  I checked, and at least recent versions of
valgrind would not be affected (contrary to what I said earlier).

I don't think that making the page NX is viable until at least 2012.
We really want to wait for that glibc release.

(Yes, I know that not everyone uses glibc.  But the only remotely
relevant alternative out there that I can find that would be affected
is Go, and I'm sure that'll get fixed up in short order.)

--Andy
