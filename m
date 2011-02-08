Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1BHMOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:14:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56058 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab1BHMOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XpQkVN59y65+50qDAEX/vqBhF8UgI/SJGaI7xFyA6Bv9lwrP9c4TFm45RYVSRuReux
         +YwYEPliZAIuWCZ9Z0WAOceYUcx/5DcPjv5otn2goVJWbXQh2c04v1eTBm0ThWwBBxW/
         oa9SqLkb3UET4UdTKJz3z6v0B4Gj2xG75+154=
Date: Tue, 8 Feb 2011 20:14:10 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] timer: use local_bh_enable_force_wake() in
 del_timer_sync()
Message-ID: <20110208121410.GB4824@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <20110208101730.GB7020@liondog.tnic>
 <1297161712.13327.100.camel@laptop>
 <20110208121108.GA4824@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110208121108.GA4824@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 2/2] timer: use local_bh_enable_force_wake() in del_timer_sync()

raw_local_irq_save()/raw_local_irq_restore() is also not suitable
here because lockdep will report "possible reason: unannotated irqs-off"

To cure this issue, use local_bh_enable_force_wake() here in case of
we have pending softirq left during this time.

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/timer.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index d53ce66..1654dc1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -969,14 +969,10 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
 int del_timer_sync(struct timer_list *timer)
 {
 #ifdef CONFIG_LOCKDEP
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
 	local_bh_disable();
 	lock_map_acquire(&timer->lockdep_map);
 	lock_map_release(&timer->lockdep_map);
-	_local_bh_enable();
-	raw_local_irq_restore(flags);
+	local_bh_enable_force_wake();
 #endif
 	/*
 	 * don't use it in hardirq context, because it
-- 
1.7.1
