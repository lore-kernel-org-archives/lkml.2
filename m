Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2JCLWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:22:18 -0400
Received: from mout.web.de ([212.227.17.11]:64360 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab2JCLWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:11 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 08/13] scripts/gdb: Add helper and convenience function to look up tasks
Date: Wed,  3 Oct 2012 13:21:39 +0200
Message-Id: <a140d14bac49d6dec8c65f1b980084fdaf37935f.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:h8fzW/0x+HdN/+PIqVQf5d3WOHfEg65k/lPVpa5iYB5
 7MKFrFWufgHEwBJ6dLJOWBUjYPry6Z6yCD0yuqAFLUuxuQ63XR
 EYZEZyPX1AWIhx0K5X8QkXSQ8NEqjRDZEzna4PtcsHBnGGhj+L
 ON03V97hve6WWboSobV5dmR81Jcf/nAJEr5w71DHzXIw3/O54C
 N4Y0lsSZ2TGXPWP7AULkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Add the helper task_by_pid that can look up a task by its PID. Also
export it as a convenience function.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/task.py        |   29 +++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/task.py b/scripts/gdb/task.py
index 1e4f61e..41d85cc 100644
--- a/scripts/gdb/task.py
+++ b/scripts/gdb/task.py
@@ -38,3 +38,32 @@ def for_each_task(func, arg = None):
 					 get_task_ptr_type(), "thread_group")
 			if t == g:
 				break
+
+def get_task_by_pid(pid):
+	def match_pid(t, arg):
+		if int(t['pid']) == arg['pid']:
+			arg['task'] = t
+
+	arg = { 'pid': pid, 'task': None }
+	for_each_task(match_pid, arg)
+
+	return arg['task']
+
+
+class LxTaskByPidFunc(gdb.Function):
+	__doc__ = "Find Linux task by PID and return the task_struct variable.\n" \
+		  "\n" \
+		  "$lx_task_by_pid(PID): Given PID, iterate over all tasks of the target and\n" \
+		  "return that task_struct variable which PID matches.\n"
+
+	def __init__(self):
+		super(LxTaskByPidFunc, self).__init__("lx_task_by_pid")
+
+	def invoke(self, pid):
+		task = get_task_by_pid(pid)
+		if task:
+			return task.dereference()
+		else:
+			raise gdb.GdbError("No task of PID " + str(pid))
+
+LxTaskByPidFunc()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index 8b0422e..deaf652 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -22,3 +22,4 @@ else:
 	import utils
 	import symbols
 	import dmesg
+	import task
-- 
1.7.3.4

