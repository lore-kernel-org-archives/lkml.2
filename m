Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1FPHbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:31:33 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48440 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999Ab1FPHBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:33 -0400
X-Sasl-enc: WbYF0DHnNnJ0LebmRVdA2zRLJxQj2qAKhEF9xvPj8hOh 1308207692
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:36 2011
Message-Id: <20110616000236.053358245@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>
Subject: [72/89] oprofile: Free potentially owned tasks in case of errors
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
@@ -141,6 +141,13 @@ static struct notifier_block module_load
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
 	flush_cpu_work();
 
-	/* make sure we don't leak task structs */
-	process_task_mortuary();
-	process_task_mortuary();
-
+	free_all_tasks();
 	free_cpumask_var(marked_cpus);
 }
 


