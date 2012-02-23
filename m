Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2BWTjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:39:16 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48608 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2BWTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:39:14 -0500
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 14:39:14 EST
From: Arun Raghavan <arun.raghavan@collabora.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>
Subject: [PATCH] [RESEND] rlimits: Print more information when limits are exceeded
Date: Fri, 24 Feb 2012 00:59:38 +0530
Message-Id: <1330025378-26075-1-git-send-email-arun.raghavan@collabora.co.uk>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This dumps some information in logs when a process exceeds its CPU or RT
limits (soft and hard). Makes debugging easier when userspace triggers
these limits.

Signed-off-by: Arun Raghavan <arun.raghavan@collabora.co.uk>
---
 kernel/posix-cpu-timers.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 125cb67..bb0ae71 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -956,6 +956,9 @@ static void check_thread_timers(struct task_struct *tsk,
 			 * At the hard limit, we just die.
 			 * No need to calculate anything else now.
 			 */
+			printk(KERN_INFO
+				"RT Watchdog Timeout (hard): %s[%d]\n",
+				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
@@ -968,7 +971,7 @@ static void check_thread_timers(struct task_struct *tsk,
 				sig->rlim[RLIMIT_RTTIME].rlim_cur = soft;
 			}
 			printk(KERN_INFO
-				"RT Watchdog Timeout: %s[%d]\n",
+				"RT Watchdog Timeout (soft): %s[%d]\n",
 				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
 		}
@@ -1116,6 +1119,9 @@ static void check_process_timers(struct task_struct *tsk,
 			 * At the hard limit, we just die.
 			 * No need to calculate anything else now.
 			 */
+			printk(KERN_INFO
+				"CPU Watchdog Timeout (hard): %s[%d]\n",
+				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
@@ -1123,6 +1129,9 @@ static void check_process_timers(struct task_struct *tsk,
 			/*
 			 * At the soft limit, send a SIGXCPU every second.
 			 */
+			printk(KERN_INFO
+				"CPU Watchdog Timeout (soft): %s[%d]\n",
+				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
 			if (soft < hard) {
 				soft++;
-- 
1.7.8.4

