Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab1GNP6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:58:25 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:53980 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1GNP6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:58:24 -0400
X-Greylist: delayed 2331 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jul 2011 11:58:24 EDT
Message-ID: <4E1F0685.1000803@toshiba.co.jp>
Date: Thu, 14 Jul 2011 22:08:53 +0700
From: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com
Subject: [PATCH RT] ipc: add a critical section in pipelined_receive
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for v2.6.33.9-rt31 to avoid a deadlock.
In POSIX message queue, if a sender process uses SCHED_FIFO and 
has a higher priority than a receiver process, the sender will
be stuck at ipc/mqueue.c:446

  445                 while (ewp->state == STATE_PENDING)
  446                         cpu_relax();

Description of the problem
 (receiver process)
   1. receiver changes sender's state to STATE_PENDING (mqueue.c:832)
   2. wake up sender process and "switch to sender" (mqueue.c:833)
      Note: This context switch only happens in PREEMPT_RT kernel.
 (sender process)
   3. sender check the own state in above loop (mqueue.c:445-446)
   *. receiver will never wake up and cannot change sender's state to
      STATE_READY because sender has higher priority


Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
---
 ipc/mqueue.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 01582e5..712d813 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -827,12 +827,17 @@ static inline void pipelined_receive(struct mqueue_inode_info *info)
 		wake_up_interruptible(&info->wait_q);
 		return;
 	}
+	/*
+	 * Keep them in one critical section for PREEMPT_RT:
+	 */
+	preempt_disable_rt();
 	msg_insert(sender->msg, info);
 	list_del(&sender->list);
 	sender->state = STATE_PENDING;
 	wake_up_process(sender->task);
 	smp_wmb();
 	sender->state = STATE_READY;
+	preempt_enable_rt();
 }
 
 SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
-- 
1.7.2.5
