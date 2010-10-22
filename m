Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0JVSgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:36:48 -0400
Received: from kroah.org ([198.145.64.141]:41907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542Ab0JVSVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/49] serial: mrst_max3110: Make the IRQ option runtime
Date: Fri, 22 Oct 2010 11:21:01 -0700
Message-Id: <1287771688-14805-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

And while we are at it allow it to fail to find one. Without this the IRQ
option will cause the 3110 driver to fail on 0.7 SFI firmware.

Acked-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/Kconfig        |    7 -----
 drivers/serial/mrst_max3110.c |   55 +++++++++++++++++++++--------------------
 2 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 12900f7..ba4b390 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -717,13 +717,6 @@ config SERIAL_MRST_MAX3110
 	  the Intel Moorestown platform. On other systems use the max3100
 	  driver.
 
-config MRST_MAX3110_IRQ
-	boolean "Enable GPIO IRQ for Max3110 over Moorestown"
-	default n
-	depends on SERIAL_MRST_MAX3110 && GPIO_LANGWELL
-	help
-	  This has to be enabled after Moorestown GPIO driver is loaded
-
 config SERIAL_MFD_HSU
 	tristate "Medfield High Speed UART support"
 	depends on PCI
diff --git a/drivers/serial/mrst_max3110.c b/drivers/serial/mrst_max3110.c
index af8db27..b62857b 100644
--- a/drivers/serial/mrst_max3110.c
+++ b/drivers/serial/mrst_max3110.c
@@ -447,7 +447,6 @@ static int max3110_main_thread(void *_max)
 	return ret;
 }
 
-#ifdef CONFIG_MRST_MAX3110_IRQ
 static irqreturn_t serial_m3110_irq(int irq, void *dev_id)
 {
 	struct uart_max3110 *max = dev_id;
@@ -459,7 +458,7 @@ static irqreturn_t serial_m3110_irq(int irq, void *dev_id)
 
 	return IRQ_HANDLED;
 }
-#else
+
 /* if don't use RX IRQ, then need a thread to polling read */
 static int max3110_read_thread(void *_max)
 {
@@ -482,7 +481,6 @@ static int max3110_read_thread(void *_max)
 
 	return 0;
 }
-#endif
 
 static int serial_m3110_startup(struct uart_port *port)
 {
@@ -505,34 +503,38 @@ static int serial_m3110_startup(struct uart_port *port)
 	/* as we use thread to handle tx/rx, need set low latency */
 	port->state->port.tty->low_latency = 1;
 
-#ifdef CONFIG_MRST_MAX3110_IRQ
-	ret = request_irq(max->irq, serial_m3110_irq,
+	if (max->irq) {
+		max->read_thread = NULL;
+		ret = request_irq(max->irq, serial_m3110_irq,
 				IRQ_TYPE_EDGE_FALLING, "max3110", max);
-	if (ret)
-		return ret;
+		if (ret) {
+			max->irq = 0;
+			pr_err(PR_FMT "unable to allocate IRQ, polling\n");
+		}  else {
+			/* Enable RX IRQ only */
+			config |= WC_RXA_IRQ_ENABLE;
+		}
+	}
 
-	/* Enable RX IRQ only */
-	config |= WC_RXA_IRQ_ENABLE;
-#else
-	/* If IRQ is disabled, start a read thread for input data */
-	max->read_thread =
-		kthread_run(max3110_read_thread, max, "max3110_read");
-	if (IS_ERR(max->read_thread)) {
-		ret = PTR_ERR(max->read_thread);
-		max->read_thread = NULL;
-		pr_err(PR_FMT "Can't create read thread!");
-		return ret;
+	if (max->irq == 0) {
+		/* If IRQ is disabled, start a read thread for input data */
+		max->read_thread =
+			kthread_run(max3110_read_thread, max, "max3110_read");
+		if (IS_ERR(max->read_thread)) {
+			ret = PTR_ERR(max->read_thread);
+			max->read_thread = NULL;
+			pr_err(PR_FMT "Can't create read thread!\n");
+			return ret;
+		}
 	}
-#endif
 
 	ret = max3110_out(max, config);
 	if (ret) {
-#ifdef CONFIG_MRST_MAX3110_IRQ
-		free_irq(max->irq, max);
-#else
-		kthread_stop(max->read_thread);
+		if (max->irq)
+			free_irq(max->irq, max);
+		if (max->read_thread)
+			kthread_stop(max->read_thread);
 		max->read_thread = NULL;
-#endif
 		return ret;
 	}
 
@@ -551,9 +553,8 @@ static void serial_m3110_shutdown(struct uart_port *port)
 		max->read_thread = NULL;
 	}
 
-#ifdef CONFIG_MRST_MAX3110_IRQ
-	free_irq(max->irq, max);
-#endif
+	if (max->irq)
+		free_irq(max->irq, max);
 
 	/* Disable interrupts from this port */
 	config = WC_TAG | WC_SW_SHDI;
-- 
1.7.2

