Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685Ab0HEOi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:38:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:41184 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760635Ab0HEOii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:38 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Dongdong Deng <dongdong.deng@windriver.com>
Subject: [PATCH 08/17] gdbstub: do not directly use dbg_reg_def[] in gdb_cmd_reg_set()
Date: Thu,  5 Aug 2010 09:37:49 -0500
Message-Id: <1281019078-6636-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:17.0574 (UTC) FILETIME=[D7DBA860:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presently the usable registers definitions on x86 are not contiguous
for kgdb.  The x86 kgdb uses a case statement for the sparse register
accesses.  The array which defines the registers (dbg_reg_def) should
not be used directly in order to safely work with sparse register
definitions.

Specifically there was a problem when gdb accesses ORIG_AX, which is
accessed only through the case statement.

This patch encodes register memory using the size information provided
from the debugger which avoids the need to look up the size of the
register.  The dbg_set_reg() function always further validates the
inputs from the debugger.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
---
 kernel/debug/gdbstub.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 4ef9ddd..fc7b174 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -604,6 +604,7 @@ static void gdb_cmd_reg_set(struct kgdb_state *ks)
 {
 	unsigned long regnum;
 	char *ptr = &remcom_in_buffer[1];
+	int i = 0;
 
 	kgdb_hex2long(&ptr, &regnum);
 	if (*ptr++ != '=' ||
@@ -612,7 +613,14 @@ static void gdb_cmd_reg_set(struct kgdb_state *ks)
 		error_packet(remcom_out_buffer, -EINVAL);
 		return;
 	}
-	kgdb_hex2mem(ptr, (char *)gdb_regs, dbg_reg_def[regnum].size);
+	memset(gdb_regs, 0, sizeof(gdb_regs));
+	while (i < sizeof(gdb_regs) * 2)
+		if (hex_to_bin(ptr[i]) >= 0)
+			i++;
+		else
+			break;
+	i = i / 2;
+	kgdb_hex2mem(ptr, (char *)gdb_regs, i);
 	dbg_set_reg(regnum, gdb_regs, ks->linux_regs);
 	strcpy(remcom_out_buffer, "OK");
 }
-- 
1.6.3.3

