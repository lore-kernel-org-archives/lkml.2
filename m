Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0KZJNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:13:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:44602 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab0KZJN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:13:29 -0500
From: Dongdong Deng <libfetion@gmail.com>
To: jason.wessel@windriver.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        libfetion@gmail.com
Subject: [PATCH] debug_core: cleanup kgdb_cpu_enter() that removing smp_mb()
Date: Fri, 26 Nov 2010 17:14:58 +0800
Message-Id: <1290762898-26978-1-git-send-email-libfetion@gmail.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 26 Nov 2010 09:13:18.0351 (UTC) FILETIME=[2A1819F0:01CB8D4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit dfee3a7b92208b30f77876068aece9ea571270c2(debug_core:
refactor locking for master/slave cpus) uses spin_lock to replace
the atomic counter lock mechanism, and most kgdb data was designed
to per-cpu, thus the 'smp_mb()' operation is useless here now.

Signed-off-by: Dongdong Deng <libfetion@gmail.com>
---
 kernel/debug/debug_core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 722968f..1b019b5 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -492,9 +492,6 @@ acquirelock:
 	kgdb_info[cpu].ret_state = 0;
 	kgdb_info[cpu].irq_depth = hardirq_count() >> HARDIRQ_SHIFT;
 
-	/* Make sure the above info reaches the primary CPU */
-	smp_mb();
-
 	if (exception_level == 1) {
 		if (raw_spin_trylock(&dbg_master_lock))
 			atomic_xchg(&kgdb_active, cpu);
-- 
1.6.0.4

