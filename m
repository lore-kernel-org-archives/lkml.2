Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab2JCLW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:22:27 -0400
Received: from mout.web.de ([212.227.17.12]:60763 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab2JCLWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:14 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Subject: [PATCH 10/13] scripts/gdb: Add internal helper and convenience function to retrieve thread_info
Date: Wed,  3 Oct 2012 13:21:41 +0200
Message-Id: <1929cc69bb7bf62887dbe1a4751e51742aff64b0.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:gIVQ+u6LLgv29uv1d/PYMvy4mFqpuXwNhdbgfEEoPr1
 01xBeTZFaVU+Yexp0Y6gzYlq7s60t3uqQyGJssIdJh+0ZdOkJ2
 mwHt9yPeWBkxiukAcjRILNQ8GoZ8tfKE2DDxoBsTLxgTD53iMf
 Yzendy7fS+i0Kpn/3Itx00Cia906rRNOmNmyZ+CN8rifIwnZw2
 yuF0GNXNBFiif9M0qNV8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Add the internal helper get_thread_info that calculated the thread_info
from a given task variable. Also export this service as a convenience
function.

Note: ia64 version is untested.

CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
CC: linux-ia64@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/task.py |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/task.py b/scripts/gdb/task.py
index 41d85cc..523e495 100644
--- a/scripts/gdb/task.py
+++ b/scripts/gdb/task.py
@@ -67,3 +67,42 @@ class LxTaskByPidFunc(gdb.Function):
 			raise gdb.GdbError("No task of PID " + str(pid))
 
 LxTaskByPidFunc()
+
+
+thread_info_ptr_type = None
+
+def get_thread_info_ptr_type():
+	global thread_info_ptr_type
+	if thread_info_ptr_type == None:
+		thread_info_ptr_type = get_type('struct thread_info').pointer()
+	return thread_info_ptr_type
+
+ia64_task_size = None
+
+def get_thread_info(task):
+	if is_target_arch("ia64"):
+		global ia64_task_size
+		if ia64_task_size == None:
+			ia64_task_size = gdb.parse_and_eval(
+						"sizeof(struct task_struct)")
+		thread_info_addr = task.address + ia64_task_size
+		thread_info = thread_info_addr.cast(get_thread_info_ptr_type())
+	else:
+		thread_info = task['stack'].cast(get_thread_info_ptr_type())
+	return thread_info.dereference()
+
+
+class LxThreadInfoFunc (gdb.Function):
+	# Calculate Linux thread_info from task variable.
+	__doc__ = "Calculate Linux thread_info from task variable.\n" \
+		  "\n" \
+		  "$lx_thread_info(TASK): Given TASK, return the corresponding thread_info\n" \
+		  "variable.\n"
+
+	def __init__(self):
+		super(LxThreadInfoFunc, self).__init__("lx_thread_info")
+
+	def invoke(self, task):
+		return get_thread_info(task)
+
+LxThreadInfoFunc()
-- 
1.7.3.4

