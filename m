Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab2K0KPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:15:17 -0500
Received: from goliath.siemens.de ([192.35.17.28]:23737 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462Ab2K0KME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:12:04 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>
Subject: [PATCH v3 08/13] scripts/gdb: Add helper and convenience function to look up tasks
Date: Tue, 27 Nov 2012 11:11:39 +0100
Message-Id: <1d03b2331777e7839f2f8245433b4869d018a7b2.1354011091.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 8af7084..1a9b293 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -24,3 +24,4 @@ else:
 	import utils
 	import symbols
 	import dmesg
+	import task
-- 
1.7.3.4

