Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab1KQKEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:04:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61696 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab1KQKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:04:44 -0500
Date: Thu, 17 Nov 2011 14:04:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] Introduce CAP_CHECKPOINT capability and filter map_files/
 access
Message-ID: <20111117100439.GK20508@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal idea of checkpoint/restore is to provide this feature not
for admins only but regular users as well. Still some operations
are privileged -- such as accessing /proc/$pid/map_files.

So instead of requiring anyone who has a will to checkpoint/restore
processes CAP_SYS_ADMIN privileges, it might (?) be worth to bring a way
less powerful CAP_CHECKPOINT capability.

The following permissions for CAP_CHECKPOINT should be granted
 - read/write /proc/$pid/map_files/
 - (not yet merged) clone-with-specified-pid, might be changed to last_pid+clone setup
 - (not yet published/stabilized) prctls calls to tune up vDSO and elements
   of mm_struct such as mm->start_code, mm->end_code, mm->start_data and etc

I would like to gather people opinions on such approach as a general.
_ANY_ comments are highly appreciated. Would it worth it or not (since
CAPs space is pretty limited one).

(the patch is on top of -mm)

*NOT-FOR-INCLUSION*
---
 fs/proc/base.c             |    6 ++++--
 include/linux/capability.h |    7 ++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -2386,7 +2386,8 @@ static struct dentry *proc_map_files_loo
 	struct mm_struct *mm;
 
 	result = ERR_PTR(-EACCES);
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) &&
+	    !capable(CAP_CHECKPOINT))
 		goto out;
 
 	result = ERR_PTR(-ENOENT);
@@ -2442,7 +2443,8 @@ proc_map_files_readdir(struct file *filp
 	int ret;
 
 	ret = -EACCES;
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) &&
+	    !capable(CAP_CHECKPOINT))
 		goto out;
 
 	ret = -ENOENT;
Index: linux-2.6.git/include/linux/capability.h
===================================================================
--- linux-2.6.git.orig/include/linux/capability.h
+++ linux-2.6.git/include/linux/capability.h
@@ -360,8 +360,13 @@ struct cpu_vfs_cap_data {
 
 #define CAP_WAKE_ALARM            35
 
+/*
+ * Allow to use privilege operations needed for
+ * checkpoint/restore procedure.
+ */
+#define CAP_CHECKPOINT             36
 
-#define CAP_LAST_CAP         CAP_WAKE_ALARM
+#define CAP_LAST_CAP         CAP_CHECKPOINT
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
