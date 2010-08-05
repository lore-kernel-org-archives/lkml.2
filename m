Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab0HEHbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:31:20 -0400
Received: from mail.perches.com ([173.55.12.10]:2276 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759880Ab0HEH34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:56 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/9] drivers/input/serio: Use pr_fmt and pr_<level>
Date: Thu,  5 Aug 2010 00:29:47 -0700
Message-Id: <4c6bf59e9a9875601cfa3ee3e10a8a237a5368f0.1280992119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
In-Reply-To: <cover.1280992116.git.joe@perches.com>
References: <cover.1280992116.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add argument checking to #define dbg

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/serio/ambakmi.c         |    5 ++-
 drivers/input/serio/ct82c710.c        |   10 +++--
 drivers/input/serio/gscps2.c          |   15 ++++----
 drivers/input/serio/hil_mlc.c         |   17 ++++-----
 drivers/input/serio/hp_sdc.c          |   53 ++++++++++++++--------------
 drivers/input/serio/hp_sdc_mlc.c      |   45 +++++++++++++-----------
 drivers/input/serio/i8042-x86ia64io.h |   43 ++++++++++------------
 drivers/input/serio/i8042.c           |   62 +++++++++++++++------------------
 drivers/input/serio/i8042.h           |   21 +++++++----
 drivers/input/serio/maceps2.c         |    5 ++-
 drivers/input/serio/parkbd.c          |    8 +++--
 drivers/input/serio/q40kbd.c          |    6 ++-
 drivers/input/serio/rpckbd.c          |    6 ++-
 drivers/input/serio/sa1111ps2.c       |   17 +++++----
 drivers/input/serio/serio_raw.c       |   10 +++--
 drivers/input/serio/serport.c         |    6 ++-
 16 files changed, 175 insertions(+), 154 deletions(-)

diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakmi.c
index 92563a6..ce02f59 100644
--- a/drivers/input/serio/ambakmi.c
+++ b/drivers/input/serio/ambakmi.c
@@ -9,6 +9,9 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/serio.h>
@@ -82,7 +85,7 @@ static int amba_kmi_open(struct serio *io)
 
 	ret = request_irq(kmi->irq, amba_kmi_int, 0, "kmi-pl050", kmi);
 	if (ret) {
-		printk(KERN_ERR "kmi: failed to claim IRQ%d\n", kmi->irq);
+		pr_err("failed to claim IRQ%d\n", kmi->irq);
 		writeb(0, KMICR);
 		goto clk_disable;
 	}
diff --git a/drivers/input/serio/ct82c710.c b/drivers/input/serio/ct82c710.c
index 4a30846..3c5de1d 100644
--- a/drivers/input/serio/ct82c710.c
+++ b/drivers/input/serio/ct82c710.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
@@ -98,12 +100,12 @@ static int ct82c170_wait(void)
 static void ct82c710_close(struct serio *serio)
 {
 	if (ct82c170_wait())
-		printk(KERN_WARNING "ct82c710.c: Device busy in close()\n");
+		pr_warning("Device busy in close()\n");
 
 	outb_p(inb_p(CT82C710_STATUS) & ~(CT82C710_ENABLE | CT82C710_INTS_ON), CT82C710_STATUS);
 
 	if (ct82c170_wait())
-		printk(KERN_WARNING "ct82c710.c: Device busy in close()\n");
+		pr_warning("Device busy in close()\n");
 
 	free_irq(CT82C710_IRQ, NULL);
 }
@@ -127,7 +129,7 @@ static int ct82c710_open(struct serio *serio)
 	outb_p(status, CT82C710_STATUS);	/* Enable interrupts */
 
 	while (ct82c170_wait()) {
-		printk(KERN_ERR "ct82c710: Device busy in open()\n");
+		pr_err("Device busy in open()\n");
 		status &= ~(CT82C710_ENABLE | CT82C710_INTS_ON);
 		outb_p(status, CT82C710_STATUS);
 		free_irq(CT82C710_IRQ, NULL);
@@ -239,7 +241,7 @@ static int __init ct82c710_init(void)
 
 	serio_register_port(ct82c710_port);
 
-	printk(KERN_INFO "serio: C&T 82c710 mouse port at %#llx irq %d\n",
+	pr_info("C&T 82c710 mouse port at %#llx irq %d\n",
 		(unsigned long long)CT82C710_DATA, CT82C710_IRQ);
 
 	return 0;
diff --git a/drivers/input/serio/gscps2.c b/drivers/input/serio/gscps2.c
index 3c287dd..31c41b0 100644
--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -22,6 +22,8 @@
  *                 was usable/enabled ?)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -42,8 +44,6 @@ MODULE_DESCRIPTION("HP GSC PS2 port driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(parisc, gscps2_device_tbl);
 
-#define PFX "gscps2.c: "
-
 /*
  * Driver constants
  */
@@ -151,7 +151,8 @@ static inline int gscps2_writeb_output(struct gscps2port *ps2port, u8 data)
 	char *addr = ps2port->addr;
 
 	if (!wait_TBE(addr)) {
-		printk(KERN_DEBUG PFX "timeout - could not write byte %#x\n", data);
+		printk(KERN_DEBUG pr_fmt("timeout - could not write byte %#x\n"),
+		       data);
 		return 0;
 	}
 
@@ -287,7 +288,7 @@ static int gscps2_write(struct serio *port, unsigned char data)
 	struct gscps2port *ps2port = port->port_data;
 
 	if (!gscps2_writeb_output(ps2port, data)) {
-		printk(KERN_DEBUG PFX "sending byte %#x failed.\n", data);
+		printk(KERN_DEBUG pr_fmt("sending byte %#x failed\n"), data);
 		return -1;
 	}
 	return 0;
@@ -373,8 +374,8 @@ static int __devinit gscps2_probe(struct parisc_device *dev)
 		goto fail_miserably;
 
 	if (ps2port->id != GSC_ID_KEYBOARD && ps2port->id != GSC_ID_MOUSE) {
-		printk(KERN_WARNING PFX "Unsupported PS/2 port at 0x%08lx (id=%d) ignored\n",
-				hpa, ps2port->id);
+		pr_warning("Unsupported PS/2 port at 0x%08lx (id=%d) ignored\n",
+			   hpa, ps2port->id);
 		ret = -ENODEV;
 		goto fail;
 	}
@@ -384,7 +385,7 @@ static int __devinit gscps2_probe(struct parisc_device *dev)
 		goto fail;
 #endif
 
-	printk(KERN_INFO "serio: %s port at 0x%p irq %d @ %s\n",
+	pr_info("%s port at 0x%p irq %d @ %s\n",
 		ps2port->port->name,
 		ps2port->addr,
 		ps2port->padev->irq,
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index c92f4ed..f0e810e 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -52,6 +52,8 @@
  *	and to initiate probes of the loop for new devices.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/hil_mlc.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -69,8 +71,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 EXPORT_SYMBOL(hil_mlc_register);
 EXPORT_SYMBOL(hil_mlc_unregister);
 
-#define PREFIX "HIL MLC: "
-
 static LIST_HEAD(hil_mlcs);
 static DEFINE_RWLOCK(hil_mlcs_lock);
 static struct timer_list	hil_mlcs_kicker;
@@ -248,7 +248,7 @@ static int hilse_match(hil_mlc *mlc, int unused)
 			goto err;
 
 #ifdef HIL_MLC_DEBUG
-		printk(KERN_DEBUG PREFIX "new in slot %i\n", rc);
+		printk(KERN_DEBUG pr_fmt("new in slot %i\n"), rc);
 #endif
 		hil_mlc_copy_di_scratch(mlc, rc);
 		mlc->di_map[mlc->ddi] = rc;
@@ -260,14 +260,14 @@ static int hilse_match(hil_mlc *mlc, int unused)
 
 	mlc->di_map[mlc->ddi] = rc;
 #ifdef HIL_MLC_DEBUG
-	printk(KERN_DEBUG PREFIX "same in slot %i\n", rc);
+	printk(KERN_DEBUG pr_fmt("same in slot %i\n"), rc);
 #endif
 	mlc->serio_map[rc].di_revmap = mlc->ddi;
 	hil_mlc_clean_serio_map(mlc);
 	return 0;
 
  err:
-	printk(KERN_ERR PREFIX "Residual device slots exhausted, close some serios!\n");
+	pr_err("Residual device slots exhausted, close some serios!\n");
 	return 1;
 }
 
@@ -419,8 +419,7 @@ static int hilse_take_rnm(hil_mlc *mlc, int unused)
 		mlc->di_scratch.rnm[i] =
 			mlc->ipacket[i] & HIL_PKT_DATA_MASK;
 
-	printk(KERN_INFO PREFIX "Device name gotten: %16s\n",
-			mlc->di_scratch.rnm);
+	pr_info("Device name gotten: %16s\n", mlc->di_scratch.rnm);
 
 	return 0;
 }
@@ -626,7 +625,7 @@ static int hilse_donode(hil_mlc *mlc)
 #ifdef HIL_MLC_DEBUG
 	if (mlc->seidx && mlc->seidx != seidx &&
 	    mlc->seidx != 41 && mlc->seidx != 42 && mlc->seidx != 43) {
-		printk(KERN_DEBUG PREFIX "z%i \n {%i}", doze, mlc->seidx);
+		printk(KERN_DEBUG pr_fmt("z%i\n {%i}\n"), doze, mlc->seidx);
 		doze = 0;
 	}
 
@@ -776,7 +775,7 @@ static void hil_mlcs_process(unsigned long unused)
 			if (mlc->seidx != 41 &&
 			    mlc->seidx != 42 &&
 			    mlc->seidx != 43)
-				printk(KERN_DEBUG PREFIX " + ");
+				printk(KERN_DEBUG pr_fmt(" + "));
 #endif
 		}
 	}
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index bcc2d30..e1affca 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -61,6 +61,8 @@
  * sure it doesn't freeze up and to allow for bad reads to time out.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/hp_sdc.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -87,8 +89,6 @@
 # error "HIL is not supported on this platform"
 #endif
 
-#define PREFIX "HP SDC: "
-
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
 MODULE_DESCRIPTION("HP i8042-based SDC Driver");
 MODULE_LICENSE("Dual BSD/GPL");
@@ -259,7 +259,7 @@ static irqreturn_t hp_sdc_isr(int irq, void *dev_id)
 		if (hp_sdc.pup != NULL)
 			hp_sdc.pup(irq, dev_id, status, data);
 		else
-			printk(KERN_INFO PREFIX "HP SDC reports successful PUP.\n");
+			pr_info("HP SDC reports successful PUP.\n");
 		read_unlock(&hp_sdc.hook_lock);
 		break;
 
@@ -280,7 +280,7 @@ static irqreturn_t hp_sdc_nmisr(int irq, void *dev_id)
 	int status;
 
 	status = hp_sdc_status_in8();
-	printk(KERN_WARNING PREFIX "NMI !\n");
+	pr_warning("NMI !\n");
 
 #if 0
 	if (status & HP_SDC_NMISTATUS_FHS) {
@@ -290,7 +290,7 @@ static irqreturn_t hp_sdc_nmisr(int irq, void *dev_id)
 		read_unlock(&hp_sdc.hook_lock);
 	} else {
 		/* TODO: pass this on to the HIL handler, or do SAK here? */
-		printk(KERN_WARNING PREFIX "HIL NMI\n");
+		pr_warning("HIL NMI\n");
 	}
 #endif
 
@@ -322,8 +322,8 @@ static void hp_sdc_tasklet(unsigned long foo)
 			 * we'll need to figure out a way to communicate
 			 * it back to the application. and be less verbose.
 			 */
-			printk(KERN_WARNING PREFIX "read timeout (%ius)!\n",
-			       (int)(tv.tv_usec - hp_sdc.rtv.tv_usec));
+			pr_warning("read timeout (%ius)!\n",
+				   (int)(tv.tv_usec - hp_sdc.rtv.tv_usec));
 			curr->idx += hp_sdc.rqty;
 			hp_sdc.rqty = 0;
 			tmp = curr->seq[curr->actidx];
@@ -624,11 +624,11 @@ int __hp_sdc_enqueue_transaction(hp_sdc_transaction *this)
 			return 0;
 		}
 
-	printk(KERN_WARNING PREFIX "No free slot to add transaction.\n");
+	pr_warning("No free slot to add transaction.\n");
 	return -EBUSY;
 
  fail:
-	printk(KERN_WARNING PREFIX "Transaction add failed: transaction already queued?\n");
+	pr_warning("Transaction add failed: transaction already queued?\n");
 	return -EINVAL;
 }
 
@@ -888,8 +888,8 @@ static int __init hp_sdc_init(void)
 			"HP SDC NMI", &hp_sdc))
 		goto err2;
 
-	printk(KERN_INFO PREFIX "HP SDC at 0x%p, IRQ %d (NMI IRQ %d)\n",
-	       (void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
+	pr_info("HP SDC at 0x%p, IRQ %d (NMI IRQ %d)\n",
+		(void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
 
 	hp_sdc_status_in8();
 	hp_sdc_data_in8();
@@ -922,8 +922,8 @@ static int __init hp_sdc_init(void)
  err1:
 	release_region(hp_sdc.data_io, 2);
  err0:
-	printk(KERN_WARNING PREFIX ": %s SDC IO=0x%p IRQ=0x%x NMI=0x%x\n",
-		errstr, (void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
+	pr_warning("%s SDC IO=0x%p IRQ=0x%x NMI=0x%x\n",
+		   errstr, (void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
 	hp_sdc.dev = NULL;
 
 	return hp_sdc.dev_err;
@@ -992,7 +992,7 @@ static void hp_sdc_exit(void)
 #if defined(__hppa__)
 	cancel_delayed_work_sync(&moduleloader_work);
 	if (unregister_parisc_driver(&hp_sdc_driver))
-		printk(KERN_WARNING PREFIX "Error unregistering HP SDC");
+		pr_warning("Error unregistering HP SDC");
 #endif
 }
 
@@ -1007,7 +1007,7 @@ static int __init hp_sdc_register(void)
 #endif
 
 	if (hp_sdc_disabled) {
-		printk(KERN_WARNING PREFIX "HP SDC driver disabled by no_hpsdc=1.\n");
+		pr_warning("HP SDC driver disabled by no_hpsdc=1\n");
 		return -ENODEV;
 	}
 
@@ -1015,7 +1015,7 @@ static int __init hp_sdc_register(void)
 	hp_sdc.dev_err = 0;
 #if defined(__hppa__)
 	if (register_parisc_driver(&hp_sdc_driver)) {
-		printk(KERN_WARNING PREFIX "Error registering SDC with system bus tree.\n");
+		pr_warning("Error registering SDC with system bus tree\n");
 		return -ENODEV;
 	}
 #elif defined(__mc68000__)
@@ -1035,7 +1035,7 @@ static int __init hp_sdc_register(void)
 	hp_sdc.dev_err   = hp_sdc_init();
 #endif
 	if (hp_sdc.dev == NULL) {
-		printk(KERN_WARNING PREFIX "No SDC found.\n");
+		pr_warning("No SDC found\n");
 		return hp_sdc.dev_err;
 	}
 
@@ -1060,14 +1060,14 @@ static int __init hp_sdc_register(void)
 	up(&tq_init_sem);
 
 	if ((tq_init_seq[0] & HP_SDC_ACT_DEAD) == HP_SDC_ACT_DEAD) {
-		printk(KERN_WARNING PREFIX "Error reading config byte.\n");
+		pr_warning("Error reading config byte\n");
 		hp_sdc_exit();
 		return -ENODEV;
 	}
 	hp_sdc.r11 = tq_init_seq[4];
 	if (hp_sdc.r11 & HP_SDC_CFG_NEW) {
 		const char *str;
-		printk(KERN_INFO PREFIX "New style SDC\n");
+		pr_info("New style SDC\n");
 		tq_init_seq[1] = HP_SDC_CMD_READ_XTD;
 		tq_init.actidx		= 0;
 		tq_init.idx		= 1;
@@ -1076,18 +1076,17 @@ static int __init hp_sdc_register(void)
 		down(&tq_init_sem);
 		up(&tq_init_sem);
 		if ((tq_init_seq[0] & HP_SDC_ACT_DEAD) == HP_SDC_ACT_DEAD) {
-			printk(KERN_WARNING PREFIX "Error reading extended config byte.\n");
+			pr_warning("Error reading extended config byte\n");
 			return -ENODEV;
 		}
 		hp_sdc.r7e = tq_init_seq[4];
 		HP_SDC_XTD_REV_STRINGS(hp_sdc.r7e & HP_SDC_XTD_REV, str)
-		printk(KERN_INFO PREFIX "Revision: %s\n", str);
+		pr_info("Revision: %s\n", str);
 		if (hp_sdc.r7e & HP_SDC_XTD_BEEPER)
-			printk(KERN_INFO PREFIX "TI SN76494 beeper present\n");
+			pr_info("TI SN76494 beeper present\n");
 		if (hp_sdc.r7e & HP_SDC_XTD_BBRTC)
-			printk(KERN_INFO PREFIX "OKI MSM-58321 BBRTC present\n");
-		printk(KERN_INFO PREFIX "Spunking the self test register to force PUP "
-		       "on next firmware reset.\n");
+			pr_info("OKI MSM-58321 BBRTC present\n");
+		pr_info("Spunking the self test register to force PUP on next firmware reset\n");
 		tq_init_seq[0] = HP_SDC_ACT_PRECMD |
 			HP_SDC_ACT_DATAOUT | HP_SDC_ACT_SEMAPHORE;
 		tq_init_seq[1] = HP_SDC_CMD_SET_STR;
@@ -1101,8 +1100,8 @@ static int __init hp_sdc_register(void)
 		down(&tq_init_sem);
 		up(&tq_init_sem);
 	} else
-		printk(KERN_INFO PREFIX "Old style SDC (1820-%s).\n",
-		       (hp_sdc.r11 & HP_SDC_CFG_REV) ? "3300" : "2564/3087");
+		pr_info("Old style SDC (1820-%s)\n",
+			(hp_sdc.r11 & HP_SDC_CFG_REV) ? "3300" : "2564/3087");
 
         return 0;
 }
diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
index 7d2b820..09477f5 100644
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -33,6 +33,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/hil_mlc.h>
 #include <linux/hp_sdc.h>
 #include <linux/errno.h>
@@ -42,8 +44,6 @@
 #include <linux/string.h>
 #include <linux/semaphore.h>
 
-#define PREFIX "HP SDC MLC: "
-
 static hil_mlc hp_sdc_mlc;
 
 MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
@@ -66,7 +66,7 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 
 	write_lock(&mlc->lock);
 	if (mlc->icount < 0) {
-		printk(KERN_WARNING PREFIX "HIL Overflow!\n");
+		pr_warning("HIL Overflow!\n");
 		up(&mlc->isem);
 		goto out;
 	}
@@ -104,11 +104,11 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 	goto out;
 
  err:
-	printk(KERN_DEBUG PREFIX "err code %x\n", data);
+	printk(KERN_DEBUG pr_fmt("err code %x\n"), data);
 
 	switch (data) {
 	case HP_SDC_HIL_RC_DONE:
-		printk(KERN_WARNING PREFIX "Bastard SDC reconfigured loop!\n");
+		pr_warning("Bastard SDC reconfigured loop!\n");
 		break;
 
 	case HP_SDC_HIL_ERR:
@@ -121,11 +121,11 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 		break;
 
 	case HP_SDC_HIL_RC:
-		printk(KERN_WARNING PREFIX "Bastard SDC decided to reconfigure loop!\n");
+		pr_warning("Bastard SDC decided to reconfigure loop!\n");
 		break;
 
 	default:
-		printk(KERN_WARNING PREFIX "Unknown HIL Error status (%x)!\n", data);
+		pr_warning("Unknown HIL Error status (%x)!\n", data);
 		break;
 	}
 
@@ -157,16 +157,19 @@ static int hp_sdc_mlc_in(hil_mlc *mlc, suseconds_t timeout)
 						HIL_PKT_ADDR_MASK |
 						HIL_PKT_DATA_MASK));
 			mlc->icount = 14;
-			/* printk(KERN_DEBUG PREFIX ">[%x]\n", mlc->ipacket[0]); */
+			/*
+			printk(KERN_DEBUG pr_fmt(">[%x]\n"), mlc->ipacket[0]);
+			*/
 			goto wasup;
 		}
 		do_gettimeofday(&tv);
 		tv.tv_usec += USEC_PER_SEC * (tv.tv_sec - mlc->instart.tv_sec);
 		if (tv.tv_usec - mlc->instart.tv_usec > mlc->intimeout) {
-			/*	printk("!%i %i",
-				tv.tv_usec - mlc->instart.tv_usec,
-				mlc->intimeout);
-			 */
+			/*
+			printk(KERN_DEBUG pr_fmt("!%i %i\n"),
+			       tv.tv_usec - mlc->instart.tv_usec,
+			       mlc->intimeout);
+			*/
 			rc = 1;
 			up(&mlc->isem);
 		}
@@ -311,7 +314,7 @@ static int __init hp_sdc_mlc_init(void)
 		return -ENODEV;
 #endif
 
-	printk(KERN_INFO PREFIX "Registering the System Domain Controller's HIL MLC.\n");
+	pr_info("Registering the System Domain Controller's HIL MLC\n");
 
 	hp_sdc_mlc_priv.emtestmode = 0;
 	hp_sdc_mlc_priv.trans.seq = hp_sdc_mlc_priv.tseq;
@@ -324,19 +327,19 @@ static int __init hp_sdc_mlc_init(void)
 	mlc->priv = &hp_sdc_mlc_priv;
 
 	if (hil_mlc_register(mlc)) {
-		printk(KERN_WARNING PREFIX "Failed to register MLC structure with hil_mlc\n");
+		pr_warning("Failed to register MLC structure with hil_mlc\n");
 		goto err0;
 	}
 
 	if (hp_sdc_request_hil_irq(&hp_sdc_mlc_isr)) {
-		printk(KERN_WARNING PREFIX "Request for raw HIL ISR hook denied\n");
+		pr_warning("Request for raw HIL ISR hook denied\n");
 		goto err1;
 	}
 	return 0;
  err1:
 	if (hil_mlc_unregister(mlc))
-		printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
-			"This is bad.  Could cause an oops.\n");
+		pr_err("Failed to unregister MLC structure with hil_mlc\n"
+		       "This is bad.  Could cause an oops\n");
  err0:
 	return -EBUSY;
 }
@@ -346,12 +349,12 @@ static void __exit hp_sdc_mlc_exit(void)
 	hil_mlc *mlc = &hp_sdc_mlc;
 
 	if (hp_sdc_release_hil_irq(&hp_sdc_mlc_isr))
-		printk(KERN_ERR PREFIX "Failed to release the raw HIL ISR hook.\n"
-			"This is bad.  Could cause an oops.\n");
+		pr_err("Failed to release the raw HIL ISR hook.\n"
+		       "This is bad.  Could cause an oops\n");
 
 	if (hil_mlc_unregister(mlc))
-		printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
-			"This is bad.  Could cause an oops.\n");
+		pr_err("Failed to unregister MLC structure with hil_mlc.\n"
+		       "This is bad.  Could cause an oops.\n");
 }
 
 module_init(hp_sdc_mlc_init);
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index ed7ad74..96903ab 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -741,7 +741,7 @@ static int __init i8042_pnp_init(void)
 #endif
 
 	if (i8042_nopnp) {
-		printk(KERN_INFO "i8042: PNP detection disabled\n");
+		pr_info("PNP detection disabled\n");
 		return 0;
 	}
 
@@ -758,7 +758,7 @@ static int __init i8042_pnp_init(void)
 #if defined(__ia64__)
 		return -ENODEV;
 #else
-		printk(KERN_INFO "PNP: No PS/2 controller found. Probing ports directly.\n");
+		pr_info("No PS/2 controller found. Probing ports directly.\n");
 		return 0;
 #endif
 	}
@@ -770,11 +770,13 @@ static int __init i8042_pnp_init(void)
 		snprintf(aux_irq_str, sizeof(aux_irq_str),
 			"%d", i8042_pnp_aux_irq);
 
-	printk(KERN_INFO "PNP: PS/2 Controller [%s%s%s] at %#x,%#x irq %s%s%s\n",
-		i8042_pnp_kbd_name, (i8042_pnp_kbd_devices && i8042_pnp_aux_devices) ? "," : "",
+	pr_info("PS/2 Controller [%s%s%s] at %#x,%#x irq %s%s%s\n",
+		i8042_pnp_kbd_name,
+		(i8042_pnp_kbd_devices && i8042_pnp_aux_devices) ? "," : "",
 		i8042_pnp_aux_name,
 		i8042_pnp_data_reg, i8042_pnp_command_reg,
-		kbd_irq_str, (i8042_pnp_kbd_devices && i8042_pnp_aux_devices) ? "," : "",
+		kbd_irq_str,
+		(i8042_pnp_kbd_devices && i8042_pnp_aux_devices) ? "," : "",
 		aux_irq_str);
 
 #if defined(__ia64__)
@@ -787,10 +789,9 @@ static int __init i8042_pnp_init(void)
 	if (((i8042_pnp_data_reg & ~0xf) == (i8042_data_reg & ~0xf) &&
 	      i8042_pnp_data_reg != i8042_data_reg) ||
 	    !i8042_pnp_data_reg) {
-		printk(KERN_WARNING
-			"PNP: PS/2 controller has invalid data port %#x; "
-			"using default %#x\n",
-			i8042_pnp_data_reg, i8042_data_reg);
+		pr_warning("PS/2 controller has invalid data port %#x; "
+			   "using default %#x\n",
+			   i8042_pnp_data_reg, i8042_data_reg);
 		i8042_pnp_data_reg = i8042_data_reg;
 		pnp_data_busted = true;
 	}
@@ -798,33 +799,29 @@ static int __init i8042_pnp_init(void)
 	if (((i8042_pnp_command_reg & ~0xf) == (i8042_command_reg & ~0xf) &&
 	      i8042_pnp_command_reg != i8042_command_reg) ||
 	    !i8042_pnp_command_reg) {
-		printk(KERN_WARNING
-			"PNP: PS/2 controller has invalid command port %#x; "
-			"using default %#x\n",
-			i8042_pnp_command_reg, i8042_command_reg);
+		pr_warning("PS/2 controller has invalid command port %#x; "
+			   "using default %#x\n",
+			   i8042_pnp_command_reg, i8042_command_reg);
 		i8042_pnp_command_reg = i8042_command_reg;
 		pnp_data_busted = true;
 	}
 
 	if (!i8042_nokbd && !i8042_pnp_kbd_irq) {
-		printk(KERN_WARNING
-			"PNP: PS/2 controller doesn't have KBD irq; "
-			"using default %d\n", i8042_kbd_irq);
+		pr_warning("PS/2 controller doesn't have KBD irq; "
+			   "using default %d\n", i8042_kbd_irq);
 		i8042_pnp_kbd_irq = i8042_kbd_irq;
 		pnp_data_busted = true;
 	}
 
 	if (!i8042_noaux && !i8042_pnp_aux_irq) {
 		if (!pnp_data_busted && i8042_pnp_kbd_irq) {
-			printk(KERN_WARNING
-				"PNP: PS/2 appears to have AUX port disabled, "
-				"if this is incorrect please boot with "
-				"i8042.nopnp\n");
+			pr_warning("PS/2 appears to have AUX port disabled, "
+				   "if this is incorrect please boot with "
+				   "i8042.nopnp\n");
 			i8042_noaux = true;
 		} else {
-			printk(KERN_WARNING
-				"PNP: PS/2 controller doesn't have AUX irq; "
-				"using default %d\n", i8042_aux_irq);
+			pr_warning("PS/2 controller doesn't have AUX irq; "
+				   "using default %d\n", i8042_aux_irq);
 			i8042_pnp_aux_irq = i8042_aux_irq;
 		}
 	}
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 258b98b..ae4bc8b 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -10,6 +10,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/module.h>
@@ -359,17 +361,15 @@ static void i8042_port_close(struct serio *serio)
 
 	i8042_ctr &= ~irq_bit;
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_WARNING
-			"i8042.c: Can't write CTR while closing %s port.\n",
-			port_name);
+		pr_warning("Can't write CTR while closing %s port\n",
+			   port_name);
 
 	udelay(50);
 
 	i8042_ctr &= ~disable_bit;
 	i8042_ctr |= irq_bit;
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_ERR "i8042.c: Can't reactivate %s port.\n",
-			port_name);
+		pr_err("Can't reactivate %s port\n", port_name);
 
 	/*
 	 * See if there is any data appeared while we were messing with
@@ -544,7 +544,7 @@ static int i8042_enable_kbd_port(void)
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
 		i8042_ctr &= ~I8042_CTR_KBDINT;
 		i8042_ctr |= I8042_CTR_KBDDIS;
-		printk(KERN_ERR "i8042.c: Failed to enable KBD port.\n");
+		pr_err("Failed to enable KBD port\n");
 		return -EIO;
 	}
 
@@ -563,7 +563,7 @@ static int i8042_enable_aux_port(void)
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
 		i8042_ctr &= ~I8042_CTR_AUXINT;
 		i8042_ctr |= I8042_CTR_AUXDIS;
-		printk(KERN_ERR "i8042.c: Failed to enable AUX port.\n");
+		pr_err("Failed to enable AUX port\n");
 		return -EIO;
 	}
 
@@ -645,7 +645,7 @@ static int __init i8042_check_mux(void)
 	if (i8042_set_mux_mode(true, &mux_version))
 		return -1;
 
-	printk(KERN_INFO "i8042.c: Detected active multiplexing controller, rev %d.%d.\n",
+	pr_info("Detected active multiplexing controller, rev %d.%d\n",
 		(mux_version >> 4) & 0xf, mux_version & 0xf);
 
 /*
@@ -655,7 +655,7 @@ static int __init i8042_check_mux(void)
 	i8042_ctr &= ~I8042_CTR_AUXINT;
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_ERR "i8042.c: Failed to disable AUX port, can't use MUX.\n");
+		pr_err("Failed to disable AUX port, can't use MUX\n");
 		return -EIO;
 	}
 
@@ -774,8 +774,8 @@ static int __init i8042_check_aux(void)
  */
 
 	if (i8042_toggle_aux(false)) {
-		printk(KERN_WARNING "Failed to disable AUX port, but continuing anyway... Is this a SiS?\n");
-		printk(KERN_WARNING "If AUX port is really absent please use the 'i8042.noaux' option.\n");
+		pr_warning("Failed to disable AUX port, but continuing anyway... Is this a SiS?\n");
+		pr_warning("If AUX port is really absent please use the 'i8042.noaux' option\n");
 	}
 
 	if (i8042_toggle_aux(true))
@@ -849,7 +849,7 @@ static int __init i8042_check_aux(void)
 static int i8042_controller_check(void)
 {
 	if (i8042_flush() == I8042_BUFFER_SIZE) {
-		printk(KERN_ERR "i8042.c: No controller found.\n");
+		pr_err("No controller found\n");
 		return -ENODEV;
 	}
 
@@ -868,15 +868,15 @@ static int i8042_controller_selftest(void)
 	do {
 
 		if (i8042_command(&param, I8042_CMD_CTL_TEST)) {
-			printk(KERN_ERR "i8042.c: i8042 controller self test timeout.\n");
+			pr_err("i8042 controller self test timeout\n");
 			return -ENODEV;
 		}
 
 		if (param == I8042_RET_CTL_TEST)
 			return 0;
 
-		printk(KERN_ERR "i8042.c: i8042 controller selftest failed. (%#x != %#x)\n",
-			param, I8042_RET_CTL_TEST);
+		pr_err("i8042 controller selftest failed. (%#x != %#x)\n",
+		       param, I8042_RET_CTL_TEST);
 		msleep(50);
 	} while (i++ < 5);
 
@@ -887,8 +887,7 @@ static int i8042_controller_selftest(void)
 	 * and user will still get a working keyboard. This is especially
 	 * important on netbooks. On other arches we trust hardware more.
 	 */
-	printk(KERN_INFO
-		"i8042: giving up on controller selftest, continuing anyway...\n");
+	pr_info("giving up on controller selftest, continuing anyway...\n");
 	return 0;
 #else
 	return -EIO;
@@ -913,8 +912,7 @@ static int i8042_controller_init(void)
 
 	do {
 		if (n >= 10) {
-			printk(KERN_ERR
-				"i8042.c: Unable to get stable CTR read.\n");
+			pr_err("Unable to get stable CTR read\n");
 			return -EIO;
 		}
 
@@ -922,8 +920,7 @@ static int i8042_controller_init(void)
 			udelay(50);
 
 		if (i8042_command(&ctr[n++ % 2], I8042_CMD_CTL_RCTR)) {
-			printk(KERN_ERR
-				"i8042.c: Can't read CTR while initializing i8042.\n");
+			pr_err("Can't read CTR while initializing i8042\n");
 			return -EIO;
 		}
 
@@ -947,7 +944,7 @@ static int i8042_controller_init(void)
 		if (i8042_unlock)
 			i8042_ctr |= I8042_CTR_IGNKEYLOCK;
 		else
-			printk(KERN_WARNING "i8042.c: Warning: Keylock active.\n");
+			pr_warning("Warning: Keylock active\n");
 	}
 	spin_unlock_irqrestore(&i8042_lock, flags);
 
@@ -974,7 +971,7 @@ static int i8042_controller_init(void)
  */
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_ERR "i8042.c: Can't write CTR while initializing i8042.\n");
+		pr_err("Can't write CTR while initializing i8042\n");
 		return -EIO;
 	}
 
@@ -1004,7 +1001,7 @@ static void i8042_controller_reset(void)
 	i8042_ctr &= ~(I8042_CTR_KBDINT | I8042_CTR_AUXINT);
 
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_WARNING "i8042.c: Can't write CTR while resetting.\n");
+		pr_warning("Can't write CTR while resetting\n");
 
 /*
  * Disable MUX mode if present.
@@ -1025,7 +1022,7 @@ static void i8042_controller_reset(void)
  */
 
 	if (i8042_command(&i8042_initial_ctr, I8042_CMD_CTL_WCTR))
-		printk(KERN_WARNING "i8042.c: Can't restore CTR.\n");
+		pr_warning("Can't restore CTR\n");
 }
 
 
@@ -1083,9 +1080,7 @@ static void i8042_dritek_enable(void)
 
 	error = i8042_command(&param, 0x1059);
 	if (error)
-		printk(KERN_WARNING
-			"Failed to enable DRITEK extension: %d\n",
-			error);
+		pr_warning("Failed to enable DRITEK extension: %d\n", error);
 }
 #endif
 
@@ -1120,10 +1115,10 @@ static int i8042_controller_resume(bool force_reset)
 	i8042_ctr |= I8042_CTR_AUXDIS | I8042_CTR_KBDDIS;
 	i8042_ctr &= ~(I8042_CTR_AUXINT | I8042_CTR_KBDINT);
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_WARNING "i8042: Can't write CTR to resume, retrying...\n");
+		pr_warning("Can't write CTR to resume, retrying...\n");
 		msleep(50);
 		if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-			printk(KERN_ERR "i8042: CTR write retry failed\n");
+			pr_err("CTR write retry failed\n");
 			return -EIO;
 		}
 	}
@@ -1136,9 +1131,8 @@ static int i8042_controller_resume(bool force_reset)
 
 	if (i8042_mux_present) {
 		if (i8042_set_mux_mode(true, NULL) || i8042_enable_mux_ports())
-			printk(KERN_WARNING
-				"i8042: failed to resume active multiplexor, "
-				"mouse won't work.\n");
+			pr_warning("failed to resume active multiplexor, "
+				   "mouse won't work\n");
 	} else if (i8042_ports[I8042_AUX_PORT_NO].serio)
 		i8042_enable_aux_port();
 
@@ -1283,7 +1277,7 @@ static void __init i8042_register_ports(void)
 
 	for (i = 0; i < I8042_NUM_PORTS; i++) {
 		if (i8042_ports[i].serio) {
-			printk(KERN_INFO "serio: %s at %#lx,%#lx irq %d\n",
+			pr_info("%s at %#lx,%#lx irq %d\n",
 				i8042_ports[i].serio->name,
 				(unsigned long) I8042_DATA_REG,
 				(unsigned long) I8042_COMMAND_REG,
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index cbc1beb..ebbe7dc 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -89,15 +89,22 @@
 #ifdef DEBUG
 static unsigned long i8042_start_time;
 #define dbg_init() do { i8042_start_time = jiffies; } while (0)
-#define dbg(format, arg...) 							\
-	do { 									\
-		if (i8042_debug)						\
-			printk(KERN_DEBUG __FILE__ ": " format " [%d]\n" ,	\
-	 			## arg, (int) (jiffies - i8042_start_time));	\
-	} while (0)
+#define dbg(format, arg...)						\
+do {									\
+	if (i8042_debug)						\
+		printk(KERN_DEBUG pr_fmt(format " [%d]\n"),		\
+		       ##arg,						\
+		       (int)(jiffies - i8042_start_time));		\
+} while (0)
 #else
 #define dbg_init() do { } while (0)
-#define dbg(format, arg...) do {} while (0)
+#define dbg(format, arg...)						\
+do {									\
+	if (0)								\
+		printk(KERN_DEBUG pr_fmt(format " [%d]\n"),		\
+		       ##arg,						\
+		       (int)(jiffies - i8042_start_time));		\
+} while (0)
 #endif
 
 #endif /* _I8042_H */
diff --git a/drivers/input/serio/maceps2.c b/drivers/input/serio/maceps2.c
index 558200e..8348e0c 100644
--- a/drivers/input/serio/maceps2.c
+++ b/drivers/input/serio/maceps2.c
@@ -7,6 +7,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/serio.h>
@@ -91,7 +94,7 @@ static int maceps2_open(struct serio *dev)
 	struct maceps2_data *data = (struct maceps2_data *)dev->port_data;
 
 	if (request_irq(data->irq, maceps2_interrupt, 0, "PS2 port", dev)) {
-		printk(KERN_ERR "Could not allocate PS/2 IRQ\n");
+		pr_err("Could not allocate PS/2 IRQ\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/input/serio/parkbd.c b/drivers/input/serio/parkbd.c
index 26b4593..e4155ae 100644
--- a/drivers/input/serio/parkbd.c
+++ b/drivers/input/serio/parkbd.c
@@ -44,6 +44,8 @@
  * with 300 mA power reqirement of a typical AT keyboard.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/parport.h>
 #include <linux/slab.h>
@@ -148,7 +150,7 @@ static int parkbd_getport(void)
 	pp = parport_find_number(parkbd_pp_no);
 
 	if (pp == NULL) {
-		printk(KERN_ERR "parkbd: no such parport\n");
+		pr_err("no such parport\n");
 		return -ENODEV;
 	}
 
@@ -201,8 +203,8 @@ static int __init parkbd_init(void)
 
 	serio_register_port(parkbd_port);
 
-	printk(KERN_INFO "serio: PARKBD %s adapter on %s\n",
-                        parkbd_mode ? "AT" : "XT", parkbd_dev->port->name);
+	pr_info("PARKBD %s adapter on %s\n",
+		parkbd_mode ? "AT" : "XT", parkbd_dev->port->name);
 
 	return 0;
 }
diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index 5eb84b3..0499d5a 100644
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -29,6 +29,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/serio.h>
@@ -95,7 +97,7 @@ static int q40kbd_open(struct serio *port)
 	q40kbd_flush();
 
 	if (request_irq(Q40_IRQ_KEYBOARD, q40kbd_interrupt, 0, "q40kbd", NULL)) {
-		printk(KERN_ERR "q40kbd.c: Can't get irq %d.\n", Q40_IRQ_KEYBOARD);
+		pr_err("Can't get irq %d\n", Q40_IRQ_KEYBOARD);
 		return -EBUSY;
 	}
 
@@ -129,7 +131,7 @@ static int __devinit q40kbd_probe(struct platform_device *dev)
 	strlcpy(q40kbd_port->phys, "Q40", sizeof(q40kbd_port->phys));
 
 	serio_register_port(q40kbd_port);
-	printk(KERN_INFO "serio: Q40 kbd registered\n");
+	pr_info("Q40 kbd registered\n");
 
 	return 0;
 }
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 9da6fbc..e5f2920 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -27,6 +27,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
@@ -84,12 +86,12 @@ static int rpckbd_open(struct serio *port)
 	iomd_readb(IOMD_KARTRX);
 
 	if (request_irq(IRQ_KEYBOARDRX, rpckbd_rx, 0, "rpckbd", port) != 0) {
-		printk(KERN_ERR "rpckbd.c: Could not allocate keyboard receive IRQ\n");
+		pr_err("Could not allocate keyboard receive IRQ\n");
 		return -EBUSY;
 	}
 
 	if (request_irq(IRQ_KEYBOARDTX, rpckbd_tx, 0, "rpckbd", port) != 0) {
-		printk(KERN_ERR "rpckbd.c: Could not allocate keyboard transmit IRQ\n");
+		pr_err("Could not allocate keyboard transmit IRQ\n");
 		free_irq(IRQ_KEYBOARDRX, NULL);
 		return -EBUSY;
 	}
diff --git a/drivers/input/serio/sa1111ps2.c b/drivers/input/serio/sa1111ps2.c
index d55874e..7836323 100644
--- a/drivers/input/serio/sa1111ps2.c
+++ b/drivers/input/serio/sa1111ps2.c
@@ -7,6 +7,9 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
@@ -129,16 +132,16 @@ static int ps2_open(struct serio *io)
 	ret = request_irq(ps2if->dev->irq[0], ps2_rxint, 0,
 			  SA1111_DRIVER_NAME(ps2if->dev), ps2if);
 	if (ret) {
-		printk(KERN_ERR "sa1111ps2: could not allocate IRQ%d: %d\n",
-			ps2if->dev->irq[0], ret);
+		pr_err("could not allocate IRQ%d: %d\n",
+		       ps2if->dev->irq[0], ret);
 		return ret;
 	}
 
 	ret = request_irq(ps2if->dev->irq[1], ps2_txint, 0,
 			  SA1111_DRIVER_NAME(ps2if->dev), ps2if);
 	if (ret) {
-		printk(KERN_ERR "sa1111ps2: could not allocate IRQ%d: %d\n",
-			ps2if->dev->irq[1], ret);
+		pr_err("could not allocate IRQ%d: %d\n",
+		       ps2if->dev->irq[1], ret);
 		free_irq(ps2if->dev->irq[0], ps2if);
 		return ret;
 	}
@@ -204,19 +207,19 @@ static int __devinit ps2_test(struct ps2if *ps2if)
 
 	stat = ps2_test_one(ps2if, PS2CR_FKC);
 	if (stat != PS2STAT_KBD) {
-		printk("PS/2 interface test failed[1]: %02x\n", stat);
+		pr_info("PS/2 interface test failed[1]: %02x\n", stat);
 		ret = -ENODEV;
 	}
 
 	stat = ps2_test_one(ps2if, 0);
 	if (stat != (PS2STAT_KBC | PS2STAT_KBD)) {
-		printk("PS/2 interface test failed[2]: %02x\n", stat);
+		pr_info("PS/2 interface test failed[2]: %02x\n", stat);
 		ret = -ENODEV;
 	}
 
 	stat = ps2_test_one(ps2if, PS2CR_FKD);
 	if (stat != PS2STAT_KBC) {
-		printk("PS/2 interface test failed[3]: %02x\n", stat);
+		pr_info("PS/2 interface test failed[3]: %02x\n", stat);
 		ret = -ENODEV;
 	}
 
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 9986648..2db32a0 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -9,6 +9,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
@@ -276,7 +278,7 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 	int err;
 
 	if (!(serio_raw = kzalloc(sizeof(struct serio_raw), GFP_KERNEL))) {
-		printk(KERN_ERR "serio_raw.c: can't allocate memory for a device\n");
+		pr_err("can't allocate memory for a device\n");
 		return -ENOMEM;
 	}
 
@@ -308,12 +310,12 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 	}
 
 	if (err) {
-		printk(KERN_INFO "serio_raw: failed to register raw access device for %s\n",
+		pr_info("failed to register raw access device for %s\n",
 			serio->phys);
 		goto out_close;
 	}
 
-	printk(KERN_INFO "serio_raw: raw access enabled on %s (%s, minor %d)\n",
+	pr_info("raw access enabled on %s (%s, minor %d)\n",
 		serio->phys, serio_raw->name, serio_raw->dev.minor);
 	goto out;
 
@@ -334,7 +336,7 @@ static int serio_raw_reconnect(struct serio *serio)
 	struct serio_driver *drv = serio->drv;
 
 	if (!drv || !serio_raw) {
-		printk(KERN_DEBUG "serio_raw: reconnect request, but serio is disconnected, ignoring...\n");
+		printk(KERN_DEBUG pr_fmt("reconnect request, but serio is disconnected, ignoring...\n"));
 		return -1;
 	}
 
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 6d34511..5e6d379 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -13,6 +13,8 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -167,7 +169,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	serio->port_data = serport;
 
 	serio_register_port(serport->serio);
-	printk(KERN_INFO "serio: Serial port %s\n", tty_name(tty, name));
+	pr_info("Serial port %s\n", tty_name(tty, name));
 
 	wait_event_interruptible(serport->wait, test_bit(SERPORT_DEAD, &serport->flags));
 	serio_unregister_port(serport->serio);
@@ -237,7 +239,7 @@ static int __init serport_init(void)
 	int retval;
 	retval = tty_register_ldisc(N_MOUSE, &serport_ldisc);
 	if (retval)
-		printk(KERN_ERR "serport.c: Error registering line discipline.\n");
+		pr_err("Error registering line discipline\n");
 
 	return  retval;
 }
-- 
1.7.2.19.g9a302

