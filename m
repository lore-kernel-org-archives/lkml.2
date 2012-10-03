Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2JCLYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:24:07 -0400
Received: from mout.web.de ([212.227.17.11]:50107 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2JCLWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:10 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 11/13] scripts/gdb: Add get_gdbserver_type helper
Date: Wed,  3 Oct 2012 13:21:42 +0200
Message-Id: <dc74efefe70641d6217695394b080823050c41d6.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:fgKSUnURVSEkKIERNN3Lg6UnG6YewzKUaA98UnuyOwn
 +dYvN/Yt+p40tjYFfq9wx8h3SY3o8Tinn2aUvExH1oaYgwSmNn
 FvyLdf6fa5gX0gw+ITZWHK2nVZfs7T7GEhggmbiGIOzpXVekir
 8LPR+N/kYb4ty9LpDWtsrel7OhXNM98f8bgFcWrquQkbM6BoYQ
 pIHQKtjoek9UR4sU/EMDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This helper probes the type of the gdb server. Supported are QEMU and
KGDB so far. Knowledge about the gdb server is required e.g. to retrieve
the current CPU or current task.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 7c09787..6558a80 100644
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

