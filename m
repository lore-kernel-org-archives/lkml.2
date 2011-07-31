Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1GaBoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 21:44:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015Ab1GaBof convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 21:44:35 -0400
MIME-Version: 1.0
In-Reply-To: <4E34B095.100@zytor.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
 <1311971867-25124-2-git-send-email-hpa@linux.intel.com> <CA+55aFz07ewwkBHeqj_VqAiNCBzDj8uzA0xzt2fc4qrYB9O19g@mail.gmail.com>
 <4E34B095.100@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jul 2011 15:43:42 -1000
Message-ID: <CA+55aFy5iRjCigmK-eddkP8Wqy_qFDZRd6PV5d0XFE3p8ws1Bg@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 3:32 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> The only minor issue with this is that RDRAND can, at least in theory,
> return a failure condition transiently ("the entropy buffer is empty")
> or permanently ("the random number generator is broken.")  Although we
> have never actually observed the former under anything approaching
> realistic conditions, the recommendation is to loop for 10 iterations.

So I don't care too deeply, we could easily make the
"alternative_io()" thing just do a "call" to an out-of-line thing
instead.

That said, I seriously suggest that we shouldn't even care.

Why?

Because the high-level code needs to handle the failure case *anyway*,
so if there is some "in theory, CF might be clear and we don't get any
data" under certain odd an unusual circumstances, I think we might as
well just opt out for braking out early. So I don't think we really
should necessarily at all do the intel-recommended "loop at least ten
times", because quite frankly, we're probably better off just falling
back to our old sw fallback anyway.

So at this point, I'd much rather go for "really simple,
straightforward and small" than anything else.

> What makes that more than a bit ugly is that extract_entropy() and
> extract_entropy_user() take their randomness type ("perfect/blocking"
> versus "PRNG degrade OK/nonblocking") from a pointer to the pool, which
> means that some kind of indirection or policy information is going to be
> necessary there anyway, in order to enable get_random_bytes() and its
> friends -- as opposed to get_random_int().

Why?

WHY SHOULD WE CARE?

Nobody is ever going to complain about being better than necessary,
and the whole point of rdrand should be that it's (a) fast enough and
(b) good enough that the whole "blocking/degraded" thing is a total
nonissue.

In other words, we should consider rdrand to be "perfect +
nonblocking", which is acceptable to everybody. Those nonblocking
users aren't going to complain about good randomness, even if they
might *accept* less than perfect randomness.

IOW, I really want to aim for simple and straightforward. Don't make
it more complicated than it is.

Aim to make my patch *smaller* rather than trying to find ways to make
it bigger.

             Linus
