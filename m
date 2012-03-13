Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab2CMA0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:26:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:49112 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073Ab2CMAZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 188/196] taskstats: don't allow duplicate entries in listener mode
Date: Mon, 12 Mar 2012 20:21:41 -0400
Message-Id: <1331598109-31424-143-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 26c4caea9d697043cc5a458b96411b86d7f6babd upstream.

Currently a single process may register exit handlers unlimited times.
It may lead to a bloated listeners chain and very slow process
terminations.

Eg after 10KK sent TASKSTATS_CMD_ATTR_REGISTER_CPUMASKs ~300 Mb of
kernel memory is stolen for the handlers chain and "time id" shows 2-7
seconds instead of normal 0.003.  It makes it possible to exhaust all
kernel memory and to eat much of CPU time by triggerring numerous exits
on a single CPU.

The patch limits the number of times a single process may register
itself on a single CPU to one.

One little issue is kept unfixed - as taskstats_exit() is called before
exit_files() in do_exit(), the orphaned listener entry (if it was not
explicitly deregistered) is kept until the next someone's exit() and
implicit deregistration in send_cpu_listeners().  So, if a process
registered itself as a listener exits and the next spawned process gets
the same pid, it would inherit taskstats attributes.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/taskstats.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 11281d5..5e21645 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -292,16 +292,18 @@ ret:
 static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 {
 	struct listener_list *listeners;
-	struct listener *s, *tmp;
+	struct listener *s, *tmp, *s2;
 	unsigned int cpu;
 
 	if (!cpumask_subset(mask, cpu_possible_mask))
 		return -EINVAL;
 
+	s = NULL;
 	if (isadd == REGISTER) {
 		for_each_cpu(cpu, mask) {
-			s = kmalloc_node(sizeof(struct listener), GFP_KERNEL,
-					 cpu_to_node(cpu));
+			if (!s)
+				s = kmalloc_node(sizeof(struct listener),
+						 GFP_KERNEL, cpu_to_node(cpu));
 			if (!s)
 				goto cleanup;
 			s->pid = pid;
@@ -310,9 +312,16 @@ static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
 
 			listeners = &per_cpu(listener_array, cpu);
 			down_write(&listeners->sem);
+			list_for_each_entry_safe(s2, tmp, &listeners->list, list) {
+				if (s2->pid == pid)
+					goto next_cpu;
+			}
 			list_add(&s->list, &listeners->list);
+			s = NULL;
+next_cpu:
 			up_write(&listeners->sem);
 		}
+		kfree(s);
 		return 0;
 	}
 
-- 
1.7.9.3

