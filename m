Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2ISW5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:57:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55384 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2ISW5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:57:08 -0400
Date: Wed, 19 Sep 2012 15:56:59 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] audit: Use a tracepoint for getname
Message-ID: <20120919225659.GA11325@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, Eric,

	Was this considered before? Acceptable?

- Arnaldo

---

Instead of an explicit hook only for audit, use a tracepoint, so that
other users that need to know about filenames can hook there just like
audit.

Based on an earlier patch by Thomas Gleixner that added the tracepoint
but left the audit_getname call.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 fs/namei.c                 |    5 ++++-
 include/linux/audit.h      |    6 +-----
 include/trace/events/vfs.h |   32 ++++++++++++++++++++++++++++++++
 init/Kconfig               |    2 +-
 kernel/audit.c             |   11 +++++++++++
 5 files changed, 49 insertions(+), 7 deletions(-)
 create mode 100644 include/trace/events/vfs.h

diff --git a/fs/namei.c b/fs/namei.c
index dd1ed1b..e1462d1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -39,6 +39,9 @@
 #include "internal.h"
 #include "mount.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/vfs.h>
+
 /* [Feb-1997 T. Schoebel-Theuer]
  * Fundamental changes in the pathname lookup mechanisms (namei)
  * were necessary because of omirr.  The reason is that omirr needs
@@ -141,7 +144,7 @@ static char *getname_flags(const char __user *filename, int flags, int *empty)
 
 	err = ERR_PTR(-ENAMETOOLONG);
 	if (likely(len < PATH_MAX)) {
-		audit_getname(result);
+		trace_getname(result);
 		return result;
 	}
 
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 36abf2a..7ad39e0 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -493,11 +493,7 @@ static inline void audit_syscall_exit(void *pt_regs)
 		__audit_syscall_exit(success, return_code);
 	}
 }
-static inline void audit_getname(const char *name)
-{
-	if (unlikely(!audit_dummy_context()))
-		__audit_getname(name);
-}
+
 static inline void audit_inode(const char *name, const struct dentry *dentry) {
 	if (unlikely(!audit_dummy_context()))
 		__audit_inode(name, dentry);
diff --git a/include/trace/events/vfs.h b/include/trace/events/vfs.h
new file mode 100644
index 0000000..a6a5d1a
--- /dev/null
+++ b/include/trace/events/vfs.h
@@ -0,0 +1,32 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vfs
+
+#if !defined(_TRACE_VFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VFS_H_
+
+#include <linux/tracepoint.h>
+#include <linux/ftrace.h>
+
+TRACE_EVENT(getname,
+
+	TP_PROTO(const char *filename),
+
+	TP_ARGS(filename),
+
+	TP_STRUCT__entry(
+		__string(	filename, filename);
+	),
+
+	TP_fast_assign(
+		__assign_str(filename, filename);
+	),
+
+	TP_printk("vfs_getname %s", __get_str(filename))
+);
+
+#undef NO_DEV
+
+#endif /* _TRACE_VFS_H_ */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/init/Kconfig b/init/Kconfig
index af6c7f8..63413ea 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -348,7 +348,7 @@ config TASK_IO_ACCOUNTING
 
 config AUDIT
 	bool "Auditing support"
-	depends on NET
+	depends on NET && TRACEPOINTS
 	help
 	  Enable auditing infrastructure that can be used with another
 	  kernel subsystem, such as SELinux (which requires this for
diff --git a/kernel/audit.c b/kernel/audit.c
index ea3b7b6..99cb039 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -64,6 +64,8 @@
 
 #include "audit.h"
 
+#include <trace/events/vfs.h>
+
 /* No auditing will take place until audit_initialized == AUDIT_INITIALIZED.
  * (Initialization happens after skb_init is called.) */
 #define AUDIT_DISABLED		-1
@@ -958,6 +960,12 @@ static void audit_receive(struct sk_buff  *skb)
 	mutex_unlock(&audit_cmd_mutex);
 }
 
+static void audit_getname(void *ignore, const char *name)
+{
+	if (unlikely(!audit_dummy_context()))
+		__audit_getname(name);
+}
+
 /* Initialize audit support at boot time. */
 static int __init audit_init(void)
 {
@@ -978,6 +986,9 @@ static int __init audit_init(void)
 	else
 		audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
 
+	if (register_trace_getname(audit_getname, NULL))
+		audit_panic("cannot register getname tracepoint");
+
 	skb_queue_head_init(&audit_skb_queue);
 	skb_queue_head_init(&audit_skb_hold_queue);
 	audit_initialized = AUDIT_INITIALIZED;
-- 
1.7.1


