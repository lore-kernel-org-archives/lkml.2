Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab0EGI4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:56:42 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:46474 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab0EGI4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:56:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 09/11] rlimits: switch more rlimit syscalls to do_prlimit
Date: Fri,  7 May 2010 10:55:41 +0200
Message-Id: <1273222543-17083-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005060827520.901@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

After we added more generic do_prlimit, switch sys_getrlimit to that.
Also switch compat handling, so we can get rid of ugly __user casts
and avoid setting process' address limit to kernel data and back.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/compat.c |   16 +++-------------
 kernel/sys.c    |   17 ++++++++---------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 7f40e92..199b345 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -280,10 +280,6 @@ asmlinkage long compat_sys_setrlimit(unsigned int resource,
 {
 	struct rlimit r;
 	int ret;
-	mm_segment_t old_fs = get_fs ();
-
-	if (resource >= RLIM_NLIMITS)
-		return -EINVAL;
 
 	if (!access_ok(VERIFY_READ, rlim, sizeof(*rlim)) ||
 	    __get_user(r.rlim_cur, &rlim->rlim_cur) ||
@@ -294,10 +290,7 @@ asmlinkage long compat_sys_setrlimit(unsigned int resource,
 		r.rlim_cur = RLIM_INFINITY;
 	if (r.rlim_max == COMPAT_RLIM_INFINITY)
 		r.rlim_max = RLIM_INFINITY;
-	set_fs(KERNEL_DS);
-	ret = sys_setrlimit(resource, (struct rlimit __user *) &r);
-	set_fs(old_fs);
-	return ret;
+	return do_prlimit(current, resource, &r, NULL);
 }
 
 #ifdef COMPAT_RLIM_OLD_INFINITY
@@ -329,16 +322,13 @@ asmlinkage long compat_sys_old_getrlimit(unsigned int resource,
 
 #endif
 
-asmlinkage long compat_sys_getrlimit (unsigned int resource,
+asmlinkage long compat_sys_getrlimit(unsigned int resource,
 		struct compat_rlimit __user *rlim)
 {
 	struct rlimit r;
 	int ret;
-	mm_segment_t old_fs = get_fs();
 
-	set_fs(KERNEL_DS);
-	ret = sys_getrlimit(resource, (struct rlimit __user *) &r);
-	set_fs(old_fs);
+	ret = do_prlimit(current, resource, NULL, &r);
 	if (!ret) {
 		if (r.rlim_cur > COMPAT_RLIM_INFINITY)
 			r.rlim_cur = COMPAT_RLIM_INFINITY;
diff --git a/kernel/sys.c b/kernel/sys.c
index 7a453d2..0f8034f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1236,15 +1236,14 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 
 SYSCALL_DEFINE2(getrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 {
-	if (resource >= RLIM_NLIMITS)
-		return -EINVAL;
-	else {
-		struct rlimit value;
-		task_lock(current->group_leader);
-		value = current->signal->rlim[resource];
-		task_unlock(current->group_leader);
-		return copy_to_user(rlim, &value, sizeof(*rlim)) ? -EFAULT : 0;
-	}
+	struct rlimit value;
+	int ret;
+
+	ret = do_prlimit(current, resource, NULL, &value);
+	if (!ret)
+		ret = copy_to_user(rlim, &value, sizeof(*rlim)) ? -EFAULT : 0;
+
+	return ret;
 }
 
 #ifdef __ARCH_WANT_SYS_OLD_GETRLIMIT
-- 
1.7.1


