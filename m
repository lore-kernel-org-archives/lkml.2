Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab0HJWMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:12:52 -0400
Received: from kroah.org ([198.145.64.141]:44799 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286Ab0HJV7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:59:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/68] serial: fix wakup races in the mrst_max3110 driver
Date: Tue, 10 Aug 2010 14:58:30 -0700
Message-Id: <1281477570-18944-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

The mrst_max3110 driver had a set of unsafe wakeup sequences
along the following line:

if (!atomic_read(&foo)) {
  atomic_set(&foo, 1);
  wake_up(worker_thread);
}
and the worker thread would do

if (atomic_read(&foo)) {
  do_work();
  atomic_set(&foo, 0);
}

which can result in various missed wakups due to test-then-set races,
as well as due to clear-after-work instead of clear-before-work.

This patch fixes these races by using the proper bit test-and-set operations,
and by doing clear-before-work.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mrst_max3110.c |   46 ++++++++++++++++-------------------------
 1 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/serial/mrst_max3110.c b/drivers/serial/mrst_max3110.c
index 0341853..f6ad1ec 100644
--- a/drivers/serial/mrst_max3110.c
+++ b/drivers/serial/mrst_max3110.c
@@ -48,6 +48,10 @@
 
 #define PR_FMT	"mrst_max3110: "
 
+#define UART_TX_NEEDED 1
+#define CON_TX_NEEDED  2
+#define BIT_IRQ_PENDING    3
+
 struct uart_max3110 {
 	struct uart_port port;
 	struct spi_device *spi;
@@ -63,15 +67,13 @@ struct uart_max3110 {
 	u8 clock;
 	u8 parity, word_7bits;
 
-	atomic_t uart_tx_need;
+	unsigned long uart_flags;
 
 	/* console related */
 	struct circ_buf con_xmit;
-	atomic_t con_tx_need;
 
 	/* irq related */
 	u16 irq;
-	atomic_t irq_pending;
 };
 
 /* global data structure, may need be removed */
@@ -176,10 +178,9 @@ static void serial_m3110_con_putchar(struct uart_port *port, int ch)
 		xmit->head = (xmit->head + 1) & (PAGE_SIZE - 1);
 	}
 
-	if (!atomic_read(&max->con_tx_need)) {
-		atomic_set(&max->con_tx_need, 1);
+
+	if (!test_and_set_bit(CON_TX_NEEDED, &max->uart_flags))
 		wake_up_process(max->main_thread);
-	}
 }
 
 /*
@@ -318,10 +319,8 @@ static void serial_m3110_start_tx(struct uart_port *port)
 	struct uart_max3110 *max =
 		container_of(port, struct uart_max3110, port);
 
-	if (!atomic_read(&max->uart_tx_need)) {
-		atomic_set(&max->uart_tx_need, 1);
+	if (!test_and_set_bit(UART_TX_NEEDED, &max->uart_flags))
 		wake_up_process(max->main_thread);
-	}
 }
 
 static void receive_chars(struct uart_max3110 *max, unsigned char *str, int len)
@@ -392,32 +391,23 @@ static int max3110_main_thread(void *_max)
 	pr_info(PR_FMT "start main thread\n");
 
 	do {
-		wait_event_interruptible(*wq, (atomic_read(&max->irq_pending) ||
-					       atomic_read(&max->con_tx_need) ||
-					     atomic_read(&max->uart_tx_need)) ||
-					     kthread_should_stop());
+		wait_event_interruptible(*wq, max->uart_flags || kthread_should_stop());
 
 		mutex_lock(&max->thread_mutex);
 
-#ifdef CONFIG_MRST_MAX3110_IRQ
-		if (atomic_read(&max->irq_pending)) {
+		if (test_and_clear_bit(BIT_IRQ_PENDING, &max->uart_flags))
 			max3110_console_receive(max);
-			atomic_set(&max->irq_pending, 0);
-		}
-#endif
 
 		/* first handle console output */
-		if (atomic_read(&max->con_tx_need)) {
+		if (test_and_clear_bit(CON_TX_NEEDED, &max->uart_flags))
 			send_circ_buf(max, xmit);
-			atomic_set(&max->con_tx_need, 0);
-		}
 
 		/* handle uart output */
-		if (atomic_read(&max->uart_tx_need)) {
+		if (test_and_clear_bit(UART_TX_NEEDED, &max->uart_flags))
 			transmit_char(max);
-			atomic_set(&max->uart_tx_need, 0);
-		}
+
 		mutex_unlock(&max->thread_mutex);
+
 	} while (!kthread_should_stop());
 
 	return ret;
@@ -430,10 +420,9 @@ static irqreturn_t serial_m3110_irq(int irq, void *dev_id)
 
 	/* max3110's irq is a falling edge, not level triggered,
 	 * so no need to disable the irq */
-	if (!atomic_read(&max->irq_pending)) {
-		atomic_inc(&max->irq_pending);
+	if (!test_and_set_bit(BIT_IRQ_PENDING, &max->uart_flags))
 		wake_up_process(max->main_thread);
-	}
+
 	return IRQ_HANDLED;
 }
 #else
@@ -753,7 +742,8 @@ static int serial_m3110_probe(struct spi_device *spi)
 	max->baud = 0;
 
 	max->cur_conf = 0;
-	atomic_set(&max->irq_pending, 0);
+	max->uart_flags = 0;
+
 	/* Check if reading configuration register returns something sane */
 
 	res = RC_TAG;
-- 
1.7.2

