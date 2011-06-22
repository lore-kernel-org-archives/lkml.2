Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab1FVJU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:20:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:57952 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1FVJUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:20:55 -0400
Subject: Re: [PATCH 0/4] printk: Remove lockdep_off() and wakeups -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de
In-Reply-To: <20110621151725.705140475@chello.nl>
References: <20110621151725.705140475@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Jun 2011 11:20:09 +0200
Message-ID: <1308734409.1022.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 17:17 +0200, Peter Zijlstra wrote:
> Patch 0b5e1c5255 from -tip needs to be reverted (or better dropped), due
> us discovering why doing up() under logbuf_lock was important -- thanks 
> Andrew, Ingo! 

Or we can do the below delta to fix things up..

---
Subject: printk: Fix-up console_sem vs logbuf_lock unlock race
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Jun 10 12:05:38 CEST 2011

Fix up the fallout from commit 0b5e1c5255 (printk: Release console_sem
after logbuf_lock).

The reason for unlocking the console_sem under the logbuf_lock is that
a concurrent printk() might full up the buffer but fail to acquire the
console sem, resulting in a missed write to the console until a
subsequent console_sem acquire/release cycle.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -1244,7 +1244,7 @@ void console_unlock(void)
 {
 	unsigned long flags;
 	unsigned _con_start, _log_end;
-	unsigned wake_klogd = 0;
+	unsigned wake_klogd = 0, retry = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -1253,6 +1253,7 @@ void console_unlock(void)
 
 	console_may_schedule = 0;
 
+again:
 	for ( ; ; ) {
 		spin_lock_irqsave(&logbuf_lock, flags);
 		wake_klogd |= log_start - log_end;
@@ -1273,8 +1274,23 @@ void console_unlock(void)
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	spin_unlock_irqrestore(&logbuf_lock, flags);
+	spin_unlock(&logbuf_lock);
+
 	up(&console_sem);
+
+	/*
+	 * Someone could have filled up the buffer again, so re-check if there's
+	 * something to flush. In case we cannot trylock the console_sem again,
+	 * there's a new owner and the console_unlock() from them will do the
+	 * flush, no worries.
+	 */
+	spin_lock(&logbuf_lock);
+	if (con_start != log_end)
+		retry = 1;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (retry && console_trylock())
+		goto again;
+
 	if (wake_klogd)
 		wake_up_klogd();
 }

