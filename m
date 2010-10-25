Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0JYPYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:24:49 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:54049 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab0JYPYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:24:48 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, dhowells@redhat.com,
        jkosina@suse.cz, jan.kiszka@web.de, xiyou.wangcong@gmail.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: Fix IRQ flag handling naming
Date: Mon, 25 Oct 2010 17:24:33 +0200
Message-Id: <1288020273-31161-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit df9ee292 changed the IRQ flag handling naming scheme
and broke UML.
This patch brings the new scheme to UML and makes it work again.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/system.h |   49 +++++++++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/um/include/asm/system.h b/arch/um/include/asm/system.h
index 93af1cf..68a90ec 100644
--- a/arch/um/include/asm/system.h
+++ b/arch/um/include/asm/system.h
@@ -8,23 +8,38 @@ extern int set_signals(int enable);
 extern void block_signals(void);
 extern void unblock_signals(void);
 
-#define local_save_flags(flags) do { typecheck(unsigned long, flags); \
-				     (flags) = get_signals(); } while(0)
-#define local_irq_restore(flags) do { typecheck(unsigned long, flags); \
-				      set_signals(flags); } while(0)
-
-#define local_irq_save(flags) do { local_save_flags(flags); \
-                                   local_irq_disable(); } while(0)
-
-#define local_irq_enable() unblock_signals()
-#define local_irq_disable() block_signals()
-
-#define irqs_disabled()                 \
-({                                      \
-        unsigned long flags;            \
-        local_save_flags(flags);        \
-        (flags == 0);                   \
-})
+static inline unsigned long arch_local_save_flags(void)
+{
+	return get_signals();
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	set_signals(flags);
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	unblock_signals();
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	block_signals();
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+	flags = arch_local_save_flags();
+	arch_local_irq_disable();
+	return flags;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_local_save_flags() == 0;
+}
 
 extern void *_switch_to(void *prev, void *next, void *last);
 #define switch_to(prev, next, last) prev = _switch_to(prev, next, last)
-- 
1.6.6.1

