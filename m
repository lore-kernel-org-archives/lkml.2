Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0ENPQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 11:16:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab0ENPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 11:16:50 -0400
Date: Fri, 14 May 2010 08:13:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 00/10] V2: rwsem changes + down_read_unfair() proposal
In-Reply-To: <1273840782-5920-1-git-send-email-walken@google.com>
Message-ID: <alpine.LFD.2.00.1005140757301.3711@i5.linux-foundation.org>
References: <1273840782-5920-1-git-send-email-walken@google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 May 2010, Michel Lespinasse wrote:
>
> I would like to sollicit comments regarding the following changes
> against 2.6.34-rc7 + 91af708 (from V1 proposal) already applied.
> 
> The motivation for this change was some cluster monitoring software we
> use at google

Quite frankly, I hate it the way it reads now.

I think "down_read_unfair()" is a really dangerous model, and the reason I 
say that is we used to have _all_ mutexes work that way, and it was a 
disaster from a unfairness perspective.

HOWEVER.

I do see where you are coming from, and I do think that unfair readers are 
likely to be ok AS LONG AS THEY CANNOT BLOCK.

And I think that _that_ is likely the much more important issue than the 
unfairness. IOW, I suspect that I would personally at least be perfectly 
ok with something like this, with the following fairly trivial changes:

 - Make it actually do a "preempt_disable()" _after_ getting the rwsem, so 
   that we get a warning if something tries to sleep inside the region 
   (see the whole "__might_sleep()" thing).

   This also implies that you need a separate unlock routine to pair with 
   it, that undoes that. So you can't unlock it with a regular "up_read()"

 - rename the thing to be about the fact that you promise that the code 
   that runs under the thing is nonblocking. IOW, rather than talk about 
   "unfair", you talk about "nonpreemptible" or "critical" or something.

   So you'd have something like

	down_read_critical();
	.. atomic region with no allocation, no preemption ..
	up_read_critical();

   ratehr than talk about "unfairness".

So it would have "spinlock" semantics when held (the taking of the lock 
itself can obviously block - but you couldn't block while _holding_ the 
lock).

In fact, for the generic lib/rwsem-spinlock.c version, it's quite possible 
you should just _hold_ the spinlock over the critical region. That would 
potentially speed up the locking quite a lot.

The reason I think the above would be acceptable is exactly because it 
consciously _limits_ that unfair spinlock to only ever work in cases where 
a certain amount of unfairness would be ok.

IOW, you can't just use the unfair version in random places that you think 
are "more important" and are worthy of unfairness. They have to be places 
where you can guarantee that you release the lock with no delay. And we'd 
disable preemption not just to get the warning, but also to make sure that 
"timely release" really happens.

			Linus
