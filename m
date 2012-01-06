Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab2AFMB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:01:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35398 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab2AFMBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:01:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Date: Fri, 06 Jan 2012 21:01:08 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <1325847671.2442.7.camel@twins>
References: <20120106192256.AB15.E1E9C6FF@jp.fujitsu.com> <1325847671.2442.7.camel@twins>
Message-Id: <20120106210108.AB18.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2012-01-06 at 19:22 +0900, Yasunori Goto wrote:
> > I just confirmed booting up on my box, and I would like to get rough agreement
> > about this way to solve this issue at first. 
> 
> I really don't like it. It makes the ttwu path more complex and more
> expensive. ttwu is one of the hottest and more complex paths in the
> scheduler, it needs neither more overhead nor more complexity.

Hmmmmm.
Ok.
> 
> I'd really much rather put another raw_spin_unlocked_wait() in do_exit()
> before we set TASK_DEAD. It probably needs an smp memory barrier too.

Do you mean the following patch?

---

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 kernel/exit.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-3.2-rc7/kernel/exit.c
===================================================================
--- linux-3.2-rc7.orig/kernel/exit.c
+++ linux-3.2-rc7/kernel/exit.c
@@ -1038,6 +1038,10 @@ NORET_TYPE void do_exit(long code)
 
 	preempt_disable();
 	exit_rcu();
+
+	smp_mb();
+	raw_spin_unlock_wait(&tsk->pi_lock);
+
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
 	schedule();


-- 
Yasunori Goto 


