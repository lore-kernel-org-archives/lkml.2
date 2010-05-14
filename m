Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0ENENW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:13:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35277 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0ENELd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:11:33 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Matt Helsley <matthltc@us.ibm.com>
Subject: [PATCH 3/8] PM: suspend_block: Abort task freezing if a suspend_blocker is active.
Date: Thu, 13 May 2010 21:11:08 -0700
Message-Id: <1273810273-3039-4-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1273810273-3039-3-git-send-email-arve@android.com>
References: <1273810273-3039-1-git-send-email-arve@android.com>
 <1273810273-3039-2-git-send-email-arve@android.com>
 <1273810273-3039-3-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a suspend_blocker is active, suspend will fail anyway. Since
try_to_freeze_tasks can take up to 20 seconds to complete or fail, aborting
as soon as someone blocks suspend (e.g. from an interrupt handler) improves
the worst case wakeup latency.

On an older kernel where task freezing could fail for processes attached
to a debugger, this fixed a problem where the device sometimes hung for
20 seconds before the screen turned on.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 71ae290..27d26d3 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -38,6 +38,7 @@ static int try_to_freeze_tasks(bool sig_only)
 	struct timeval start, end;
 	u64 elapsed_csecs64;
 	unsigned int elapsed_csecs;
+	bool wakeup = false;
 
 	do_gettimeofday(&start);
 
@@ -63,6 +64,10 @@ static int try_to_freeze_tasks(bool sig_only)
 				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
+		if (todo && suspend_is_blocked()) {
+			wakeup = true;
+			break;
+		}
 		if (!todo || time_after(jiffies, end_time))
 			break;
 
@@ -85,13 +90,15 @@ static int try_to_freeze_tasks(bool sig_only)
 		 * but it cleans up leftover PF_FREEZE requests.
 		 */
 		printk("\n");
-		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
+		printk(KERN_ERR "Freezing of tasks %s after %d.%02d seconds "
 				"(%d tasks refusing to freeze):\n",
+				wakeup ? "aborted" : "failed",
 				elapsed_csecs / 100, elapsed_csecs % 100, todo);
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			task_lock(p);
-			if (freezing(p) && !freezer_should_skip(p))
+			if (freezing(p) && !freezer_should_skip(p)
+					&& elapsed_csecs > 100)
 				sched_show_task(p);
 			cancel_freezing(p);
 			task_unlock(p);
-- 
1.6.5.1

