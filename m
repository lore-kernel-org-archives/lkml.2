Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0IQPRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:17:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32776 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab0IQPRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:17:47 -0400
From: Will Drewry <wad@chromium.org>
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        containers@lists.linux-foundation.org, Eugene Teo <eteo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-fsdevel@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Subject: [PATCH 1/2] nsproxy: add copy_namespaces_unattached
Date: Fri, 17 Sep 2010 10:16:57 -0500
Message-Id: <1284736618-27153-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100917152639.0e88341a@basil.nowhere.org>
References: <20100917152639.0e88341a@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes adds copy_namespaces_unattached which provides similar
behavior to copy_namespaces() for clone, but is meant for use when a
new namespace needs to be derived from an existing process outside
of process creation.

The next patch in this series shows this function used in fs/exec.c to
insert the core_pattern pipe thread into the crashed processes
namespaces.

This patch is similar to the setns patches floated earlier this year,
but the goal is less lofty though not incompatible!

Any and all input, thoughts, etc will be appreciated.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/nsproxy.h |    2 ++
 kernel/nsproxy.c        |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 7b370c7..4c823d2 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -63,6 +63,8 @@ static inline struct nsproxy *task_nsproxy(struct task_struct *tsk)
 }
 
 int copy_namespaces(unsigned long flags, struct task_struct *tsk);
+int copy_namespaces_unattached(unsigned long flags, struct task_struct *tsk,
+			       struct nsproxy **nsproxy, struct fs_struct **fs);
 void exit_task_namespaces(struct task_struct *tsk);
 void switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
 void free_nsproxy(struct nsproxy *ns);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f74e6c0..ddaea4d 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <net/net_namespace.h>
 #include <linux/ipc_namespace.h>
+#include <linux/fs_struct.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
@@ -161,6 +162,44 @@ out:
 	return err;
 }
 
+/**
+ * copy_namespaces_unattached: creates a new nsproxy and fs from a given task
+ * @flags:	clone flags to change namespace creation/copy behavior
+ * @tsk:	task's namespace to base the nsproxy and fs on
+ * @nsproxy:	pointer which will contain the newly created nsproxy
+ * @fs:		pointer which will contain the newly created fs_struct
+ *
+ * Returns 0 on success and non-zero on failure.
+ *
+ * This function should aid in migrating processes across namespaces when after
+ * creation.
+ */
+int copy_namespaces_unattached(unsigned long flags, struct task_struct *tsk,
+			       struct nsproxy **nsproxy, struct fs_struct **fs)
+{
+	int err = 0;
+	if (!fs || !nsproxy) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	*fs = copy_fs_struct(tsk->fs);
+	if (!*fs) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	*nsproxy = create_new_namespaces(flags, tsk, *fs);
+	if (IS_ERR(*nsproxy)) {
+		err = PTR_ERR(*nsproxy);
+		free_fs_struct(*fs);
+		goto out;
+	}
+
+out:
+	return err;
+}
+
 void free_nsproxy(struct nsproxy *ns)
 {
 	if (ns->mnt_ns)
-- 
1.7.0.4

