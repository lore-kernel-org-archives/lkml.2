Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3AHXhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:63492 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab3AHXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Robert Richter <robert.richter@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 46/77] oprofile: Free potentially owned tasks in case of errors
Date: Tue, 8 Jan 2013 18:35:25 -0500
Message-ID: <1357688156-25387-47-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6ac6519b93065625119a347be1cbcc1b89edb773 upstream.

After registering the task free notifier we possibly have tasks in our
dying_tasks list. Free them after unregistering the notifier in case
of an error.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/oprofile/buffer_sync.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index b7e755f..e353ebf 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -141,6 +141,13 @@ static struct notifier_block module_load_nb = {
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
@@ -174,6 +181,7 @@ out3:
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 out2:
 	task_handoff_unregister(&task_free_nb);
+	free_all_tasks();
 out1:
 	free_cpumask_var(marked_cpus);
 	goto out;
@@ -192,10 +200,7 @@ void sync_stop(void)
 	mutex_unlock(&buffer_mutex);
 	flush_scheduled_work();
 
-	/* make sure we don't leak task structs */
-	process_task_mortuary();
-	process_task_mortuary();
-
+	free_all_tasks();
 	free_cpumask_var(marked_cpus);
 }
 
-- 
1.7.12.1

