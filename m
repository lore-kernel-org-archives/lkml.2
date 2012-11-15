Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993208Ab2KOI4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:56:53 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58349 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992999Ab2KOIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 9/9] TTY: call tty_port_destroy in the rest of drivers
Date: Thu, 15 Nov 2012 09:49:56 +0100
Message-Id: <1352969396-23760-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit "TTY: move tty buffers to tty_port", the tty buffers are
not freed in some drivers. This is because tty_port_destructor is not
called whenever a tty_port is freed. This was an assumption I counted
with but was unfortunately untrue. So fix the drivers to fulfil this
assumption.

To be sure, the TTY buffers (and later some stuff) are gone along with
the tty_port, we have to call tty_port_destroy at tear-down places.
This is mostly where the structure containing a tty_port is freed.
This patch does exactly that -- put tty_port_destroy at those places.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/alpha/kernel/srmcons.c             |  5 ++++-
 arch/ia64/hp/sim/simserial.c            |  1 +
 arch/m68k/emu/nfcon.c                   |  6 ++++--
 arch/parisc/kernel/pdc_cons.c           |  5 +++--
 arch/um/drivers/line.c                  |  2 ++
 arch/xtensa/platforms/iss/console.c     |  1 +
 drivers/char/pcmcia/synclink_cs.c       |  5 ++++-
 drivers/char/ttyprintk.c                |  4 +++-
 drivers/isdn/gigaset/common.c           | 10 ++++++----
 drivers/isdn/i4l/isdn_tty.c             |  4 ++++
 drivers/misc/pti.c                      |  7 +++++--
 drivers/net/usb/hso.c                   |  5 +++--
 drivers/s390/char/con3215.c             |  1 +
 drivers/s390/char/sclp_tty.c            |  4 +++-
 drivers/s390/char/sclp_vt220.c          |  2 ++
 drivers/s390/char/tty3270.c             |  2 ++
 drivers/staging/ccg/u_serial.c          |  5 ++++-
 drivers/staging/dgrp/dgrp_specproc.c    |  2 ++
 drivers/staging/dgrp/dgrp_tty.c         |  4 +++-
 drivers/staging/ipack/devices/ipoctal.c |  2 ++
 drivers/tty/amiserial.c                 |  2 ++
 drivers/tty/bfin_jtag_comm.c            |  6 ++++--
 drivers/tty/cyclades.c                  |  8 +++++---
 drivers/tty/ehv_bytechan.c              |  2 ++
 drivers/tty/hvc/hvsi.c                  |  1 +
 drivers/tty/ipwireless/tty.c            |  1 +
 drivers/tty/moxa.c                      |  4 ++++
 drivers/tty/mxser.c                     | 25 +++++++++++++++++--------
 drivers/tty/nozomi.c                    | 13 +++++++++----
 drivers/tty/rocket.c                    |  2 ++
 drivers/tty/serial/68328serial.c        |  2 ++
 drivers/tty/serial/ifx6x60.c            |  5 ++++-
 drivers/tty/serial/kgdb_nmi.c           |  2 ++
 drivers/tty/serial/serial_core.c        |  6 ++++++
 drivers/tty/synclink.c                  |  1 +
 drivers/tty/synclink_gt.c               |  5 ++++-
 drivers/tty/synclinkmp.c                |  5 ++++-
 drivers/tty/vt/vt.c                     |  5 ++++-
 drivers/usb/gadget/u_serial.c           |  5 ++++-
 drivers/usb/serial/usb-serial.c         |  1 +
 net/irda/ircomm/ircomm_tty.c            |  1 +
 41 files changed, 139 insertions(+), 40 deletions(-)

diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 5d58652..59b7bba 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -205,7 +205,6 @@ static const struct tty_operations srmcons_ops = {
 static int __init
 srmcons_init(void)
 {
-	tty_port_init(&srmcons_singleton.port);
 	setup_timer(&srmcons_singleton.timer, srmcons_receive_chars,
 			(unsigned long)&srmcons_singleton);
 	if (srm_is_registered_console) {
@@ -215,6 +214,9 @@ srmcons_init(void)
 		driver = alloc_tty_driver(MAX_SRM_CONSOLE_DEVICES);
 		if (!driver)
 			return -ENOMEM;
+
+		tty_port_init(&srmcons_singleton.port);
+
 		driver->driver_name = "srm";
 		driver->name = "srm";
 		driver->major = 0; 	/* dynamic */
@@ -227,6 +229,7 @@ srmcons_init(void)
 		err = tty_register_driver(driver);
 		if (err) {
 			put_tty_driver(driver);
+			tty_port_destroy(&srmcons_singleton.port);
 			return err;
 		}
 		srmcons_driver = driver;
diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index ec536e4..fc3924d 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -555,6 +555,7 @@ static int __init simrs_init(void)
 	return 0;
 err_free_tty:
 	put_tty_driver(hp_simserial_driver);
+	tty_port_destroy(&state->port);
 	return retval;
 }
 
diff --git a/arch/m68k/emu/nfcon.c b/arch/m68k/emu/nfcon.c
index 16d170f..6685bf4 100644
--- a/arch/m68k/emu/nfcon.c
+++ b/arch/m68k/emu/nfcon.c
@@ -120,8 +120,6 @@ static int __init nfcon_init(void)
 {
 	int res;
 
-	tty_port_init(&nfcon_tty_port);
-
 	stderr_id = nf_get_id("NF_STDERR");
 	if (!stderr_id)
 		return -ENODEV;
@@ -130,6 +128,8 @@ static int __init nfcon_init(void)
 	if (!nfcon_tty_driver)
 		return -ENOMEM;
 
+	tty_port_init(&nfcon_tty_port);
+
 	nfcon_tty_driver->driver_name = "nfcon";
 	nfcon_tty_driver->name = "nfcon";
 	nfcon_tty_driver->type = TTY_DRIVER_TYPE_SYSTEM;
@@ -143,6 +143,7 @@ static int __init nfcon_init(void)
 	if (res) {
 		pr_err("failed to register nfcon tty driver\n");
 		put_tty_driver(nfcon_tty_driver);
+		tty_port_destroy(&nfcon_tty_port);
 		return res;
 	}
 
@@ -157,6 +158,7 @@ static void __exit nfcon_exit(void)
 	unregister_console(&nf_console);
 	tty_unregister_driver(nfcon_tty_driver);
 	put_tty_driver(nfcon_tty_driver);
+	tty_port_destroy(&nfcon_tty_port);
 }
 
 module_init(nfcon_init);
diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 8823863..efc5e7d 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -186,13 +186,13 @@ static int __init pdc_console_tty_driver_init(void)
 	printk(KERN_INFO "The PDC console driver is still registered, removing CON_BOOT flag\n");
 	pdc_cons.flags &= ~CON_BOOT;
 
-	tty_port_init(&tty_port);
-
 	pdc_console_tty_driver = alloc_tty_driver(1);
 
 	if (!pdc_console_tty_driver)
 		return -ENOMEM;
 
+	tty_port_init(&tty_port);
+
 	pdc_console_tty_driver->driver_name = "pdc_cons";
 	pdc_console_tty_driver->name = "ttyB";
 	pdc_console_tty_driver->major = MUX_MAJOR;
@@ -207,6 +207,7 @@ static int __init pdc_console_tty_driver_init(void)
 	err = tty_register_driver(pdc_console_tty_driver);
 	if (err) {
 		printk(KERN_ERR "Unable to register the PDC console TTY driver\n");
+		tty_port_destroy(&tty_port);
 		return err;
 	}
 
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index fd9a15b..9ffc28b 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -584,6 +584,8 @@ int register_lines(struct line_driver *line_driver,
 		printk(KERN_ERR "register_lines : can't register %s driver\n",
 		       line_driver->name);
 		put_tty_driver(driver);
+		for (i = 0; i < nlines; i++)
+			tty_port_destroy(&lines[i].port);
 		return err;
 	}
 
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 7e74895..8207a11 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -221,6 +221,7 @@ static __exit void rs_exit(void)
 		printk("ISS_SERIAL: failed to unregister serial driver (%d)\n",
 		       error);
 	put_tty_driver(serial_driver);
+	tty_port_destroy(&serial_port);
 }
 
 
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 21721d2..b66eaa0 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -549,8 +549,10 @@ static int mgslpc_probe(struct pcmcia_device *link)
     /* Initialize the struct pcmcia_device structure */
 
     ret = mgslpc_config(link);
-    if (ret)
+    if (ret) {
+	    tty_port_destroy(&info->port);
 	    return ret;
+    }
 
     mgslpc_add_device(info);
 
@@ -2757,6 +2759,7 @@ static void mgslpc_remove_device(MGSLPC_INFO *remove_info)
 			hdlcdev_exit(info);
 #endif
 			release_resources(info);
+			tty_port_destroy(&info->port);
 			kfree(info);
 			mgslpc_device_count--;
 			return;
diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index af98f6d..4945bd3 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -179,7 +179,6 @@ static int __init ttyprintk_init(void)
 {
 	int ret = -ENOMEM;
 
-	tty_port_init(&tpk_port.port);
 	tpk_port.port.ops = &null_ops;
 	mutex_init(&tpk_port.port_write_mutex);
 
@@ -190,6 +189,8 @@ static int __init ttyprintk_init(void)
 	if (IS_ERR(ttyprintk_driver))
 		return PTR_ERR(ttyprintk_driver);
 
+	tty_port_init(&tpk_port.port);
+
 	ttyprintk_driver->driver_name = "ttyprintk";
 	ttyprintk_driver->name = "ttyprintk";
 	ttyprintk_driver->major = TTYAUX_MAJOR;
@@ -211,6 +212,7 @@ static int __init ttyprintk_init(void)
 error:
 	tty_unregister_driver(ttyprintk_driver);
 	put_tty_driver(ttyprintk_driver);
+	tty_port_destroy(&tpk_port.port);
 	ttyprintk_driver = NULL;
 	return ret;
 }
diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index 30a6b17..bc9d89a 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -518,6 +518,7 @@ f_bcs:	gig_dbg(DEBUG_INIT, "freeing bcs[]");
 	kfree(cs->bcs);
 f_cs:	gig_dbg(DEBUG_INIT, "freeing cs");
 	mutex_unlock(&cs->mutex);
+	tty_port_destroy(&cs->port);
 	free_cs(cs);
 }
 EXPORT_SYMBOL_GPL(gigaset_freecs);
@@ -751,14 +752,14 @@ struct cardstate *gigaset_initcs(struct gigaset_driver *drv, int channels,
 	gig_dbg(DEBUG_INIT, "setting up iif");
 	if (gigaset_isdn_regdev(cs, modulename) < 0) {
 		pr_err("error registering ISDN device\n");
-		goto error;
+		goto error_port;
 	}
 
 	make_valid(cs, VALID_ID);
 	++cs->cs_init;
 	gig_dbg(DEBUG_INIT, "setting up hw");
 	if (cs->ops->initcshw(cs) < 0)
-		goto error;
+		goto error_port;
 
 	++cs->cs_init;
 
@@ -773,7 +774,7 @@ struct cardstate *gigaset_initcs(struct gigaset_driver *drv, int channels,
 		gig_dbg(DEBUG_INIT, "setting up bcs[%d]", i);
 		if (gigaset_initbcs(cs->bcs + i, cs, i) < 0) {
 			pr_err("could not allocate channel %d data\n", i);
-			goto error;
+			goto error_port;
 		}
 	}
 
@@ -786,7 +787,8 @@ struct cardstate *gigaset_initcs(struct gigaset_driver *drv, int channels,
 
 	gig_dbg(DEBUG_INIT, "cs initialized");
 	return cs;
-
+error_port:
+	tty_port_destroy(&cs->port);
 error:
 	gig_dbg(DEBUG_INIT, "failed");
 	gigaset_freecs(cs);
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index b817809..e09dc8a 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1849,6 +1849,8 @@ err_unregister:
 		kfree(info->fax);
 #endif
 		kfree(info->port.xmit_buf - 4);
+		info->port.xmit_buf = NULL;
+		tty_port_destroy(&info->port);
 	}
 	tty_unregister_driver(m->tty_modem);
 err:
@@ -1870,6 +1872,8 @@ isdn_tty_exit(void)
 		kfree(info->fax);
 #endif
 		kfree(info->port.xmit_buf - 4);
+		info->port.xmit_buf = NULL;
+		tty_port_destroy(&info->port);
 	}
 	tty_unregister_driver(dev->mdm.tty_modem);
 	put_tty_driver(dev->mdm.tty_modem);
diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 4999b34..a1f0d17 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -882,11 +882,14 @@ err:
 static void __devexit pti_pci_remove(struct pci_dev *pdev)
 {
 	struct pti_dev *drv_data = pci_get_drvdata(pdev);
+	unsigned int a;
 
 	unregister_console(&pti_console);
 
-	tty_unregister_device(pti_tty_driver, 0);
-	tty_unregister_device(pti_tty_driver, 1);
+	for (a = 0; a < PTITTY_MINOR_NUM; a++) {
+		tty_unregister_device(pti_tty_driver, a);
+		tty_port_destroy(&drv_data->port[a]);
+	}
 
 	iounmap(drv_data->pti_ioaddr);
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 605a4ba..cd8ccb2 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2274,6 +2274,7 @@ static void hso_serial_common_free(struct hso_serial *serial)
 	/* unlink and free TX URB */
 	usb_free_urb(serial->tx_urb);
 	kfree(serial->tx_data);
+	tty_port_destroy(&serial->port);
 }
 
 static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
@@ -2283,12 +2284,12 @@ static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
 	int minor;
 	int i;
 
+	tty_port_init(&serial->port);
+
 	minor = get_free_serial_index();
 	if (minor < 0)
 		goto exit;
 
-	tty_port_init(&serial->port);
-
 	/* register our minor number */
 	serial->parent->dev = tty_port_register_device(&serial->port, tty_drv,
 			minor, &serial->parent->interface->dev);
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 9ffb6d5..8fb014f 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -677,6 +677,7 @@ static void raw3215_free_info(struct raw3215_info *raw)
 {
 	kfree(raw->inbuf);
 	kfree(raw->buffer);
+	tty_port_destroy(&raw->port);
 	kfree(raw);
 }
 
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 30ec09e..877fbc3 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -547,7 +547,6 @@ sclp_tty_init(void)
 		sclp_tty_tolower = 1;
 	}
 	sclp_tty_chars_count = 0;
-	tty_port_init(&sclp_port);
 
 	rc = sclp_register(&sclp_input_event);
 	if (rc) {
@@ -555,6 +554,8 @@ sclp_tty_init(void)
 		return rc;
 	}
 
+	tty_port_init(&sclp_port);
+
 	driver->driver_name = "sclp_line";
 	driver->name = "sclp_line";
 	driver->major = TTY_MAJOR;
@@ -571,6 +572,7 @@ sclp_tty_init(void)
 	rc = tty_register_driver(driver);
 	if (rc) {
 		put_tty_driver(driver);
+		tty_port_destroy(&sclp_port);
 		return rc;
 	}
 	sclp_tty_driver = driver;
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 7e60f3d..effcc87 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -615,6 +615,7 @@ static void __init __sclp_vt220_cleanup(void)
 		return;
 	sclp_unregister(&sclp_vt220_register);
 	__sclp_vt220_free_pages();
+	tty_port_destroy(&sclp_vt220_port);
 }
 
 /* Allocate buffer pages and register with sclp core. Controlled by init
@@ -650,6 +651,7 @@ out:
 	if (rc) {
 		__sclp_vt220_free_pages();
 		sclp_vt220_init_count--;
+		tty_port_destroy(&sclp_vt220_port);
 	}
 	return rc;
 }
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 482ee02..43ea059 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -722,6 +722,7 @@ out_pages:
 	while (pages--)
 		free_pages((unsigned long) tp->freemem_pages[pages], 0);
 	kfree(tp->freemem_pages);
+	tty_port_destroy(&tp->port);
 out_tp:
 	kfree(tp);
 out_err:
@@ -744,6 +745,7 @@ tty3270_free_view(struct tty3270 *tp)
 	for (pages = 0; pages < TTY3270_STRING_PAGES; pages++)
 		free_pages((unsigned long) tp->freemem_pages[pages], 0);
 	kfree(tp->freemem_pages);
+	tty_port_destroy(&tp->port);
 	kfree(tp);
 }
 
diff --git a/drivers/staging/ccg/u_serial.c b/drivers/staging/ccg/u_serial.c
index 5b3f5ff..373c406 100644
--- a/drivers/staging/ccg/u_serial.c
+++ b/drivers/staging/ccg/u_serial.c
@@ -1140,8 +1140,10 @@ int gserial_setup(struct usb_gadget *g, unsigned count)
 
 	return status;
 fail:
-	while (count--)
+	while (count--) {
+		tty_port_destroy(&ports[count].port->port);
 		kfree(ports[count].port);
+	}
 	put_tty_driver(gs_tty_driver);
 	gs_tty_driver = NULL;
 	return status;
@@ -1195,6 +1197,7 @@ void gserial_cleanup(void)
 
 		WARN_ON(port->port_usb != NULL);
 
+		tty_port_destroy(&port->port);
 		kfree(port);
 	}
 	n_ports = 0;
diff --git a/drivers/staging/dgrp/dgrp_specproc.c b/drivers/staging/dgrp/dgrp_specproc.c
index db91f67..c214078 100644
--- a/drivers/staging/dgrp/dgrp_specproc.c
+++ b/drivers/staging/dgrp/dgrp_specproc.c
@@ -752,6 +752,8 @@ static int dgrp_add_id(long id)
 
 	return 0;
 
+	/* FIXME this guy should free the tty driver stored in nd and destroy
+	 * all channel ports */
 error_out:
 	kfree(nd);
 	return ret;
diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index e125b03..0db4c05 100644
--- a/drivers/staging/dgrp/dgrp_tty.c
+++ b/drivers/staging/dgrp/dgrp_tty.c
@@ -3119,6 +3119,7 @@ static void dgrp_tty_hangup(struct tty_struct *tty)
 void
 dgrp_tty_uninit(struct nd_struct *nd)
 {
+	unsigned int i;
 	char id[3];
 
 	ID_TO_CHAR(nd->nd_ID, id);
@@ -3152,6 +3153,8 @@ dgrp_tty_uninit(struct nd_struct *nd)
 		put_tty_driver(nd->nd_xprint_ttdriver);
 		nd->nd_ttdriver_flags &= ~XPRINT_TTDRV_REG;
 	}
+	for (i = 0; i < CHAN_MAX; i++)
+		tty_port_destroy(&nd->nd_chan[i].port);
 }
 
 
@@ -3335,7 +3338,6 @@ dgrp_tty_init(struct nd_struct *nd)
 		init_waitqueue_head(&(ch->ch_pun.un_open_wait));
 		init_waitqueue_head(&(ch->ch_pun.un_close_wait));
 		tty_port_init(&ch->port);
-		tty_port_init(&ch->port);
 	}
 	return 0;
 }
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index b6a72e6..cd41209 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -414,6 +414,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		tty_dev = tty_port_register_device(&channel->tty_port, tty, i, NULL);
 		if (IS_ERR(tty_dev)) {
 			dev_err(&ipoctal->dev->dev, "Failed to register tty device.\n");
+			tty_port_destroy(&channel->tty_port);
 			continue;
 		}
 		dev_set_drvdata(tty_dev, channel);
@@ -699,6 +700,7 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 		struct ipoctal_channel *channel = &ipoctal->channel[i];
 		tty_unregister_device(ipoctal->tty_drv, i);
 		tty_port_free_xmit_buf(&channel->tty_port);
+		tty_port_destroy(&channel->tty_port);
 	}
 
 	tty_unregister_driver(ipoctal->tty_drv);
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 42d0a25..9d7d00c 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1771,6 +1771,7 @@ fail_free_irq:
 fail_unregister:
 	tty_unregister_driver(serial_driver);
 fail_put_tty_driver:
+	tty_port_destroy(&state->tport);
 	put_tty_driver(serial_driver);
 	return error;
 }
@@ -1785,6 +1786,7 @@ static int __exit amiga_serial_remove(struct platform_device *pdev)
 		printk("SERIAL: failed to unregister serial driver (%d)\n",
 		       error);
 	put_tty_driver(serial_driver);
+	tty_port_destroy(&state->tport);
 
 	free_irq(IRQ_AMIGA_TBE, state);
 	free_irq(IRQ_AMIGA_RBF, state);
diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index 02b7d3a..1cfcdbf 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -240,8 +240,6 @@ static int __init bfin_jc_init(void)
 {
 	int ret;
 
-	tty_port_init(&port);
-
 	bfin_jc_kthread = kthread_create(bfin_jc_emudat_manager, NULL, DRV_NAME);
 	if (IS_ERR(bfin_jc_kthread))
 		return PTR_ERR(bfin_jc_kthread);
@@ -257,6 +255,8 @@ static int __init bfin_jc_init(void)
 	if (!bfin_jc_driver)
 		goto err_driver;
 
+	tty_port_init(&port);
+
 	bfin_jc_driver->driver_name  = DRV_NAME;
 	bfin_jc_driver->name         = DEV_NAME;
 	bfin_jc_driver->type         = TTY_DRIVER_TYPE_SERIAL;
@@ -274,6 +274,7 @@ static int __init bfin_jc_init(void)
 	return 0;
 
  err:
+	tty_port_destroy(&port);
 	put_tty_driver(bfin_jc_driver);
  err_driver:
 	kfree(bfin_jc_write_buf.buf);
@@ -289,6 +290,7 @@ static void __exit bfin_jc_exit(void)
 	kfree(bfin_jc_write_buf.buf);
 	tty_unregister_driver(bfin_jc_driver);
 	put_tty_driver(bfin_jc_driver);
+	tty_port_destroy(&port);
 }
 module_exit(bfin_jc_exit);
 
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 0a6a0bc..de25774 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -3934,7 +3934,7 @@ err:
 static void __devexit cy_pci_remove(struct pci_dev *pdev)
 {
 	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
-	unsigned int i;
+	unsigned int i, channel;
 
 	/* non-Z with old PLX */
 	if (!cy_is_Z(cinfo) && (readb(cinfo->base_addr + CyPLX_VER) & 0x0f) ==
@@ -3960,9 +3960,11 @@ static void __devexit cy_pci_remove(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 
 	cinfo->base_addr = NULL;
-	for (i = cinfo->first_line; i < cinfo->first_line +
-			cinfo->nports; i++)
+	for (channel = 0, i = cinfo->first_line; i < cinfo->first_line +
+			cinfo->nports; i++, channel++) {
 		tty_unregister_device(cy_serial_driver, i);
+		tty_port_destroy(&cinfo->ports[channel].port);
+	}
 	cinfo->nports = 0;
 	kfree(cinfo->ports);
 }
diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 4ab936b..4193afb 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -757,6 +757,7 @@ static int __devinit ehv_bc_tty_probe(struct platform_device *pdev)
 	return 0;
 
 error:
+	tty_port_destroy(&bc->port);
 	irq_dispose_mapping(bc->tx_irq);
 	irq_dispose_mapping(bc->rx_irq);
 
@@ -770,6 +771,7 @@ static int ehv_bc_tty_remove(struct platform_device *pdev)
 
 	tty_unregister_device(ehv_bc_driver, bc - bcs);
 
+	tty_port_destroy(&bc->port);
 	irq_dispose_mapping(bc->tx_irq);
 	irq_dispose_mapping(bc->rx_irq);
 
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 5b95b4f..68357a6 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -1218,6 +1218,7 @@ static int __init hvsi_console_init(void)
 		if (hp->virq == 0) {
 			printk(KERN_ERR "%s: couldn't create irq mapping for 0x%x\n",
 				__func__, irq[0]);
+			tty_port_destroy(&hp->port);
 			continue;
 		}
 
diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 160f0ad..2cde13d 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -566,6 +566,7 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 			ipwireless_disassociate_network_ttys(network,
 							     ttyj->channel_idx);
 			tty_unregister_device(ipw_tty_driver, j);
+			tty_port_destroy(&ttyj->port);
 			ttys[j] = NULL;
 			mutex_unlock(&ttyj->ipw_tty_mutex);
 			kfree(ttyj);
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 56e616b..da112e1 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -895,6 +895,8 @@ static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
 
 	return 0;
 err_free:
+	for (i = 0; i < MAX_PORTS_PER_BOARD; i++)
+		tty_port_destroy(&brd->ports[i].port);
 	kfree(brd->ports);
 err:
 	return ret;
@@ -919,6 +921,8 @@ static void moxa_board_deinit(struct moxa_board_conf *brd)
 				tty_kref_put(tty);
 			}
 		}
+	for (a = 0; a < MAX_PORTS_PER_BOARD; a++)
+		tty_port_destroy(&brd->ports[a].port);
 	while (1) {
 		opened = 0;
 		for (a = 0; a < brd->numPorts; a++)
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index cfda47d..802a248 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2411,14 +2411,27 @@ static int __devinit mxser_initbrd(struct mxser_board *brd,
 
 	retval = request_irq(brd->irq, mxser_interrupt, IRQF_SHARED, "mxser",
 			brd);
-	if (retval)
+	if (retval) {
+		for (i = 0; i < brd->info->nports; i++)
+			tty_port_destroy(&brd->ports[i].port);
 		printk(KERN_ERR "Board %s: Request irq failed, IRQ (%d) may "
 			"conflict with another device.\n",
 			brd->info->name, brd->irq);
+	}
 
 	return retval;
 }
 
+static void mxser_board_remove(struct mxser_board *brd)
+{
+	unsigned int i;
+
+	for (i = 0; i < brd->info->nports; i++) {
+		tty_unregister_device(mxvar_sdriver, brd->idx + i);
+		tty_port_destroy(&brd->ports[i].port);
+	}
+}
+
 static int __init mxser_get_ISA_conf(int cap, struct mxser_board *brd)
 {
 	int id, i, bits, ret;
@@ -2649,10 +2662,8 @@ static void __devexit mxser_remove(struct pci_dev *pdev)
 {
 #ifdef CONFIG_PCI
 	struct mxser_board *brd = pci_get_drvdata(pdev);
-	unsigned int i;
 
-	for (i = 0; i < brd->info->nports; i++)
-		tty_unregister_device(mxvar_sdriver, brd->idx + i);
+	mxser_board_remove(brd);
 
 	free_irq(pdev->irq, brd);
 	pci_release_region(pdev, 2);
@@ -2748,15 +2759,13 @@ err_put:
 
 static void __exit mxser_module_exit(void)
 {
-	unsigned int i, j;
+	unsigned int i;
 
 	pci_unregister_driver(&mxser_driver);
 
 	for (i = 0; i < MXSER_BOARDS; i++) /* ISA remains */
 		if (mxser_boards[i].info != NULL)
-			for (j = 0; j < mxser_boards[i].info->nports; j++)
-				tty_unregister_device(mxvar_sdriver,
-						mxser_boards[i].idx + j);
+			mxser_board_remove(&mxser_boards[i]);
 	tty_unregister_driver(mxvar_sdriver);
 	put_tty_driver(mxvar_sdriver);
 
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index b917c94..cb764d2 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1479,6 +1479,7 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 		if (IS_ERR(tty_dev)) {
 			ret = PTR_ERR(tty_dev);
 			dev_err(&pdev->dev, "Could not allocate tty?\n");
+			tty_port_destroy(&port->port);
 			goto err_free_tty;
 		}
 	}
@@ -1486,8 +1487,10 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 	return 0;
 
 err_free_tty:
-	for (i = dc->index_start; i < dc->index_start + MAX_PORT; ++i)
-		tty_unregister_device(ntty_driver, i);
+	for (i = 0; i < MAX_PORT; ++i) {
+		tty_unregister_device(ntty_driver, dc->index_start + i);
+		tty_port_destroy(&dc->port[i].port);
+	}
 err_free_kfifo:
 	for (i = 0; i < MAX_PORT; i++)
 		kfifo_free(&dc->port[i].fifo_ul);
@@ -1520,8 +1523,10 @@ static void __devexit tty_exit(struct nozomi *dc)
 	   complete off a hangup method ? */
 	while (dc->open_ttys)
 		msleep(1);
-	for (i = dc->index_start; i < dc->index_start + MAX_PORT; ++i)
-		tty_unregister_device(ntty_driver, i);
+	for (i = 0; i < MAX_PORT; ++i) {
+		tty_unregister_device(ntty_driver, dc->index_start + i);
+		tty_port_destroy(&dc->port[i].port);
+	}
 }
 
 /* Deallocate memory for one device */
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 9700d34..d9056da 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -673,6 +673,7 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
 	if (sInitChan(ctlp, &info->channel, aiop, chan) == 0) {
 		printk(KERN_ERR "RocketPort sInitChan(%d, %d, %d) failed!\n",
 				board, aiop, chan);
+		tty_port_destroy(&info->port);
 		kfree(info);
 		return;
 	}
@@ -2357,6 +2358,7 @@ static void rp_cleanup_module(void)
 	for (i = 0; i < MAX_RP_PORTS; i++)
 		if (rp_table[i]) {
 			tty_unregister_device(rocket_driver, i);
+			tty_port_destroy(&rp_table[i]->port);
 			kfree(rp_table[i]);
 		}
 
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index 66c38a3..f99a845 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -1225,6 +1225,8 @@ rs68328_init(void)
 
 	if (tty_register_driver(serial_driver)) {
 		put_tty_driver(serial_driver);
+		for (i = 0; i < NR_PORTS; i++)
+			tty_port_destroy(&m68k_soft[i].tport);
 		printk(KERN_ERR "Couldn't register serial driver\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index fbda374..b97e348 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -822,6 +822,7 @@ static void ifx_spi_free_port(struct ifx_spi_device *ifx_dev)
 {
 	if (ifx_dev->tty_dev)
 		tty_unregister_device(tty_drv, ifx_dev->minor);
+	tty_port_destroy(&ifx_dev->tty_port);
 	kfifo_free(&ifx_dev->tx_fifo);
 }
 
@@ -855,10 +856,12 @@ static int ifx_spi_create_port(struct ifx_spi_device *ifx_dev)
 		dev_dbg(&ifx_dev->spi_dev->dev,
 			"%s: registering tty device failed", __func__);
 		ret = PTR_ERR(ifx_dev->tty_dev);
-		goto error_ret;
+		goto error_port;
 	}
 	return 0;
 
+error_port:
+	tty_port_destroy(pport);
 error_ret:
 	ifx_spi_free_port(ifx_dev);
 	return ret;
diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
index d185247..6ac2b79 100644
--- a/drivers/tty/serial/kgdb_nmi.c
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -266,6 +266,7 @@ static int kgdb_nmi_tty_install(struct tty_driver *drv, struct tty_struct *tty)
 	}
 	return 0;
 err:
+	tty_port_destroy(&priv->port);
 	kfree(priv);
 	return ret;
 }
@@ -275,6 +276,7 @@ static void kgdb_nmi_tty_cleanup(struct tty_struct *tty)
 	struct kgdb_nmi_tty_priv *priv = tty->driver_data;
 
 	tty->driver_data = NULL;
+	tty_port_destroy(&priv->port);
 	kfree(priv);
 }
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 44274ea..2c7230a 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2340,6 +2340,8 @@ int uart_register_driver(struct uart_driver *drv)
 	if (retval >= 0)
 		return retval;
 
+	for (i = 0; i < drv->nr; i++)
+		tty_port_destroy(&drv->state[i].port);
 	put_tty_driver(normal);
 out_kfree:
 	kfree(drv->state);
@@ -2359,8 +2361,12 @@ out:
 void uart_unregister_driver(struct uart_driver *drv)
 {
 	struct tty_driver *p = drv->tty_driver;
+	unsigned int i;
+
 	tty_unregister_driver(p);
 	put_tty_driver(p);
+	for (i = 0; i < drv->nr; i++)
+		tty_port_destroy(&drv->state[i].port);
 	kfree(drv->state);
 	drv->state = NULL;
 	drv->tty_driver = NULL;
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 70e3a52..e4b5c39 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -4425,6 +4425,7 @@ static void synclink_cleanup(void)
 		mgsl_release_resources(info);
 		tmp = info;
 		info = info->next_device;
+		tty_port_destroy(&tmp->port);
 		kfree(tmp);
 	}
 	
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index b38e954..6e4c340 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -3645,8 +3645,10 @@ static void device_init(int adapter_num, struct pci_dev *pdev)
 	for (i=0; i < port_count; ++i) {
 		port_array[i] = alloc_dev(adapter_num, i, pdev);
 		if (port_array[i] == NULL) {
-			for (--i; i >= 0; --i)
+			for (--i; i >= 0; --i) {
+				tty_port_destroy(&port_array[i]->port);
 				kfree(port_array[i]);
+			}
 			return;
 		}
 	}
@@ -3773,6 +3775,7 @@ static void slgt_cleanup(void)
 			release_resources(info);
 		tmp = info;
 		info = info->next_device;
+		tty_port_destroy(&tmp->port);
 		kfree(tmp);
 	}
 
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index f17d9f3..40745be 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -3843,8 +3843,10 @@ static void device_init(int adapter_num, struct pci_dev *pdev)
 	for ( port = 0; port < SCA_MAX_PORTS; ++port ) {
 		port_array[port] = alloc_dev(adapter_num,port,pdev);
 		if( port_array[port] == NULL ) {
-			for ( --port; port >= 0; --port )
+			for (--port; port >= 0; --port) {
+				tty_port_destroy(&port_array[port]->port);
 				kfree(port_array[port]);
+			}
 			return;
 		}
 	}
@@ -3953,6 +3955,7 @@ static void synclinkmp_cleanup(void)
 		}
 		tmp = info;
 		info = info->next_device;
+		tty_port_destroy(&tmp->port);
 		kfree(tmp);
 	}
 
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index f87d7e8..607636b 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -779,6 +779,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 		con_set_default_unimap(vc);
 	    vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
 	    if (!vc->vc_screenbuf) {
+		tty_port_destroy(&vc->port);
 		kfree(vc);
 		vc_cons[currcons].d = NULL;
 		return -ENOMEM;
@@ -999,8 +1000,10 @@ void vc_deallocate(unsigned int currcons)
 		put_pid(vc->vt_pid);
 		module_put(vc->vc_sw->owner);
 		kfree(vc->vc_screenbuf);
-		if (currcons >= MIN_NR_CONSOLES)
+		if (currcons >= MIN_NR_CONSOLES) {
+			tty_port_destroy(&vc->port);
 			kfree(vc);
+		}
 		vc_cons[currcons].d = NULL;
 	}
 }
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index f173952..d0f9548 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -1145,8 +1145,10 @@ int gserial_setup(struct usb_gadget *g, unsigned count)
 
 	return status;
 fail:
-	while (count--)
+	while (count--) {
+		tty_port_destroy(&ports[count].port->port);
 		kfree(ports[count].port);
+	}
 	put_tty_driver(gs_tty_driver);
 	gs_tty_driver = NULL;
 	return status;
@@ -1200,6 +1202,7 @@ void gserial_cleanup(void)
 
 		WARN_ON(port->port_usb != NULL);
 
+		tty_port_destroy(&port->port);
 		kfree(port);
 	}
 	n_ports = 0;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 73b8e05..64bda13 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -597,6 +597,7 @@ static void port_release(struct device *dev)
 	kfifo_free(&port->write_fifo);
 	kfree(port->interrupt_in_buffer);
 	kfree(port->interrupt_out_buffer);
+	tty_port_destroy(&port->port);
 	kfree(port);
 }
 
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 496ce2c..a68c88c 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -183,6 +183,7 @@ static void __exit __ircomm_tty_cleanup(struct ircomm_tty_cb *self)
 	ircomm_tty_shutdown(self);
 
 	self->magic = 0;
+	tty_port_destroy(&self->port);
 	kfree(self);
 }
 
-- 
1.8.0


