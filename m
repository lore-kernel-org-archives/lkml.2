Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031726Ab2COQaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:30:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55887 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031681Ab2COQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:30:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120314170918.404528547@linutronix.de>
References: <20120314170736.617746873@linutronix.de> <20120314170918.404528547@linutronix.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Mar 2012 09:29:50 -0700
X-Google-Sender-Auth: GpwVHgz5LYY3E8yp0OK8Da_Mmeo
Message-ID: <CA+55aFzCQEiV2ZfB3s983fe-zpyFhhc+QvpA58qeLWJxRJtU0A@mail.gmail.com>
Subject: Re: [patch 1/5] seqlock: Remove unused functions
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I have to say, I hate this entire series.

Seriously, what the heck is the point of this churn? It's all entirely
pointless searc-and-replace as far as I can tell, with absolutely zero
upside.

It makes the low-level filesystems have to be aware of things that
they don't want to know and *shouldn't* know. Why should a filesystem
care that d_lock is a seqlock, and have to use a locking function that
they've never seen before and is very specialized?

The "seq" part of the dentry is something only the lookup code and the
internal dentry code should care about. NOBODY ELSE should ever care.

Also, we have actually tried to largely split the D$ lines, so the
d_seq field isn't even necessarily in the same cacheline as the d_lock
part. Very much on purpose: the beginning of the 'struct dentry' is
largely read-only for the lookup part, and can (hopefully) actually be
shared across CPU's for hot directory entries.

Sure, we may have screwed that up, and maybe it turns out that we
write to it too much, but it really was the *intention*. And you
fundamentally and totally screwed that up, and put the largely
read-only sequence count next to the d_lock thing.

So quite frankly, I think the whole series is total and utter garbage.
And there isn't even any *explanation" for the garbage. You say that
you are unifying things, but dammit, in order to unify them you end up
*adding*new*f&^#ing*code*. You add all those "seq_spin_trylock()" etc
counters that really shouldn't be added because nobody needs them, but
you have to add them because you turned what was a perfectly good
spinlock into a seq_spinlock.

I didn't do a full line count, but I think you added more lines than
you removed. The *only* actual removal of code was the few little "use
a seq_spin_init()" instead of initializing the sequence count and
spinlocks separately. Everything else was just search-and-replace with
less common functions.  And addition of those special function code.

Maybe there is some huge advantage that I'm missing - like the fact
that you could optimize the code using some very special new hardware
transactional memory trick that you have pre-production hardware for
now. But dammit, if that is the case, you should have written that out
in some big letters and explained exactly why you are sending out this
series that seems to be a lot of stupid code churn and that actually
makes the code noticeably worse, bigger, and less flexible.

So a honking big NAK on this whole series unless you can explain with
numbers and show with numbers what the advantage of the abortion is.

                               Linus
