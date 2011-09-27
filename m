Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab1I0HwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:52:17 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14335 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1I0HwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:52:16 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@elte.hu>, <joe@perches.com>, <tglx@linutronix.de>,
        <peterz@infradead.org>, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH] spinlock: rm duplicated preempt en/disable for bottom half
Date: Tue, 27 Sep 2011 15:56:25 +0800
Message-ID: <1317110185-9219-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

local_bh_en/disable() has already deal with en/disable preempt, so rm the
dumplicated one from spinlock_api_up/smp.h head file.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 include/linux/spinlock_api_smp.h |    4 ----
 include/linux/spinlock_api_up.h  |    5 ++---
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index e253ccd..ba8b8f3 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -132,7 +132,6 @@ static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
 static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
 {
 	local_bh_disable();
-	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
@@ -174,19 +173,16 @@ static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
-	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
 
 static inline int __raw_spin_trylock_bh(raw_spinlock_t *lock)
 {
 	local_bh_disable();
-	preempt_disable();
 	if (do_raw_spin_trylock(lock)) {
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
-	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 	return 0;
 }
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index af1f472..c9e4f1c 100644
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -28,7 +28,7 @@
   do { preempt_disable(); __acquire(lock); (void)(lock); } while (0)
 
 #define __LOCK_BH(lock) \
-  do { local_bh_disable(); __LOCK(lock); } while (0)
+  do { local_bh_disable(); __acquire(lock); (void)(lock); } while (0)
 
 #define __LOCK_IRQ(lock) \
   do { local_irq_disable(); __LOCK(lock); } while (0)
@@ -40,8 +40,7 @@
   do { preempt_enable(); __release(lock); (void)(lock); } while (0)
 
 #define __UNLOCK_BH(lock) \
-  do { preempt_enable_no_resched(); local_bh_enable(); \
-	  __release(lock); (void)(lock); } while (0)
+  do { local_bh_enable(); __release(lock); (void)(lock); } while (0)
 
 #define __UNLOCK_IRQ(lock) \
   do { local_irq_enable(); __UNLOCK(lock); } while (0)
-- 
1.6.3.3


