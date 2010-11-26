Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0KZI1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:27:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:34980 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0KZI07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:26:59 -0500
From: Dongdong Deng <libfetion@gmail.com>
To: jason.wessel@windriver.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        yong.zhang0@gmail.com, libfetion@gmail.com
Subject: [PATCH 2/2] debug_core: replace atomic_set() with atomic_xchg() for atomic kgdb_active
Date: Fri, 26 Nov 2010 16:28:27 +0800
Message-Id: <ebd30eb40bc876676f905c1d5db687b0f0627580.1290742567.git.dongdong.deng@windriver.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <78b0196768a81236ed514577fc7dcc96bd1b7b03.1290742567.git.dongdong.deng@windriver.com>
References: <78b0196768a81236ed514577fc7dcc96bd1b7b03.1290742567.git.dongdong.deng@windriver.com>
In-Reply-To: <78b0196768a81236ed514577fc7dcc96bd1b7b03.1290742567.git.dongdong.deng@windriver.com>
References: <78b0196768a81236ed514577fc7dcc96bd1b7b03.1290742567.git.dongdong.deng@windriver.com>
X-OriginalArrivalTime: 26 Nov 2010 08:26:50.0193 (UTC) FILETIME=[AC38F410:01CB8D43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atomic_set() don't imply memory barriers, therefor the single
stepping processor could not observe the changing of kgdb_active
value which was done at other cpu immediately.

Using atomic_xchg() to replace atomic_set() to change kgdb_active,
as it implys the memory barrier semantics around the atomic_xchg().

Signed-off-by: Dongdong Deng <libfetion@gmail.com>
---
 kernel/debug/debug_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index bec8af0..722968f 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -548,7 +548,7 @@ return_normal:
 	if (atomic_read(&kgdb_cpu_doing_single_step) != -1 &&
 	    (kgdb_info[cpu].task &&
 	     kgdb_info[cpu].task->pid != kgdb_sstep_pid) && --sstep_tries) {
-		atomic_set(&kgdb_active, -1);
+		atomic_xchg(&kgdb_active, -1);
 		raw_spin_unlock(&dbg_master_lock);
 		dbg_touch_watchdogs();
 		local_irq_restore(flags);
@@ -657,7 +657,7 @@ kgdb_restore:
 	smp_mb__before_atomic_dec();
 	atomic_dec(&masters_in_kgdb);
 	/* Free kgdb_active */
-	atomic_set(&kgdb_active, -1);
+	atomic_xchg(&kgdb_active, -1);
 	raw_spin_unlock(&dbg_master_lock);
 	dbg_touch_watchdogs();
 	local_irq_restore(flags);
-- 
1.6.0.4

