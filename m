Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2JCLYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:24:46 -0400
Received: from mout.web.de ([212.227.17.12]:57864 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab2JCLWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:22:01 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Kay Sievers <kay@vrfy.org>
Subject: [PATCH 06/13] scripts/gdb: Add lx-dmesg command
Date: Wed,  3 Oct 2012 13:21:37 +0200
Message-Id: <805b20bb0e1fb1ec06acf8e50237cdb40dd54290.1349263293.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
In-Reply-To: <cover.1349263293.git.jan.kiszka@web.de>
References: <cover.1349263293.git.jan.kiszka@web.de>
X-Provags-ID: V02:K0:7vpseFInKTcydlRk6JQZXn6V1MLA/2t6AwoDF8hgvno
 5ctRuF+A4kEKrpM+rXVJhP3Au3hM8iytumbA47yLA9dXjOQY5/
 xn78KjcvJJuGFK5iK449BCWGL1g05O2f2QUNrWYT7krR3RMY3w
 UiDuv93zj9KFcurSYvTPXogph2wiQ088szrWLzt2zYDbnRIr4M
 bppBOd0FyErfJj+WICCDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This pokes into the log buffer of the debugged kernel, dumping it to the
gdb console. Helping in case the target should or can no longer execute
dmesg itself.

CC: Kay Sievers <kay@vrfy.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/dmesg.py       |   63 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/gdb/vmlinux-gdb.py |    1 +
 2 files changed, 64 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/dmesg.py

diff --git a/scripts/gdb/dmesg.py b/scripts/gdb/dmesg.py
new file mode 100644
index 0000000..2f475bc
--- /dev/null
+++ b/scripts/gdb/dmesg.py
@@ -0,0 +1,63 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  kernel log buffer dump
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
+import string
+
+from utils import *
+
+class LinuxDmesg(gdb.Command):
+	__doc__ = "Print Linux kernel log buffer."
+
+	def __init__(self):
+		super(LinuxDmesg, self).__init__("lx-dmesg", gdb.COMMAND_DATA)
+
+	def invoke(self, arg, from_tty):
+		log_buf_addr = int(str(gdb.parse_and_eval("(void *)log_buf")),
+				   16)
+		log_first_idx = int(gdb.parse_and_eval("log_first_idx"))
+		log_next_idx = int(gdb.parse_and_eval("log_next_idx"))
+		log_buf_len = int(gdb.parse_and_eval("log_buf_len"))
+
+		inf = gdb.inferiors()[0]
+		start = log_buf_addr + log_first_idx
+		if log_first_idx < log_next_idx:
+			log_buf_2nd_half = -1
+			length = log_next_idx - log_first_idx
+			log_buf = inf.read_memory(start, length)
+		else:
+			log_buf_2nd_half = log_buf_len - log_first_idx
+			log_buf = inf.read_memory(start, log_buf_2nd_half) + \
+				  inf.read_memory(log_buf_addr, log_next_idx)
+
+		pos = 0
+		while pos < log_buf.__len__():
+			length = read_u16(log_buf[pos + 8 : pos + 10])
+			if length == 0:
+				if log_buf_2nd_half == -1:
+					print "Corrupted log buffer!"
+					break
+				pos = log_buf_2nd_half
+				continue
+
+			text_len = read_u16(log_buf[pos + 10 : pos + 12])
+			time_stamp = read_u64(log_buf[pos : pos + 8])
+
+			for line in log_buf[pos + 16 :
+					    pos + 16 + text_len].splitlines():
+				print "[%13.6f] " % \
+				      (time_stamp / 1000000000.0) + line
+
+			pos += length
+
+LinuxDmesg()
diff --git a/scripts/gdb/vmlinux-gdb.py b/scripts/gdb/vmlinux-gdb.py
index fa1d5e1..8b0422e 100644
--- a/scripts/gdb/vmlinux-gdb.py
+++ b/scripts/gdb/vmlinux-gdb.py
@@ -21,3 +21,4 @@ if not gdb.VERSION >= "7.1":
 else:
 	import utils
 	import symbols
+	import dmesg
-- 
1.7.3.4

