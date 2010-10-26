Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab0JZCyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821Ab0JZCyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 09/43] MN10300: Provide the functions to fully disable
 maskable interrupts
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:53:50 +0100
Message-ID: <20101026025350.23512.40273.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

The local_irq_disable() function and co. merely raise the interrupt mask on the
MN10300 arch to exclude normal interrupts.  This still lets other, higher
priority maskable interrupts through, such as are used to service gdbstub's
serial port and the MN10300 on-chip serial port virtual FIFOs.

Provide functions to allow the maskable interrupts to be fully disabled, which
will exclude those interrupts.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/irqflags.h |   77 +++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/include/asm/irqflags.h b/arch/mn10300/include/asm/irqflags.h
index 5e529a1..f1b64b2 100644
--- a/arch/mn10300/include/asm/irqflags.h
+++ b/arch/mn10300/include/asm/irqflags.h
@@ -119,5 +119,82 @@ static inline void arch_safe_halt(void)
 		: "cc");
 }
 
+static inline void arch_local_cli(void)
+{
+	asm volatile(
+		"	and	%0,epsw		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	nop			\n"
+		:
+		: "i"(~EPSW_IE)
+		: "memory"
+		);
+}
+
+static inline unsigned long arch_local_cli_save(void)
+{
+	unsigned long flags = arch_local_save_flags();
+	arch_local_cli();
+	return flags;
+}
+
+static inline void arch_local_sti(void)
+{
+	asm volatile(
+		"	or	%0,epsw		\n"
+		:
+		: "i"(EPSW_IE)
+		: "memory");
+}
+
+static inline void arch_local_change_intr_mask_level(unsigned long level)
+{
+	asm volatile(
+		"	and	%0,epsw		\n"
+		"	or	%1,epsw		\n"
+		:
+		: "i"(~EPSW_IM), "i"(EPSW_IE | level)
+		: "cc", "memory");
+}
+
+#else /* !__ASSEMBLY__ */
+
+#define LOCAL_SAVE_FLAGS(reg)			\
+	mov	epsw,reg
+
+#define LOCAL_IRQ_DISABLE				\
+	and	~EPSW_IM,epsw;				\
+	or	EPSW_IE|MN10300_CLI_LEVEL,epsw;		\
+	nop;						\
+	nop;						\
+	nop
+
+#define LOCAL_IRQ_ENABLE		\
+	or	EPSW_IE|EPSW_IM_7,epsw
+
+#define LOCAL_IRQ_RESTORE(reg)	\
+	mov	reg,epsw
+
+#define LOCAL_CLI_SAVE(reg)	\
+	mov	epsw,reg;	\
+	and	~EPSW_IE,epsw;	\
+	nop;			\
+	nop;			\
+	nop
+
+#define LOCAL_CLI		\
+	and	~EPSW_IE,epsw;	\
+	nop;			\
+	nop;			\
+	nop
+
+#define LOCAL_STI		\
+	or	EPSW_IE,epsw
+
+#define LOCAL_CHANGE_INTR_MASK_LEVEL(level)	\
+	and	~EPSW_IM,epsw;			\
+	or	EPSW_IE|(level),epsw
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_IRQFLAGS_H */

