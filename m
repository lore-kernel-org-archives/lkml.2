Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0F1QFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:05:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219Ab0F1QFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:05:18 -0400
MIME-Version: 1.0
In-Reply-To: <m3fx07rx9i.fsf@hase.home>
References: <alpine.LFD.2.00.1006252140410.18683@localhost.localdomain>
	<235959492.961541277496281970.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<AANLkTilaOOlzS2cJXCJF8Qn_cqjr7ywUv9RUTSsK9pf3@mail.gmail.com>
	<m3fx07rx9i.fsf@hase.home>
Date: Mon, 28 Jun 2010 09:04:41 -0700
Message-ID: <AANLkTil7vXFkl89GbM022NrDT469XaYpMitNvrrnEiGn@mail.gmail.com>
Subject: Re: Q: sys_futex() && timespec_valid()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andreas Schwab <schwab@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 8:29 AM, Andreas Schwab <schwab@redhat.com> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> We know it's not a valid absolute timeout, since there's no way
>> somebody is "waiting" for something that happened in the sixties.
>
> Should it reject timestamps from the seventies?

Conceptually, we could certainly say "any timeouts from before the
boot of the machine are obviously bogus". It would be stupid and
complicated, and it would be a total pain for anybody who wants to do
migration or anything like that, so we shouldn't do it, but I could
imagine some system that rejected such timeouts as "crazy".

At the same time, for us, there's simply no _reason_ to do that. A
positive time_t value is well-defined. In contrast, a negative tv_sec
value is inherently suspect. Traditionally, you couldn't even know if
time_t was a signed quantity to begin with! And on 32-bit machines, a
negative time_t is quite often the result of overflow (no, you don't
have to get to 2038 to see it - you can get overflows from simply
doing large relative timeouts etc).

So there is no _reason_ to reject timestamps from the seventies. Why
would we care about a specific date? In contrast, negative timestamps
make no sense for absolute timeouts, and they are inherently much less
trustworthy. So it's not about 1970 per se, it's more an issue about
the fundamental representation of time.

In other words, think of negative tv_sec values as a "hmm, I wonder
what the thing is thinking - let's reject it, because I don't want to
guess what the heck is wrong with this guy".

And it's also what we've apparently been doing for a long time, so
changing it had better had some serious reason.

There are certainly cases where negative tv_sec makes sense. Dates on
files, things like that. But why would it make sense to have a
negative tv_sec for an absolute timeout? (Side note: for a _relative_
timeout a negative value makes much more sense: it happens quite
naturally when you end up subtracting two times from each other - but
Ulrich seems to explicitly want negative time for the case where it
makes _less_ sense)

                       Linus
