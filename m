Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2A3XPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:15:01 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58357 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab2A3XO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:14:59 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 2/4] PM/Freezer: Make thaw_processes() thaw only userspace
 tasks
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 04:44:48 +0530
Message-ID: <20120130231437.11129.3708.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
References: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12013023-4790-0000-0000-00000118E062
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the situation is:

freeze_processes() - freezes only userspace tasks
freeze_kernel_threads() - freezes only kernel threads
thaw_kernel_threads() - thaws only kernel threads
thaw_processes() - thaws *everything* (both userspace tasks and kernel threads)

The point that thaw_processes() thaws everything is rather unintuitive
and can lead to bugs. So, modify thaw_processes() so that it thaws only
userspace processes. This way we can also have more control over what
exactly gets thawed in different situations.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/power/process.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 3734fb9..8ae6c4b 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -116,7 +116,8 @@ static int try_to_freeze_tasks(bool user_only)
 /**
  * freeze_processes - Signal user space processes to enter the refrigerator.
  *
- * On success, returns 0.  On failure, -errno and system is fully thawed.
+ * On success, returns 0.  On failure, -errno and all user space processes
+ * are thawed.
  */
 int freeze_processes(void)
 {
@@ -170,17 +171,15 @@ void thaw_processes(void)
 	if (pm_freezing)
 		atomic_dec(&system_freezing_cnt);
 	pm_freezing = false;
-	pm_nosig_freezing = false;
 
 	oom_killer_enable();
 
 	printk("Restarting tasks ... ");
 
-	thaw_workqueues();
-
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
-		__thaw_task(p);
+		if (!(p->flags & (PF_KTHREAD | PF_WQ_WORKER)))
+			__thaw_task(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 

