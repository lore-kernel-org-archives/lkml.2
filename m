Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1LWMue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:50:34 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45742 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1LWMua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:50:30 -0500
Message-Id: <20111223124920.860062736@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Dec 2011 16:47:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 4/4] proc: Show IDs of objects cloned with CLONE_ in proc
References: <20111223124741.711871189@openvz.org>
Content-Disposition: inline; filename=4-proc-object-entry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An example of output is

	# cat /proc/2332/objects 
	VM        :445332486314238977
	FILES     :16574420397857109505
	FS        :7421276367695228033
	SIGHAND   :9517130248188834433
	IO        :9605099974489260945
	SYSVSEM   :0

each one represents an ID of appropriate resource used
by a task -- memory, signals, fs and etc.

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
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 Documentation/filesystems/proc.txt |   18 ++++++++++++++++++
 fs/proc/base.c                     |   29 +++++++++++++++++++++++++++++
 include/linux/gen_obj_id.h         |    6 ++++++
 3 files changed, 53 insertions(+)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -41,6 +41,7 @@ Table of Contents
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
   3.7	/proc/<pid>/ns - Information about namespaces
+  3.8	/proc/<pid>/objects - Information about generic objects
 
 
 ------------------------------------------------------------------------------
@@ -1569,3 +1570,20 @@ obtained from another <pid>.
 Moreover, a safe approach is to remember it as a string, since format may
 change in future and id would be not a long integer value, but something
 else, say SHA1/2 or even uuid encoded stream.
+
+3.8	/proc/<pid>/objects - Information about generic objects
+---------------------------------------------------------------
+
+Similar to /proc/<pid>/ns this file provide generic object ids by
+the following format (better to illustrate with example)
+
+VM        :445332486300860161
+FILES     :16574420397866995457
+FS        :7421276367693613825
+SIGHAND   :9517130248196786369
+IO        :0
+SYSVSEM   :0
+
+The first column is an object name, the second -- object ID number.
+As being mentioned in 3.7 one should carry them as a string to be
+on a safe side.
Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -313,6 +313,32 @@ out:
 	return res;
 }
 
+#ifdef CONFIG_GENERIC_OBJECT_ID
+static int proc_pid_objs(struct task_struct *task, char * buffer)
+{
+	int ret = 0;
+
+#define SHOW_PID_OBJ(__type, __field)					\
+	do {								\
+		ret += sprintf(buffer + ret, "%-10s:%lu\n",		\
+				#__type,				\
+				gen_obj_id(task->__field,		\
+					GEN_OBJ_ID_##__type));		\
+	} while (0)
+
+	SHOW_PID_OBJ(VM, mm);
+	SHOW_PID_OBJ(FILES, files);
+	SHOW_PID_OBJ(FS, fs);
+	SHOW_PID_OBJ(SIGHAND, sighand);
+	SHOW_PID_OBJ(IO, io_context);
+	SHOW_PID_OBJ(SYSVSEM, sysvsem.undo_list);
+
+#undef SHOW_PID_OBJ
+
+	return ret;
+}
+#endif /* CONFIG_GENERIC_OBJECT_ID */
+
 static int proc_pid_auxv(struct task_struct *task, char *buffer)
 {
 	struct mm_struct *mm = mm_for_maps(task);
@@ -3173,6 +3199,9 @@ static const struct pid_entry tgid_base_
 	INF("syscall",    S_IRUGO, proc_pid_syscall),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
+#ifdef CONFIG_GENERIC_OBJECT_ID
+	INF("objects",    S_IRUGO, proc_pid_objs),
+#endif
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_maps_operations),
Index: linux-2.6.git/include/linux/gen_obj_id.h
===================================================================
--- linux-2.6.git.orig/include/linux/gen_obj_id.h
+++ linux-2.6.git/include/linux/gen_obj_id.h
@@ -6,6 +6,12 @@
 enum {
 	GEN_OBJ_ID_FILE,
 	GEN_OBJ_ID_NS,
+	GEN_OBJ_ID_VM,
+	GEN_OBJ_ID_FILES,
+	GEN_OBJ_ID_FS,
+	GEN_OBJ_ID_SIGHAND,
+	GEN_OBJ_ID_IO,
+	GEN_OBJ_ID_SYSVSEM,
 	GEN_OBJ_ID_TYPES,
 };
 

