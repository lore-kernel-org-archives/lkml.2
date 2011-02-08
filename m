Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1BHKkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:40:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:41639 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1BHKkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:40:46 -0500
Subject: Re: lockdep: possible reason: unannotated irqs-off. (was: Re:
 Linux 2.6.38-rc4)
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, tglx <tglx@linutronix.de>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <20110208101730.GB7020@liondog.tnic>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	 <20110208101730.GB7020@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 11:41:52 +0100
Message-ID: <1297161712.13327.100.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 11:17 +0100, Borislav Petkov wrote:
> 
> So, I'm getting the warning below early in the boot process. And yes, I
> didn't have it on -rc3. 2.6.38-rc4-00001-g1e554e3-dirty means a debug
> diff ontop of -rc4 which shouldn't have anything to do with this splat
> since all it does is a couple of printk's due to -rc3 not suspending to
> disk properly in some cases.
> 
> Now, I'm not going to even pretend to understand the code but here's
> what I can read out, you tell me whether it makes sense.
> 
> spawn_ksoftirqd() is one of the early initcalls that gets called and
> it's notifier callback does kthread_bind() and you can follow in the
> backtrace below that this thing comes down to del_timer_sync() which
> does the lockdep annotation. Now, problem as I see it, is that hardirqs
> were disabled when we were called although it doesn't say so in the
> irqtrace events dump after the calltrace: "hardirqs last enabled at
> (999)" and our irq event stamp is 1000.
> 
> There are actually at least three del_timer_sync()'s inflight so the
> problem could be there somewhere, I dunno.
> 
> So, is it a wrong lockdep annotation or is it a real problem? I've
> attached dmesg and config.

Argh! Its an annotation nightmare that.. it didn't trigger for me when
running that because I didn't have DEBUG_LOCKDEP=y.

OK, let me try and come up with another way to annotate this
del_timer_sync() muck, the trouble is we want that lock to be called
with BH disabled, but simply doing local_bh_disable()/local_bh_enable()
has the nasty side effect of calling __do_softirq(). Faking IRQ state
will trip this check_flags() debug muck..

We used to have local_irq_disable()/local_irq_enable() around it, but
then people wanted to use del_timer_sync() from softirq context..



