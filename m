Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1IVJDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:03:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1IVJDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:03:52 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Clemens Ladisch <clemens@ladisch.de>, Corey Minyard <minyard@acm.org>,
        Mark Gross <mark.gross@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jiri Kosina <jkosina@suse.cz>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 28/55] driver/char: irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:58:55 +0800
Message-Id: <1316681962-8217-29-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Acked-by: Corey Minyard <cminyard@mvista.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/hpet.c              |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c |    4 ++--
 drivers/char/nwbutton.c          |    2 +-
 drivers/char/rtc.c               |    4 ++--
 drivers/char/snsc.c              |    2 +-
 drivers/char/snsc_event.c        |    2 +-
 drivers/char/tlclk.c             |    2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index c9aeb7f..2a2ecac 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -532,7 +532,7 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 
 		sprintf(devp->hd_name, "hpet%d", (int)(devp - hpetp->hp_dev));
 		irq_flags = devp->hd_flags & HPET_SHARED_IRQ
-						? IRQF_SHARED : IRQF_DISABLED;
+						? IRQF_SHARED : 0;
 		if (request_irq(irq, hpet_interrupt, irq_flags,
 				devp->hd_name, (void *)devp)) {
 			printk(KERN_ERR "hpet: IRQ %d is not free\n", irq);
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 9397ab4..44e8da3 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1336,7 +1336,7 @@ static int std_irq_setup(struct smi_info *info)
 	if (info->si_type == SI_BT) {
 		rv = request_irq(info->irq,
 				 si_bt_irq_handler,
-				 IRQF_SHARED | IRQF_DISABLED,
+				 IRQF_SHARED,
 				 DEVICE_NAME,
 				 info);
 		if (!rv)
@@ -1346,7 +1346,7 @@ static int std_irq_setup(struct smi_info *info)
 	} else
 		rv = request_irq(info->irq,
 				 si_irq_handler,
-				 IRQF_SHARED | IRQF_DISABLED,
+				 IRQF_SHARED,
 				 DEVICE_NAME,
 				 info);
 	if (rv) {
diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index 04a480f..36aaf43 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -220,7 +220,7 @@ static int __init nwbutton_init(void)
 		return -EBUSY;
 	}
 
-	if (request_irq (IRQ_NETWINDER_BUTTON, button_handler, IRQF_DISABLED,
+	if (request_irq (IRQ_NETWINDER_BUTTON, button_handler, 0,
 			"nwbutton", NULL)) {
 		printk (KERN_WARNING "nwbutton: IRQ %d is not free.\n",
 				IRQ_NETWINDER_BUTTON);
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index ccd124a..d1478cd 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -228,7 +228,7 @@ static inline unsigned char rtc_is_updating(void)
 
 #ifdef RTC_IRQ
 /*
- *	A very tiny interrupt handler. It runs with IRQF_DISABLED set,
+ *	A very tiny interrupt handler. It runs with irqs disabled,
  *	but there is possibility of conflicting with the set_rtc_mmss()
  *	call (the rtc irq and the timer irq can easily run at the same
  *	time in two different CPUs). So we need to serialize
@@ -1041,7 +1041,7 @@ no_irq:
 		rtc_int_handler_ptr = rtc_interrupt;
 	}
 
-	if (request_irq(RTC_IRQ, rtc_int_handler_ptr, IRQF_DISABLED,
+	if (request_irq(RTC_IRQ, rtc_int_handler_ptr, 0,
 			"rtc", NULL)) {
 		/* Yeah right, seeing as irq 8 doesn't even hit the bus. */
 		rtc_has_irq = 0;
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index 5816b39..d3464ef 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -108,7 +108,7 @@ scdrv_open(struct inode *inode, struct file *file)
 	/* hook this subchannel up to the system controller interrupt */
 	mutex_lock(&scdrv_mutex);
 	rv = request_irq(SGI_UART_VECTOR, scdrv_interrupt,
-			 IRQF_SHARED | IRQF_DISABLED,
+			 IRQF_SHARED,
 			 SYSCTL_BASENAME, sd);
 	if (rv) {
 		ia64_sn_irtr_close(sd->sd_nasid, sd->sd_subch);
diff --git a/drivers/char/snsc_event.c b/drivers/char/snsc_event.c
index ee15694..a35978c 100644
--- a/drivers/char/snsc_event.c
+++ b/drivers/char/snsc_event.c
@@ -292,7 +292,7 @@ scdrv_event_init(struct sysctl_data_s *scd)
 
 	/* hook event subchannel up to the system controller interrupt */
 	rv = request_irq(SGI_UART_VECTOR, scdrv_event_interrupt,
-			 IRQF_SHARED | IRQF_DISABLED,
+			 IRQF_SHARED,
 			 "system controller events", event_sd);
 	if (rv) {
 		printk(KERN_WARNING "%s: irq request failed (%d)\n",
diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index 0c964cd..771e48e 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -222,7 +222,7 @@ static int tlclk_open(struct inode *inode, struct file *filp)
 	/* This device is wired through the FPGA IO space of the ATCA blade
 	 * we can't share this IRQ */
 	result = request_irq(telclk_interrupt, &tlclk_interrupt,
-			     IRQF_DISABLED, "telco_clock", tlclk_interrupt);
+			     0, "telco_clock", tlclk_interrupt);
 	if (result == -EBUSY)
 		printk(KERN_ERR "tlclk: Interrupt can't be reserved.\n");
 	else
-- 
1.7.4.1

