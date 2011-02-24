Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab1BXPCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:02:50 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:40157
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756263Ab1BXPCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:02:46 -0500
Date: Thu, 24 Feb 2011 15:03:01 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@osdl.org>, containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, dhowells@redhat.com,
        oleg@mail.hallyn.com, dlezcano@mail.hallyn.com,
        LSM <linux-security-module@vger.kernel.org>
Subject: [PATCH 07/10] add a user namespace owner of ipc ns
Message-ID: <20110224150301.GG8262@mail.hallyn.com>
References: <20110224150150.GA8262@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224150150.GA8262@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
	Feb 15: Don't set new ipc->user_ns if we didn't create a new
		ipc_ns.
	Feb 23: Move extern declaration to ipc_namespace.h, and group
		fwd declarations at top.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
---
 include/linux/ipc_namespace.h |    4 ++++
 ipc/msgutil.c                 |    1 +
 ipc/namespace.c               |    9 +++++++--
 kernel/nsproxy.c              |    5 +++++
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 5195298..c8cdf0e 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -15,6 +15,8 @@
 
 #define IPCNS_CALLBACK_PRI 0
 
+struct user_namespace;
+extern struct user_namespace init_user_ns;
 
 struct ipc_ids {
 	int in_use;
@@ -56,6 +58,8 @@ struct ipc_namespace {
 	unsigned int    mq_msg_max;      /* initialized to DFLT_MSGMAX */
 	unsigned int    mq_msgsize_max;  /* initialized to DFLT_MSGSIZEMAX */
 
+	/* user_ns which owns the ipc ns */
+	struct user_namespace *user_ns;
 };
 
 extern struct ipc_namespace init_ipc_ns;
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index f095ee2..8b5ce5d 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -32,6 +32,7 @@ struct ipc_namespace init_ipc_ns = {
 	.mq_msg_max      = DFLT_MSGMAX,
 	.mq_msgsize_max  = DFLT_MSGSIZEMAX,
 #endif
+	.user_ns = &init_user_ns,
 };
 
 atomic_t nr_ipc_ns = ATOMIC_INIT(1);
diff --git a/ipc/namespace.c b/ipc/namespace.c
index a1094ff..aa18899 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -11,10 +11,11 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/user_namespace.h>
 
 #include "util.h"
 
-static struct ipc_namespace *create_ipc_ns(void)
+static struct ipc_namespace *create_ipc_ns(struct ipc_namespace *old_ns)
 {
 	struct ipc_namespace *ns;
 	int err;
@@ -43,6 +44,9 @@ static struct ipc_namespace *create_ipc_ns(void)
 	ipcns_notify(IPCNS_CREATED);
 	register_ipcns_notifier(ns);
 
+	ns->user_ns = old_ns->user_ns;
+	get_user_ns(ns->user_ns);
+
 	return ns;
 }
 
@@ -50,7 +54,7 @@ struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
 {
 	if (!(flags & CLONE_NEWIPC))
 		return get_ipc_ns(ns);
-	return create_ipc_ns();
+	return create_ipc_ns(ns);
 }
 
 /*
@@ -105,6 +109,7 @@ static void free_ipc_ns(struct ipc_namespace *ns)
 	 * order to have a correct value when recomputing msgmni.
 	 */
 	ipcns_notify(IPCNS_REMOVED);
+	put_user_ns(ns->user_ns);
 }
 
 /*
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index b97fc9d..ac8a56e 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -80,6 +80,11 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		err = PTR_ERR(new_nsp->ipc_ns);
 		goto out_ipc;
 	}
+	if (new_nsp->ipc_ns != tsk->nsproxy->ipc_ns) {
+		put_user_ns(new_nsp->ipc_ns->user_ns);
+		new_nsp->ipc_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
+		get_user_ns(new_nsp->ipc_ns->user_ns);
+	}
 
 	new_nsp->pid_ns = copy_pid_ns(flags, task_active_pid_ns(tsk));
 	if (IS_ERR(new_nsp->pid_ns)) {
-- 
1.7.0.4

