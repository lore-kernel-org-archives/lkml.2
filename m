Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2AaMws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:52:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47762 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab2AaMwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:52:47 -0500
Date: Tue, 31 Jan 2012 13:52:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Andrew Morton <akpm@linux-foundation.org>, arjanvandeven@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: smp: Start up non-boot CPUs asynchronously
Message-ID: <20120131125232.GD4408@elte.hu>
References: <20120130205444.22f5e26a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130205444.22f5e26a@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> >From 3700e391ab2841a9f9241e4e31a6281aa59be5f1 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 30 Jan 2012 20:44:51 -0800
> Subject: [PATCH] smp: Start up non-boot CPUs asynchronously
> 
> The starting of the "not first" CPUs actually takes a lot of 
> boot time of the kernel... upto "minutes" on some of the 
> bigger SGI boxes. Right now, this is a fully sequential 
> operation with the rest of the kernel boot.

Yeah.

> This patch turns this bringup of the other cpus into an 
> asynchronous operation, saving significant kernel boot time 
> (40% on my laptop!!). Basically now CPUs get brought up in 
> parallel to disk enumeration, graphic mode bringup etc etc 
> etc.

Very nice!

> Note that the implementation in this patch still waits for all 
> CPUs to be brought up before starting userspace; I would love 
> to remove that restriction over time (technically that is 
> simple), but that becomes then a change in behavior... I'd 
> like to see more discussion on that being a good idea before I 
> write that patch.

Yeah, it's a good idea to be conservative with that - most of 
the silent assumptions will be on the kernel init side anyway 
and we want to map those out first, without any userspace 
variance mixed in.

I'd expect this patch to eventually break stuff in the kernel - 
we'll fix any kernel bugs that get uncovered, and we can move on 
to make things more parallel once that process has stabilized.

> Second note: We add a small delay between the bring up of 
> cpus, this is needed to actually get a boot time improvement. 
> If we bring up CPUs straight back-to-back, we hog the cpu 
> hotplug lock for write, and that lock is used everywhere 
> during initialization for read. By adding a small delay, we 
> allow those tasks to make progress.

> +void __init async_cpu_up(void *data, async_cookie_t cookie)
> +{
> +	unsigned long nr = (unsigned long) data;
> +	/*
> +	 * we can only up one cpu at a time, due to the hotplug lock;
> +	 * it's better to wait for all earlier CPUs to be done before
> +	 * us so that the bring up order is predictable.
> +	 */
> +	async_synchronize_cookie(cookie);
> +	/*
> +	 * wait a little bit of time between cpus, to allow
> +	 * the kernel boot to not get stuck for a long time
> +	 * on the hotplug lock. We wait longer for the first
> +	 * CPU since many of the early kernel init code is
> +	 * of the hotplug-lock using type.
> +	 */
> +	if (nr < 2)
> +		msleep(100);
> +	else
> +		msleep(5);

Hm, the limits here seem way too ad-hoc and rigid to me.

The bigger worry is that it makes the asynchronity of the boot 
process very timing dependent, 'hiding' a lot of early code on 
faster boxes and only interleaving the execution on slower 
boxes. But slower boxes are harder to debug!

The real fix would be to make the init code depend less on each 
other, i.e. have less hotplug lock dependencies. Or, if it's 
such a hot lock for a good reason, why does spinning on it slow 
down the boot process? It really shouldnt.

So i think this bit is not a good idea. Lets just be fully 
parallel and profile early execution via 'perf kvm' or so and 
figure out where the hotplug lock overhead comes from?

Thanks,

	Ingo
