Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab1LVNLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 08:11:53 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57184 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1LVNLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 08:11:46 -0500
Message-Id: <20111222131139.537644156@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Dec 2011 16:56:41 +0400
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
Subject: [patch 2/4] proc: Show namespaces IDs in /proc/pid/ns/* files
References: <20111222125639.360640574@openvz.org>
Content-Disposition: inline; filename=2-objids-namespaces
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proc_ns_read method which provides
IDs for /proc/pid/ns/* files.

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
 Documentation/filesystems/proc.txt |   24 ++++++++++++++++++++++++
 fs/proc/namespaces.c               |   21 +++++++++++++++++++++
 include/linux/mm.h                 |    1 +
 3 files changed, 46 insertions(+)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -40,6 +40,7 @@ Table of Contents
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
+  3.7	/proc/<pid>/ns - Information about namespaces
 
 
 ------------------------------------------------------------------------------
@@ -1545,3 +1546,26 @@ a task to set its own or one of its thre
 is limited in size compared to the cmdline value, so writing anything longer
 then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
 comm value.
+
+3.7	/proc/<pid>/ns - Information about namespaces
+-----------------------------------------------------
+
+This directory consists of the following files "net", "uts", "ipc",
+and depend if appropriate CONFIG_ entry is set, i.e. it's possible
+to have only one, two or all three files here.
+
+Currently file contents provides that named "object id" number, which
+is a number useful for the one purpose only -- to test if two differen
+<pid> share the namespace.
+
+A typical format is
+
+id:	445332486300860161
+
+i.e. "id" followed by a number. One should never assume the number
+means something, it is only useful for "sameness" test with another number
+obtained from another <pid>.
+
+Moreover, a safe approach is to remember it as a string, since format may
+change in future and id would be not a long integer value, but something
+else, say SHA1/2 or even uuid encoded stream.
Index: linux-2.6.git/fs/proc/namespaces.c
===================================================================
--- linux-2.6.git.orig/fs/proc/namespaces.c
+++ linux-2.6.git/fs/proc/namespaces.c
@@ -27,10 +27,31 @@ static const struct proc_ns_operations *
 #endif
 };
 
+#ifdef CONFIG_GENERIC_OBJECT_IDS
+static ssize_t proc_ns_read(struct file *file, char __user *buf,
+				      size_t len, loff_t *ppos)
+{
+	struct proc_inode *ei = PROC_I(file->f_dentry->d_inode);
+	char tmp[32];
+
+	snprintf(tmp, sizeof(tmp), "id:\t%lu\n",
+		gen_obj_id(ei->ns, GEN_OBJ_ID_NS));
+	return simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
+}
+
+static const struct file_operations ns_file_operations = {
+	.llseek		= no_llseek,
+	.read		= proc_ns_read,
+};
+
+#else
+
 static const struct file_operations ns_file_operations = {
 	.llseek		= no_llseek,
 };
 
+#endif /* CONFIG_GENERIC_OBJECT_IDS */
+
 static struct dentry *proc_ns_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
Index: linux-2.6.git/include/linux/mm.h
===================================================================
--- linux-2.6.git.orig/include/linux/mm.h
+++ linux-2.6.git/include/linux/mm.h
@@ -1641,6 +1641,7 @@ extern void copy_user_huge_page(struct p
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 enum {
+	GEN_OBJ_ID_NS,
 	GEN_OBJ_ID_TYPES,
 };
 

