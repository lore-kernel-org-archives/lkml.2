Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab2D0KtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 06:49:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38314 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2D0KtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 06:49:11 -0400
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Cc: rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Sommerseth <davids@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH RT] [scsi-qla2xxx] Fix BUG: sleeping function called from invalid context
Date: Fri, 27 Apr 2012 12:48:46 +0200
Message-Id: <1335523726-10024-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The relevant part of the traceback follows
[   11.307652]  [<ffffffff81077b27>] __might_sleep+0xe7/0x110
[   11.307663]  [<ffffffff8150e524>] rt_spin_lock+0x24/0x60
[   11.307670]  [<ffffffff8150da78>] ? rt_spin_lock_slowunlock+0x78/0x90
[   11.307703]  [<ffffffffa0272d83>] qla24xx_intr_handler+0x63/0x2d0 [qla2xxx]
[   11.307736]  [<ffffffffa0262307>] qla2x00_poll+0x67/0x90 [qla2xxx]

Function qla2x00_poll does local_irq_save() before calling qla24xx_intr_handler
which has a spinlock. Since spinlocks are sleepable on rt, it is not allowed
to call them with interrupts disabled. Therefore we use local_irq_save_nort()
instead which saves flags without disabling interrupts.

This fix needs to be applied to v3.0-rt, v3.2-rt and v3.4-rt

Suggested-by: Thomas Gleixner
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/scsi/qla2xxx/qla_inline.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 6e45764..28d9a8d 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -36,12 +36,12 @@ qla2x00_poll(struct rsp_que *rsp)
 {
 	unsigned long flags;
 	struct qla_hw_data *ha = rsp->hw;
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	if (IS_QLA82XX(ha))
 		qla82xx_poll(0, rsp);
 	else
 		ha->isp_ops->intr_handler(0, rsp);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 }
 
 static inline uint8_t *
-- 
1.7.1

