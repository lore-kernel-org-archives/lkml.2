Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1LVNL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 08:11:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61832 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1LVNLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 08:11:52 -0500
Message-Id: <20111222131139.612370710@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Dec 2011 16:56:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/4] proc: Show open file ID in /proc/pid/fdinfo/*
References: <20111222125639.360640574@openvz.org>
Content-Disposition: inline; filename=3-objid-fdinfo-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds "id" field in /proc/pid/fdinfo/<file>
output which represent generic ID for 'struct file'
being used by a task.

Based-on-patch-from: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Glauber Costa <glommer@parallels.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Tejun Heo <tj@kernel.org>
CC: Matt Helsley <matthltc@us.ibm.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Vasiliy Kulikov <segoon@openwall.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/base.c     |   34 +++++++++++++++++++++++++++++-----
 include/linux/mm.h |    1 +
 2 files changed, 30 insertions(+), 5 deletions(-)

Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -1888,8 +1888,36 @@ out:
 	return ~0U;
 }
 
+#ifdef CONFIG_GENERIC_OBJECT_IDS
+
+#define PROC_FDINFO_MAX 128
+
+static void proc_fd_info_fill(char *info, struct file *file, unsigned int f_flags)
+{
+	snprintf(info, PROC_FDINFO_MAX,
+		"pos:\t%lli\n"
+		"flags:\t0%o\n"
+		"id:\t%lu\n",
+		(long long)file->f_pos,
+		f_flags,
+		gen_obj_id(file, GEN_OBJ_ID_FILE));
+}
+
+#else /* CONFIG_GENERIC_OBJECT_IDS */
+
 #define PROC_FDINFO_MAX 64
 
+static void proc_fd_info_fill(char *info, struct file *file, unsigned int f_flags)
+{
+	snprintf(info, PROC_FDINFO_MAX,
+		"pos:\t%lli\n"
+		"flags:\t0%o\n",
+		(long long)file->f_pos,
+		f_flags);
+}
+
+#endif
+
 static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 {
 	struct task_struct *task = get_proc_task(inode);
@@ -1922,11 +1950,7 @@ static int proc_fd_info(struct inode *in
 				path_get(&file->f_path);
 			}
 			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long) file->f_pos,
-					 f_flags);
+				proc_fd_info_fill(info, file, f_flags);
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
Index: linux-2.6.git/include/linux/mm.h
===================================================================
--- linux-2.6.git.orig/include/linux/mm.h
+++ linux-2.6.git/include/linux/mm.h
@@ -1642,6 +1642,7 @@ extern void copy_user_huge_page(struct p
 
 enum {
 	GEN_OBJ_ID_NS,
+	GEN_OBJ_ID_FILE,
 	GEN_OBJ_ID_TYPES,
 };
 

