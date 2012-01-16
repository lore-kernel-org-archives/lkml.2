Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab2APLwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:52:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47342 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab2APLwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:52:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Date: Mon, 16 Jan 2012 20:51:40 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Cc: Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120107103059.BF5F.E1E9C6FF@jp.fujitsu.com>
References: <20120106141258.GB19462@redhat.com> <20120107103059.BF5F.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok. Thansk for your agreement.
> I'll test this patch.

Hi.

I tested this patch. I've not found any problems so far.
Please merge it.


-----
try_to_wake_up() has a problem which may change status from TASK_DEAD to
TASK_RUNNING in race condition with SMI or guest environment of virtual
machine. (See: https://lkml.org/lkml/2011/12/21/523)
As a result, exited task is scheduled() again and panic occurs.

By this patch, do_exit() waits for releasing task->pi_lock which is used
in try_to_wake_up(). It guarantees the task becomes TASK_DEAD after
waking up.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 kernel/exit.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-3.2/kernel/exit.c
===================================================================
--- linux-3.2.orig/kernel/exit.c
+++ linux-3.2/kernel/exit.c
@@ -1038,6 +1038,14 @@ NORET_TYPE void do_exit(long code)
 
 	preempt_disable();
 	exit_rcu();
+
+	/*
+	 * try_to_wake_up() might be waking me up due to race condition.
+	 * Make sure it is finished.
+	 */
+	smp_mb();
+	raw_spin_unlock_wait(&tsk->pi_lock);
+
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
 	schedule();

-- 
Yasunori Goto 


