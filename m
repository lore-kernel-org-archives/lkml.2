Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1BCRQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:16:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:51775 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab1BCRQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:16:07 -0500
Subject: Re: [RFC][PATCH 14/18] sched: Remove rq->lock from the first half
 of ttwu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: frank.rowand@am.sony.com
Cc: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D4367CA.2030303@am.sony.com>
References: <20110104145929.772813816@chello.nl>
	 <20110104150103.012710349@chello.nl>  <4D4367CA.2030303@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Feb 2011 18:16:51 +0100
Message-ID: <1296753411.26581.464.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 17:05 -0800, Frank Rowand wrote:
> 
> The deadlock can occur if __ARCH_WANT_UNLOCKED_CTXSW and
> __ARCH_WANT_INTERRUPTS_ON_CTXSW are defined.
> 
> A task sets p->state = TASK_UNINTERRUPTIBLE, then calls schedule().
> 
> schedule()
>    prev->on_rq = 0
>    context_switch()
>       prepare_task_switch()
>          prepare_lock_switch()
>             raw_spin_unlock_irq(&rq->lock)
> 
> At this point, a pending interrupt (on this same cpu) is handled.
> The interrupt handling results in a call to try_to_wake_up() on the
> current process.  The try_to_wake_up() gets into:
> 
>    while (p->on_cpu)
>       cpu_relax();
> 
> and spins forever.  This is because "prev->on_cpu = 0" slightly
> after this point at:
> 
>    finish_task_switch()
>       finish_lock_switch()
>          prev->on_cpu = 0

Right, very good spot!

> 
> One possible fix would be to get rid of __ARCH_WANT_INTERRUPTS_ON_CTXSW.
> I don't suspect the reaction to that suggestion will be very positive...

:-), afaik some architectures requires this, ie. removing this would
require dropping whole architectures.

> Another fix might be:
> 
>    while (p->on_cpu) {
>       if (p == current)
>          goto out_activate;
>       cpu_relax();
>       }
> 
>    Then add back in the out_activate label.
> 
> I don't know if the second fix is good -- I haven't thought out how
> it impacts the later patches in the series.

Right, I've done something similar to this, simply short-circuit the cpu
selection to force it to activate the task on the local cpu.
