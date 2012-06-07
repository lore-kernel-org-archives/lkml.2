Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181Ab2FGPna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:43:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab2FGPnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:43:15 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=D7Wfu0q6AdEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=clqqo40ESsp2xoiuPbIA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120607154313.336714561@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Jun 2012 11:42:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, David Sommerseth <davids@redhat.com>
Subject: [PATCH RT 1/4] scsi: qla2xxx: Use local_irq_save_nort() in qla2x00_poll
References: <20120607154222.443210802@goodmis.org>
Content-Disposition: inline; filename=0001-scsi-qla2xxx-Use-local_irq_save_nort-in-qla2x00_poll.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Kacur <jkacur@redhat.com>

RT triggers the following:

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
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sommerseth <davids@redhat.com>
Link: http://lkml.kernel.org/r/1335523726-10024-1-git-send-email-jkacur@redhat.com
Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/qla2xxx/qla_inline.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 9902834..6d01db6 100644
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
1.7.10


