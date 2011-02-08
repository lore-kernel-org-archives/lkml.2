Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1BHML0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:11:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45585 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1BHMLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:11:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tY+RmA5fdWj1gT5RYwS/InY1OKiDkC88oUhPBiWQfVeYFpFTQKXuABgAzc9dS7128Y
         IxpuTFGCaNZQWwLTFrIApQNgSjM5WxGdGvP0lc4xSM05ClXBeWr2eDVDYzh4arWrV05b
         p5asKmKTvshgiik1+kYqDaESzGaX2HbkbDg34=
Date: Tue, 8 Feb 2011 20:11:09 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep: possible reason: unannotated irqs-off. (was: Re:
 Linux 2.6.38-rc4)
Message-ID: <20110208121108.GA4824@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <20110208101730.GB7020@liondog.tnic>
 <1297161712.13327.100.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1297161712.13327.100.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:41:52AM +0100, Peter Zijlstra wrote:
> Argh! Its an annotation nightmare that.. it didn't trigger for me when
> running that because I didn't have DEBUG_LOCKDEP=y.

Me too...

> 
> OK, let me try and come up with another way to annotate this
> del_timer_sync() muck,

Is my previous patch acceptable?

I inlined it as below(and updated based on linux-2.6.38-rc4)

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 1/2] softirq: introduce loacal_bh_enable_force_wake()

If there is pending softirq, don't handle it in the caller's
context, invoke ksoftirqd directly instead.

del_timer_sync() will be the first caller.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/bottom_half.h |    1 +
 kernel/softirq.c            |   21 +++++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/bottom_half.h b/include/linux/bottom_half.h
index 27b1bcf..665d697 100644
--- a/include/linux/bottom_half.h
+++ b/include/linux/bottom_half.h
@@ -5,5 +5,6 @@ extern void local_bh_disable(void);
 extern void _local_bh_enable(void);
 extern void local_bh_enable(void);
 extern void local_bh_enable_ip(unsigned long ip);
+extern void local_bh_enable_force_wake(void);
 
 #endif /* _LINUX_BH_H */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 68eb5ef..3c05dfa 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -154,9 +154,9 @@ void _local_bh_enable(void)
 
 EXPORT_SYMBOL(_local_bh_enable);
 
-static inline void _local_bh_enable_ip(unsigned long ip)
+static inline void _local_bh_enable_ip(unsigned long ip, bool force_wake)
 {
-	WARN_ON_ONCE(in_irq() || irqs_disabled());
+	WARN_ON_ONCE(in_irq() || (!force_wake && irqs_disabled()));
 #ifdef CONFIG_TRACE_IRQFLAGS
 	local_irq_disable();
 #endif
@@ -171,8 +171,12 @@ static inline void _local_bh_enable_ip(unsigned long ip)
  	 */
 	sub_preempt_count(SOFTIRQ_DISABLE_OFFSET - 1);
 
-	if (unlikely(!in_interrupt() && local_softirq_pending()))
-		do_softirq();
+	if (unlikely(!in_interrupt() && local_softirq_pending())) {
+		if (!force_wake)
+			do_softirq();
+		else
+			wakeup_softirqd();
+	}
 
 	dec_preempt_count();
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -183,16 +187,21 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 
 void local_bh_enable(void)
 {
-	_local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	_local_bh_enable_ip((unsigned long)__builtin_return_address(0), false);
 }
 EXPORT_SYMBOL(local_bh_enable);
 
 void local_bh_enable_ip(unsigned long ip)
 {
-	_local_bh_enable_ip(ip);
+	_local_bh_enable_ip(ip, false);
 }
 EXPORT_SYMBOL(local_bh_enable_ip);
 
+void local_bh_enable_force_wake(void)
+{
+	_local_bh_enable_ip((unsigned long)__builtin_return_address(0), true);
+}
+EXPORT_SYMBOL(local_bh_enable_force_wake);
 /*
  * We restart softirq processing MAX_SOFTIRQ_RESTART times,
  * and we fall back to softirqd after that.
-- 
1.7.1
