Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1FFQIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:08:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33438 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab1FFQI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:08:29 -0400
Date: Mon, 6 Jun 2011 18:08:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606160810.GA16636@elte.hu>
References: <4DEB8A93.30601@die-jansens.de>
 <20110605141003.GB29338@elte.hu>
 <4DEB933C.1070900@die-jansens.de>
 <20110605151323.GA30590@elte.hu>
 <1307349530.2353.7374.camel@twins>
 <20110606145827.GD30348@elte.hu>
 <1307372989.2322.136.camel@twins>
 <1307375227.2322.161.camel@twins>
 <20110606155236.GA7374@elte.hu>
 <1307376039.2322.164.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307376039.2322.164.camel@twins>
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

> On Mon, 2011-06-06 at 17:52 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Needs more staring at, preferably by someone who actually 
> > > understands that horrid mess :/ Also, this all still doesn't make 
> > > printk() work reliably while holding rq->lock.
> > 
> > So, what about my suggestion to just *remove* the wakeup from there 
> > and use the deferred wakeup mechanism that klogd uses.
> > 
> > That would make printk() *visibly* more robust in practice.
> 
> That's currently done from the jiffy tick, do you want to effectively
> delay releasing the console_sem for the better part of a jiffy?

Yes, and we already do it in some other circumstances. Can you see 
any problem with that? klogd is an utter slowpath anyway.

> > [ It would also open up the way to possibly make printk() NMI entry 
> >   safe - currently we lock up if we printk in an NMI or #MC context 
> >   that happens to nest inside a printk(). ]
> 
> Well, for that to happen you also need to deal with logbuf_lock 
> nesting. [...]

That we could do as a robustness patch: detect when the current CPU 
already holds it and do not lock up on that. This would also allow 
printk() to work within a crashing printk(). (assuming the second 
printk() does not crash - in which case it's game over anyway)

> Personally I think using printk() from NMI context is quite beyond 
> sane.

Yeah, quite so, but it *can* happen so if we can make it work as a 
free side-effect of a printk()-robustness increasing patch, why not?

Thanks,

	Ingo
