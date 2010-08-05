Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab0HEWri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:47:38 -0400
Received: from kroah.org ([198.145.64.141]:37564 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760765Ab0HEWXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/67] serial: replace open coded mutex with a real mutex in mrst_max3110.c
Date: Thu,  5 Aug 2010 15:22:34 -0700
Message-Id: <1281047014-23429-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

The mrst_max3110.c driver uses an open coded, non atomic variable
to create exclusion between two of its worker threads. More than that,
while the main thread does a proper set-work-clear sequence,
the other thread only does a test, with the result that no actual
exclusion is happening.

this patch replaces this open coded variable with a proper mutex

in addition, the 'lock' spinlock is removed from the per adapter structure,
the lock was only ever initialized but never used

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mrst_max3110.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/mrst_max3110.c b/drivers/serial/mrst_max3110.c
index f9c01ae..0341853 100644
--- a/drivers/serial/mrst_max3110.c
+++ b/drivers/serial/mrst_max3110.c
@@ -56,8 +56,7 @@ struct uart_max3110 {
 	wait_queue_head_t wq;
 	struct task_struct *main_thread;
 	struct task_struct *read_thread;
-	int mthread_up;
-	spinlock_t lock;
+	struct mutex thread_mutex;;
 
 	u32 baud;
 	u16 cur_conf;
@@ -397,7 +396,8 @@ static int max3110_main_thread(void *_max)
 					       atomic_read(&max->con_tx_need) ||
 					     atomic_read(&max->uart_tx_need)) ||
 					     kthread_should_stop());
-		max->mthread_up = 1;
+
+		mutex_lock(&max->thread_mutex);
 
 #ifdef CONFIG_MRST_MAX3110_IRQ
 		if (atomic_read(&max->irq_pending)) {
@@ -417,7 +417,7 @@ static int max3110_main_thread(void *_max)
 			transmit_char(max);
 			atomic_set(&max->uart_tx_need, 0);
 		}
-		max->mthread_up = 0;
+		mutex_unlock(&max->thread_mutex);
 	} while (!kthread_should_stop());
 
 	return ret;
@@ -444,8 +444,9 @@ static int max3110_read_thread(void *_max)
 
 	pr_info(PR_FMT "start read thread\n");
 	do {
-		if (!max->mthread_up)
-			max3110_console_receive(max);
+		mutex_lock(&max->thread_mutex);
+		max3110_console_receive(max);
+		mutex_unlock(&max->thread_mutex);
 
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ / 20);
@@ -745,7 +746,7 @@ static int serial_m3110_probe(struct spi_device *spi)
 	max->name = spi->modalias;	/* use spi name as the name */
 	max->irq = (u16)spi->irq;
 
-	spin_lock_init(&max->lock);
+	mutex_init(&max->thread_mutex);
 
 	max->word_7bits = 0;
 	max->parity = 0;
-- 
1.7.2

