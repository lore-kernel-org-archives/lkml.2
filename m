Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2EUJpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:45:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39041 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab2EUJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:45:05 -0400
Date: Mon, 21 May 2012 02:44:52 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-05fdd70d2fe1e34d8b80ec56d6e3272d9293653e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com, hpa@zytor.com,
        mingo@kernel.org, dhsharp@google.com, rostedt@goodmis.org,
        chavey@google.com, tglx@linutronix.de, teravest@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, chavey@google.com,
        dhsharp@google.com, tglx@linutronix.de, teravest@google.com
In-Reply-To: <1337372991-14783-1-git-send-email-vnagarnaik@google.com>
References: <1337372991-14783-1-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ring-buffer: Merge separate resize loops
Git-Commit-ID: 05fdd70d2fe1e34d8b80ec56d6e3272d9293653e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:44:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05fdd70d2fe1e34d8b80ec56d6e3272d9293653e
Gitweb:     http://git.kernel.org/tip/05fdd70d2fe1e34d8b80ec56d6e3272d9293653e
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Fri, 18 May 2012 13:29:51 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Sat, 19 May 2012 08:28:50 -0400

ring-buffer: Merge separate resize loops

There are 2 separate loops to resize cpu buffers that are online and
offline. Merge them to make the code look better.

Also change the name from update_completion to update_done to allow
shorter lines.

Link: http://lkml.kernel.org/r/1337372991-14783-1-git-send-email-vnagarnaik@google.com

Cc: Laurent Chavey <chavey@google.com>
Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   41 +++++++++++++++--------------------------
 1 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 68388f8..6420cda 100644
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
@@ -1058,7 +1058,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	INIT_WORK(&cpu_buffer->update_pages_work, update_pages_handler);
-	init_completion(&cpu_buffer->update_completion);
+	init_completion(&cpu_buffer->update_done);
 
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
@@ -1461,7 +1461,7 @@ static void update_pages_handler(struct work_struct *work)
 	struct ring_buffer_per_cpu *cpu_buffer = container_of(work,
 			struct ring_buffer_per_cpu, update_pages_work);
 	rb_update_pages(cpu_buffer);
-	complete(&cpu_buffer->update_completion);
+	complete(&cpu_buffer->update_done);
 }
 
 /**
@@ -1534,39 +1534,29 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
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
-			if (!cpu_buffer->nr_pages_to_update ||
-			    !cpu_online(cpu))
+			if (!cpu_buffer->nr_pages_to_update)
 				continue;
 
-			wait_for_completion(&cpu_buffer->update_completion);
-			/* reset this value */
+			if (cpu_online(cpu))
+				wait_for_completion(&cpu_buffer->update_done);
 			cpu_buffer->nr_pages_to_update = 0;
 		}
 
@@ -1593,13 +1583,12 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
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
