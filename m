Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549Ab2ERU3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:29:55 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:44816 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2ERU3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:29:54 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Laurent Chavey <chavey@google.com>, Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] tracing: Merge separate resize loops
Date: Fri, 18 May 2012 13:29:51 -0700
Message-Id: <1337372991-14783-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 2 separate loops to resize cpu buffers that are online and
offline. Merge them to make the code look better.

Also change the name from update_completion to update_done to allow
shorter lines.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 kernel/trace/ring_buffer.c |   42 ++++++++++++++++--------------------------
 1 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d4c458a..4a142b2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -473,7 +473,7 @@ struct ring_buffer_per_cpu {
 	int				nr_pages_to_update;
 	struct list_head		new_pages; /* new pages to add */
 	struct work_struct		update_pages_work;
-	struct completion		update_completion;
+	struct completion		update_done;
 };
 
 struct ring_buffer {
@@ -1054,7 +1054,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	INIT_WORK(&cpu_buffer->update_pages_work, update_pages_handler);
-	init_completion(&cpu_buffer->update_completion);
+	init_completion(&cpu_buffer->update_done);
 
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
@@ -1457,7 +1457,7 @@ static void update_pages_handler(struct work_struct *work)
 	struct ring_buffer_per_cpu *cpu_buffer = container_of(work,
 			struct ring_buffer_per_cpu, update_pages_work);
 	rb_update_pages(cpu_buffer);
-	complete(&cpu_buffer->update_completion);
+	complete(&cpu_buffer->update_done);
 }
 
 /**
@@ -1530,45 +1530,36 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 		get_online_cpus();
 		/*
 		 * Fire off all the required work handlers
-		 * Look out for offline CPUs
-		 */
-		for_each_buffer_cpu(buffer, cpu) {
-			cpu_buffer = buffer->buffers[cpu];
-			if (!cpu_buffer->nr_pages_to_update ||
-			    !cpu_online(cpu))
-				continue;
-
-			schedule_work_on(cpu, &cpu_buffer->update_pages_work);
-		}
-		/*
-		 * This loop is for the CPUs that are not online.
-		 * We can't schedule anything on them, but it's not necessary
+		 * We can't schedule on offline CPUs, but it's not necessary
 		 * since we can change their buffer sizes without any race.
 		 */
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer = buffer->buffers[cpu];
-			if (!cpu_buffer->nr_pages_to_update ||
-			    cpu_online(cpu))
+			if (!cpu_buffer->nr_pages_to_update)
 				continue;
 
-			rb_update_pages(cpu_buffer);
+			if (cpu_online(cpu))
+				schedule_work_on(cpu,
+						&cpu_buffer->update_pages_work);
+			else
+				rb_update_pages(cpu_buffer);
 		}
 
 		/* wait for all the updates to complete */
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer = buffer->buffers[cpu];
-			if (!cpu_buffer->nr_pages_to_update||
-			    !cpu_online(cpu))
+			if (!cpu_buffer->nr_pages_to_update)
 				continue;
 
-			wait_for_completion(&cpu_buffer->update_completion);
-			/* reset this value */
+			if (cpu_online(cpu))
+				wait_for_completion(&cpu_buffer->update_done);
 			cpu_buffer->nr_pages_to_update = 0;
 		}
 
 		put_online_cpus();
 	} else {
 		cpu_buffer = buffer->buffers[cpu_id];
+
 		if (nr_pages == cpu_buffer->nr_pages)
 			goto out;
 
@@ -1588,13 +1579,12 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 		if (cpu_online(cpu_id)) {
 			schedule_work_on(cpu_id,
 					 &cpu_buffer->update_pages_work);
-			wait_for_completion(&cpu_buffer->update_completion);
+			wait_for_completion(&cpu_buffer->update_done);
 		} else
 			rb_update_pages(cpu_buffer);
 
-		put_online_cpus();
-		/* reset this value */
 		cpu_buffer->nr_pages_to_update = 0;
+		put_online_cpus();
 	}
 
  out:
-- 
1.7.7.3

