Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0KRM4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:56:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:53233 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab0KRM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:56:12 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 3/4] kgdb,x86: fix regression in detach handling
Date: Thu, 18 Nov 2010 06:56:02 -0600
Message-Id: <1290084963-6376-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290084963-6376-1-git-send-email-jason.wessel@windriver.com>
References: <1290084963-6376-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Nov 2010 12:55:25.0510 (UTC) FILETIME=[DE652E60:01CB871F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fix from ba773f7c510c0b252145933926c636c439889207
(x86,kgdb: Fix hw breakpoint regression) was not entirely complete.

The kgdb_remove_all_hw_break() function also needs to call the
hw_break_release_slot() or else a breakpoint can get activated again
after the debugger has detached.

The kgdb test suite exposes the behavior in the form of either a hang
or repetitive failure.  The kernel config that exposes the problem
contains all of the following:

CONFIG_DEBUG_RODATA=y
CONFIG_KGDB_TESTS=y
CONFIG_KGDB_TESTS_ON_BOOT=y
CONFIG_KGDB_TESTS_BOOT_STRING="V1F100"

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/kgdb.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index ec592ca..cd21b65 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -315,14 +315,18 @@ static void kgdb_remove_all_hw_break(void)
 		if (!breakinfo[i].enabled)
 			continue;
 		bp = *per_cpu_ptr(breakinfo[i].pev, cpu);
-		if (bp->attr.disabled == 1)
+		if (!bp->attr.disabled) {
+			arch_uninstall_hw_breakpoint(bp);
+			bp->attr.disabled = 1;
 			continue;
+		}
 		if (dbg_is_early)
 			early_dr7 &= ~encode_dr7(i, breakinfo[i].len,
 						 breakinfo[i].type);
-		else
-			arch_uninstall_hw_breakpoint(bp);
-		bp->attr.disabled = 1;
+		else if (hw_break_release_slot(i))
+			printk(KERN_ERR "KGDB: hw bpt remove failed %lx\n",
+			       breakinfo[i].addr);
+		breakinfo[i].enabled = 0;
 	}
 }
 
-- 
1.7.0.4

