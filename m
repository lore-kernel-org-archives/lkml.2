Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab1FFQSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:18:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab1FFQSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:18:04 -0400
Date: Mon, 6 Jun 2011 18:17:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606161749.GA22157@elte.hu>
References: <4DEB933C.1070900@die-jansens.de>
 <20110605151323.GA30590@elte.hu>
 <1307349530.2353.7374.camel@twins>
 <20110606145827.GD30348@elte.hu>
 <1307372989.2322.136.camel@twins>
 <1307375227.2322.161.camel@twins>
 <20110606155236.GA7374@elte.hu>
 <1307376039.2322.164.camel@twins>
 <20110606160810.GA16636@elte.hu>
 <1307376771.2322.168.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307376771.2322.168.camel@twins>
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

> On Mon, 2011-06-06 at 18:08 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Mon, 2011-06-06 at 17:52 +0200, Ingo Molnar wrote:
> > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > 
> > > > > Needs more staring at, preferably by someone who actually 
> > > > > understands that horrid mess :/ Also, this all still doesn't make 
> > > > > printk() work reliably while holding rq->lock.
> > > > 
> > > > So, what about my suggestion to just *remove* the wakeup from there 
> > > > and use the deferred wakeup mechanism that klogd uses.
> > > > 
> > > > That would make printk() *visibly* more robust in practice.
> > > 
> > > That's currently done from the jiffy tick, do you want to effectively
> > > delay releasing the console_sem for the better part of a jiffy?
> > 
> > Yes, and we already do it in some other circumstances. 
> 
> We do?

Yes, see the whole printk_pending logic, it delays:

                wake_up_interruptible(&log_wait);

to the next jiffies tick.

> > Can you see 
> > any problem with that? klogd is an utter slowpath anyway.
> 
> but console_sem isn't klogd. We delay klogd and that's perfectly 
> fine, but afaict we don't delay console_sem.

But console_sem is really a similar special case as klogd. See, it's 
about a *printk*. That's rare by definition.

If someone on the console sees it he'll be startled by at least 10 
msecs ;-) So delaying the wakeup to the next jiffy really fits into 
the same approach as we already do with &log_wait, hm?

This would solve a real nightmare that has plagued us ever since 
printk() has done wakeups directly - i.e. like forever.

Thanks,

	Ingo
