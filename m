Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab0DMH4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 03:56:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46192
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab0DMH4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 03:56:36 -0400
Date: Tue, 13 Apr 2010 00:56:40 -0700 (PDT)
Message-Id: <20100413.005640.48990319.davem@davemloft.net>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 0/4]: Respin local_irq_*_nmi() stuff.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1271144938.4807.925.camel@twins>
References: <20100409.160132.216116766.davem@davemloft.net>
	<20100412.220838.132238558.davem@davemloft.net>
	<1271144938.4807.925.camel@twins>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 13 Apr 2010 09:48:58 +0200

> Care to enlighten the curious amongst us as to what exactly you're
> doing in the sparc code?

>From 0c25e9e6cbe7b233bb91d14d0e2c258bf8e6ec83 Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@davemloft.net>
Date: Mon, 12 Apr 2010 22:21:52 -0700
Subject: [PATCH 2/2] sparc64: Adjust __raw_local_irq_save() to cooperate in NMIs.

If we are in an NMI then doing a plain raw_local_irq_disable() will
write PIL_NORMAL_MAX into %pil, which is lower than PIL_NMI, and thus
we'll re-enable NMIs and recurse.

Doing a simple:

	%pil = %pil | PIL_NORMAL_MAX

does what we want, if we're already at PIL_NMI (15) we leave it at
that setting, else we set it to PIL_NORMAL_MAX (14).

This should get the function tracer working on sparc64.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/irqflags_64.h |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/irqflags_64.h b/arch/sparc/include/asm/irqflags_64.h
index 8b49bf9..a16e94c 100644
--- a/arch/sparc/include/asm/irqflags_64.h
+++ b/arch/sparc/include/asm/irqflags_64.h
@@ -76,9 +76,19 @@ static inline int raw_irqs_disabled(void)
  */
 static inline unsigned long __raw_local_irq_save(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags, tmp;
 
-	raw_local_irq_disable();
+	/* Disable interrupts to PIL_NORMAL_MAX unless we already
+	 * are using PIL_NMI, in which case PIL_NMI is retained.
+	 */
+	__asm__ __volatile__(
+		"rdpr	%%pil, %0\n\t"
+		"or	%0, %2, %1\n\t"
+		"wrpr	%1, 0x0, %%pil"
+		: "=r" (flags), "=r" (tmp)
+		: "i" (PIL_NORMAL_MAX)
+		: "memory"
+	);
 
 	return flags;
 }
-- 
1.7.0.4

