Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2HUT1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:27:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47554 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2HUT04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:26:56 -0400
Date: Tue, 21 Aug 2012 12:26:51 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Subject: Re: [tip:timers/core] timer: Implement TIMER_IRQSAFE
Message-ID: <20120821192651.GA7701@google.com>
References: <1344449428-24962-5-git-send-email-tj@kernel.org>
 <tip-c5f66e99b7cb091e3d51ae8e8156892e8feb7fa3@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-c5f66e99b7cb091e3d51ae8e8156892e8feb7fa3@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 09:43:07AM -0700, tip-bot for Tejun Heo wrote:
> Commit-ID:  c5f66e99b7cb091e3d51ae8e8156892e8feb7fa3
> Gitweb:     http://git.kernel.org/tip/c5f66e99b7cb091e3d51ae8e8156892e8feb7fa3
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Wed, 8 Aug 2012 11:10:28 -0700
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 21 Aug 2012 16:28:31 +0200
> 
> timer: Implement TIMER_IRQSAFE
> 
> Timer internals are protected with irq-safe locks but timer execution
> isn't, so a timer being dequeued for execution and its execution
> aren't atomic against IRQs.  This makes it impossible to wait for its
> completion from IRQ handlers and difficult to shoot down a timer from
> IRQ handlers.
> 
> This issue caused some issues for delayed_work interface.  Because
> there's no way to reliably shoot down delayed_work->timer from IRQ
> handlers, __cancel_delayed_work() can't share the logic to steal the
> target delayed_work with cancel_delayed_work_sync(), and can only
> steal delayed_works which are on queued on timer.  Similarly, the
> pending mod_delayed_work() can't be used from IRQ handlers.
> 
> This patch adds a new timer flag TIMER_IRQSAFE, which makes the timer
> to be executed without enabling IRQ after dequeueing such that its
> dequeueing and execution are atomic against IRQ handlers.
> 
> This makes it safe to wait for the timer's completion from IRQ
> handlers, for example, using del_timer_sync().  It can never be
> executing on the local CPU and if executing on other CPUs it won't be
> interrupted until done.
> 
> This will enable simplifying delayed_work cancel/mod interface.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: torvalds@linux-foundation.org
> Cc: peterz@infradead.org
> Link: http://lkml.kernel.org/r/1344449428-24962-5-git-send-email-tj@kernel.org
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Will pull into wq/for-3.7 and put delay_work changes on top.  If
there's any objection, please scream.

Thanks a lot.

-- 
tejun
