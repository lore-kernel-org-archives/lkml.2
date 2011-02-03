Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab1BCLvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:51:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42552 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1BCLvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:51:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x6hOrQVblITKA10DrhtiqkpmO4ZNvwLnMcxlHuUaAlCtBK906aGHEhNZvn6nXnn+nF
         wjPHwjUowsL5wZnLDYG2+1gqIR+nW0t7Yqm3leyVNfpYKAtqF1dIibJhAN4S9HT4M69s
         5p6/Upqjdffrchl0WF8Q0er390QcpMg1DrxWc=
Date: Thu, 3 Feb 2011 19:50:56 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] softirq: introduce loacal_bh_enable_force_wake()
Message-ID: <20110203115056.GA2121@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110203031943.GA8910@elliptictech.com>
 <20110203091227.GA1603@zhy>
 <1296725440.26581.354.camel@laptop>
 <20110203101739.GA1551@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110203101739.GA1551@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 06:17:39PM +0800, Yong Zhang wrote:
> Maybe we can introduce another type of local_bh_enable() in which
> waking up ksoftirqd is forced if needed.

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
 kernel/softirq.c            |   19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

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
index 68eb5ef..5f224d4 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -154,7 +154,7 @@ void _local_bh_enable(void)
 
 EXPORT_SYMBOL(_local_bh_enable);
 
-static inline void _local_bh_enable_ip(unsigned long ip)
+static inline void _local_bh_enable_ip(unsigned long ip, bool force_wake)
 {
 	WARN_ON_ONCE(in_irq() || irqs_disabled());
 #ifdef CONFIG_TRACE_IRQFLAGS
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

