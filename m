Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab2ENQzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:55:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57431 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757341Ab2ENQzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:55:08 -0400
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/4] printk: Separate out kmsg bits to kmsg.c
Date: Mon, 14 May 2012 09:54:33 -0700
Message-Id: <cc522263684c3537613c822332fae4678d1e89e2.1337013607.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <1337013987.29436.16.camel@joe2Laptop>
References: <1337013987.29436.16.camel@joe2Laptop>
In-Reply-To: <76bd4533a88ae2ebf584887d51bf306591d0c01a.1337013604.git.joe@perches.com>
References: <76bd4533a88ae2ebf584887d51bf306591d0c01a.1337013604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some clarity to the printk subsystem by restructuring
the code a bit.

Move the kmsg variables and functions to a separate
code file.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/Makefile |    1 +
 kernel/printk/kmsg.c   |  114 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/printk/printk.c |  107 ---------------------------------------------
 3 files changed, 115 insertions(+), 107 deletions(-)
 create mode 100644 kernel/printk/kmsg.c

diff --git a/kernel/printk/Makefile b/kernel/printk/Makefile
index 28b7129..396e085 100644
--- a/kernel/printk/Makefile
+++ b/kernel/printk/Makefile
@@ -1,3 +1,4 @@
 obj-y += printk.o
 obj-y += log_buf.o
 obj-y += console.o
+obj-y += kmsg.o
diff --git a/kernel/printk/kmsg.c b/kernel/printk/kmsg.c
new file mode 100644
index 0000000..ce64242
--- /dev/null
+++ b/kernel/printk/kmsg.c
@@ -0,0 +1,114 @@
+#include <linux/kernel.h>
+#include <linux/nmi.h>
+#include <linux/module.h>
+#include <linux/kmsg_dump.h>
+
+#include "log_buf.h"
+
+static bool always_kmsg_dump;
+module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
+
+static DEFINE_SPINLOCK(dump_list_lock);
+static LIST_HEAD(dump_list);
+
+/**
+ * kmsg_dump_register - register a kernel log dumper.
+ * @dumper: pointer to the kmsg_dumper structure
+ *
+ * Adds a kernel log dumper to the system. The dump callback in the
+ * structure will be called when the kernel oopses or panics and must be
+ * set. Returns zero on success and %-EINVAL or %-EBUSY otherwise.
+ */
+int kmsg_dump_register(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+	int err = -EBUSY;
+
+	/* The dump callback needs to be set */
+	if (!dumper->dump)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dump_list_lock, flags);
+	/* Don't allow registering multiple times */
+	if (!dumper->registered) {
+		dumper->registered = 1;
+		list_add_tail_rcu(&dumper->list, &dump_list);
+		err = 0;
+	}
+	spin_unlock_irqrestore(&dump_list_lock, flags);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_register);
+
+/**
+ * kmsg_dump_unregister - unregister a kmsg dumper.
+ * @dumper: pointer to the kmsg_dumper structure
+ *
+ * Removes a dump device from the system. Returns zero on success and
+ * %-EINVAL otherwise.
+ */
+int kmsg_dump_unregister(struct kmsg_dumper *dumper)
+{
+	unsigned long flags;
+	int err = -EINVAL;
+
+	spin_lock_irqsave(&dump_list_lock, flags);
+	if (dumper->registered) {
+		dumper->registered = 0;
+		list_del_rcu(&dumper->list);
+		err = 0;
+	}
+	spin_unlock_irqrestore(&dump_list_lock, flags);
+	synchronize_rcu();
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
+
+/**
+ * kmsg_dump - dump kernel log to kernel message dumpers.
+ * @reason: the reason (oops, panic etc) for dumping
+ *
+ * Iterate through each of the dump devices and call the oops/panic
+ * callbacks with the log buffer.
+ */
+void kmsg_dump(enum kmsg_dump_reason reason)
+{
+	unsigned long end;
+	unsigned chars;
+	struct kmsg_dumper *dumper;
+	const char *s1, *s2;
+	unsigned long l1, l2;
+	unsigned long flags;
+
+	if ((reason > KMSG_DUMP_OOPS) && !always_kmsg_dump)
+		return;
+
+	/* Theoretically, the log could move on after we do this, but
+	   there's not a lot we can do about that. The new messages
+	   will overwrite the start of what we dump. */
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	end = log_end & LOG_BUF_MASK;
+	chars = logged_chars;
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	if (chars > end) {
+		s1 = log_buf + log_buf_len - chars + end;
+		l1 = chars - end;
+
+		s2 = log_buf;
+		l2 = end;
+	} else {
+		s1 = "";
+		l1 = 0;
+
+		s2 = log_buf + end - chars;
+		l2 = chars;
+	}
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(dumper, &dump_list, list)
+		dumper->dump(dumper, reason, s1, l1, s2, l2);
+	rcu_read_unlock();
+}
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 3281441..aff4563 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -288,9 +288,6 @@ static bool printk_time = 0;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
-static bool always_kmsg_dump;
-module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
-
 /**
  * printk - print a kernel message
  * @fmt: format string
@@ -623,108 +620,4 @@ bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
 
-static DEFINE_SPINLOCK(dump_list_lock);
-static LIST_HEAD(dump_list);
-
-/**
- * kmsg_dump_register - register a kernel log dumper.
- * @dumper: pointer to the kmsg_dumper structure
- *
- * Adds a kernel log dumper to the system. The dump callback in the
- * structure will be called when the kernel oopses or panics and must be
- * set. Returns zero on success and %-EINVAL or %-EBUSY otherwise.
- */
-int kmsg_dump_register(struct kmsg_dumper *dumper)
-{
-	unsigned long flags;
-	int err = -EBUSY;
-
-	/* The dump callback needs to be set */
-	if (!dumper->dump)
-		return -EINVAL;
-
-	spin_lock_irqsave(&dump_list_lock, flags);
-	/* Don't allow registering multiple times */
-	if (!dumper->registered) {
-		dumper->registered = 1;
-		list_add_tail_rcu(&dumper->list, &dump_list);
-		err = 0;
-	}
-	spin_unlock_irqrestore(&dump_list_lock, flags);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(kmsg_dump_register);
-
-/**
- * kmsg_dump_unregister - unregister a kmsg dumper.
- * @dumper: pointer to the kmsg_dumper structure
- *
- * Removes a dump device from the system. Returns zero on success and
- * %-EINVAL otherwise.
- */
-int kmsg_dump_unregister(struct kmsg_dumper *dumper)
-{
-	unsigned long flags;
-	int err = -EINVAL;
-
-	spin_lock_irqsave(&dump_list_lock, flags);
-	if (dumper->registered) {
-		dumper->registered = 0;
-		list_del_rcu(&dumper->list);
-		err = 0;
-	}
-	spin_unlock_irqrestore(&dump_list_lock, flags);
-	synchronize_rcu();
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
-
-/**
- * kmsg_dump - dump kernel log to kernel message dumpers.
- * @reason: the reason (oops, panic etc) for dumping
- *
- * Iterate through each of the dump devices and call the oops/panic
- * callbacks with the log buffer.
- */
-void kmsg_dump(enum kmsg_dump_reason reason)
-{
-	unsigned long end;
-	unsigned chars;
-	struct kmsg_dumper *dumper;
-	const char *s1, *s2;
-	unsigned long l1, l2;
-	unsigned long flags;
-
-	if ((reason > KMSG_DUMP_OOPS) && !always_kmsg_dump)
-		return;
-
-	/* Theoretically, the log could move on after we do this, but
-	   there's not a lot we can do about that. The new messages
-	   will overwrite the start of what we dump. */
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	end = log_end & LOG_BUF_MASK;
-	chars = logged_chars;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
-
-	if (chars > end) {
-		s1 = log_buf + log_buf_len - chars + end;
-		l1 = chars - end;
-
-		s2 = log_buf;
-		l2 = end;
-	} else {
-		s1 = "";
-		l1 = 0;
-
-		s2 = log_buf + end - chars;
-		l2 = chars;
-	}
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(dumper, &dump_list, list)
-		dumper->dump(dumper, reason, s1, l1, s2, l2);
-	rcu_read_unlock();
-}
 #endif
-- 
1.7.8.111.gad25c.dirty

