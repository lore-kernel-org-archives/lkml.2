Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1GHFIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:08:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab1GHFFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:02 2011
Message-Id: <20110708001701.966947273@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [095/107] taskstats: dont allow duplicate entries in listener mode
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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

---
 kernel/taskstats.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -285,16 +285,18 @@ ret:
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
@@ -303,9 +305,16 @@ static int add_del_listener(pid_t pid, c
 
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
 


