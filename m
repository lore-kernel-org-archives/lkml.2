Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2A3WFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:05:09 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34167 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2A3WFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:05:06 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 1/4] PM/Freezer: Make thaw_processes() thaw only userspace
 tasks
To: rjw@sisk.pl
Cc: pavel@ucw.cz, len.brown@intel.com, tj@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 03:34:57 +0530
Message-ID: <20120130220419.9442.39596.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120130220259.9442.70091.stgit@srivatsabhat.in.ibm.com>
References: <20120130220259.9442.70091.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12013022-9574-0000-0000-0000012B0323
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

 kernel/power/process.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index eeca003..def6b1b 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -170,17 +170,15 @@ void thaw_processes(void)
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
 

