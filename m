Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab1KBUbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:31:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58185 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1KBUb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:29 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        anton@samba.org, benh@kernel.crashing.org, paulus@samba.org
Subject: [PATCH RFC tip/core/rcu 01/28] powerpc: Strengthen value-returning-atomics memory barriers
Date: Wed,  2 Nov 2011 13:30:22 -0700
Message-Id: <1320265849-5744-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-6078-0000-0000-000003EA3C5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trailing isync/lwsync in PowerPC value-returning atomics needs
to be a sync in order to provide the required ordering properties.
The leading lwsync/eieio can remain, as the remainder of the required
ordering guarantees are provided by the atomic instructions: Any
reordering will cause the stwcx to fail, which will result in a retry.

This commit provides the needed adjustment.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: anton@samba.org
Cc: benh@kernel.crashing.org
Cc: paulus@samba.org
---
 arch/powerpc/include/asm/synch.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/synch.h b/arch/powerpc/include/asm/synch.h
index d7cab44..4d97fbe 100644
--- a/arch/powerpc/include/asm/synch.h
+++ b/arch/powerpc/include/asm/synch.h
@@ -37,11 +37,7 @@ static inline void isync(void)
 #endif
 
 #ifdef CONFIG_SMP
-#define __PPC_ACQUIRE_BARRIER				\
-	START_LWSYNC_SECTION(97);			\
-	isync;						\
-	MAKE_LWSYNC_SECTION_ENTRY(97, __lwsync_fixup);
-#define PPC_ACQUIRE_BARRIER	"\n" stringify_in_c(__PPC_ACQUIRE_BARRIER)
+#define PPC_ACQUIRE_BARRIER	"\n" stringify_in_c(sync;)
 #define PPC_RELEASE_BARRIER	stringify_in_c(LWSYNC) "\n"
 #else
 #define PPC_ACQUIRE_BARRIER
-- 
1.7.3.2

