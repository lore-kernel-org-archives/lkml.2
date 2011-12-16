Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735Ab1LPUyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:54:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964900Ab1LPUwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:52:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 12:50:42 2011
Message-Id: <20111216205042.705238600@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 12:49:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [04/16] oprofile: Free potentially owned tasks in case of errors
In-Reply-To: <20111216205049.GA28030@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit 6ac6519b93065625119a347be1cbcc1b89edb773 upstream.

After registering the task free notifier we possibly have tasks in our
dying_tasks list. Free them after unregistering the notifier in case
of an error.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/oprofile/buffer_sync.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -140,6 +140,13 @@ static struct notifier_block module_load
 	.notifier_call = module_load_notify,
 };
 
+static void free_all_tasks(void)
+{
+	/* make sure we don't leak task structs */
+	process_task_mortuary();
+	process_task_mortuary();
+}
+
 int sync_start(void)
 {
 	int err;
@@ -173,6 +180,7 @@ out3:
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 out2:
 	task_handoff_unregister(&task_free_nb);
+	free_all_tasks();
 out1:
 	free_cpumask_var(marked_cpus);
 	goto out;
@@ -191,10 +199,7 @@ void sync_stop(void)
 	mutex_unlock(&buffer_mutex);
 	flush_scheduled_work();
 
-	/* make sure we don't leak task structs */
-	process_task_mortuary();
-	process_task_mortuary();
-
+	free_all_tasks();
 	free_cpumask_var(marked_cpus);
 }
 


