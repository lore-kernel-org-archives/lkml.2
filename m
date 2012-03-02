Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2CBBi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:38:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49121 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2CBBiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:38:54 -0500
MIME-Version: 1.0
In-Reply-To: <20120302011119.GA22197@one.firstfloor.org>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
 <m2ipinq16x.fsf@firstfloor.org> <CA+55aFw=wwGD=QLmQgfGm+oZR3UyvKBmXdXj+SJtK6pipCe45A@mail.gmail.com>
 <20120302011119.GA22197@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Mar 2012 17:38:33 -0800
X-Google-Sender-Auth: z8FdM9fUPvkIvpS4mESEYzrCgOc
Message-ID: <CA+55aFwKbRTNy7Z7UcMZWdF_2ddChZ7sQkYgPrnSmqnuCZr2Bw@mail.gmail.com>
Subject: Re: .. anybody know of any filesystems that depend on the exact VFS
 'namehash' implementation?
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 5:11 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> With better I meant mainly faster in cycles.
>
> e.g. CityHash claims upto ~6 bytes/cycle. That's extreme and may need
> the SSE versions, but there are non SSE variants e.g. in spooky that are
> somewhat competive.

Oh. Yeah, no. The real problem we have is finding the end of the
string, and the NUL and '/' bytes.

> Are you anywhere near that with your hash function?
>
> Partly they get that from unrolling, but there are also lots of other tricks.

Unrolling actually hurts. Badly.

The common path components sizes really are small. Three letters is
not unusual ("usr" and "bin" come to mind), but 5-10 letters is the
common case.

And when you do things a word at a time on a 64-bit architecture, that
means that you go through the loop *once*. Maybe twice. More than that
is quite unusual.

So the *hashing* is actually pretty trivial. Our name hash used to do
some "shift four bits games" to spread out the bytes a bit, but with
words that really doesn't make much sense, and I'm currently just
using "hash = hash*11 + word" which seems *plenty* fine.

It's the final masking of bytes and the loading the big constants to
find the zero and '/' bytes that are costly. The "inner loop" is
trivial, and does 8 bytes at a time with this loop:

.L402:
        addq    %rdi, %rdx      # hash, D.39887
        addq    $8, %rsi        #, len
        leaq    (%rdx,%rdx,4), %rax     #, tmp347
        leaq    (%rdx,%rax,2), %rdi     #, hash
        movq    (%r12,%rsi), %rdx       #* len, a
        movq    %rdx, %rax      # a, D.39884
        movq    %rdx, %r10      # a, tmp359
        xorq    %r11, %rax      # tmp469, D.39884
        notq    %r10    # tmp359
        leaq    (%rax,%r9), %rcx        #, tmp354
        notq    %rax    # tmp353
        andq    %rax, %rcx      # tmp353, tmp354
        leaq    (%rdx,%r9), %rax        #, tmp361
        andq    %r10, %rax      # tmp359, tmp361
        orq     %rcx, %rax      # tmp354, tmp361
        andq    %r8, %rax       # tmp471, mask
        je      .L402   #,

where most of it is about finding the final bytes. And remember, while
this is a "loop", usually we go through it once, and the final "jump
back to the top" generally is never actually taken for path components
of size 1-7 bytes.

(And it really is about the *components*. The pathname may be long,
but we do the hashing on a component basis)

According to my profiles, one of the most expensive parts is literally
this loop at the very end

        /* remove trailing slashes */
        while (name[len] == '/')
                len++;

which is *trivial*, but I think it mispredicts a lot (the common case
is a single slash at the end of the component except for the final
one, of course) but gcc has created a horrible mess that turns it into

   if(name[len] == '/') {
     .. align the loop that will never be taken, stupid gcc ..
     do { len ++ } while (name[len] == '/');
   }

which is just sad and doesn't buy us anything. I actually suspect I
should do something like

   len += name[len] == '/';

to get rid of the unpredictable "end of string vs end of path
component" case, and then I could have a very unlikely loop for the
"multiple slashes" case after that.

I use a "bsf" instruction to find how many bytes we had at the end,
which is just sad too. But hey, it's fine on modern CPU's that have
the special hardware for bit scanning. It might be one of those "sucks
on atom" kind of things, though.

                          Linus
