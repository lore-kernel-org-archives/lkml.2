Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0EJSBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:01:35 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37097 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab0EJSB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:01:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH v3 03/11] rlimits: make sure ->rlim_max never grows in sys_setrlimit
Date: Mon, 10 May 2010 20:00:43 +0200
Message-Id: <1273514451-28894-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Mostly preparation for Jiri's changes, but probably makes sense anyway.

sys_setrlimit() checks new_rlim.rlim_max <= old_rlim->rlim_max, but when
it takes task_lock() old_rlim->rlim_max can be already lowered. Move this
check under task_lock().

Currently this is not important, we can only race with our sub-thread,
this means the application is stupid. But when we change the code to allow
the update of !current task's limits, it becomes important to make sure
->rlim_max can be lowered "reliably" even if we race with the application
doing sys_setrlimit().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 kernel/sys.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index f5183b0..d527c46 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1283,10 +1283,6 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 		return -EFAULT;
 	if (new_rlim.rlim_cur > new_rlim.rlim_max)
 		return -EINVAL;
-	old_rlim = current->signal->rlim + resource;
-	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
-	    !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
 	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
 		return -EPERM;
 
@@ -1304,11 +1300,16 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 		new_rlim.rlim_cur = 1;
 	}
 
+	old_rlim = current->signal->rlim + resource;
 	task_lock(current->group_leader);
-	*old_rlim = new_rlim;
+	if ((new_rlim.rlim_max <= old_rlim->rlim_max) ||
+				capable(CAP_SYS_RESOURCE))
+		*old_rlim = new_rlim;
+	else
+		retval = -EPERM;
 	task_unlock(current->group_leader);
 
-	if (resource != RLIMIT_CPU)
+	if (retval || resource != RLIMIT_CPU)
 		goto out;
 
 	/*
@@ -1322,7 +1323,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 
 	update_rlimit_cpu(current, new_rlim.rlim_cur);
 out:
-	return 0;
+	return retval;
 }
 
 /*
-- 
1.7.1


