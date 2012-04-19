Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2DSU0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:26:35 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38050 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2DSU0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:26:34 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Attilio Rao <attilio.rao@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Jones <drjones@redhat.com>, Avi Kivity <avi@redhat.com>,
        Xen Devel <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Apr 2012 01:45:46 +0530
Message-Id: <20120419201543.5411.37767.sendpatchset@codeblue>
In-Reply-To: <20120419201209.5411.43877.sendpatchset@codeblue>
References: <20120419201209.5411.43877.sendpatchset@codeblue>
Subject: [PATCH RFC V7 9/12] split out rate limiting from jump_label.h
x-cbid: 12041911-3568-0000-0000-000001925884
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

Commit b202952075f62603bea9bfb6ebc6b0420db11949 introduced rate limiting
for jump label disabling. The changes were made in the jump label code
in order to be more widely available and to keep things tidier. This is
all fine, except now jump_label.h includes linux/workqueue.h, which
makes it impossible to include jump_label.h from anything that
workqueue.h needs. For example, it's now impossible to include
jump_label.h from asm/spinlock.h, which is done in proposed
pv-ticketlock patches. This patch splits out the rate limiting related
changes from jump_label.h into a new file, jump_label_ratelimit.h, to
resolve the issue.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 include/linux/jump_label.h           |   26 +-------------------------
 include/linux/jump_label_ratelimit.h |   34 ++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h           |    1 +
 kernel/jump_label.c                  |    1 +
 4 files changed, 37 insertions(+), 25 deletions(-)
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index c513a40..8195227 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -49,7 +49,6 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/workqueue.h>
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 
@@ -62,12 +61,6 @@ struct static_key {
 #endif
 };
 
-struct static_key_deferred {
-	struct static_key key;
-	unsigned long timeout;
-	struct delayed_work work;
-};
-
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
@@ -126,10 +119,7 @@ extern void arch_jump_label_transform_static(struct jump_entry *entry,
 extern int jump_label_text_reserved(void *start, void *end);
 extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
-extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
 extern void jump_label_apply_nops(struct module *mod);
-extern void
-jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 
 #define STATIC_KEY_INIT_TRUE ((struct static_key) \
 	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
@@ -148,10 +138,6 @@ static __always_inline void jump_label_init(void)
 {
 }
 
-struct static_key_deferred {
-	struct static_key  key;
-};
-
 static __always_inline bool static_key_false(struct static_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)) > 0)
@@ -184,11 +170,6 @@ static inline void static_key_slow_dec(struct static_key *key)
 	atomic_dec(&key->enabled);
 }
 
-static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
-{
-	static_key_slow_dec(&key->key);
-}
-
 static inline int jump_label_text_reserved(void *start, void *end)
 {
 	return 0;
@@ -202,12 +183,6 @@ static inline int jump_label_apply_nops(struct module *mod)
 	return 0;
 }
 
-static inline void
-jump_label_rate_limit(struct static_key_deferred *key,
-		unsigned long rl)
-{
-}
-
 #define STATIC_KEY_INIT_TRUE ((struct static_key) \
 		{ .enabled = ATOMIC_INIT(1) })
 #define STATIC_KEY_INIT_FALSE ((struct static_key) \
@@ -218,6 +193,7 @@ jump_label_rate_limit(struct static_key_deferred *key,
 #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
 #define jump_label_enabled static_key_enabled
 
+static inline int atomic_read(const atomic_t *v);
 static inline bool static_key_enabled(struct static_key *key)
 {
 	return (atomic_read(&key->enabled) > 0);
diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
new file mode 100644
index 0000000..1137883
--- /dev/null
+++ b/include/linux/jump_label_ratelimit.h
@@ -0,0 +1,34 @@
+#ifndef _LINUX_JUMP_LABEL_RATELIMIT_H
+#define _LINUX_JUMP_LABEL_RATELIMIT_H
+
+#include <linux/jump_label.h>
+#include <linux/workqueue.h>
+
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+struct static_key_deferred {
+	struct static_key key;
+	unsigned long timeout;
+	struct delayed_work work;
+};
+#endif
+
+#ifdef HAVE_JUMP_LABEL
+extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
+extern void
+jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
+
+#else	/* !HAVE_JUMP_LABEL */
+struct static_key_deferred {
+	struct static_key  key;
+};
+static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
+{
+	static_key_slow_dec(&key->key);
+}
+static inline void
+jump_label_rate_limit(struct static_key_deferred *key,
+		unsigned long rl)
+{
+}
+#endif	/* HAVE_JUMP_LABEL */
+#endif	/* _LINUX_JUMP_LABEL_RATELIMIT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ddbb6a9..a0e6118 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -605,6 +605,7 @@ struct perf_guest_info_callbacks {
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
 #include <linux/static_key.h>
+#include <linux/jump_label_ratelimit.h>
 #include <linux/atomic.h>
 #include <linux/sysfs.h>
 #include <asm/local.h>
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 4304919..e17f8d6 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -13,6 +13,7 @@
 #include <linux/sort.h>
 #include <linux/err.h>
 #include <linux/static_key.h>
+#include <linux/jump_label_ratelimit.h>
 
 #ifdef HAVE_JUMP_LABEL
 

