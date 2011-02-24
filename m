Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1BXAVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:21:52 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:51341
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752279Ab1BXAVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:21:50 -0500
Date: Thu, 24 Feb 2011 00:22:04 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com, Daniel Lezcano <daniel.lezcano@free.fr>
Subject: [PATCH 2/4] userns: let copy_ipcs handle setting ipc_ns->user_ns
Message-ID: <20110224002204.GB27640@mail.hallyn.com>
References: <20110221040156.GA12580@mail.hallyn.com>
 <20110221040230.GB12580@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221040230.GB12580@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To do that, we have to pass in the task_struct of the task which
will own the ipc_ns, so we can assign its user_ns.

Changelog:
	Feb 23: As per Oleg comment, just pass in tsk.  To get the
	        ipc_ns from the nsproxy we need to include nsproxy.h

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 include/linux/ipc_namespace.h |    7 ++++---
 ipc/namespace.c               |   13 ++++++++-----
 kernel/nsproxy.c              |    7 +------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 46d2eb4..c079d09 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -5,6 +5,7 @@
 #include <linux/idr.h>
 #include <linux/rwsem.h>
 #include <linux/notifier.h>
+#include <linux/nsproxy.h>
 
 /*
  * ipc namespace events
@@ -93,7 +94,7 @@ static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
 
 #if defined(CONFIG_IPC_NS)
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
-				       struct ipc_namespace *ns);
+				       struct task_struct *tsk);
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 {
 	if (ns)
@@ -104,12 +105,12 @@ static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 extern void put_ipc_ns(struct ipc_namespace *ns);
 #else
 static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
-		struct ipc_namespace *ns)
+					      struct task_struct *tsk)
 {
 	if (flags & CLONE_NEWIPC)
 		return ERR_PTR(-EINVAL);
 
-	return ns;
+	return tsk->nsproxy->ipc_ns;
 }
 
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
diff --git a/ipc/namespace.c b/ipc/namespace.c
index aa18899..3c3e522 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -15,7 +15,8 @@
 
 #include "util.h"
 
-static struct ipc_namespace *create_ipc_ns(struct ipc_namespace *old_ns)
+static struct ipc_namespace *create_ipc_ns(struct task_struct *tsk,
+					   struct ipc_namespace *old_ns)
 {
 	struct ipc_namespace *ns;
 	int err;
@@ -44,17 +45,19 @@ static struct ipc_namespace *create_ipc_ns(struct ipc_namespace *old_ns)
 	ipcns_notify(IPCNS_CREATED);
 	register_ipcns_notifier(ns);
 
-	ns->user_ns = old_ns->user_ns;
-	get_user_ns(ns->user_ns);
+	ns->user_ns = get_user_ns(task_cred_xxx(tsk, user)->user_ns);
 
 	return ns;
 }
 
-struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
+struct ipc_namespace *copy_ipcs(unsigned long flags,
+				struct task_struct *tsk)
 {
+	struct ipc_namespace *ns = tsk->nsproxy->ipc_ns;
+
 	if (!(flags & CLONE_NEWIPC))
 		return get_ipc_ns(ns);
-	return create_ipc_ns(ns);
+	return create_ipc_ns(tsk, ns);
 }
 
 /*
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index ac8a56e..a05d191 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -75,16 +75,11 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		goto out_uts;
 	}
 
-	new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
+	new_nsp->ipc_ns = copy_ipcs(flags, tsk);
 	if (IS_ERR(new_nsp->ipc_ns)) {
 		err = PTR_ERR(new_nsp->ipc_ns);
 		goto out_ipc;
 	}
-	if (new_nsp->ipc_ns != tsk->nsproxy->ipc_ns) {
-		put_user_ns(new_nsp->ipc_ns->user_ns);
-		new_nsp->ipc_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
-		get_user_ns(new_nsp->ipc_ns->user_ns);
-	}
 
 	new_nsp->pid_ns = copy_pid_ns(flags, task_active_pid_ns(tsk));
 	if (IS_ERR(new_nsp->pid_ns)) {
-- 
1.7.0.4

