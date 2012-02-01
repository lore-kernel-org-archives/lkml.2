Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab2BAUTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:19:41 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62246 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab2BAUTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:19:39 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzVWjqcs1zRF-93_9yHRDS-YgmpgFTzACw6HQ-059U06Q@mail.gmail.com>
References: <20120201151918.GC16714@quack.suse.cz> <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
 <1328118174.15992.6206.camel@triegel.csb> <20120201194025.GG6148@sunsite.ms.mff.cuni.cz>
 <CA+55aFzVWjqcs1zRF-93_9yHRDS-YgmpgFTzACw6HQ-059U06Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 12:19:18 -0800
X-Google-Sender-Auth: RXtGJGdZv8yMs_G4dhQHZpOvdgI
Message-ID: <CA+55aFwG7BoFg-zaER7=hiamX62_zZCQhB_A+edHaK9Sj7Ga0g@mail.gmail.com>
Subject: Re: Memory corruption due to word sharing
To: Jakub Jelinek <jakub@redhat.com>
Cc: Torvald Riegel <triegel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
        dsterba@suse.cz, ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 12:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>  - However, while using the *smallest* possible access may generate
> correct code, it often generates really *crappy* code. Which is
> exactly the bug that I reported in
>
>   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48696

Btw, as I also pointed out in that (old) bugzilla entry, gcc can do
pretty much whatever it damn well pleases with loads from a bitfield.

You can narrow them, you can make them wider, you can paint them pink.

Widening the loads can still be a performance problem, and technically
it's a really bad idea for any nearby "volatile"s too, but in practice
things will *work*.

Writes are much more critical. If you overwrite a field that is no
longer in the bitfield, you can no longer depend on "nobody cares
about bitfield accesses", because by definition you are clearly now
stepping on non-bitfield things.

You do realize that even in user space, and even before C11, people
have things like "sig_atomic_t" etc. So even if you don't like the
notion of "volatile", here's *another* example of this being  real gcc
bug:

   struct mydata {
      sig_atomic_t seen_signal;
      unsigned flags:1;
   };

and now do the same test-program, realizing that "sig_atomic_t" is
normally the exact same thing as "int".

Now, thing about what happens if you have a signal handler that comes
in and does

   mydata.seen_signal = 1;

and happens to interrupt the code that changes "mydata.flags" in just
the right spot.

That's right: the bitfield update will possibly *clear* that
"signal-safe" flag again, and gcc just created buggy asm code from
correct C code.

Guys, if you don't admit that this is a bug, I don't know what to say.

IT IS A GCC BUG.

Don't try to make it into something bigger and related to C++11/C11.
Don't try to talk about "memory models". Just admit that it is a bug
to do a 64-bit write to a 32-bit bitfield, and fix it!

                        Linus
