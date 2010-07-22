Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0GVAh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:37:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:59980 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab0GVAhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:37:13 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 4/5] debug_core,kdb: fix kgdb_connected bit set in the wrong place
Date: Wed, 21 Jul 2010 19:36:14 -0500
Message-Id: <1279758975-16658-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1279758975-16658-4-git-send-email-jason.wessel@windriver.com>
References: <1279758975-16658-1-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-2-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-3-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Jul 2010 00:36:33.0549 (UTC) FILETIME=[EF5483D0:01CB2935]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Immediately following an exit from the kdb shell the kgdb_connected
variable should be set to zero, unless there are breakpoints planted.
If the kgdb_connected variable is not zeroed out with kdb, it is
impossible to turn off kdb.

This patch is merely a work around for now, the real fix will check
for the breakpoints.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 5cb7cd1..8bc5eef 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -605,13 +605,13 @@ cpu_master_loop:
 		if (dbg_kdb_mode) {
 			kgdb_connected = 1;
 			error = kdb_stub(ks);
+			kgdb_connected = 0;
 		} else {
 			error = gdb_serial_stub(ks);
 		}
 
 		if (error == DBG_PASS_EVENT) {
 			dbg_kdb_mode = !dbg_kdb_mode;
-			kgdb_connected = 0;
 		} else if (error == DBG_SWITCH_CPU_EVENT) {
 			dbg_cpu_switch(cpu, dbg_switch_cpu);
 			goto cpu_loop;
-- 
1.6.3.3

