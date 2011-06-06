Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab1FFPE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:04:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37127 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab1FFPE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:04:27 -0400
Date: Mon, 6 Jun 2011 17:04:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606150409.GE30348@elte.hu>
References: <4DEBA9CC.4090503@die-jansens.de>
 <4DEBB05C.8090506@die-jansens.de>
 <4DEBB3DA.8060001@die-jansens.de>
 <20110605172052.GA1036@elte.hu>
 <4DEBBFF9.2030101@die-jansens.de>
 <20110605185957.GA3452@elte.hu>
 <4DEBD95B.6030901@die-jansens.de>
 <20110605194419.GA12965@elte.hu>
 <4DEBE3DF.70104@die-jansens.de>
 <1307350909.2353.7408.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307350909.2353.7408.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2011-06-05 at 22:15 +0200, Arne Jansen wrote:
> > 
> > Can lockdep just get confused by the lockdep_off/on calls in printk
> > while scheduling is allowed? There aren't many users of lockdep_off().
> 
> Yes!, in that case lock_is_held() returns false, triggering the warning.
> I guess there's an argument to be made in favour of the below..
> 
> ---
>  kernel/lockdep.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 53a6895..e4129cf 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3242,7 +3242,7 @@ int lock_is_held(struct lockdep_map *lock)
>  	int ret = 0;
>  
>  	if (unlikely(current->lockdep_recursion))
> -		return ret;
> +		return 1; /* avoid false negative lockdep_assert_held */
>  
>  	raw_local_irq_save(flags);
>  	check_flags(flags);

Oh, this explains the full bug i think.

lockdep_off() causes us to not track pi_lock, and thus the assert 
inside printk() called try_to_wake_up() triggers incorrectly.

The reason why Arne triggered it is probably because console_lock 
*wakeups* from printk are very, very rare: almost nothing actually 
locks the console. His remote system probably has some VT-intense 
application (screen?) that hits console_lock more intensely.

Arne, do you use some vt-intense application there?

The real fix might be to remove the lockdep_off()/on() call from 
printk(), that looks actively evil ... we had to hack through several 
layers of side-effects before we found the real bug - so it's not 
like the off()/on() made things more robust!

So i think what we want to apply is the lockdep_off()/on() removal, 
once Arne has it tested.

Thanks,

	Ingo
