Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1FHTSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:18:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab1FHTSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:18:18 -0400
Date: Wed, 8 Jun 2011 21:17:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110608191758.GA12457@elte.hu>
References: <20110606155236.GA7374@elte.hu>
 <1307376039.2322.164.camel@twins>
 <20110606160810.GA16636@elte.hu>
 <1307376771.2322.168.camel@twins>
 <20110606161749.GA22157@elte.hu>
 <4DED0292.1040605@die-jansens.de>
 <4DED0423.4050904@die-jansens.de>
 <20110606170725.GD2391@elte.hu>
 <1307380311.2322.223.camel@twins>
 <1307548218.3941.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307548218.3941.6.camel@twins>
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

> I came up with the below hackery, seems to actually boot and such 
> on a lockdep enabled kernel (although Ingo did report lockups with 
> a partial version of the patch, still need to look at that).
> 
> The idea is to use the console_sem.lock instead of the semaphore 
> itself, we flush the console when console_sem.count > 0, which 
> means its uncontended. Its more or less equivalent to 
> down_trylock() + up(), except it never releases the sem internal 
> lock, and optimizes the count fiddling away.
> 
> It doesn't require a wakeup because any real semaphore contention 
> will still be spinning on the spinlock instead of enqueueing itself 
> on the waitlist.
> 
> Its rather ugly, exposes semaphore internals in places it 
> shouldn't, although we could of course expose some primitives for 
> this, but then people might thing it'd be okay to use them etc..
> 
> /me puts on the asbestos underwear

Hm, the no-wakeup aspect seems rather useful.

Could we perhaps remove console_sem and replace it with a mutex and 
do something like this with a mutex and its ->wait_lock?

We'd have two happy side effects:

 - we'd thus remove one of the last core kernel semaphore users
 - we'd gain lockdep coverage for console locking as a bonus ...

Thanks,

	Ingo
