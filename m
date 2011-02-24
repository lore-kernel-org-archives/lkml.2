Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1BXPCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:02:16 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:40129
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756231Ab1BXPCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:02:14 -0500
Date: Thu, 24 Feb 2011 15:02:29 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@osdl.org>, containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, dhowells@redhat.com,
        oleg@mail.hallyn.com, dlezcano@mail.hallyn.com,
        LSM <linux-security-module@vger.kernel.org>
Subject: [PATCH 03/10] allow sethostname in a container
Message-ID: <20110224150229.GC8262@mail.hallyn.com>
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
	Feb 23: let clone_uts_ns() handle setting uts->user_ns
		To do so we need to pass in the task_struct who'll
		get the utsname, so we can get its user_ns.
	Feb 23: As per Oleg's coment, just pass in tsk, instead of two
		of its members.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
---
 include/linux/utsname.h |    6 +++---
 kernel/nsproxy.c        |    7 +------
 kernel/sys.c            |    2 +-
 kernel/utsname.c        |   12 +++++++-----
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 2c3c0f5..4e5b021 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -54,7 +54,7 @@ static inline void get_uts_ns(struct uts_namespace *ns)
 }
 
 extern struct uts_namespace *copy_utsname(unsigned long flags,
-					struct uts_namespace *ns);
+					  struct task_struct *tsk);
 extern void free_uts_ns(struct kref *kref);
 
 static inline void put_uts_ns(struct uts_namespace *ns)
@@ -71,12 +71,12 @@ static inline void put_uts_ns(struct uts_namespace *ns)
 }
 
 static inline struct uts_namespace *copy_utsname(unsigned long flags,
-					struct uts_namespace *ns)
+						 struct task_struct *tsk)
 {
 	if (flags & CLONE_NEWUTS)
 		return ERR_PTR(-EINVAL);
 
-	return ns;
+	return tsk->nsproxy->uts_ns;
 }
 #endif
 
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 034dc2e..b97fc9d 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -69,16 +69,11 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 		goto out_ns;
 	}
 
-	new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns);
+	new_nsp->uts_ns = copy_utsname(flags, tsk);
 	if (IS_ERR(new_nsp->uts_ns)) {
 		err = PTR_ERR(new_nsp->uts_ns);
 		goto out_uts;
 	}
-	if (new_nsp->uts_ns != tsk->nsproxy->uts_ns) {
-		put_user_ns(new_nsp->uts_ns->user_ns);
-		new_nsp->uts_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
-		get_user_ns(new_nsp->uts_ns->user_ns);
-	}
 
 	new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
 	if (IS_ERR(new_nsp->ipc_ns)) {
diff --git a/kernel/sys.c b/kernel/sys.c
index 18da702..7a1bbad 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1177,7 +1177,7 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 	int errno;
 	char tmp[__NEW_UTS_LEN];
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (len < 0 || len > __NEW_UTS_LEN)
 		return -EINVAL;
diff --git a/kernel/utsname.c b/kernel/utsname.c
index a7b3a8d..4464617 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -31,7 +31,8 @@ static struct uts_namespace *create_uts_ns(void)
  * @old_ns: namespace to clone
  * Return NULL on error (failure to kmalloc), new ns otherwise
  */
-static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
+static struct uts_namespace *clone_uts_ns(struct task_struct *tsk,
+					  struct uts_namespace *old_ns)
 {
 	struct uts_namespace *ns;
 
@@ -41,8 +42,7 @@ static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
 
 	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
-	ns->user_ns = old_ns->user_ns;
-	get_user_ns(ns->user_ns);
+	ns->user_ns = get_user_ns(task_cred_xxx(tsk, user)->user_ns);
 	up_read(&uts_sem);
 	return ns;
 }
@@ -53,8 +53,10 @@ static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
  * utsname of this process won't be seen by parent, and vice
  * versa.
  */
-struct uts_namespace *copy_utsname(unsigned long flags, struct uts_namespace *old_ns)
+struct uts_namespace *copy_utsname(unsigned long flags,
+				   struct task_struct *tsk)
 {
+	struct uts_namespace *old_ns = tsk->nsproxy->uts_ns;
 	struct uts_namespace *new_ns;
 
 	BUG_ON(!old_ns);
@@ -63,7 +65,7 @@ struct uts_namespace *copy_utsname(unsigned long flags, struct uts_namespace *ol
 	if (!(flags & CLONE_NEWUTS))
 		return old_ns;
 
-	new_ns = clone_uts_ns(old_ns);
+	new_ns = clone_uts_ns(tsk, old_ns);
 
 	put_uts_ns(old_ns);
 	return new_ns;
-- 
1.7.0.4

