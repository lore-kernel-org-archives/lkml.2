Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1IPMjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:39:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52137 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1IPMjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:39:54 -0400
Subject: Re: [RFC][PATCH 3/3] ipc/sem: Rework wakeup scheme
From: Peter Zijlstra <peterz@infradead.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Fri, 16 Sep 2011 14:39:42 +0200
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.916911903@chello.nl> <4E7235F6.1030303@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316176782.10174.26.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 14:18 +0200, Peter Zijlstra wrote:
> Currently the wake-list is a FILO, although making it FIFO isn't really
> hard (in fact, I've got the patch). 

might as well post it too

---
Subject: 
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Sep 15 15:32:06 CEST 2011


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-mus5f94zr5rckytoysdn4pqd@git.kernel.org
---
 include/linux/sched.h |   11 ++++++++---
 ipc/sem.c             |   11 +++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1067,6 +1067,7 @@ struct sched_domain;
 
 struct wake_list_head {
 	struct wake_list_node *first;
+	struct wake_list_node *last;
 };
 
 struct wake_list_node {
@@ -1076,7 +1077,7 @@ struct wake_list_node {
 #define WAKE_LIST_TAIL ((struct wake_list_node *)0x01)
 
 #define WAKE_LIST(name) \
-	struct wake_list_head name = { WAKE_LIST_TAIL }
+	struct wake_list_head name = { WAKE_LIST_TAIL, WAKE_LIST_TAIL }
 
 /*
  * wake flags
@@ -2174,11 +2175,15 @@ wake_list_add(struct wake_list_head *hea
 	 * This cmpxchg() implies a full barrier, which pairs with the write
 	 * barrier implied by the wakeup in wake_up_list().
 	 */
-	if (cmpxchg(&n->next, 0, head->first))
+	if (cmpxchg(&n->next, 0, WAKE_LIST_TAIL))
 		return;
 
 	get_task_struct(p);
-	head->first = n;
+	if (head->first == WAKE_LIST_TAIL)
+		head->first = n;
+	else
+		head->last->next = n;
+	head->last = n;
 }
 
 extern void wake_up_list(struct wake_list_head *head, unsigned int state);

