Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab2HHSKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:10:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35859 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab2HHSKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:10:41 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org
Subject: 
Date: Wed,  8 Aug 2012 11:10:24 -0700
Message-Id: <1344449428-24962-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timer internals are protected by irqsafe lock but the lock is
naturally dropped and irq enabled while a timer is executed.  This
makes dequeueing timer for execution and the actual execution
non-atomic against IRQs.  No matter what the timer function does, IRQs
can occur between timer dispatch and execution.  This means that an
IRQ handler could interrupt any timer in progress and it's impossible
for an IRQ handler to cancel and drain a timer.

This restriction manifests as ugly convolutions in workqueue
delayed_work interface.  A !idle delayed_work is either on timer,
being transferred from timer to worklist, on worklist, or executing.
There are interfaces which need to cancel a pending delayed_work -
cancel_delayed_work() and friends and mod_delayed_work().  They want
to cancel a work item in the first three states but it's impossible to
drain the second state from IRQ handlers which lead to the following
oddities.

* mod_delayed_work() can't be used from IRQ handlers.

* __cancel_delayed_work() can't use the usual try_to_grab_pending()
  which handles all three states but instead only deals with the first
  state using a separate implementation.  There's no way to make a
  delayed_work not pending from IRQ handlers.

* The context / behavior differences among cancel_delayed_work(),
  __cancel_delayed_work(), cancel_delayed_work_sync() are subtle and
  confusing (the first two are mostly historical tho).

This patchset implements irqsafe timers.  For an irqsafe timer, IRQ is
not enabled from dispatch till the end of its execution making it safe
to drain the timer regardless of context.  This will enable cleaning
up delayed_work interface.

This patchset contains the following four patches.

 0001-timer-generalize-timer-base-flags-handling.patch
 0002-timer-relocate-declarations-of-init_timer_on_stack_k.patch
 0003-timer-clean-up-timer-initializers.patch
 0004-timer-implement-TIMER_IRQSAFE.patch

0001 generalizes timer->base flags handling so that TIMER_IRQSAFE can
be added easily.

0002-0003 clean up initializers so that adding TIMER_IRQSAFE doesn't
need to duplicate init code multiple times.

0004 implements TIMER_IRQSAFE.

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-timer-irqsafe

Will soon post workqueue patchset which makes use of this.  If this
goes in, it would be great if this either goes through wq/for-3.7 or
gets its own branch somewhere so that it can be pulled into
wq/for-3.7.

Thanks.

 include/linux/timer.h |  161 ++++++++++++++++++--------------------------------
 kernel/timer.c        |  108 +++++++++++++++------------------
 2 files changed, 110 insertions(+), 159 deletions(-)

--
tejun
