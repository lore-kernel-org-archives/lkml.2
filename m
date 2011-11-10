Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407Ab1KJRPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:15:36 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:37973 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003Ab1KJRPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:15:35 -0500
Message-ID: <4EBC06B3.2000802@parallels.com>
Date: Thu, 10 Nov 2011 21:15:31 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: [PATCH 1/3] pids: Make alloc_pid return error
References: <4EBC0696.9030103@parallels.com>
In-Reply-To: <4EBC0696.9030103@parallels.com>
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
 kernel/pid.c  |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

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
index e432057..2d9704c 100644
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
 
@@ -321,7 +321,7 @@ out_free:
 		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
-	pid = NULL;
+	pid = ERR_PTR(nr);
 	goto out;
 }
 
-- 
1.5.5.6
