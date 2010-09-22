Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab0IVBtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 21:49:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62232 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab0IVBtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 21:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IdWYztz6MInD/LFl/HgauPlBed7fIQjRY1F/iego+bB6N9iUNrJGF0bKyL9KFsz+bq
         +5dHW4qpri70VZRrFTz4EBZxl9i4fmp5WXDyesjceUbkSHdRl0qB2MapPZXYssEbL1OZ
         Xm2mI9VJ5O4Kvf52ziQM9Vz6NJ2EhiK9Lq0ig=
From: tom.leiming@gmail.com
To: sameo@linux.intel.com
Cc: linux-omap@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Balaji T K <balajitk@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: speedup twl4030 irq response time and decrease irq disable time
Date: Wed, 22 Sep 2010 09:49:31 +0800
Message-Id: <1285120171-3030-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch sets scheduler policy of twl4030 irq thread
(twl4030_irq_thread) as SCHED_FIFO to speedup irq response
time, just like taken by kernel threaded irq in irq_thread
(kernel/irq/manage.c). Also higher priority than that of
threaded irq is taken to avoid preemption from twl4030
subchips's threaded irq handler, so pih irq disable time may
be decreased.

The pih irq is disabled in handle_twl4030_pih which may
wakeup twl4030 irq thread, and the pih irq will be enabled
again until complete of all sih irqs' handling in twl4030
irq thread.

Also for each one interrupt line of twl4030 subchip, only
two irq events can be buffered by twl4030(4.4.2.3 of TPS65950 TRM).

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Balaji T K <balajitk@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org
---
 drivers/mfd/twl4030-irq.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 097f24d..d1e0d80 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -286,8 +286,16 @@ static int twl4030_irq_thread(void *data)
 	long irq = (long)data;
 	static unsigned i2c_errors;
 	static const unsigned max_i2c_errors = 100;
-
-
+	struct sched_param param = {
+		.sched_priority = MAX_USER_RT_PRIO/2 + 10,
+	};
+
+	/* Take higher priority than threaded irq to make us immune of
+ 	 * preemption from twl4030 subchips's threaded irq handler, then
+ 	 * we can complete all SIH irqs' handling and enable PIH irq
+ 	 * again asap.
+ 	 * */
+	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;
 
 	while (!kthread_should_stop()) {
-- 
1.6.2.5

