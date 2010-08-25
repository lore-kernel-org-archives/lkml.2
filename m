Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab0HYG0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 02:26:15 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48893 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0HYG0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 02:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ULNlmjAQy8HJGy+2zyxkmJ2QCmnwNrMf5KokTzQxzQJ4y5PlGG6fLwx2vRgjFDAWNq
         JQ8mCXejSfjLnWzPxdQBthsGcdmm8JWb39a6+sSd+mae05HZK6jjkyKVeAKjZDg5ayWQ
         MfZ4WtPc+rq1NQTKChVSH63TX7Ra5lYY49QyY=
MIME-Version: 1.0
Date: Wed, 25 Aug 2010 14:26:12 +0800
Message-ID: <AANLkTimUb4GCdacq0C5+k=q9TrTMW956iUY-00ZpXsrX@mail.gmail.com>
Subject: [RFC PATCH 1/3] timer: make try_to_del_timer_sync() safe on both
 hardirq context and UP
From: Yong Zhang <yong.zhang0@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

In commit fd450b7318b75343fd76b3d95416853e34e72c95, it was saying
try_to_del_timer_sync() can be used in interrupt context.

But because base->running_timer is SMP special, this lead to
unsymmetry try_to_del_timer_sync() on UP and SMP.

We can make running_timer live on everywhere, then try_to_del_timer_sync()
is also UP safe and can be used in hardirq context.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/timer.h |    4 ++--
 kernel/timer.c        |    6 +-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 38cf093..225c4ce 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -248,11 +248,11 @@ static inline void
timer_stats_timer_clear_start_info(struct timer_list *timer)

 extern void add_timer(struct timer_list *timer);

+extern int try_to_del_timer_sync(struct timer_list *timer);
+
 #ifdef CONFIG_SMP
-  extern int try_to_del_timer_sync(struct timer_list *timer);
   extern int del_timer_sync(struct timer_list *timer);
 #else
-# define try_to_del_timer_sync(t)	del_timer(t)
 # define del_timer_sync(t)		del_timer(t)
 #endif

diff --git a/kernel/timer.c b/kernel/timer.c
index 97bf05b..e031eb4 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -347,9 +347,7 @@ EXPORT_SYMBOL_GPL(set_timer_slack);
 static inline void set_running_timer(struct tvec_base *base,
 					struct timer_list *timer)
 {
-#ifdef CONFIG_SMP
 	base->running_timer = timer;
-#endif
 }

 static void internal_add_timer(struct tvec_base *base, struct
timer_list *timer)
@@ -936,15 +934,12 @@ int del_timer(struct timer_list *timer)
 }
 EXPORT_SYMBOL(del_timer);

-#ifdef CONFIG_SMP
 /**
  * try_to_del_timer_sync - Try to deactivate a timer
  * @timer: timer do del
  *
  * This function tries to deactivate a timer. Upon successful (ret >= 0)
  * exit the timer is not queued and the handler is not running on any CPU.
- *
- * It must not be called from interrupt contexts.
  */
 int try_to_del_timer_sync(struct timer_list *timer)
 {
@@ -973,6 +968,7 @@ out:
 }
 EXPORT_SYMBOL(try_to_del_timer_sync);

+#ifdef CONFIG_SMP
 /**
  * del_timer_sync - deactivate a timer and wait for the handler to finish.
  * @timer: the timer to be deactivated
-- 
1.7.0.4
