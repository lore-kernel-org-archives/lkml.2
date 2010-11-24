Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0KXP6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:58:04 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41444 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0KXP6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:58:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bv12UCVUY4ANtuDDGICfMgGziRVZz+WC+bPqQD+pRQrEomGKUTjkgjWc0NgLX2FG73
         pR3HlZTsLdKJRxxFvp5RJUvY6h94c849YXkhoBKypD9c21piRNKUv2oDSrCDGrsbRrQL
         jr+FMHQ9BLXODtVyGoE7FVGvTU8zfoLi6mFi4=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <error27@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] generic-ipi: add lock context annotations
Date: Thu, 25 Nov 2010 00:57:52 +0900
Message-Id: <1290614272-3213-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipi_call_[un]lock[_irq] functions grab/release a spin lock
but were missing proper annotations. Add them. This fixes
following sparse warnings:

 kernel/smp.c:513:6: warning: context imbalance in 'ipi_call_lock' - wrong count at exit
 kernel/smp.c:518:6: warning: context imbalance in 'ipi_call_unlock' - unexpected unlock
 kernel/smp.c:523:6: warning: context imbalance in 'ipi_call_lock_irq' - wrong count at exit
 kernel/smp.c:528:6: warning: context imbalance in 'ipi_call_unlock_irq' - unexpected unlock

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/smp.h |    8 ++++----
 kernel/smp.c        |    4 ++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 6dc95ca..f969345 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -86,10 +86,10 @@ int smp_call_function_any(const struct cpumask *mask,
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void generic_smp_call_function_single_interrupt(void);
 void generic_smp_call_function_interrupt(void);
-void ipi_call_lock(void);
-void ipi_call_unlock(void);
-void ipi_call_lock_irq(void);
-void ipi_call_unlock_irq(void);
+void ipi_call_lock(void) __acquires(call_function.lock);
+void ipi_call_unlock(void) __releases(call_function.lock);
+void ipi_call_lock_irq(void) __acquires(call_function.lock);
+void ipi_call_unlock_irq(void) __releases(call_function.lock);
 #endif
 
 /*
diff --git a/kernel/smp.c b/kernel/smp.c
index 12ed8b0..5a62f1f 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -511,21 +511,25 @@ int smp_call_function(smp_call_func_t func, void *info, int wait)
 EXPORT_SYMBOL(smp_call_function);
 
 void ipi_call_lock(void)
+	__acquires(call_function.lock)
 {
 	raw_spin_lock(&call_function.lock);
 }
 
 void ipi_call_unlock(void)
+	__releases(call_function.lock)
 {
 	raw_spin_unlock(&call_function.lock);
 }
 
 void ipi_call_lock_irq(void)
+	__acquires(call_function.lock)
 {
 	raw_spin_lock_irq(&call_function.lock);
 }
 
 void ipi_call_unlock_irq(void)
+	__releases(call_function.lock)
 {
 	raw_spin_unlock_irq(&call_function.lock);
 }
-- 
1.7.0.4

