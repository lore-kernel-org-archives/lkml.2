Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1LTT24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:28:56 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53769 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1LTT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:28:48 -0500
MIME-Version: 1.0
In-Reply-To: <20111220162315.GC10752@google.com>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com> <20111220162315.GC10752@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 Dec 2011 11:28:25 -0800
X-Google-Sender-Auth: WCy45op7ECl51rMp5qrMrIOC08I
Message-ID: <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
To: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 8:23 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> To illustrate the issue, for "per cpu add" we have:
>>
>> __this_cpu_add()
>> this_cpu_add()
>> irqsafe_cpu_add()
>
> Description for 7340a0b152 "this_cpu: Introduce this_cpu_ptr() and
> generic this_cpu_* operations" should explain the above three.

I don't think that's relevant.

Sure, they have semantics, but the semantics are stupid and wrong.
Whether they are documented or not isn't even the issue.

There are also too many of them to begin with, and they are generally pointless.

Just grep for "this_cpu_" and notice that we basically have *more*
lines in the header files to defile the crap, than we have lines in
the rest of the kernel to *use* it.

If that doesn't show how crappy the idiotic interface is, I don't know
what would.

So I would suggest:

 - get rid of *all* of them, leave exactly one version (this_cpu_xyz())

 - ask yourself which of the ops we even need. "this_cpu_write()"
needs to just go away. There's no excuse for it. Are the other ones
needed? I can see "add" and "cmpxchg". Is there *any* reason to
support anything else?

 - afaik, there is exactly *one* user of the "this_cpu_cmpxchg", and
*one* user of "irqsafe_cpu_cmpxchg". And those are both inside
CONFIG_CMPXCHG_LOCAL. Yet we have completely *INSANE* semantics for
the cmpxchg operations.

 - there's the magic "irqsafe_cmpxchg_double". Again, there is exactly
*one* user of it, but just grep for "cpu_cmpxchg_double" and notice
how we define all the crazy variations of it etc too. Again, *INSANE*.

In general, just grep for "this_cpu_" and notice that we basically
have *more* lines in the header files to defile the crap, than we have
lines in the rest of the ernel to *use* it.

Seriously, the whole piece of crap needs to go. Everything. It's shit.
It's unsalvageable.

I would suggest that we support exactly two operations, and nothing more.

 - this_cpu_cmpxchg (and the "double") version of it:

   This operation needs to be irq-safe and preempt-safe
*by*definition*. The whole concept of "cmpxchg" doesn't make sense
without that. Having three different versions of it with totally
insane semantics just NEEDS TO GO AWAY. There should be one version,
and it damn well is safe to use and does a totally unambiguous
"cmpxchg". Nothing else.

 - this_cpu_add()

   This operation is potentially useful for "sloppy statistics" where
the point is to do things quickly without requiring atomic accesses.
As such, it at least has *some* excuse for having the "irqsafe" vs
"preempt_safe" vs "regular" semantics. And it does have several users,
so.. However, I'd like to do something sane about it, and the
non-preempt version absolutely *needs* to have a debug check to verify
it, Thomas was already complaining about this.

But get rid of everything else. Stop using the "inc" ones, replace
them by "add 1". Don't have millions of lines of duplicate definitions
for crap that nobody cares about.

Also, get rid of the 1-byte and 2-byte versions. I doubt anybody
actually uses them, and it's not even a portable thing to do well (ie
the whole alpha issue with non-atomic byte and word accesses). So
again, it's just noise in the header files that makes it hard to
understand how they work because they are so verbose and do so many
stupid things.

Being "generic" is not actually a good thing. Not when we're talking
about random details like this.

Hmm?

                    Linus
