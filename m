Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1IUIuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:50:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:48164 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1IUIuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:50:52 -0400
Date: Wed, 21 Sep 2011 10:50:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: akpm@google.com
cc: cschan@codeaurora.org, john.stultz@linaro.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] kernel/timer.c: use debugobjects to catch deletion
 of uninitialized timers
In-Reply-To: <201109202114.p8KLErtg011804@hpaq2.eem.corp.google.com>
Message-ID: <alpine.LFD.2.02.1109211028060.2723@ionos>
References: <201109202114.p8KLErtg011804@hpaq2.eem.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christine,

On Tue, 20 Sep 2011, akpm@google.com wrote:

> From: Christine Chan <cschan@codeaurora.org>
> Subject: kernel/timer.c: use debugobjects to catch deletion of uninitialized timers
> 
> del_timer_sync() calls debug_object_assert_init() to assert that a timer
> has been initialized before calling lock_timer_base().  lock_timer_base()
> would spin forever on a NULL(uninit-ed) base.  The check is added to
> del_timer() to prevent silent failure, even though it would not get stuck
> in an infinite loop.

Ok, that makes sense, but the changelog of the debugobjects code wants
a better explanation.
 
> +/*
> + * fixup_assert_init is called when:
> + * - an untracked/uninit-ed object is found
> + */
> +static int timer_fixup_assert_init(void *addr, enum debug_obj_state state)
> +{
> +	struct timer_list *timer = addr;
> +
> +	switch (state) {
> +	case ODEBUG_STATE_NOTAVAILABLE:
> +		if (timer->entry.prev == TIMER_ENTRY_STATIC) {
> +			/*
> +			 * This is not really a fixup. The timer was
> +			 * statically initialized. We just make sure that it
> +			 * is tracked in the object tracker.
> +			 */
> +			debug_object_init(timer, &timer_debug_descr);
> +			return 0;
> +		} else {
> +			WARN_ON(1);
> +			init_timer(timer);
> +			return 1;

Can we please remove the WARN_ON() and use the return value in the
debugobjects code? That needs a variant of debug_print_object() to give us
proper state output.

Also the fixup function should check for timer->function == NULL and
set a default stub callback.

Thinking more about that, we should do the same for the
timer_fixup_activate() case.

Can you have a stab at that, please?

Thanks,

	tglx
