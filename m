Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab2KQQiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 11:38:05 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42423 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2KQQiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 11:38:04 -0500
From: Nick Kossifidis <mickflemm@gmail.com>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH] random: Mix cputime from each thread that exits to the pool
Date: Sat, 17 Nov 2012 18:37:29 +0200
Message-Id: <1353170249-1004-1-git-send-email-mickflemm@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a thread exits mix it's cputime (userspace + kernelspace) to the entropy pool.

We don't know how "random" this is, so we use add_device_randomness that doesn't mess
with entropy count.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 kernel/posix-cpu-timers.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 125cb67..f07827a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -9,6 +9,7 @@
 #include <asm/uaccess.h>
 #include <linux/kernel_stat.h>
 #include <trace/events/timer.h>
+#include <linux/random.h>
 
 /*
  * Called after updating RLIMIT_CPU to run cpu timer and update
@@ -494,6 +495,8 @@ static void cleanup_timers(struct list_head *head,
  */
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
+	add_device_randomness((const void*) &tsk->se.sum_exec_runtime,
+						sizeof(unsigned long long));
 	cleanup_timers(tsk->cpu_timers,
 		       tsk->utime, tsk->stime, tsk->se.sum_exec_runtime);
 
-- 
1.7.8.6

