Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1JMAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:09:26 -0400
Received: from claw.goop.org ([74.207.240.146]:47109 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab1JMAJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:09:00 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC V4 10/10] jump-label: initialize jump-label subsystem much earlier
Date: Wed, 12 Oct 2011 17:08:41 -0700
Message-Id: <c133180533d7e520bb1e818e987117811a666fbc.1318464413.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1318464413.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318464413.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Initialize jump_labels much earlier, we can use them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/jump_label.h |   14 +++++++++-----
 init/main.c                |    1 +
 kernel/jump_label.c        |    5 +----
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 56594e4..388b0d4 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -16,7 +16,7 @@ struct jump_label_key {
 
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
-#endif
+#endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
 
 enum jump_label_type {
 	JUMP_LABEL_DISABLE = 0,
@@ -41,6 +41,7 @@ static __always_inline bool static_branch(struct jump_label_key *key)
 extern struct jump_entry __start___jump_table[];
 extern struct jump_entry __stop___jump_table[];
 
+extern void jump_label_init(void);
 extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
@@ -53,7 +54,7 @@ extern void jump_label_dec(struct jump_label_key *key);
 extern bool jump_label_enabled(struct jump_label_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 
-#else
+#else  /* !HAVE_JUMP_LABEL */
 
 #include <linux/atomic.h>
 
@@ -63,6 +64,10 @@ struct jump_label_key {
 	atomic_t enabled;
 };
 
+static __always_inline void jump_label_init(void)
+{
+}
+
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)))
@@ -97,7 +102,6 @@ static inline int jump_label_apply_nops(struct module *mod)
 {
 	return 0;
 }
+#endif	/* HAVE_JUMP_LABEL */
 
-#endif
-
-#endif
+#endif	/* _LINUX_JUMP_LABEL_H */
diff --git a/init/main.c b/init/main.c
index 2a9b88a..f4094ed 100644
--- a/init/main.c
+++ b/init/main.c
@@ -637,6 +637,7 @@ asmlinkage void __init start_kernel(void)
 	acpi_early_init(); /* before LAPIC and SMP init */
 	sfi_init_late();
 
+	jump_label_init();
 	ftrace_init();
 
 	/* Do the rest non-__init'ed, we're now alive */
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index ff2028f..bbdfe2a 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -133,7 +133,7 @@ static void __jump_label_update(struct jump_label_key *key,
 	}
 }
 
-static __init int jump_label_init(void)
+void __init jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
 	struct jump_entry *iter_stop = __stop___jump_table;
@@ -159,10 +159,7 @@ static __init int jump_label_init(void)
 #endif
 	}
 	jump_label_unlock();
-
-	return 0;
 }
-early_initcall(jump_label_init);
 
 #ifdef CONFIG_MODULES
 
-- 
1.7.6.4

