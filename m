Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1JZFWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 01:22:42 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:41599
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996Ab1JZFWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 01:22:40 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] mutex:SMP:bf561:Run smp memory barrier after take atomic lock in mutex_fastpath APIs.
Date: Wed, 26 Oct 2011 13:15:51 +0800
Message-ID: <1319606151-29707-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

In blackfin SMP architecture, no cache coherence among cores is supppored by hardware. Data protected
by spin lock or atomic operation are kept consistent by invalidating entired local cache in spin lock APIs
and smp memory barrier APIs on the other cores.

In mutex fast path APIs, spin lock may not be called if the lock can be taken by atomic operation.
So, smp memory barrier should be invoked to keep cache consistent for SMP architecture without hardware
cache coherency support.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 include/asm-generic/mutex-dec.h  |   10 +++++++++-
 include/asm-generic/mutex-xchg.h |    8 ++++++++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/mutex-dec.h b/include/asm-generic/mutex-dec.h
index f104af7..61f722f 100644
--- a/include/asm-generic/mutex-dec.h
+++ b/include/asm-generic/mutex-dec.h
@@ -22,6 +22,8 @@ __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		fail_fn(count);
+	else
+		smp_rmb();
 }
 
 /**
@@ -39,6 +41,8 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		return fail_fn(count);
+	else
+		smp_rmb();
 	return 0;
 }
 
@@ -60,6 +64,8 @@ __mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_inc_return(count) <= 0))
 		fail_fn(count);
+	else
+		smp_wmb();
 }
 
 #define __mutex_slowpath_needs_to_unlock()		1
@@ -82,8 +88,10 @@ __mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 static inline int
 __mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
-	if (likely(atomic_cmpxchg(count, 1, 0) == 1))
+	if (likely(atomic_cmpxchg(count, 1, 0) == 1)) {
+		smp_rmb();
 		return 1;
+	}
 	return 0;
 }
 
diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
index 580a6d3..6d6bde8 100644
--- a/include/asm-generic/mutex-xchg.h
+++ b/include/asm-generic/mutex-xchg.h
@@ -27,6 +27,8 @@ __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_xchg(count, 0) != 1))
 		fail_fn(count);
+	else
+		smp_rmb();
 }
 
 /**
@@ -44,6 +46,8 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_xchg(count, 0) != 1))
 		return fail_fn(count);
+	else
+		smp_rmb();
 	return 0;
 }
 
@@ -64,6 +68,8 @@ __mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_xchg(count, 1) != 0))
 		fail_fn(count);
+	else
+		smp_wmb();
 }
 
 #define __mutex_slowpath_needs_to_unlock()		0
@@ -104,6 +110,8 @@ __mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
 		if (prev < 0)
 			prev = 0;
 	}
+	if (prev)
+		smp_rmb();
 
 	return prev;
 }
-- 
1.7.0.4


