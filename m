Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab2BAQ4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:56:52 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63593 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2BAQ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:56:49 -0500
MIME-Version: 1.0
In-Reply-To: <1328114266.5355.44.camel@lenny>
References: <20120201151918.GC16714@quack.suse.cz> <1328114266.5355.44.camel@lenny>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 08:56:29 -0800
X-Google-Sender-Auth: mOxHTR3jx_io1eKxO_-bv7vCdR4
Message-ID: <CA+55aFxmdskUXX1iBaPx7rUGD95UqNJxhe1BLeVtZjqHjBpsPA@mail.gmail.com>
Subject: Re: Memory corruption due to word sharing
To: Colin Walters <walters@verbum.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, dsterba@suse.cz, ptesarik@suse.cz,
        rguenther@suse.de, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 8:37 AM, Colin Walters <walters@verbum.org> wrote:
>
> 1) Use the same lock for a given bitfield

That's not the problem. All the *bitfield* fields are all accessed
under the same word already.

> 2) Split up the bitfield into different words

Again, it's not the bitfield that is the problem.

The problem is that the compiler - when it writes to the word that
contains the bitfield - will also corrupt the word *NEXT* to the
bitfield (or before - it probably depends on alignment).

So we have two separate 32-bit words - one of which just happens to
contain a bitfield. We write to these *separate* words using different
locking rules (btw, they don't even need to be protected by a lock: we
may have other rules that protects the individual word contents.

But the compiler turns the access to the bitfield (in a 32-bit aligned
word) into a 64-bit access that accesses the word *next* to it.

That word next to it might *be* the lock, for example.

So we could literally have this kind of situation:

   struct {
      atomic_t counter;
      unsigned int val:4, other:4, data:24;
   };

and if we write code like this:

    spin_lock(&somelock);
    s->data++;
    spin_unlock(&somelock);

and on another CPU we might do

   atomic_inc(&counter);

and the access to the bitfield will *corrupt* the atomic counter, even
though both of them are perfectly fine!

Quite frankly, if the bug is simply because gcc doesn't actually know
or care about the underlying size of the bitmask, it is possible that
we can find a case where gcc clearly is buggy even according to the
original C rules.

Honza - since you have access to the compiler in question, try
compiling this trivial test-program:


   struct example {
      volatile int a;
      int b:1;
   };

   ..
     s->b = 1;
   ..

and if that bitfield access actually does a 64-bit access that also
touches 's->a', then dammit, that's a clear violation of even the
*old* C standard, and the gcc people cannot just wave away their bugs
by saying "we've got standads, pttthththt".

And I suspect it really is a generic bug that can be shown even with
the above trivial example.

                               Linus
