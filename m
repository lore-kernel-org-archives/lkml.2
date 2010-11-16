Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0KPQdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:33:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50694 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab0KPQdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:33:22 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sergio Aguirre <saaguirre@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [RFC][PATCH] futex: Hide false positive about uninit var usage
Date: Tue, 16 Nov 2010 10:32:37 -0600
Message-Id: <1289925157-17054-1-git-send-email-saaguirre@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In exit_robust_list, there was this warning shown:

kernel/futex.c: In function 'exit_robust_list':
kernel/futex.c:2492: warning: 'next_pi' may be used uninitialized in this function

Which is a false positive, since in the function, the only scenario
possible in which the var is read, is after a successful excecution of
fetch_robust_entry, which populates the variable.

So there's no real possibility of it being used uninitialized.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
---
 kernel/futex.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6c683b3..3646157 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2489,7 +2489,8 @@ void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
 	struct robust_list __user *entry, *next_entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi;
+	unsigned int uninitialized_var(next_pi), pip;
 	unsigned long futex_offset;
 	int rc;
 
-- 
1.7.0.4

