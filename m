Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1FFRMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:12:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1FFRMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:12:08 -0400
Date: Mon, 6 Jun 2011 19:11:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606171153.GE2391@elte.hu>
References: <1307349530.2353.7374.camel@twins>
 <20110606145827.GD30348@elte.hu>
 <1307372989.2322.136.camel@twins>
 <1307375227.2322.161.camel@twins>
 <20110606155236.GA7374@elte.hu>
 <1307376039.2322.164.camel@twins>
 <20110606160810.GA16636@elte.hu>
 <1307376771.2322.168.camel@twins>
 <20110606161749.GA22157@elte.hu>
 <1307378649.2322.198.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307378649.2322.198.camel@twins>
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

> > > but console_sem isn't klogd. We delay klogd and that's 
> > > perfectly fine, but afaict we don't delay console_sem.
> > 
> > But console_sem is really a similar special case as klogd. See, 
> > it's about a *printk*. That's rare by definition.
> 
> But its not rare, its _the_ lock that serialized the whole console 
> layer. Pretty much everything a console does goes through that 
> lock.

Please. Think.

If console_sem was so frequently held then why on earth were you 
*unable* to trigger the lockup with an artificial printk() storm and 
why on earth has almost no-one else but Arne triggered it? :-)

This bug is the very proof that console_sem is seldom contended!

> Ahh, what we could do is something like the below and delay both 
> the acquire and release of the console_sem.

Yeah!

> +void printk_tick(void)
> +{
> +	if (!__this_cpu_read(printk_pending))
> +		return;
> +
> +	/*
> +	 * Try to acquire and then immediately release the
> +	 * console semaphore. The release will do all the
> +	 * actual magic (print out buffers, wake up klogd,
> +	 * etc). 
> +	 */
> +	if (console_trylock_for_printk(smp_processor_id())) {
> +		console_unlock();
> +		__this_cpu_write(printk_pending, 0);
> +	}
> +}

Arne does this fix the hang you are seeing?

Now, we probably don't want to do this in 3.0, just to give time for 
interactions to found and complaints to be worded. So we could do the 
minimal fix first and queue up the bigger change for 3.1.

Hm?

Thanks,

	Ingo
