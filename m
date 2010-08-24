Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0HXEZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:25:10 -0400
Received: from kroah.org ([198.145.64.141]:56438 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0HXEYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:24:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] kobject: Break the kobject namespace defs into their own header
Date: Mon, 23 Aug 2010 21:24:37 -0700
Message-Id: <1282623879-17092-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100824040503.GB16749@kroah.com>
References: <20100824040503.GB16749@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Break the kobject namespace defs into their own header to avoid a header file
inclusion ordering problem between linux/sysfs.h and linux/kobject.h.

This fixes the build breakage on older versions of gcc.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h    |   35 +--------------------------
 include/linux/kobject_ns.h |   56 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h      |    1 +
 3 files changed, 58 insertions(+), 34 deletions(-)
 create mode 100644 include/linux/kobject_ns.h

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index cf343a8..7950a37 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -22,6 +22,7 @@
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/kref.h>
+#include <linux/kobject_ns.h>
 #include <linux/kernel.h>
 #include <linux/wait.h>
 #include <asm/atomic.h>
@@ -136,42 +137,8 @@ struct kobj_attribute {
 
 extern const struct sysfs_ops kobj_sysfs_ops;
 
-/*
- * Namespace types which are used to tag kobjects and sysfs entries.
- * Network namespace will likely be the first.
- */
-enum kobj_ns_type {
-	KOBJ_NS_TYPE_NONE = 0,
-	KOBJ_NS_TYPE_NET,
-	KOBJ_NS_TYPES
-};
-
 struct sock;
 
-/*
- * Callbacks so sysfs can determine namespaces
- *   @current_ns: return calling task's namespace
- *   @netlink_ns: return namespace to which a sock belongs (right?)
- *   @initial_ns: return the initial namespace (i.e. init_net_ns)
- */
-struct kobj_ns_type_operations {
-	enum kobj_ns_type type;
-	const void *(*current_ns)(void);
-	const void *(*netlink_ns)(struct sock *sk);
-	const void *(*initial_ns)(void);
-};
-
-int kobj_ns_type_register(const struct kobj_ns_type_operations *ops);
-int kobj_ns_type_registered(enum kobj_ns_type type);
-const struct kobj_ns_type_operations *kobj_child_ns_ops(struct kobject *parent);
-const struct kobj_ns_type_operations *kobj_ns_ops(struct kobject *kobj);
-
-const void *kobj_ns_current(enum kobj_ns_type type);
-const void *kobj_ns_netlink(enum kobj_ns_type type, struct sock *sk);
-const void *kobj_ns_initial(enum kobj_ns_type type);
-void kobj_ns_exit(enum kobj_ns_type type, const void *ns);
-
-
 /**
  * struct kset - a set of kobjects of a specific type, belonging to a specific subsystem.
  *
diff --git a/include/linux/kobject_ns.h b/include/linux/kobject_ns.h
new file mode 100644
index 0000000..82cb5bf
--- /dev/null
+++ b/include/linux/kobject_ns.h
@@ -0,0 +1,56 @@
+/* Kernel object name space definitions
+ *
+ * Copyright (c) 2002-2003 Patrick Mochel
+ * Copyright (c) 2002-2003 Open Source Development Labs
+ * Copyright (c) 2006-2008 Greg Kroah-Hartman <greg@kroah.com>
+ * Copyright (c) 2006-2008 Novell Inc.
+ *
+ * Split from kobject.h by David Howells (dhowells@redhat.com)
+ *
+ * This file is released under the GPLv2.
+ *
+ * Please read Documentation/kobject.txt before using the kobject
+ * interface, ESPECIALLY the parts about reference counts and object
+ * destructors.
+ */
+
+#ifndef _LINUX_KOBJECT_NS_H
+#define _LINUX_KOBJECT_NS_H
+
+struct sock;
+struct kobject;
+
+/*
+ * Namespace types which are used to tag kobjects and sysfs entries.
+ * Network namespace will likely be the first.
+ */
+enum kobj_ns_type {
+	KOBJ_NS_TYPE_NONE = 0,
+	KOBJ_NS_TYPE_NET,
+	KOBJ_NS_TYPES
+};
+
+/*
+ * Callbacks so sysfs can determine namespaces
+ *   @current_ns: return calling task's namespace
+ *   @netlink_ns: return namespace to which a sock belongs (right?)
+ *   @initial_ns: return the initial namespace (i.e. init_net_ns)
+ */
+struct kobj_ns_type_operations {
+	enum kobj_ns_type type;
+	const void *(*current_ns)(void);
+	const void *(*netlink_ns)(struct sock *sk);
+	const void *(*initial_ns)(void);
+};
+
+int kobj_ns_type_register(const struct kobj_ns_type_operations *ops);
+int kobj_ns_type_registered(enum kobj_ns_type type);
+const struct kobj_ns_type_operations *kobj_child_ns_ops(struct kobject *parent);
+const struct kobj_ns_type_operations *kobj_ns_ops(struct kobject *kobj);
+
+const void *kobj_ns_current(enum kobj_ns_type type);
+const void *kobj_ns_netlink(enum kobj_ns_type type, struct sock *sk);
+const void *kobj_ns_initial(enum kobj_ns_type type);
+void kobj_ns_exit(enum kobj_ns_type type, const void *ns);
+
+#endif /* _LINUX_KOBJECT_NS_H */
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 3c92121..96eb576 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
+#include <linux/kobject_ns.h>
 #include <asm/atomic.h>
 
 struct kobject;
-- 
1.7.2

