Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab1CWOvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:51:41 -0400
Received: from mout.perfora.net ([74.208.4.195]:52666 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab1CWOvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:51:39 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH v2 resend 10/12] proc: hold cred_guard_mutex in check_mem_permission()
Date: Wed, 23 Mar 2011 10:43:59 -0400
Message-Id: <1300891441-16280-11-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1300891441-16280-1-git-send-email-wilsons@start.ca>
References: <1300891441-16280-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:0Pn2I+y017w+XHKFSf9o/F3NUfZxQgqPeFEN5sGNQpA
 8VCuhui3+rgxtY/iuN0boRe3N3xIg0VjzqMj0N79NIwxrvzHEY
 UmkAgQN8PGE3KVdeYpafpbKjRfvCFjCBVwIWzXf+ioJnCd/0zn
 tSL9gik0OiR35kD1jWPMsH/tlwZLdkbZbNwOcLn1qnbaZC+2YC
 9fnxSMtozl0/FmyFPhMtLx/xJY5Hv8PpTu532z2FE0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid a potential race when task exec's and we get a new ->mm but check against
the old credentials in ptrace_may_access().

Holding of the mutex is implemented by factoring out the body of the code into a
helper function __check_mem_permission().  Performing this factorization now
simplifies upcoming changes and minimizes churn in the diff's.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 fs/proc/base.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 13c5e8c..084d046 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -191,10 +191,7 @@ static int proc_root_link(struct inode *inode, struct path *path)
 	return result;
 }
 
-/*
- * Return zero if current may access user memory in @task, -error if not.
- */
-static int check_mem_permission(struct task_struct *task)
+static int __check_mem_permission(struct task_struct *task)
 {
 	/*
 	 * A task can always look at itself, in case it chooses
@@ -222,6 +219,27 @@ static int check_mem_permission(struct task_struct *task)
 	return -EPERM;
 }
 
+/*
+ * Return zero if current may access user memory in @task, -error if not.
+ */
+static int check_mem_permission(struct task_struct *task)
+{
+	int err;
+
+	/*
+	 * Avoid racing if task exec's as we might get a new mm but validate
+	 * against old credentials.
+	 */
+	err = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (err)
+		return err;
+
+	err = __check_mem_permission(task);
+	mutex_unlock(&task->signal->cred_guard_mutex);
+
+	return err;
+}
+
 struct mm_struct *mm_for_maps(struct task_struct *task)
 {
 	struct mm_struct *mm;
-- 
1.7.3.5

