Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab2BUPYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 10:24:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab2BUPYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:24:37 -0500
Date: Tue, 21 Feb 2012 16:23:50 +0100
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 1/1] linux headers: header file(s) changes to enable
 spinlock use jumplabel
Message-ID: <20120221152349.GA7274@turtle.usersys.redhat.com>
References: <ac7058ed-4080-4490-a45b-6b2d4de692ab@zmail17.collab.prod.int.phx2.redhat.com>
 <4F428814.1060801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F428814.1060801@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 11:21:16PM +0530, Raghavendra K T wrote:
> Perhaps we need jump_label.h to define a "minimal
> >jump label", and then we can create an "extended jump label",
> >which has rate limiting and other capabilities.
> >
> 
> I completely agree. seeing that, you have not started that, it seems
> it's good idea for me to take a look at that option, (but may be at
> slower pace considering some changes I require (TODO) for kvm paravirt
> spinlock).
>

Below is the patch I wrote when I first proposed the idea to
Gleb. This patch isn't exactly what I stated above, because
it's splitting original and ratelimit, rather than minimal and
extended. Maybe this is sufficient for now? Or maybe we don't
want to split at all?

Drew

---

From: Andrew Jones <drjones@redhat.com>
Date: Thu, 26 Jan 2012 13:59:30 +0100
Subject: [PATCH] split out rate limiting from jump_label.h

Commit b202952075f62603bea9bfb6ebc6b0420db11949 introduced rate limiting
for jump label disabling. The changes were made in the jump label code
in order to be more widely available and to keep things tidier. This is
all fine, except now jump_label.h includes linux/workqueue.h, which
makes it impossible to include jump_label.h from anything that
workqueue.h needs. For example, it's now impossible to include
jump_label.h from asm/spinlock.h, which was done in Jeremy's proposed
pv-ticketlock patches. This patch splits out the rate limiting related
changes from jump_label.h into a new file, jump_label_ratelimit.h, to
resolve the issue.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 include/linux/jump_label.h           |   24 ------------------------
 include/linux/jump_label_ratelimit.h |   32 ++++++++++++++++++++++++++++++++
 include/linux/perf_event.h           |    2 +-
 kernel/jump_label.c                  |    2 +-
 4 files changed, 34 insertions(+), 26 deletions(-)
 create mode 100644 include/linux/jump_label_ratelimit.h

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 5ce8b14..b15954a 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/workqueue.h>
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 
@@ -15,12 +14,6 @@ struct jump_label_key {
 #endif
 };
 
-struct jump_label_key_deferred {
-	struct jump_label_key key;
-	unsigned long timeout;
-	struct delayed_work work;
-};
-
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif	/* CC_HAVE_ASM_GOTO && CONFIG_JUMP_LABEL */
@@ -58,11 +51,8 @@ extern void arch_jump_label_transform_static(struct jump_entry *entry,
 extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
-extern void jump_label_dec_deferred(struct jump_label_key_deferred *key);
 extern bool jump_label_enabled(struct jump_label_key *key);
 extern void jump_label_apply_nops(struct module *mod);
-extern void jump_label_rate_limit(struct jump_label_key_deferred *key,
-		unsigned long rl);
 
 #else  /* !HAVE_JUMP_LABEL */
 
@@ -78,10 +68,6 @@ static __always_inline void jump_label_init(void)
 {
 }
 
-struct jump_label_key_deferred {
-	struct jump_label_key  key;
-};
-
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)))
@@ -99,11 +85,6 @@ static inline void jump_label_dec(struct jump_label_key *key)
 	atomic_dec(&key->enabled);
 }
 
-static inline void jump_label_dec_deferred(struct jump_label_key_deferred *key)
-{
-	jump_label_dec(&key->key);
-}
-
 static inline int jump_label_text_reserved(void *start, void *end)
 {
 	return 0;
@@ -121,11 +102,6 @@ static inline int jump_label_apply_nops(struct module *mod)
 {
 	return 0;
 }
-
-static inline void jump_label_rate_limit(struct jump_label_key_deferred *key,
-		unsigned long rl)
-{
-}
 #endif	/* HAVE_JUMP_LABEL */
 
 #define jump_label_key_enabled	((struct jump_label_key){ .enabled = ATOMIC_INIT(1), })
diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
new file mode 100644
index 0000000..2cf61b9
--- /dev/null
+++ b/include/linux/jump_label_ratelimit.h
@@ -0,0 +1,32 @@
+#ifndef _LINUX_JUMP_LABEL_RATELIMIT_H
+#define _LINUX_JUMP_LABEL_RATELIMIT_H
+
+#include <linux/jump_label.h>
+#include <linux/workqueue.h>
+
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+struct jump_label_key_deferred {
+	struct jump_label_key key;
+	unsigned long timeout;
+	struct delayed_work work;
+};
+#endif
+
+#ifdef HAVE_JUMP_LABEL
+extern void jump_label_dec_deferred(struct jump_label_key_deferred *key);
+extern void jump_label_rate_limit(struct jump_label_key_deferred *key,
+		unsigned long rl);
+#else
+struct jump_label_key_deferred {
+	struct jump_label_key  key;
+};
+static inline void jump_label_dec_deferred(struct jump_label_key_deferred *key)
+{
+	jump_label_dec(&key->key);
+}
+static inline void jump_label_rate_limit(struct jump_label_key_deferred *key,
+		unsigned long rl)
+{
+}
+#endif
+#endif	/* _LINUX_JUMP_LABEL_RATELIMIT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0885561..7ae33d9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -512,7 +512,7 @@ struct perf_guest_info_callbacks {
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
-#include <linux/jump_label.h>
+#include <linux/jump_label_ratelimit.h>
 #include <linux/atomic.h>
 #include <asm/local.h>
 
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 01d3b70..f736308 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/err.h>
-#include <linux/jump_label.h>
+#include <linux/jump_label_ratelimit.h>
 
 #ifdef HAVE_JUMP_LABEL
 
-- 
1.7.7.6


