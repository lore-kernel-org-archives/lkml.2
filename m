Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1BHOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:16:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab1BHOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:16:56 -0500
Subject: Re: lockdep: possible reason: unannotated irqs-off. (was: Re:
 Linux 2.6.38-rc4)
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1297172906.13327.104.camel@laptop>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	 <20110208101730.GB7020@liondog.tnic> <1297161712.13327.100.camel@laptop>
	 <20110208121108.GA4824@zhy>  <20110208133457.GA5813@zhy>
	 <1297172906.13327.104.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 15:18:00 +0100
Message-ID: <1297174680.13327.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 14:48 +0100, Peter Zijlstra wrote:
> 
> Well that and modifying softirq bits for a lockdep annotation really
> feels wrong. 

How about we revert it for this release and try again later?

---
Subject: lockdep, timer: Revert the del_timer_sync() annotation

Both attempts at trying to allow softirq usage failed, revert for this
release and try again later.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/timer.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 343ff27..c848cd8 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -959,7 +959,7 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
  * otherwise this function is meaningless. It must not be called from
- * hardirq contexts. The caller must not hold locks which would prevent
+ * interrupt contexts. The caller must not hold locks which would prevent
  * completion of the timer's handler. The timer's handler must not call
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
@@ -971,12 +971,10 @@ int del_timer_sync(struct timer_list *timer)
 #ifdef CONFIG_LOCKDEP
 	unsigned long flags;
 
-	raw_local_irq_save(flags);
-	local_bh_disable();
+	local_irq_save(flags);
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
-	_local_bh_enable();
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 #endif
 	/*
 	 * don't use it in hardirq context, because it


