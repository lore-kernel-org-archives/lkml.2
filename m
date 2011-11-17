Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1KQLm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:42:29 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:31212 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab1KQLm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:42:27 -0500
Message-ID: <4EC4F31F.3010702@parallels.com>
Date: Thu, 17 Nov 2011 15:42:23 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: [PATCH 1/3] pids: Make alloc_pid return error
References: <4EC4F2FB.408@parallels.com>
In-Reply-To: <4EC4F2FB.408@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the alloc_pid just reports the pid allocation failre
and this gets reported as ENOMEM to user. With the clone-with-pid
ability the error codes set will be extended and this patch eases
this extension.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 kernel/fork.c |    5 +++--
 kernel/pid.c  |    9 ++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..45a5f54 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1253,10 +1253,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
-		retval = -ENOMEM;
 		pid = alloc_pid(p->nsproxy->pid_ns);
-		if (!pid)
+		if (IS_ERR(pid)) {
+			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_io;
+		}
 	}
 
 	p->pid = pid_nr(pid);
diff --git a/kernel/pid.c b/kernel/pid.c
index e432057..4816f43 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -214,7 +214,7 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 		}
 		pid = mk_pid(pid_ns, map, offset);
 	}
-	return -1;
+	return -ENOMEM;
 }
 
 int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
@@ -281,7 +281,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 {
 	struct pid *pid;
 	enum pid_type type;
-	int i, nr;
+	int i, nr = -ENOMEM;
 	struct pid_namespace *tmp;
 	struct upid *upid;
 
@@ -313,7 +313,6 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 				&pid_hash[pid_hashfn(upid->nr, upid->ns)]);
 	spin_unlock_irq(&pidmap_lock);
 
-out:
 	return pid;
 
 out_free:
@@ -321,8 +320,8 @@ out_free:
 		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
-	pid = NULL;
-	goto out;
+out:
+	return ERR_PTR(nr);
 }
 
 struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
-- 
1.5.5.6
