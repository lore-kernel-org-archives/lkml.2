Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0EQV2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:28:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:3572 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0EQV2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:28:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=TDvVtVEsrL58m4wSpUmzreQZlOVGpobKBiVhPkYuizJ2gcv7kWZXX3lLBCYdcIM+P
	AXr1cv3FkOWzplo2NGqvg==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005140757301.3711@i5.linux-foundation.org>
References: <1273840782-5920-1-git-send-email-walken@google.com>
	 <alpine.LFD.2.00.1005140757301.3711@i5.linux-foundation.org>
Date: Mon, 17 May 2010 14:28:38 -0700
Message-ID: <AANLkTindoY94Y2kcnqC2x_1kvGN2y8Oaf2APBD0AUKTa@mail.gmail.com>
Subject: Re: [PATCH 00/10] V2: rwsem changes + down_read_unfair() proposal
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 8:13 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I think "down_read_unfair()" is a really dangerous model, and the reason I
> say that is we used to have _all_ mutexes work that way, and it was a
> disaster from a unfairness perspective.
>
> HOWEVER.
>
> I do see where you are coming from, and I do think that unfair readers are
> likely to be ok AS LONG AS THEY CANNOT BLOCK.

Thanks for your comments. Seems reasonable to me - and as you pointed
out, not very difficult to implement either.

> And I think that _that_ is likely the much more important issue than the
> unfairness. IOW, I suspect that I would personally at least be perfectly
> ok with something like this, with the following fairly trivial changes:
>
>  - Make it actually do a "preempt_disable()" _after_ getting the rwsem, so
>   that we get a warning if something tries to sleep inside the region
>   (see the whole "__might_sleep()" thing).
>
>   This also implies that you need a separate unlock routine to pair with
>   it, that undoes that. So you can't unlock it with a regular "up_read()"

Done in V3 (will send out shortly).

>  - rename the thing to be about the fact that you promise that the code
>   that runs under the thing is nonblocking. IOW, rather than talk about
>   "unfair", you talk about "nonpreemptible" or "critical" or something.
>
>   So you'd have something like
>
>        down_read_critical();
>        .. atomic region with no allocation, no preemption ..
>        up_read_critical();
>
>   rather than talk about "unfairness".

Changed the high level API to work that way. I did not change
__down_read_unfair though, because at that low level it's still about
unfairness - the tying with non-preemptible is done higher up. (I had
actually started changing it to __down_read_critical, but then I
realized that there was no __up_read_critical to pair it with).

> So it would have "spinlock" semantics when held (the taking of the lock
> itself can obviously block - but you couldn't block while _holding_ the
> lock).
>
> In fact, for the generic lib/rwsem-spinlock.c version, it's quite possible
> you should just _hold_ the spinlock over the critical region. That would
> potentially speed up the locking quite a lot.

I did not pursue that one - one issue would have been that I would
have to expose the spin_lock_irqsave flags to the down_read_critical
caller. It can be done but I'm not sure it makes sense given that the
non-generic implementation wouldn't use them.

> The reason I think the above would be acceptable is exactly because it
> consciously _limits_ that unfair spinlock to only ever work in cases where
> a certain amount of unfairness would be ok.
>
> IOW, you can't just use the unfair version in random places that you think
> are "more important" and are worthy of unfairness. They have to be places
> where you can guarantee that you release the lock with no delay. And we'd
> disable preemption not just to get the warning, but also to make sure that
> "timely release" really happens.

I like the strategic thinking here :)

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
