Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0FWVyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:54:14 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37329 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753868Ab0FWVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:53:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       adobriyan@gmail.com, nhorman@tuxdriver.com,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/12] rlimits: switch more rlimit syscalls to do_prlimit
Date: Wed, 23 Jun 2010 23:52:11 +0200
Message-Id: <1277329933-8139-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
References: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

After we added more generic do_prlimit, switch sys_getrlimit to that.
Also switch compat handling, so we can get rid of ugly __user casts
and avoid setting process' address limit to kernel data and back.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/compat.c |   17 +++--------------
 kernel/sys.c    |   17 ++++++++---------
 2 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 5adab05..e167efc 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -279,11 +279,6 @@ asmlinkage long compat_sys_setrlimit(unsigned int resource,
 		struct compat_rlimit __user *rlim)
 {
 	struct rlimit r;
-	int ret;
-	mm_segment_t old_fs = get_fs ();
-
-	if (resource >= RLIM_NLIMITS)
-		return -EINVAL;
 
 	if (!access_ok(VERIFY_READ, rlim, sizeof(*rlim)) ||
 	    __get_user(r.rlim_cur, &rlim->rlim_cur) ||
@@ -294,10 +289,7 @@ asmlinkage long compat_sys_setrlimit(unsigned int resource,
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
@@ -329,16 +321,13 @@ asmlinkage long compat_sys_old_getrlimit(unsigned int resource,
 
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
index bc7d1be..9da98dd 100644
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


