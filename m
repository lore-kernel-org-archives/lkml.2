Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1DGRVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:21:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755928Ab1DGRVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:21:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110407164245.GA21838@one.firstfloor.org>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
 <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com> <20110407164245.GA21838@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Apr 2011 10:20:31 -0700
Message-ID: <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com>
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 9:42 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> I'm sure a single barrier would have fixed the testers, as you point out,
> but the goal wasn't to only fix testers.

You missed two points:

 - first off, do we have any reason to believe that the rdtsc would
migrate down _anyway_? As AndyL says, both Intel and AMD seem to
document only the "[lm]fence + rdtsc" thing with a single fence
instruction before.

  Instruction scheduling isn't some kind of theoretical game. It's a
very practical issue, and CPU schedulers are constrained to do a good
job quickly and _effectively_. In other words, instructions don't just
schedule randomly. In the presense of the barrier, is there any reason
to believe that the rdtsc would really schedule oddly? There is never
any reason to _delay_ an rdtsc (it can take no cache misses or wait on
any other resources), so when it is not able to move up, where would
it move?

IOW, it's all about "practical vs theoretical". Sure, in theory the
rdtsc could move down arbitrarily. In _practice_, the caller is going
to use the result (and if it doesn't, the value doesn't matter), and
thus the CPU will have data dependencies etc that constrain
scheduling. But more practically, there's no reason to delay
scheduling, because an rdtsc isn't going to be waiting for any
interesting resources, and it's also not going to be holding up any
more important resources (iow, sure, you'd like to schedule subsequent
loads early, but those won't be fighting over the same resource with
the rdtsc anyway, so I don't see any reason that would delay the rdtsc
and move it down).

So I suspect that one lfence (before) is basically the _same_ as the
current two lfences (around). Now, I can't guarantee it, but in the
absense of numbers to the contrary, there really isn't much reason to
believe otherwise. Especially considering the Intel/AMD
_documentation_. So we should at least try it, I think.

 - the reason "back-to-back" (with the extreme example being in a
tight loop) matters is that if something isn't in a tight loop, any
jitter we see in the time counting wouldn't be visible anyway. One
random timestamp is meaningless on its own. It's only when you have
multiple ones that you can compare them. No?

So _before_ we try some really clever data dependency trick with new
inline asm and magic "double shifts to create a zero" things, I really
would suggest just trying to remove the second lfence entirely and see
how that works. Maybe it doesn't work, but ...

                              Linus
