Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab0DFXkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:40:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35011
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757787Ab0DFXjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:39:53 -0400
Date: Tue, 06 Apr 2010 16:39:55 -0700 (PDT)
Message-Id: <20100406.163955.28809295.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, acme@redhat.com, paulus@samba.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 1/2] sparc64: Implement local_irq_save_nmi().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It disables up to PIL_NMI instead of just PIL_NORMAL_MAX.

Signed-off-by: David S. Miller <davem@davemloft.net>

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
