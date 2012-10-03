Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2JCLWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:22:24 -0400
Received: from mout.web.de ([212.227.15.4]:61335 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab2JCLWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:11 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 07/13] scripts/gdb: Add task iteration helper
Date: Wed,  3 Oct 2012 13:21:38 +0200
Message-Id: <3b3d21da348b3c0fcb83682fe29a7de18b167f39.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:XzUTwk9uKnd1SN133ESbjyaqwJ2BJDqMwENULLrS9Sp
 Byq4iMQQtZuxJ4a+LgzF4qeq6lV3YLZS4BtLVVyjWZ7TAFp8zK
 GBSyyGJPNXjxsF2Ald65jgDrV8QpXVcuAg7psZO0FYqjC3ZmhL
 YOVszEl9JG3mE+3nrPgO/TDEU+NBl9ROXcgIMsJGdiIMQg89tw
 sLnIEtugk9vZ+w5LrNbLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

The internal helper for_each_task iterates over all tasks of the target,
calling the provided function on each. For performance reasons, we cache
a reference to the gdb type object of a task.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/task.py |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/task.py

diff --git a/scripts/gdb/task.py b/scripts/gdb/task.py
new file mode 100644
index 0000000..1e4f61e
--- /dev/null
+++ b/scripts/gdb/task.py
@@ -0,0 +1,40 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  task & thread tools
+#
+# Copyright (c) 2011, 2012 Siemens AG
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+
+from utils import *
+
+task_ptr_type = None
+
+def get_task_ptr_type():
+	global task_ptr_type
+	if task_ptr_type == None:
+		task_ptr_type = get_type("struct task_struct").pointer()
+	return task_ptr_type
+
+def for_each_task(func, arg = None):
+	init_task = gdb.parse_and_eval("init_task")
+	g = init_task.address
+	while True:
+		g =  container_of(g['tasks']['next'], get_task_ptr_type(),
+				  "tasks")
+		if g == init_task.address:
+			break;
+		t = g
+		while True:
+			func(t, arg)
+			t = container_of(t['thread_group']['next'],
+					 get_task_ptr_type(), "thread_group")
+			if t == g:
+				break
-- 
1.7.3.4

