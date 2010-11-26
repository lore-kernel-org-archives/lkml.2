Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0KZI1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:27:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:34979 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0KZI07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:26:59 -0500
From: Dongdong Deng <libfetion@gmail.com>
To: jason.wessel@windriver.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        yong.zhang0@gmail.com, libfetion@gmail.com
Subject: [PATCH 1/2] debug_core: add a memory barrier before atomic_inc(&slaves_in_kgdb)
Date: Fri, 26 Nov 2010 16:28:26 +0800
Message-Id: <78b0196768a81236ed514577fc7dcc96bd1b7b03.1290742567.git.dongdong.deng@windriver.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 26 Nov 2010 08:26:48.0177 (UTC) FILETIME=[AB055610:01CB8D43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atomic_inc operation of slaves_in_kgdb could be executed on
multi-cpus at the same time when kgdb have more than one slave
cpu.

Due to the atomic_inc() function do not imply memory barrier,
a missing memory barrier here maybe could casue an incorrect
value of slaves_in_kgdb, then let kgdb confused.

Add a memory barrier before atomic_inc(&slaves_in_kgdb) to
avoid that potential problem.

Signed-off-by: Dongdong Deng <libfetion@gmail.com>
---
 kernel/debug/debug_core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index cefd4a1..bec8af0 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -468,10 +468,13 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
 	kgdb_info[ks->cpu].enter_kgdb++;
 	kgdb_info[ks->cpu].exception_state |= exception_state;
 
-	if (exception_state == DCPU_WANT_MASTER)
+	if (exception_state == DCPU_WANT_MASTER) {
+		smp_mb__before_atomic_inc();
 		atomic_inc(&masters_in_kgdb);
-	else
+	} else {
+		smp_mb__before_atomic_inc();
 		atomic_inc(&slaves_in_kgdb);
+	}
 
 	if (arch_kgdb_ops.disable_hw_break)
 		arch_kgdb_ops.disable_hw_break(regs);
-- 
1.6.0.4

