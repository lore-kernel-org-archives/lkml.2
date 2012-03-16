Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693Ab2CPMRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:17:48 -0400
Received: from david.siemens.de ([192.35.17.14]:28481 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab2CPMRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:17:32 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/4] kgdb: Make gdbstub_exit a nop unless gdb is attached
Date: Fri, 16 Mar 2012 13:17:12 +0100
Message-Id: <c0c7d3cced4ab0b8b00d452cd9fd99c085fc513e.1331900215.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1331900215.git.jan.kiszka@siemens.com>
References: <cover.1331900215.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1331900215.git.jan.kiszka@siemens.com>
References: <cover.1331900215.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to call gdbstub_exit without worrying if
 - CONFIG_KGDB is enabled
 - if an kgdb I/O driver is loaded
 - if a gdb frontend is currently attached

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 include/linux/kgdb.h   |    1 +
 kernel/debug/gdbstub.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index fa39183..16410e2 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -306,6 +306,7 @@ extern atomic_t			kgdb_active;
 extern bool dbg_is_early;
 extern void __init dbg_late_init(void);
 #else /* ! CONFIG_KGDB */
+static inline void gdbstub_exit(int status) { }
 #define in_dbg_master() (0)
 #define dbg_late_init()
 #endif /* ! CONFIG_KGDB */
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index c22d8c2..5d7ed0a 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -1111,6 +1111,9 @@ void gdbstub_exit(int status)
 	unsigned char checksum, ch, buffer[3];
 	int loop;
 
+	if (!dbg_io_ops || !kgdb_connected)
+		return;
+
 	buffer[0] = 'W';
 	buffer[1] = hex_asc_hi(status);
 	buffer[2] = hex_asc_lo(status);
-- 
1.7.3.4

