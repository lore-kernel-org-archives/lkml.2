Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab0J0RT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:19:27 -0400
Received: from mail.perches.com ([173.55.12.10]:3632 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0J0RTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:19:20 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 2/2] drivers/input/serio: Use pr_fmt and pr_<level>
Date: Wed, 27 Oct 2010 10:19:11 -0700
Message-Id: <6b82e8b20d71f234e983605783f5164526c5e4a2.1288198839.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288198838.git.joe@perches.com>
References: <cover.1288198838.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove PREFIX and PFX defines and uses.
Keep "serio: " prefixes.
Add a missing newline to a message.

Compile tested x86 only.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/serio/ambakmi.c    |    5 +++-
 drivers/input/serio/ct82c710.c   |   10 ++++---
 drivers/input/serio/gscps2.c     |   15 ++++++-----
 drivers/input/serio/hil_mlc.c    |   17 ++++++------
 drivers/input/serio/hp_sdc.c     |   51 ++++++++++++++++++-------------------
 drivers/input/serio/hp_sdc_mlc.c |   46 ++++++++++++++++------------------
 drivers/input/serio/i8042.c      |    2 +-
 drivers/input/serio/maceps2.c    |    5 +++-
 drivers/input/serio/parkbd.c     |    8 +++--
 drivers/input/serio/q40kbd.c     |    6 +++-
 drivers/input/serio/rpckbd.c     |    6 +++-
 drivers/input/serio/sa1111ps2.c  |   11 +++++---
 drivers/input/serio/serio.c      |    8 +++---
 drivers/input/serio/serio_raw.c  |    8 +++--
 drivers/input/serio/serport.c    |    6 +++-
 15 files changed, 111 insertions(+), 93 deletions(-)

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
index 4a30846..77a0e9e 100644
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
+		pr_warn("Device busy in close()\n");
 
 	outb_p(inb_p(CT82C710_STATUS) & ~(CT82C710_ENABLE | CT82C710_INTS_ON), CT82C710_STATUS);
 
 	if (ct82c170_wait())
-		printk(KERN_WARNING "ct82c710.c: Device busy in close()\n");
+		pr_warn("Device busy in close()\n");
 
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
+	pr_info("serio: C&T 82c710 mouse port at %#llx irq %d\n",
 		(unsigned long long)CT82C710_DATA, CT82C710_IRQ);
 
 	return 0;
diff --git a/drivers/input/serio/gscps2.c b/drivers/input/serio/gscps2.c
index 3c287dd..6952c1d 100644
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
+		pr_warn("Unsupported PS/2 port at 0x%08lx (id=%d) ignored\n",
+			hpa, ps2port->id);
 		ret = -ENODEV;
 		goto fail;
 	}
@@ -384,7 +385,7 @@ static int __devinit gscps2_probe(struct parisc_device *dev)
 		goto fail;
 #endif
 
-	printk(KERN_INFO "serio: %s port at 0x%p irq %d @ %s\n",
+	pr_info("serio: %s port at 0x%p irq %d @ %s\n",
 		ps2port->port->name,
 		ps2port->addr,
 		ps2port->padev->irq,
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index e5624d8..4f67470 100644
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
+		printk(KERN_DEBUG pr_fmt("z%i  {%i}\n)", doze, mlc->seidx);
 		doze = 0;
 	}
 
@@ -776,7 +775,7 @@ static void hil_mlcs_process(unsigned long unused)
 			if (mlc->seidx != 41 &&
 			    mlc->seidx != 42 &&
 			    mlc->seidx != 43)
-				printk(KERN_DEBUG PREFIX " + ");
+				printk(KERN_CONT " + ");
 #endif
 		}
 	}
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 8c0b51c..a78780c 100644
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
+			pr_info("HP SDC reports successful PUP\n");
 		read_unlock(&hp_sdc.hook_lock);
 		break;
 
@@ -280,7 +280,7 @@ static irqreturn_t hp_sdc_nmisr(int irq, void *dev_id)
 	int status;
 
 	status = hp_sdc_status_in8();
-	printk(KERN_WARNING PREFIX "NMI !\n");
+	pr_warn("NMI !\n");
 
 #if 0
 	if (status & HP_SDC_NMISTATUS_FHS) {
@@ -290,7 +290,7 @@ static irqreturn_t hp_sdc_nmisr(int irq, void *dev_id)
 		read_unlock(&hp_sdc.hook_lock);
 	} else {
 		/* TODO: pass this on to the HIL handler, or do SAK here? */
-		printk(KERN_WARNING PREFIX "HIL NMI\n");
+		pr_warn("HIL NMI\n");
 	}
 #endif
 
@@ -322,8 +322,8 @@ static void hp_sdc_tasklet(unsigned long foo)
 			 * we'll need to figure out a way to communicate
 			 * it back to the application. and be less verbose.
 			 */
-			printk(KERN_WARNING PREFIX "read timeout (%ius)!\n",
-			       (int)(tv.tv_usec - hp_sdc.rtv.tv_usec));
+			pr_warn("read timeout (%ius)!\n",
+				(int)(tv.tv_usec - hp_sdc.rtv.tv_usec));
 			curr->idx += hp_sdc.rqty;
 			hp_sdc.rqty = 0;
 			tmp = curr->seq[curr->actidx];
@@ -624,11 +624,11 @@ int __hp_sdc_enqueue_transaction(hp_sdc_transaction *this)
 			return 0;
 		}
 
-	printk(KERN_WARNING PREFIX "No free slot to add transaction.\n");
+	pr_warn("No free slot to add transaction\n");
 	return -EBUSY;
 
  fail:
-	printk(KERN_WARNING PREFIX "Transaction add failed: transaction already queued?\n");
+	pr_warn("Transaction add failed: transaction already queued?\n");
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
@@ -922,7 +922,7 @@ static int __init hp_sdc_init(void)
  err1:
 	release_region(hp_sdc.data_io, 2);
  err0:
-	printk(KERN_WARNING PREFIX ": %s SDC IO=0x%p IRQ=0x%x NMI=0x%x\n",
+	pr_warn("%s SDC IO=0x%p IRQ=0x%x NMI=0x%x\n",
 		errstr, (void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
 	hp_sdc.dev = NULL;
 
@@ -992,7 +992,7 @@ static void hp_sdc_exit(void)
 #if defined(__hppa__)
 	cancel_delayed_work_sync(&moduleloader_work);
 	if (unregister_parisc_driver(&hp_sdc_driver))
-		printk(KERN_WARNING PREFIX "Error unregistering HP SDC");
+		pr_warn("Error unregistering HP SDC\n");
 #endif
 }
 
@@ -1007,7 +1007,7 @@ static int __init hp_sdc_register(void)
 #endif
 
 	if (hp_sdc_disabled) {
-		printk(KERN_WARNING PREFIX "HP SDC driver disabled by no_hpsdc=1.\n");
+		pr_warn("HP SDC driver disabled by no_hpsdc=1\n");
 		return -ENODEV;
 	}
 
@@ -1015,7 +1015,7 @@ static int __init hp_sdc_register(void)
 	hp_sdc.dev_err = 0;
 #if defined(__hppa__)
 	if (register_parisc_driver(&hp_sdc_driver)) {
-		printk(KERN_WARNING PREFIX "Error registering SDC with system bus tree.\n");
+		pr_warn("Error registering SDC with system bus tree\n");
 		return -ENODEV;
 	}
 #elif defined(__mc68000__)
@@ -1035,7 +1035,7 @@ static int __init hp_sdc_register(void)
 	hp_sdc.dev_err   = hp_sdc_init();
 #endif
 	if (hp_sdc.dev == NULL) {
-		printk(KERN_WARNING PREFIX "No SDC found.\n");
+		pr_warn("No SDC found\n");
 		return hp_sdc.dev_err;
 	}
 
@@ -1060,14 +1060,14 @@ static int __init hp_sdc_register(void)
 	up(&tq_init_sem);
 
 	if ((tq_init_seq[0] & HP_SDC_ACT_DEAD) == HP_SDC_ACT_DEAD) {
-		printk(KERN_WARNING PREFIX "Error reading config byte.\n");
+		pr_warn("Error reading config byte\n");
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
+			pr_warn("Error reading extended config byte\n");
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
index 7d2b820..aa2d5f3 100644
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
+		pr_warn("HIL Overflow!\n");
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
+		pr_warn("Bastard SDC reconfigured loop!\n");
 		break;
 
 	case HP_SDC_HIL_ERR:
@@ -121,11 +121,11 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 		break;
 
 	case HP_SDC_HIL_RC:
-		printk(KERN_WARNING PREFIX "Bastard SDC decided to reconfigure loop!\n");
+		pr_warn("Bastard SDC decided to reconfigure loop!\n");
 		break;
 
 	default:
-		printk(KERN_WARNING PREFIX "Unknown HIL Error status (%x)!\n", data);
+		pr_warn("Unknown HIL Error status (%x)!\n", data);
 		break;
 	}
 
@@ -157,16 +157,11 @@ static int hp_sdc_mlc_in(hil_mlc *mlc, suseconds_t timeout)
 						HIL_PKT_ADDR_MASK |
 						HIL_PKT_DATA_MASK));
 			mlc->icount = 14;
-			/* printk(KERN_DEBUG PREFIX ">[%x]\n", mlc->ipacket[0]); */
 			goto wasup;
 		}
 		do_gettimeofday(&tv);
 		tv.tv_usec += USEC_PER_SEC * (tv.tv_sec - mlc->instart.tv_sec);
 		if (tv.tv_usec - mlc->instart.tv_usec > mlc->intimeout) {
-			/*	printk("!%i %i",
-				tv.tv_usec - mlc->instart.tv_usec,
-				mlc->intimeout);
-			 */
 			rc = 1;
 			up(&mlc->isem);
 		}
@@ -311,7 +306,7 @@ static int __init hp_sdc_mlc_init(void)
 		return -ENODEV;
 #endif
 
-	printk(KERN_INFO PREFIX "Registering the System Domain Controller's HIL MLC.\n");
+	pr_info("Registering the System Domain Controller's HIL MLC\n");
 
 	hp_sdc_mlc_priv.emtestmode = 0;
 	hp_sdc_mlc_priv.trans.seq = hp_sdc_mlc_priv.tseq;
@@ -324,19 +319,20 @@ static int __init hp_sdc_mlc_init(void)
 	mlc->priv = &hp_sdc_mlc_priv;
 
 	if (hil_mlc_register(mlc)) {
-		printk(KERN_WARNING PREFIX "Failed to register MLC structure with hil_mlc\n");
+		pr_warn("Failed to register MLC structure with hil_mlc\n");
 		goto err0;
 	}
 
 	if (hp_sdc_request_hil_irq(&hp_sdc_mlc_isr)) {
-		printk(KERN_WARNING PREFIX "Request for raw HIL ISR hook denied\n");
+		pr_warn("Request for raw HIL ISR hook denied\n");
 		goto err1;
 	}
 	return 0;
  err1:
-	if (hil_mlc_unregister(mlc))
-		printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
-			"This is bad.  Could cause an oops.\n");
+	if (hil_mlc_unregister(mlc)) {
+		pr_err("Failed to unregister MLC structure with hil_mlc\n");
+		pr_err("This is bad.  Could cause an oops.\n");
+	}
  err0:
 	return -EBUSY;
 }
@@ -345,13 +341,15 @@ static void __exit hp_sdc_mlc_exit(void)
 {
 	hil_mlc *mlc = &hp_sdc_mlc;
 
-	if (hp_sdc_release_hil_irq(&hp_sdc_mlc_isr))
-		printk(KERN_ERR PREFIX "Failed to release the raw HIL ISR hook.\n"
-			"This is bad.  Could cause an oops.\n");
+	if (hp_sdc_release_hil_irq(&hp_sdc_mlc_isr)) {
+		pr_err("Failed to release the raw HIL ISR hook\n");
+		pr_err("This is bad.  Could cause an oops.\n");
+	}
 
-	if (hil_mlc_unregister(mlc))
-		printk(KERN_ERR PREFIX "Failed to unregister MLC structure with hil_mlc.\n"
-			"This is bad.  Could cause an oops.\n");
+	if (hil_mlc_unregister(mlc)) {
+		pr_err("Failed to unregister MLC structure with hil_mlc\n");
+		pr_err("This is bad.  Could cause an oops.\n");
+	}
 }
 
 module_init(hp_sdc_mlc_init);
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index b6eea1e..abb4f36 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -772,7 +772,7 @@ static int __init i8042_check_aux(void)
 
 	if (i8042_toggle_aux(false)) {
 		pr_warn("Failed to disable AUX port, but continuing anyway... Is this a SiS?\n");
-		pr_warn("If AUX port is really absent please use the 'i8042.noaux' option.\n");
+		pr_warn("If AUX port is really absent please use the 'i8042.noaux' option\n");
 	}
 
 	if (i8042_toggle_aux(true))
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
index 26b4593..bf8bca6 100644
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
+	pr_info("serio: PARKBD %s adapter on %s\n",
+		parkbd_mode ? "AT" : "XT", parkbd_dev->port->name);
 
 	return 0;
 }
diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index 5eb84b3..01539db 100644
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
+	pr_info("serio: Q40 kbd registered\n");
 
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
index d55874e..4589882 100644
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
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 405bf21..27dd457 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -200,8 +200,8 @@ static int serio_queue_event(void *object, struct module *owner,
 	}
 
 	if (!try_module_get(owner)) {
-		pr_warning("Can't get module reference, dropping event %d\n",
-			   event_type);
+		pr_warn("Can't get module reference, dropping event %d\n",
+			event_type);
 		kfree(event);
 		retval = -EINVAL;
 		goto out;
@@ -818,8 +818,8 @@ static void serio_attach_driver(struct serio_driver *drv)
 
 	error = driver_attach(&drv->driver);
 	if (error)
-		pr_warning("driver_attach() failed for %s with error %d\n",
-			   drv->driver.name, error);
+		pr_warn("driver_attach() failed for %s with error %d\n",
+			drv->driver.name, error);
 }
 
 int __serio_register_driver(struct serio_driver *drv, struct module *owner, const char *mod_name)
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index cd82bb1..8f2c6ec 100644
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
@@ -277,7 +279,7 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 	int err;
 
 	if (!(serio_raw = kzalloc(sizeof(struct serio_raw), GFP_KERNEL))) {
-		printk(KERN_ERR "serio_raw.c: can't allocate memory for a device\n");
+		pr_err("can't allocate memory for a device\n");
 		return -ENOMEM;
 	}
 
@@ -309,12 +311,12 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
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
 
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 6e362de..e94c126 100644
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
@@ -168,7 +170,7 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	serio->dev.parent = tty->dev;
 
 	serio_register_port(serport->serio);
-	printk(KERN_INFO "serio: Serial port %s\n", tty_name(tty, name));
+	pr_info("serio: Serial port %s\n", tty_name(tty, name));
 
 	wait_event_interruptible(serport->wait, test_bit(SERPORT_DEAD, &serport->flags));
 	serio_unregister_port(serport->serio);
@@ -238,7 +240,7 @@ static int __init serport_init(void)
 	int retval;
 	retval = tty_register_ldisc(N_MOUSE, &serport_ldisc);
 	if (retval)
-		printk(KERN_ERR "serport.c: Error registering line discipline.\n");
+		pr_err("Error registering line discipline\n");
 
 	return  retval;
 }
-- 
1.7.3.1.g432b3.dirty

