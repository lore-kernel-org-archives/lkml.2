Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2GPPH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:07:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:43173 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2GPPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:07:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="172692652"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v2] ns: do not block exit_task_namespaces() for a long time
Date: Mon, 16 Jul 2012 18:09:24 +0300
Message-Id: <1342451364-14787-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <20120713140806.b3d0fda8.akpm@linux-foundation.org>
References: <20120713140806.b3d0fda8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

On exiting of the last task in a namespace we need to trigger freeing of
the namespace. Currently, we call synchronize_rcu() and free_nsproxy()
directly on do_exit() path.

On my machine synchronize_rcu() blocks for about 0.01 seconds. For
comparing: normal exit_group() syscall takes less than 0.0003 seconds.

Let's offload synchronize_rcu() and free_nsproxy() to a workqueue.

I also move synchronize_rcu() inside free_nsproxy(). It fixes racy
put_nsproxy() which calls free_nsproxy() without synchronize_rcu().
I guess it was missed during switch to RCU (see cf7b708).

Microbenchmark:

: #define _GNU_SOURCE
: #include <unistd.h>
: #include <sched.h>
: #include <stdlib.h>
: #include <sys/wait.h>
:
: int
: main(void)
: {
:       int i;
:       for (i = 0; i < 1024; i++) {
:               if (fork()) {
:                       wait(NULL);
:                       continue;
:               }
:               unshare(CLONE_NEWIPC);
:               exit(0);
:       }
:       return 0;
: }

Before the patch:

real    0m8.335s
user    0m0.000s
sys     0m0.265s

After:

real    0m0.569s
user    0m0.001s
sys     0m0.154s

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
---

v2:
 - Updated description.

---
 include/linux/nsproxy.h |    1 +
 kernel/nsproxy.c        |   34 +++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index cc37a55..1d26be7 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -24,6 +24,7 @@ struct fs_struct;
  */
 struct nsproxy {
 	atomic_t count;
+	struct work_struct free_nsproxy_work;
 	struct uts_namespace *uts_ns;
 	struct ipc_namespace *ipc_ns;
 	struct mnt_namespace *mnt_ns;
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index b576f7f..ebc7d40 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -41,13 +41,17 @@ struct nsproxy init_nsproxy = {
 #endif
 };
 
+static void free_nsproxy_work(struct work_struct *work);
+
 static inline struct nsproxy *create_nsproxy(void)
 {
 	struct nsproxy *nsproxy;
 
 	nsproxy = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
-	if (nsproxy)
+	if (nsproxy) {
 		atomic_set(&nsproxy->count, 1);
+		INIT_WORK(&nsproxy->free_nsproxy_work, free_nsproxy_work);
+	}
 	return nsproxy;
 }
 
@@ -166,6 +170,14 @@ out:
 
 void free_nsproxy(struct nsproxy *ns)
 {
+	/*
+	 * wait for others to get what they want from this nsproxy.
+	 *
+	 * cannot release this nsproxy via the call_rcu() since
+	 * put_mnt_ns() will want to sleep
+	 */
+	synchronize_rcu();
+
 	if (ns->mnt_ns)
 		put_mnt_ns(ns->mnt_ns);
 	if (ns->uts_ns)
@@ -178,6 +190,14 @@ void free_nsproxy(struct nsproxy *ns)
 	kmem_cache_free(nsproxy_cachep, ns);
 }
 
+static void free_nsproxy_work(struct work_struct *work)
+{
+	struct nsproxy *ns = container_of(work, struct nsproxy,
+			free_nsproxy_work);
+
+	free_nsproxy(ns);
+}
+
 /*
  * Called from unshare. Unshare all the namespaces part of nsproxy.
  * On success, returns the new nsproxy.
@@ -215,16 +235,8 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 
 	rcu_assign_pointer(p->nsproxy, new);
 
-	if (ns && atomic_dec_and_test(&ns->count)) {
-		/*
-		 * wait for others to get what they want from this nsproxy.
-		 *
-		 * cannot release this nsproxy via the call_rcu() since
-		 * put_mnt_ns() will want to sleep
-		 */
-		synchronize_rcu();
-		free_nsproxy(ns);
-	}
+	if (ns && atomic_dec_and_test(&ns->count))
+		schedule_work(&ns->free_nsproxy_work);
 }
 
 void exit_task_namespaces(struct task_struct *p)
-- 
1.7.7.6

