Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1GTTC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:02:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab1GTTCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:02:55 -0400
Date: Wed, 20 Jul 2011 21:00:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Cc: Balbir Singh <bsingharora@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] taskstats: add_del_listener() shouldn't use the wrong
	node
Message-ID: <20110720190019.GA21753@redhat.com>
References: <20110720185959.GA21749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720185959.GA21749@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. 26c4caea "don't allow duplicate entries in listener mode"
   changed add_del_listener(REGISTER) so that "next_cpu:" can
   reuse the listener allocated for the previous cpu, this
   doesn't look exactly right even if minor.

   Change the code to kfree() in the already-registered case,
   this case is unlikely anyway so the extra kmalloc_node()
   shouldn't hurt but looke more correct and clean.

2. use the plain list_for_each_entry() instead of _safe() to
   scan listeners->list.

3. Remove the unneeded INIT_LIST_HEAD(&s->list), we are going
   to list_add(&s->list).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/taskstats.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- ts/kernel/taskstats.c~1_cleanup	2011-07-03 16:27:57.000000000 +0200
+++ ts/kernel/taskstats.c	2011-07-20 19:35:38.000000000 +0200
@@ -291,30 +291,28 @@ static int add_del_listener(pid_t pid, c
 	if (!cpumask_subset(mask, cpu_possible_mask))
 		return -EINVAL;
 
-	s = NULL;
 	if (isadd == REGISTER) {
 		for_each_cpu(cpu, mask) {
-			if (!s)
-				s = kmalloc_node(sizeof(struct listener),
-						 GFP_KERNEL, cpu_to_node(cpu));
+			s = kmalloc_node(sizeof(struct listener),
+					GFP_KERNEL, cpu_to_node(cpu));
 			if (!s)
 				goto cleanup;
+
 			s->pid = pid;
-			INIT_LIST_HEAD(&s->list);
 			s->valid = 1;
 
 			listeners = &per_cpu(listener_array, cpu);
 			down_write(&listeners->sem);
-			list_for_each_entry_safe(s2, tmp, &listeners->list, list) {
+			list_for_each_entry(s2, &listeners->list, list) {
 				if (s2->pid == pid)
-					goto next_cpu;
+					goto exists;
 			}
 			list_add(&s->list, &listeners->list);
 			s = NULL;
-next_cpu:
+exists:
 			up_write(&listeners->sem);
+			kfree(s); /* nop if NULL */
 		}
-		kfree(s);
 		return 0;
 	}
 

