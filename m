Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab1FFSHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:07:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53691 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab1FFSHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:07:50 -0400
Date: Mon, 6 Jun 2011 20:07:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
Message-ID: <20110606180733.GA20123@elte.hu>
References: <1307372989.2322.136.camel@twins>
 <1307375227.2322.161.camel@twins>
 <20110606155236.GA7374@elte.hu>
 <1307376039.2322.164.camel@twins>
 <20110606160810.GA16636@elte.hu>
 <1307376771.2322.168.camel@twins>
 <20110606161749.GA22157@elte.hu>
 <1307378649.2322.198.camel@twins>
 <20110606171153.GE2391@elte.hu>
 <4DED1519.2020803@die-jansens.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED1519.2020803@die-jansens.de>
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

> On 06.06.2011 19:11, Ingo Molnar wrote:
> >
> >* Peter Zijlstra<peterz@infradead.org>  wrote:
> 
> >
> >>+void printk_tick(void)
> >>+{
> >>+	if (!__this_cpu_read(printk_pending))
> >>+		return;
> >>+
> >>+	/*
> >>+	 * Try to acquire and then immediately release the
> >>+	 * console semaphore. The release will do all the
> >>+	 * actual magic (print out buffers, wake up klogd,
> >>+	 * etc).
> >>+	 */
> >>+	if (console_trylock_for_printk(smp_processor_id())) {
> >>+		console_unlock();
> >>+		__this_cpu_write(printk_pending, 0);
> >>+	}
> >>+}
> >
> >Arne does this fix the hang you are seeing?
> 
> What do you want me to test? just replace printk_tick with the 
> above version? If I do that, the machine doesn't even boot up any 
> more.

Yeah.

So i think we want two patches:

 - The first one that minimally removes the lockdep_off()/on() dance 
   and fixes the regression: the patch that i sent earlier today.
   I *think* that should fix the crash.

   3.0 material.

 - The second one that moves console_sem wakeups to the jiffies tick. 
   It does not push the acquiring and the console->write() calls to
   jiffies context, only delays the wakeup.

   3.1 material.

Thanks,

	Ingo
