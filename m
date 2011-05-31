Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab1EaRbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:31:11 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:45303 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab1EaRbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:31:09 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LM2LWS-01-4H2-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>, <stable@kernel.org>
Subject: [PATCH 1/3] oprofile: Free potentially owned tasks in case of errors
Date: Tue, 31 May 2011 18:46:44 +0200
Message-ID: <1306860406-6094-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <1306860406-6094-1-git-send-email-robert.richter@amd.com>
References: <1306860406-6094-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After registering the task free notifier we possibly have tasks in our
dying_tasks list. Free them after unregistering the notifier in case
of an error.

Cc: <stable@kernel.org> # .36+
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index a3984f4..04250aa 100644
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
 	flush_cpu_work();
 
-	/* make sure we don't leak task structs */
-	process_task_mortuary();
-	process_task_mortuary();
-
+	free_all_tasks();
 	free_cpumask_var(marked_cpus);
 }
 
-- 
1.7.5.rc3


