Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab1GWC6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 22:58:21 -0400
Received: from inet-tsb5.toshiba.co.jp ([202.33.96.24]:61829 "EHLO
	imx2.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1GWC6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 22:58:15 -0400
Message-ID: <4E2A38A0.1090601@toshiba.co.jp>
Date: Sat, 23 Jul 2011 11:57:36 +0900
From: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, dchinner@redhat.com, npiggin@kernel.dk,
        hch@lst.de, arnd@arndb.de
Subject: [PATCH 3.0-rt1] ipc/mqueue: add a critical section to avoid a deadlock
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Repost for v3.0-rt1 and changed the distination addreses)
I have tested the following patch on v3.0-rt1 with PREEMPT_RT_FULL.
In POSIX message queue, if a sender process uses SCHED_FIFO and
has a higher priority than a receiver process, the sender will
be stuck at ipc/mqueue.c:452

  452                 while (ewp->state == STATE_PENDING)
  453                         cpu_relax();

Description of the problem
 (receiver process)
   1. receiver changes sender's state to STATE_PENDING (mqueue.c:846)
   2. wake up sender process and "switch to sender" (mqueue.c:847)
      Note: This context switch only happens in PREEMPT_RT_FULL kernel.
 (sender process)
   3. sender check the own state in above loop (mqueue.c:452-453)
   *. receiver will never wake up and cannot change sender's state to
      STATE_READY because sender has higher priority


Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
---
 ipc/mqueue.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 22a06a4..1cf6e53 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -841,12 +841,17 @@ static inline void pipelined_receive(struct
mqueue_inode_info *info)
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
