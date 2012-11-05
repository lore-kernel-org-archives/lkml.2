Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2KEQJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:09:39 -0500
Received: from david.siemens.de ([192.35.17.14]:32411 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab2KEQJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:09:28 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 11/13] scripts/gdb: Add get_gdbserver_type helper
Date: Mon,  5 Nov 2012 17:09:04 +0100
Message-Id: <becdbf7b653665a2fe05eaaa58d2fd97ca3de077.1352131731.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1352131729.git.jan.kiszka@siemens.com>
References: <cover.1352131729.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper probes the type of the gdb server. Supported are QEMU and
KGDB so far. Knowledge about the gdb server is required e.g. to retrieve
the current CPU or current task.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 31aaf53..ca60187 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -97,3 +97,38 @@ def is_target_arch(arch):
 	if target_arch == None:
 		target_arch = gdb.execute("show architecture", False, True)
 	return target_arch.find(arch) >= 0
+
+
+GDBSERVER_QEMU = 0
+GDBSERVER_KGDB = 1
+gdbserver_type = None
+
+def get_gdbserver_type():
+	def exit_handler(event):
+		global gdbserver_type
+		gdbserver_type = None
+		gdb.events.exited.disconnect(exit_handler)
+
+	def probe_qemu():
+		try:
+			return gdb.execute("monitor info version", False,
+					   True) != ""
+		except:
+			return False
+
+	def probe_kgdb():
+		try:
+			thread_info = gdb.execute("info thread 2", False, True)
+			return thread_info.find("shadowCPU0") >= 0
+		except:
+			return False
+
+	global gdbserver_type
+	if gdbserver_type == None:
+		if probe_qemu():
+			gdbserver_type = GDBSERVER_QEMU
+		elif probe_kgdb():
+			gdbserver_type = GDBSERVER_KGDB
+		if gdbserver_type != None:
+			gdb.events.exited.connect(exit_handler)
+	return gdbserver_type
-- 
1.7.3.4

