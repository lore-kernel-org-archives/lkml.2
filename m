Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab1FETAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:00:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40103 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551Ab1FETAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:00:11 -0400
Date: Sun, 5 Jun 2011 20:59:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110605185957.GA3452@elte.hu>
References: <20110605141003.GB29338@elte.hu>
 <4DEB933C.1070900@die-jansens.de>
 <20110605151323.GA30590@elte.hu>
 <20110605152641.GA31124@elte.hu>
 <20110605153218.GA31471@elte.hu>
 <4DEBA9CC.4090503@die-jansens.de>
 <4DEBB05C.8090506@die-jansens.de>
 <4DEBB3DA.8060001@die-jansens.de>
 <20110605172052.GA1036@elte.hu>
 <4DEBBFF9.2030101@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEBBFF9.2030101@die-jansens.de>
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


* Arne Jansen <lists@die-jansens.de> wrote:

> > hm, it's hard to interpret that without the spin_lock()/unlock() 
> > logic keeping the dumps apart.
> 
> The locking was in place from the beginning. [...]

Ok, i was surprised it looked relatively ordered :-)

> [...] As the output is still scrambled, there are other sources for 
> BUG/WARN outside the watchdog that trigger in parallel. Maybe we 
> should protect the whole BUG/WARN mechanism with a lock and send it 
> to early_printk from the beginning, so we don't have to wait for 
> the watchdog to kill printk off and the first BUG can come through. 
> Or just let WARN/BUG kill off printk instead of the watchdog 
> (though I have to get rid of that syslog-WARN on startup).

I had yet another look at your lockup.txt and i think the main cause 
is the WARN_ON() caused by the not-held pi_lock. The lockup there 
causes other CPUs to wedge in printk, which triggers spinlock-lockup 
messages there.

So i think the primary trigger is the pi_lock WARN_ON() (as your 
bisection has confirmed that too), everything else comes from this.

Unfortunately i don't think we can really 'fix' the problem by 
removing the assert. By all means the assert is correct: pi_lock 
should be held there. If we are not holding it then we likely won't 
crash in an easily visible way - it's a lot easier to trigger asserts 
than to trigger obscure side-effects of locking bugs.

It is also a mystery why only printk() triggers this bug. The wakeup 
done there is not particularly special, so by all means we should 
have seen similar lockups elsewhere as well - not just with 
printk()s. Yet we are not seeing them.

So some essential piece of the puzzle is still missing.

Thanks,

	Ingo
