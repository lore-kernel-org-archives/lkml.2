Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0ESBkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:40:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:41178 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0ESBkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:13 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 23/25] debug_core,kdb: Allow the debug core to process a recursive debug entry
Date: Tue, 18 May 2010 20:39:33 -0500
Message-Id: <1274233175-3675-24-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:00.0954 (UTC) FILETIME=[324869A0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows kdb to debug a crash with in the kms code with a
single level recursive re-entry.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index fff5901..b38bb25 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -445,6 +445,10 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 	}
 
 	printk(KERN_CRIT "KGDB: re-enter exception: ALL breakpoints killed\n");
+#ifdef CONFIG_KGDB_KDB
+	/* Allow kdb to debug itself one level */
+	return 0;
+#endif
 	dump_stack();
 	panic("Recursive entry to debugger");
 
@@ -489,6 +493,9 @@ acquirelock:
 	 */
 	atomic_inc(&cpu_in_kgdb[cpu]);
 
+	if (exception_level == 1)
+		goto cpu_master_loop;
+
 	/*
 	 * CPU will loop if it is a slave or request to become a kgdb
 	 * master cpu and acquire the kgdb_active lock:
-- 
1.6.3.3

