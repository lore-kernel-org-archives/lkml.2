Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab1G0Vxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:53:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:36398 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab1G0VtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35258445"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: segoon@openwall.com, segooon@gmail.com, bsingharora@gmail.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [83/99] taskstats: don't allow duplicate entries in listener mode
Message-Id: <20110727214922.C60012403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/taskstats.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/kernel/taskstats.c
===================================================================
--- linux-2.6.35.y.orig/kernel/taskstats.c
+++ linux-2.6.35.y/kernel/taskstats.c
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
@@ -310,9 +312,16 @@ static int add_del_listener(pid_t pid, c
 
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
 
