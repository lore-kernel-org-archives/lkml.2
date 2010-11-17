Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab0KQBcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:32:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab0KQBcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:32:08 -0500
Date: Tue, 16 Nov 2010 20:31:48 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101117013148.GA22651@bombadil.infradead.org>
References: <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
 <1289778189.5154.10.camel@maggy.simson.net>
 <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
 <1289783580.495.58.camel@maggy.simson.net>
 <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net>
 <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com>
 <1289856350.14719.135.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289856350.14719.135.camel@maggy.simson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Mon, Nov 15, 2010 at 02:25:50PM -0700, Mike Galbraith wrote:
> --- linux-2.6.orig/drivers/tty/tty_io.c
> +++ linux-2.6/drivers/tty/tty_io.c
> @@ -3160,6 +3160,7 @@ static void __proc_set_tty(struct task_s
>  	put_pid(tsk->signal->tty_old_pgrp);
>  	tsk->signal->tty = tty_kref_get(tty);
>  	tsk->signal->tty_old_pgrp = NULL;
> +	sched_autogroup_create_attach(tsk);
>  }
>  

This is a bit of a problem, as it's called in_atomic context and kmalloc's
under GFP_KERNEL (which can sleep.) This results in sleep-under-spinlock
prints when CONFIG_DEBUG_SPINLOCK_SLEEP=y.

I spent a bit of time thinking about how to fix that, but it's a bit
difficult because of the nested spin_lock_irq in that bit of the
tty_ioctl callchain.

I'll think about it some more tonight and follow-up if I can think of a
way to fix it.

regards, Kyle
