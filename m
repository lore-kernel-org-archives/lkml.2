Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab2CIVNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:13:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33780 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab2CIVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:13:05 -0500
Date: Fri, 9 Mar 2012 13:12:28 -0800
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-05d74efa3c72a5c40b0edeb15856c0230126313b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120309135939.GC2114@dhcp-26-207.brq.redhat.com>
References: <20120309135939.GC2114@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq:
  No need to check IRQTF_DIED before stopping a thread handler
Git-Commit-ID: 05d74efa3c72a5c40b0edeb15856c0230126313b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 13:13:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05d74efa3c72a5c40b0edeb15856c0230126313b
Gitweb:     http://git.kernel.org/tip/05d74efa3c72a5c40b0edeb15856c0230126313b
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Fri, 9 Mar 2012 14:59:40 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 9 Mar 2012 17:19:08 +0100

genirq: No need to check IRQTF_DIED before stopping a thread handler

Since 63706172f332fd3f6e7458ebfb35fa6de9c21dc5 kthread_stop() is not
afraid of dead kernel threads. So no need to check if a thread is
alive before stopping it. These checks still were racy.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/20120309135939.GC2114@dhcp-26-207.brq.redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0fa3ce9..3feab4a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1106,8 +1106,7 @@ out_thread:
 		struct task_struct *t = new->thread;
 
 		new->thread = NULL;
-		if (likely(!test_bit(IRQTF_DIED, &new->thread_flags)))
-			kthread_stop(t);
+		kthread_stop(t);
 		put_task_struct(t);
 	}
 out_mput:
@@ -1217,8 +1216,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 #endif
 
 	if (action->thread) {
-		if (!test_bit(IRQTF_DIED, &action->thread_flags))
-			kthread_stop(action->thread);
+		kthread_stop(action->thread);
 		put_task_struct(action->thread);
 	}
 
