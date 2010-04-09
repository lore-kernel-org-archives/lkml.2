Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0DIXBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 19:01:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33612
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690Ab0DIXBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:01:34 -0400
Date: Fri, 09 Apr 2010 16:01:37 -0700 (PDT)
Message-Id: <20100409.160137.48119461.davem@davemloft.net>
To: peterz@infradead.org
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: [PATCH 2/4] sparc64: Implement local_irq_save_nmi() override.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/irqflags_64.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/include/asm/irqflags_64.h b/arch/sparc/include/asm/irqflags_64.h
index 8b49bf9..fa1e00e 100644
--- a/arch/sparc/include/asm/irqflags_64.h
+++ b/arch/sparc/include/asm/irqflags_64.h
@@ -49,6 +49,16 @@ static inline void raw_local_irq_disable(void)
 	);
 }
 
+static inline void raw_local_irq_disable_nmi(void)
+{
+	__asm__ __volatile__(
+		"wrpr	%0, %%pil"
+		: /* no outputs */
+		: "i" (PIL_NMI)
+		: "memory"
+	);
+}
+
 static inline void raw_local_irq_enable(void)
 {
 	__asm__ __volatile__(
@@ -83,9 +93,28 @@ static inline unsigned long __raw_local_irq_save(void)
 	return flags;
 }
 
+static inline unsigned long __raw_local_irq_save_nmi(void)
+{
+	unsigned long flags = __raw_local_save_flags();
+
+	raw_local_irq_disable_nmi();
+
+	return flags;
+}
+
 #define raw_local_irq_save(flags) \
 		do { (flags) = __raw_local_irq_save(); } while (0)
 
+#define raw_local_irq_save_nmi(flags) \
+		do { (flags) = __raw_local_irq_save_nmi(); } while (0)
+
+#define local_irq_save_nmi(flags) 			\
+	do {						\
+		 typecheck(unsigned long, flags);	\
+		 raw_local_irq_save_nmi(flags);		\
+		 trace_hardirqs_off();			\
+	} while (0)
+
 #endif /* (__ASSEMBLY__) */
 
 #endif /* !(_ASM_IRQFLAGS_H) */
-- 
1.7.0.4

