Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2JFT4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 15:56:37 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25178 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab2JFT4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 15:56:35 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] pidns: remove recursion from free_pid_ns (v3)
Date: Sat,  6 Oct 2012 23:56:33 +0400
Message-Id: <1349553393-902065-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a stack trace of recursion:
free_pid_ns(parent)
  put_pid_ns(parent)
    kref_put(&ns->kref, free_pid_ns);
      free_pid_ns

This patch turns recursion into loops.

pidns can be nested many times, so in case of recursion
a simple user space program can provoke a kernel panic
due to exceed of a kernel stack.

v2: * don't check parent on NULL
    * use atomic_dec_and_test(&kref->refcount)
v3: Fix coding style issue

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/linux/kref.h   |   12 ++++++++++++
 kernel/pid_namespace.c |   16 ++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 65af688..2844262 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -95,6 +95,18 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 	return kref_sub(kref, 1, release);
 }
 
+/**
+ * kref_put - decrement refcount for object.
+ * @kref: object.
+ *
+ * Decrement the refcount.
+ * Return 1 if refcount is zero.
+ */
+static inline int __kref_put(struct kref *kref)
+{
+	return atomic_dec_and_test(&kref->refcount);
+}
+
 static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *lock)
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 6144bab..b051fa6 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -138,11 +138,19 @@ void free_pid_ns(struct kref *kref)
 
 	ns = container_of(kref, struct pid_namespace, kref);
 
-	parent = ns->parent;
-	destroy_pid_namespace(ns);
+	while (1) {
+		parent = ns->parent;
+		destroy_pid_namespace(ns);
 
-	if (parent != NULL)
-		put_pid_ns(parent);
+		if (parent == &init_pid_ns)
+			break;
+
+		/* kref_put cannot be used for avoiding recursion */
+		if (__kref_put(&parent->kref) == 0)
+			break;
+
+		ns = parent;
+	}
 }
 
 void zap_pid_ns_processes(struct pid_namespace *pid_ns)
-- 
1.7.1

