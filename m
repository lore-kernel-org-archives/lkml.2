Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2JJUnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:43:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54576 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab2JJUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:43:00 -0400
Date: Thu, 11 Oct 2012 00:42:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, Andrew Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, Greg KH <greg@kroah.com>
Subject: [PATCH] pidns: remove recursion from free_pid_ns() v5
Message-ID: <20121010204256.GD29501@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The free_pid_ns function done in recursion fashion:

free_pid_ns(parent)
  put_pid_ns(parent)
    kref_put(&ns->kref, free_pid_ns);
      free_pid_ns

thus if there was a huge nesting of namespaces the userspace
may trigger avalanche calling of free_pid_ns leading to
kernel stack exhausting and a panic eventually.

This patch turns the recursion into iterative loop.

v5 (from oleg@):
 - Drop @ret variable
 - Make put_pid_ns non-inline since it grows in size,
   in turn make free_pid_ns static

Based-on-patch-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Greg KH <greg@kroah.com>
---
 include/linux/pid_namespace.h |    8 +-------
 kernel/pid_namespace.c        |   19 +++++++++++++------
 2 files changed, 14 insertions(+), 13 deletions(-)

Index: linux-2.6.git/include/linux/pid_namespace.h
===================================================================
--- linux-2.6.git.orig/include/linux/pid_namespace.h
+++ linux-2.6.git/include/linux/pid_namespace.h
@@ -47,15 +47,9 @@ static inline struct pid_namespace *get_
 }
 
 extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
-extern void free_pid_ns(struct kref *kref);
 extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
 extern int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd);
-
-static inline void put_pid_ns(struct pid_namespace *ns)
-{
-	if (ns != &init_pid_ns)
-		kref_put(&ns->kref, free_pid_ns);
-}
+extern void put_pid_ns(struct pid_namespace *ns);
 
 #else /* !CONFIG_PID_NS */
 #include <linux/err.h>
Index: linux-2.6.git/kernel/pid_namespace.c
===================================================================
--- linux-2.6.git.orig/kernel/pid_namespace.c
+++ linux-2.6.git/kernel/pid_namespace.c
@@ -132,17 +132,24 @@ struct pid_namespace *copy_pid_ns(unsign
 	return create_pid_namespace(old_ns);
 }
 
-void free_pid_ns(struct kref *kref)
+static void free_pid_ns(struct kref *kref)
 {
-	struct pid_namespace *ns, *parent;
+	struct pid_namespace *ns;
 
 	ns = container_of(kref, struct pid_namespace, kref);
-
-	parent = ns->parent;
 	destroy_pid_namespace(ns);
+}
+
+void put_pid_ns(struct pid_namespace *ns)
+{
+	struct pid_namespace *parent;
 
-	if (parent != NULL)
-		put_pid_ns(parent);
+	while (ns != &init_pid_ns) {
+		parent = ns->parent;
+		if (!kref_put(&ns->kref, free_pid_ns))
+			break;
+		ns = parent;
+	}
 }
 
 void zap_pid_ns_processes(struct pid_namespace *pid_ns)
