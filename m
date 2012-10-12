Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2JLBWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:22:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32425 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2JLBV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:21:28 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=v2vMHd0OFtsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=HZW87zcCyfsA:10 a=VwQbUJbxAAAA:8 a=bndTQQZpn-juXqhEl_8A:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121012012126.241147167@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Oct 2012 21:20:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 4/8] mm: page_alloc: Use local_lock_on() instead of plain spinlock
References: <20121012012024.056658930@goodmis.org>
Content-Disposition: inline; filename=0004-mm-page_alloc-Use-local_lock_on-instead-of-plain-spi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The plain spinlock while sufficient does not update the local_lock
internals. Use a proper local_lock function instead to ease debugging.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/locallock.h |   11 +++++++++++
 mm/page_alloc.c           |    4 ++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/locallock.h b/include/linux/locallock.h
index 0161fbb..f1804a3 100644
--- a/include/linux/locallock.h
+++ b/include/linux/locallock.h
@@ -137,6 +137,12 @@ static inline int __local_lock_irqsave(struct local_irq_lock *lv)
 		_flags = __get_cpu_var(lvar).flags;			\
 	} while (0)
 
+#define local_lock_irqsave_on(lvar, _flags, cpu)			\
+	do {								\
+		__local_lock_irqsave(&per_cpu(lvar, cpu));		\
+		_flags = per_cpu(lvar, cpu).flags;			\
+	} while (0)
+
 static inline int __local_unlock_irqrestore(struct local_irq_lock *lv,
 					    unsigned long flags)
 {
@@ -156,6 +162,11 @@ static inline int __local_unlock_irqrestore(struct local_irq_lock *lv,
 			put_local_var(lvar);				\
 	} while (0)
 
+#define local_unlock_irqrestore_on(lvar, flags, cpu)			\
+	do {								\
+		__local_unlock_irqrestore(&per_cpu(lvar, cpu), flags);	\
+	} while (0)
+
 #define local_spin_trylock_irq(lvar, lock)				\
 	({								\
 		int __locked;						\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 67202bc..8678a7f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -227,9 +227,9 @@ static DEFINE_LOCAL_IRQ_LOCK(pa_lock);
 
 #ifdef CONFIG_PREEMPT_RT_BASE
 # define cpu_lock_irqsave(cpu, flags)		\
-	spin_lock_irqsave(&per_cpu(pa_lock, cpu).lock, flags)
+	local_lock_irqsave_on(pa_lock, flags, cpu)
 # define cpu_unlock_irqrestore(cpu, flags)		\
-	spin_unlock_irqrestore(&per_cpu(pa_lock, cpu).lock, flags)
+	local_unlock_irqrestore_on(pa_lock, flags, cpu)
 #else
 # define cpu_lock_irqsave(cpu, flags)		local_irq_save(flags)
 # define cpu_unlock_irqrestore(cpu, flags)	local_irq_restore(flags)
-- 
1.7.10.4


