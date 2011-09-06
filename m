Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1IGG1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:27:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48847 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab1IGGU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:59 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        anton@samba.org, benh@kernel.crashing.org, paulus@samba.org
Subject: [PATCH tip/core/rcu 48/55] powerpc: strengthen value-returning-atomics memory barriers
Date: Tue,  6 Sep 2011 11:00:42 -0700
Message-Id: <1315332049-2604-48-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
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

