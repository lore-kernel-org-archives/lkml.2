Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab2K0KO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:14:28 -0500
Received: from goliath.siemens.de ([192.35.17.28]:23765 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498Ab2K0KMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:12:05 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>
Subject: [PATCH v3 07/13] scripts/gdb: Add task iteration helper
Date: Tue, 27 Nov 2012 11:11:38 +0100
Message-Id: <34f877885ccb44005367d5b80264a775ecd5d196.1354011091.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1354011091.git.jan.kiszka@siemens.com>
References: <cover.1354011091.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

