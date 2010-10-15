Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0JONvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:51:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:35685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab0JONvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:51:23 -0400
Message-ID: <4CB85C4C.6080806@kernel.org>
Date: Fri, 15 Oct 2010 15:51:08 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>, oprofile-list@lists.sf.net,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7] oprofile: don't use flush_scheduled_work()
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 13:51:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() is deprecated and scheduled to be removed.
sync_stop() currently cancels cpu_buffer works inside buffer_mutex and
flushes the system workqueue outside.  Instead, split end_cpu_work()
into two parts - stopping further work enqueues and flushing works -
and do the former inside buffer_mutex and latter outside.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/oprofile/buffer_sync.c |    2 +-
 drivers/oprofile/cpu_buffer.c  |   10 +++++++---
 drivers/oprofile/cpu_buffer.h  |    1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

Index: work/drivers/oprofile/buffer_sync.c
===================================================================
--- work.orig/drivers/oprofile/buffer_sync.c
+++ work/drivers/oprofile/buffer_sync.c
@@ -190,7 +190,7 @@ void sync_stop(void)
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 	task_handoff_unregister(&task_free_nb);
 	mutex_unlock(&buffer_mutex);
-	flush_scheduled_work();
+	flush_cpu_work();

 	/* make sure we don't leak task structs */
 	process_task_mortuary();
Index: work/drivers/oprofile/cpu_buffer.c
===================================================================
--- work.orig/drivers/oprofile/cpu_buffer.c
+++ work/drivers/oprofile/cpu_buffer.c
@@ -111,14 +111,18 @@ void start_cpu_work(void)

 void end_cpu_work(void)
 {
-	int i;
-
 	work_enabled = 0;
+}
+
+void flush_cpu_work(void)
+{
+	int i;

 	for_each_online_cpu(i) {
 		struct oprofile_cpu_buffer *b = &per_cpu(op_cpu_buffer, i);

-		cancel_delayed_work(&b->work);
+		/* these works are per-cpu, no need for flush_sync */
+		flush_delayed_work(&b->work);
 	}
 }

Index: work/drivers/oprofile/cpu_buffer.h
===================================================================
--- work.orig/drivers/oprofile/cpu_buffer.h
+++ work/drivers/oprofile/cpu_buffer.h
@@ -25,6 +25,7 @@ void free_cpu_buffers(void);

 void start_cpu_work(void);
 void end_cpu_work(void);
+void flush_cpu_work(void);

 /* CPU buffer is composed of such entries (which are
  * also used for context switch notes)
