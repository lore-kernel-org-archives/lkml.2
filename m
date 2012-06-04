Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab2FDLhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:37:35 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44982 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 24/24] TTY: use tty_port_register_device
Date: Mon,  4 Jun 2012 13:35:38 +0200
Message-Id: <1338809738-18967-25-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have no way to assign tty->port while performing tty
installataion. There are two ways to provide the link tty_struct =>
tty_port. Either by calling tty_port_install from tty->ops->install or
tty_port_register_device called instead of tty_register_device when
the device is being set up after connected.

In this patch we modify most of the drivers to do the latter. When the
drivers use tty_register_device and we have tty_port already, we
switch to tty_port_register_device. So we have the tty_struct =>
tty_port link for free for those.

The rest of the drivers will be changed in the next merge windows (I
ran out of time for this one).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/um/drivers/line.c           |    3 ++-
 drivers/isdn/capi/capi.c         |    3 ++-
 drivers/isdn/gigaset/interface.c |    3 ++-
 drivers/mmc/card/sdio_uart.c     |    4 ++--
 drivers/net/usb/hso.c            |    7 ++++---
 drivers/tty/cyclades.c           |   16 +++++++++-------
 drivers/tty/ehv_bytechan.c       |    9 +++++----
 drivers/tty/ipwireless/tty.c     |    2 +-
 drivers/tty/isicom.c             |    3 ++-
 drivers/tty/mxser.c              |    6 ++++--
 drivers/tty/nozomi.c             |    4 ++--
 drivers/tty/rocket.c             |    4 ++--
 drivers/tty/serial/ifx6x60.c     |    4 ++--
 drivers/tty/serial/msm_smd_tty.c |    8 +++++---
 drivers/tty/serial/serial_core.c |    3 ++-
 drivers/tty/synclink_gt.c        |    7 +++++--
 drivers/usb/class/cdc-acm.c      |    3 ++-
 drivers/usb/gadget/u_serial.c    |    3 ++-
 net/bluetooth/rfcomm/tty.c       |    4 ++--
 19 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index fb6e4ea..46efa0f 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -510,7 +510,8 @@ int setup_one_line(struct line *lines, int n, char *init,
 		line->valid = 1;
 		err = parse_chan_pair(new, line, n, opts, error_out);
 		if (!err) {
-			struct device *d = tty_register_device(driver, n, NULL);
+			struct device *d = tty_port_register_device(&line->port,
+					driver, n, NULL);
 			if (IS_ERR(d)) {
 				*error_out = "Failed to register device";
 				err = PTR_ERR(d);
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 38c4bd8..c679867 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -234,7 +234,8 @@ static struct capiminor *capiminor_alloc(struct capi20_appl *ap, u32 ncci)
 
 	mp->minor = minor;
 
-	dev = tty_register_device(capinc_tty_driver, minor, NULL);
+	dev = tty_port_register_device(&mp->port, capinc_tty_driver, minor,
+			NULL);
 	if (IS_ERR(dev))
 		goto err_out2;
 
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index a6d9fd2..3e8c1e0 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -524,7 +524,8 @@ void gigaset_if_init(struct cardstate *cs)
 	tasklet_init(&cs->if_wake_tasklet, if_wake, (unsigned long) cs);
 
 	mutex_lock(&cs->mutex);
-	cs->tty_dev = tty_register_device(drv->tty, cs->minor_index, NULL);
+	cs->tty_dev = tty_port_register_device(&cs->port, drv->tty,
+			cs->minor_index, NULL);
 
 	if (!IS_ERR(cs->tty_dev))
 		dev_set_drvdata(cs->tty_dev, cs);
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 5a2cbfa..4bba7b8 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -1132,8 +1132,8 @@ static int sdio_uart_probe(struct sdio_func *func,
 		kfree(port);
 	} else {
 		struct device *dev;
-		dev = tty_register_device(sdio_uart_tty_driver,
-						port->index, &func->dev);
+		dev = tty_port_register_device(&port->port,
+				sdio_uart_tty_driver, port->index, &func->dev);
 		if (IS_ERR(dev)) {
 			sdio_uart_port_remove(port);
 			ret = PTR_ERR(dev);
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 62f30b4..8e83860 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2289,9 +2289,11 @@ static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
 	if (minor < 0)
 		goto exit;
 
+	tty_port_init(&serial->port);
+
 	/* register our minor number */
-	serial->parent->dev = tty_register_device(tty_drv, minor,
-					&serial->parent->interface->dev);
+	serial->parent->dev = tty_port_register_device(&serial->port, tty_drv,
+			minor, &serial->parent->interface->dev);
 	dev = serial->parent->dev;
 	dev_set_drvdata(dev, serial->parent);
 	i = device_create_file(dev, &dev_attr_hsotype);
@@ -2300,7 +2302,6 @@ static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
 	serial->minor = minor;
 	serial->magic = HSO_SERIAL_MAGIC;
 	spin_lock_init(&serial->serial_lock);
-	tty_port_init(&serial->port);
 	serial->num_rx_urbs = num_urbs;
 
 	/* RX, allocate urb and initialize */
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index cff5468..ef0a774 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -3292,7 +3292,7 @@ static int __init cy_detect_isa(void)
 	struct cyclades_card *card;
 	unsigned short cy_isa_irq, nboard;
 	void __iomem *cy_isa_address;
-	unsigned short i, j, cy_isa_nchan;
+	unsigned short i, j, k, cy_isa_nchan;
 	int isparam = 0;
 
 	nboard = 0;
@@ -3395,9 +3395,10 @@ static int __init cy_detect_isa(void)
 			(unsigned long)(cy_isa_address + (CyISA_Ywin - 1)),
 			cy_isa_irq, cy_isa_nchan, cy_next_channel);
 
-		for (j = cy_next_channel;
-				j < cy_next_channel + cy_isa_nchan; j++)
-			tty_register_device(cy_serial_driver, j, NULL);
+		for (k = 0, j = cy_next_channel;
+				j < cy_next_channel + cy_isa_nchan; j++, k++)
+			tty_port_register_device(&card->ports[k].port,
+					cy_serial_driver, j, NULL);
 		cy_next_channel += cy_isa_nchan;
 	}
 	return nboard;
@@ -3701,7 +3702,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 	void __iomem *addr0 = NULL, *addr2 = NULL;
 	char *card_name = NULL;
 	u32 uninitialized_var(mailbox);
-	unsigned int device_id, nchan = 0, card_no, i;
+	unsigned int device_id, nchan = 0, card_no, i, j;
 	unsigned char plx_ver;
 	int retval, irq;
 
@@ -3912,8 +3913,9 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 
 	dev_info(&pdev->dev, "%s/PCI #%d found: %d channels starting from "
 		"port %d.\n", card_name, card_no + 1, nchan, cy_next_channel);
-	for (i = cy_next_channel; i < cy_next_channel + nchan; i++)
-		tty_register_device(cy_serial_driver, i, &pdev->dev);
+	for (j = 0, i = cy_next_channel; i < cy_next_channel + nchan; i++, j++)
+		tty_port_register_device(&card->ports[j].port,
+				cy_serial_driver, i, &pdev->dev);
 	cy_next_channel += nchan;
 
 	return 0;
diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 4813684..4ab936b 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -738,16 +738,17 @@ static int __devinit ehv_bc_tty_probe(struct platform_device *pdev)
 		goto error;
 	}
 
-	bc->dev = tty_register_device(ehv_bc_driver, i, &pdev->dev);
+	tty_port_init(&bc->port);
+	bc->port.ops = &ehv_bc_tty_port_ops;
+
+	bc->dev = tty_port_register_device(&bc->port, ehv_bc_driver, i,
+			&pdev->dev);
 	if (IS_ERR(bc->dev)) {
 		ret = PTR_ERR(bc->dev);
 		dev_err(&pdev->dev, "could not register tty (ret=%i)\n", ret);
 		goto error;
 	}
 
-	tty_port_init(&bc->port);
-	bc->port.ops = &ehv_bc_tty_port_ops;
-
 	dev_set_drvdata(&pdev->dev, bc);
 
 	dev_info(&pdev->dev, "registered /dev/%s%u for byte channel %u\n",
diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index f8b5fa0..160f0ad 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -476,7 +476,7 @@ static int add_tty(int j,
 	mutex_init(&ttys[j]->ipw_tty_mutex);
 	tty_port_init(&ttys[j]->port);
 
-	tty_register_device(ipw_tty_driver, j, NULL);
+	tty_port_register_device(&ttys[j]->port, ipw_tty_driver, j, NULL);
 	ipwireless_associate_network_tty(network, channel_idx, ttys[j]);
 
 	if (secondary_channel_idx != -1)
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index e1235ac..8060690 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -1611,7 +1611,8 @@ static int __devinit isicom_probe(struct pci_dev *pdev,
 		goto errunri;
 
 	for (index = 0; index < board->port_count; index++)
-		tty_register_device(isicom_normal, board->index * 16 + index,
+		tty_port_register_device(&board->ports[index].port,
+				isicom_normal, board->index * 16 + index,
 				&pdev->dev);
 
 	return 0;
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 90cc680..9ac15e7 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2598,7 +2598,8 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
 		goto err_rel3;
 
 	for (i = 0; i < brd->info->nports; i++)
-		tty_register_device(mxvar_sdriver, brd->idx + i, &pdev->dev);
+		tty_port_register_device(&brd->ports[i].port, mxvar_sdriver,
+				brd->idx + i, &pdev->dev);
 
 	pci_set_drvdata(pdev, brd);
 
@@ -2695,7 +2696,8 @@ static int __init mxser_module_init(void)
 
 		brd->idx = m * MXSER_PORTS_PER_BOARD;
 		for (i = 0; i < brd->info->nports; i++)
-			tty_register_device(mxvar_sdriver, brd->idx + i, NULL);
+			tty_port_register_device(&brd->ports[i].port,
+					mxvar_sdriver, brd->idx + i, NULL);
 
 		m++;
 	}
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index e7592f9..b917c94 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1473,8 +1473,8 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 		port->dc = dc;
 		tty_port_init(&port->port);
 		port->port.ops = &noz_tty_port_ops;
-		tty_dev = tty_register_device(ntty_driver, dc->index_start + i,
-							&pdev->dev);
+		tty_dev = tty_port_register_device(&port->port, ntty_driver,
+				dc->index_start + i, &pdev->dev);
 
 		if (IS_ERR(tty_dev)) {
 			ret = PTR_ERR(tty_dev);
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 777d5f9..f64b308 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -704,8 +704,8 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
 	spin_lock_init(&info->slock);
 	mutex_init(&info->write_mtx);
 	rp_table[line] = info;
-	tty_register_device(rocket_driver, line, pci_dev ? &pci_dev->dev :
-			NULL);
+	tty_port_register_device(&info->port, rocket_driver, line,
+			pci_dev ? &pci_dev->dev : NULL);
 }
 
 /*
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 144cd39..3f0c256 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -800,8 +800,8 @@ static int ifx_spi_create_port(struct ifx_spi_device *ifx_dev)
 	tty_port_init(pport);
 	pport->ops = &ifx_tty_port_ops;
 	ifx_dev->minor = IFX_SPI_TTY_ID;
-	ifx_dev->tty_dev = tty_register_device(tty_drv, ifx_dev->minor,
-					       &ifx_dev->spi_dev->dev);
+	ifx_dev->tty_dev = tty_port_register_device(pport, tty_drv,
+			ifx_dev->minor, &ifx_dev->spi_dev->dev);
 	if (IS_ERR(ifx_dev->tty_dev)) {
 		dev_dbg(&ifx_dev->spi_dev->dev,
 			"%s: registering tty device failed", __func__);
diff --git a/drivers/tty/serial/msm_smd_tty.c b/drivers/tty/serial/msm_smd_tty.c
index b25e6ee..925d1fa 100644
--- a/drivers/tty/serial/msm_smd_tty.c
+++ b/drivers/tty/serial/msm_smd_tty.c
@@ -223,9 +223,11 @@ static int __init smd_tty_init(void)
 		return ret;
 
 	for (i = 0; i < smd_tty_channels_len; i++) {
-		tty_port_init(&smd_tty[smd_tty_channels[i].id].port);
-		smd_tty[smd_tty_channels[i].id].port.ops = &smd_tty_port_ops;
-		tty_register_device(smd_tty_driver, smd_tty_channels[i].id, 0);
+		struct tty_port *port = &smd_tty[smd_tty_channels[i].id].port;
+		tty_port_init(port);
+		port->ops = &smd_tty_port_ops;
+		tty_port_register_device(port, smd_tty_driver,
+				smd_tty_channels[i].id, NULL);
 	}
 
 	return 0;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 246b823..dafd378 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2346,7 +2346,8 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 * Register the port whether it's detected or not.  This allows
 	 * setserial to be used to alter this ports parameters.
 	 */
-	tty_dev = tty_register_device(drv->tty_driver, uport->line, uport->dev);
+	tty_dev = tty_port_register_device(port, drv->tty_driver, uport->line,
+			uport->dev);
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index aa1debf..8a4addd 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -3689,8 +3689,11 @@ static void device_init(int adapter_num, struct pci_dev *pdev)
 		}
 	}
 
-	for (i=0; i < port_count; ++i)
-		tty_register_device(serial_driver, port_array[i]->line, &(port_array[i]->pdev->dev));
+	for (i = 0; i < port_count; ++i) {
+		struct slgt_info *info = port_array[i];
+		tty_port_register_device(&info->port, serial_driver, info->line,
+				&info->pdev->dev);
+	}
 }
 
 static int __devinit init_one(struct pci_dev *dev,
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index f2a120e..96f1a6a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1290,7 +1290,8 @@ skip_countries:
 	usb_set_intfdata(data_interface, acm);
 
 	usb_get_intf(control_interface);
-	tty_register_device(acm_tty_driver, minor, &control_interface->dev);
+	tty_port_register_device(&acm->port, acm_tty_driver, minor,
+			&control_interface->dev);
 
 	return 0;
 alloc_fail7:
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 5b3f5ff..2b5534c 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -1129,7 +1129,8 @@ int gserial_setup(struct usb_gadget *g, unsigned count)
 	for (i = 0; i < count; i++) {
 		struct device	*tty_dev;
 
-		tty_dev = tty_register_device(gs_tty_driver, i, &g->dev);
+		tty_dev = tty_port_register_device(&ports[i].port->port,
+				gs_tty_driver, i, &g->dev);
 		if (IS_ERR(tty_dev))
 			pr_warning("%s: no classdev for port %d, err %ld\n",
 				__func__, i, PTR_ERR(tty_dev));
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index cb96077..f89c568 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -278,8 +278,8 @@ out:
 	if (err < 0)
 		goto free;
 
-	dev->tty_dev = tty_register_device(rfcomm_tty_driver, dev->id, NULL);
-
+	dev->tty_dev = tty_port_register_device(&dev->port, rfcomm_tty_driver,
+			dev->id, NULL);
 	if (IS_ERR(dev->tty_dev)) {
 		err = PTR_ERR(dev->tty_dev);
 		list_del(&dev->list);
-- 
1.7.10.3


