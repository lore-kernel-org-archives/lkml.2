Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2J1II0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:08:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60007 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752881Ab2J1IIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:08:11 -0400
From: Joe Perches <joe@perches.com>
To: Harald Welte <laforge@gnumonks.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [PATCH 05/16] pcmcia: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:43 -0700
Message-Id: <c90f9832dc0616c623bd1d702974967a2ffa93b9.1351411047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.
Coalesce formats for easier grep.
Add missing newline.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/pcmcia/cm4040_cs.c  |    5 +-
 drivers/pcmcia/cistpl.c          |   10 ++---
 drivers/pcmcia/cs.c              |   28 ++++++--------
 drivers/pcmcia/ds.c              |   38 ++++++++----------
 drivers/pcmcia/pcmcia_cis.c      |    4 +-
 drivers/pcmcia/pcmcia_resource.c |   11 ++---
 drivers/pcmcia/rsrc_nonstatic.c  |   24 +++++------
 drivers/pcmcia/ti113x.h          |   80 ++++++++++++++++++--------------------
 drivers/pcmcia/yenta_socket.c    |   61 +++++++++++++---------------
 9 files changed, 118 insertions(+), 143 deletions(-)

diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 8dd48a2..fc061f7 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -532,9 +532,8 @@ static int reader_config(struct pcmcia_device *link, int devno)
 
 	fail_rc = pcmcia_enable_device(link);
 	if (fail_rc != 0) {
-		dev_printk(KERN_INFO, &link->dev,
-			   "pcmcia_enable_device failed 0x%x\n",
-			   fail_rc);
+		dev_info(&link->dev, "pcmcia_enable_device failed 0x%x\n",
+			 fail_rc);
 		goto cs_release;
 	}
 
diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 884a984..8641bff 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -94,8 +94,7 @@ static void __iomem *set_cis_map(struct pcmcia_socket *s,
 		mem->res = pcmcia_find_mem_region(0, s->map_size,
 						s->map_size, 0, s);
 		if (mem->res == NULL) {
-			dev_printk(KERN_NOTICE, &s->dev,
-				   "cs: unable to map card memory!\n");
+			dev_notice(&s->dev, "cs: unable to map card memory!\n");
 			return NULL;
 		}
 		s->cis_virt = NULL;
@@ -378,8 +377,7 @@ int verify_cis_cache(struct pcmcia_socket *s)
 
 	buf = kmalloc(256, GFP_KERNEL);
 	if (buf == NULL) {
-		dev_printk(KERN_WARNING, &s->dev,
-			   "no memory for verifying CIS\n");
+		dev_warn(&s->dev, "no memory for verifying CIS\n");
 		return -ENOMEM;
 	}
 	mutex_lock(&s->ops_mutex);
@@ -411,14 +409,14 @@ int pcmcia_replace_cis(struct pcmcia_socket *s,
 		       const u8 *data, const size_t len)
 {
 	if (len > CISTPL_MAX_CIS_SIZE) {
-		dev_printk(KERN_WARNING, &s->dev, "replacement CIS too big\n");
+		dev_warn(&s->dev, "replacement CIS too big\n");
 		return -EINVAL;
 	}
 	mutex_lock(&s->ops_mutex);
 	kfree(s->fake_cis);
 	s->fake_cis = kmalloc(len, GFP_KERNEL);
 	if (s->fake_cis == NULL) {
-		dev_printk(KERN_WARNING, &s->dev, "no memory to replace CIS\n");
+		dev_warn(&s->dev, "no memory to replace CIS\n");
 		mutex_unlock(&s->ops_mutex);
 		return -ENOMEM;
 	}
diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 5292db6..9628a59 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -177,8 +177,8 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
 
 	wait_for_completion(&socket->thread_done);
 	if (!socket->thread) {
-		dev_printk(KERN_WARNING, &socket->dev,
-			   "PCMCIA: warning: socket thread did not start\n");
+		dev_warn(&socket->dev,
+			 "PCMCIA: warning: socket thread did not start\n");
 		return -EIO;
 	}
 
@@ -275,7 +275,7 @@ static int socket_reset(struct pcmcia_socket *skt)
 		msleep(unreset_check * 10);
 	}
 
-	dev_printk(KERN_ERR, &skt->dev, "time out after reset.\n");
+	dev_err(&skt->dev, "time out after reset\n");
 	return -ETIMEDOUT;
 }
 
@@ -325,8 +325,8 @@ static void socket_shutdown(struct pcmcia_socket *s)
 
 	s->ops->get_status(s, &status);
 	if (status & SS_POWERON) {
-		dev_printk(KERN_ERR, &s->dev,
-			   "*** DANGER *** unable to remove socket power\n");
+		dev_err(&s->dev,
+			"*** DANGER *** unable to remove socket power\n");
 	}
 
 	s->state &= ~SOCKET_INUSE;
@@ -356,15 +356,13 @@ static int socket_setup(struct pcmcia_socket *skt, int initial_delay)
 	}
 
 	if (status & SS_PENDING) {
-		dev_printk(KERN_ERR, &skt->dev,
-			   "voltage interrogation timed out.\n");
+		dev_err(&skt->dev, "voltage interrogation timed out\n");
 		return -ETIMEDOUT;
 	}
 
 	if (status & SS_CARDBUS) {
 		if (!(skt->features & SS_CAP_CARDBUS)) {
-			dev_printk(KERN_ERR, &skt->dev,
-				"cardbus cards are not supported.\n");
+			dev_err(&skt->dev, "cardbus cards are not supported\n");
 			return -EINVAL;
 		}
 		skt->state |= SOCKET_CARDBUS;
@@ -379,7 +377,7 @@ static int socket_setup(struct pcmcia_socket *skt, int initial_delay)
 	else if (!(status & SS_XVCARD))
 		skt->socket.Vcc = skt->socket.Vpp = 50;
 	else {
-		dev_printk(KERN_ERR, &skt->dev, "unsupported voltage key.\n");
+		dev_err(&skt->dev, "unsupported voltage key\n");
 		return -EIO;
 	}
 
@@ -396,7 +394,7 @@ static int socket_setup(struct pcmcia_socket *skt, int initial_delay)
 
 	skt->ops->get_status(skt, &status);
 	if (!(status & SS_POWERON)) {
-		dev_printk(KERN_ERR, &skt->dev, "unable to apply power.\n");
+		dev_err(&skt->dev, "unable to apply power\n");
 		return -EIO;
 	}
 
@@ -429,7 +427,7 @@ static int socket_insert(struct pcmcia_socket *skt)
 	if (ret == 0) {
 		skt->state |= SOCKET_PRESENT;
 
-		dev_printk(KERN_NOTICE, &skt->dev,
+		dev_notice(&skt->dev,
 			   "pccard: %s card inserted into slot %d\n",
 			   (skt->state & SOCKET_CARDBUS) ? "CardBus" : "PCMCIA",
 			   skt->sock);
@@ -558,8 +556,7 @@ static int socket_resume(struct pcmcia_socket *skt)
 
 static void socket_remove(struct pcmcia_socket *skt)
 {
-	dev_printk(KERN_NOTICE, &skt->dev,
-		   "pccard: card ejected from slot %d\n", skt->sock);
+	dev_notice(&skt->dev, "pccard: card ejected from slot %d\n", skt->sock);
 	socket_shutdown(skt);
 }
 
@@ -605,8 +602,7 @@ static int pccardd(void *__skt)
 	/* register with the device core */
 	ret = device_register(&skt->dev);
 	if (ret) {
-		dev_printk(KERN_WARNING, &skt->dev,
-			   "PCMCIA: unable to register socket\n");
+		dev_warn(&skt->dev, "PCMCIA: unable to register socket\n");
 		skt->thread = NULL;
 		complete(&skt->thread_done);
 		return 0;
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 079629b..b92a278 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -284,8 +284,8 @@ static int pcmcia_device_probe(struct device *dev)
 		dev_dbg(dev, "base %x, regs %x", p_dev->config_base,
 			p_dev->config_regs);
 	} else {
-		dev_printk(KERN_INFO, dev,
-			   "pcmcia: could not parse base and rmask0 of CIS\n");
+		dev_info(dev,
+			 "pcmcia: could not parse base and rmask0 of CIS\n");
 		p_dev->config_base = 0;
 		p_dev->config_regs = 0;
 	}
@@ -382,15 +382,15 @@ static int pcmcia_device_remove(struct device *dev)
 
 	/* check for proper unloading */
 	if (p_dev->_irq || p_dev->_io || p_dev->_locked)
-		dev_printk(KERN_INFO, dev,
-			"pcmcia: driver %s did not release config properly\n",
-			p_drv->name);
+		dev_info(dev,
+			 "pcmcia: driver %s did not release config properly\n",
+			 p_drv->name);
 
 	for (i = 0; i < MAX_WIN; i++)
 		if (p_dev->_win & CLIENT_WIN_REQ(i))
-			dev_printk(KERN_INFO, dev,
-			  "pcmcia: driver %s did not release window properly\n",
-			   p_drv->name);
+			dev_info(dev,
+				 "pcmcia: driver %s did not release window properly\n",
+				 p_drv->name);
 
 	/* references from pcmcia_probe_device */
 	pcmcia_put_dev(p_dev);
@@ -578,7 +578,7 @@ static struct pcmcia_device *pcmcia_device_add(struct pcmcia_socket *s,
 
 	mutex_unlock(&s->ops_mutex);
 
-	dev_printk(KERN_NOTICE, &p_dev->dev,
+	dev_notice(&p_dev->dev,
 		   "pcmcia: registering new device %s (IRQ: %d)\n",
 		   p_dev->devname, p_dev->irq);
 
@@ -742,16 +742,14 @@ static int pcmcia_load_firmware(struct pcmcia_device *dev, char * filename)
 	if (request_firmware(&fw, filename, &dev->dev) == 0) {
 		if (fw->size >= CISTPL_MAX_CIS_SIZE) {
 			ret = -EINVAL;
-			dev_printk(KERN_ERR, &dev->dev,
-				   "pcmcia: CIS override is too big\n");
+			dev_err(&dev->dev, "pcmcia: CIS override is too big\n");
 			goto release;
 		}
 
 		if (!pcmcia_replace_cis(s, fw->data, fw->size))
 			ret = 0;
 		else {
-			dev_printk(KERN_ERR, &dev->dev,
-				   "pcmcia: CIS override failed\n");
+			dev_err(&dev->dev, "pcmcia: CIS override failed\n");
 			goto release;
 		}
 
@@ -1143,10 +1141,9 @@ static int pcmcia_dev_suspend(struct device *dev, pm_message_t state)
 	if (p_drv->suspend) {
 		ret = p_drv->suspend(p_dev);
 		if (ret) {
-			dev_printk(KERN_ERR, dev,
-				   "pcmcia: device %s (driver %s) did "
-				   "not want to go to sleep (%d)\n",
-				   p_dev->devname, p_drv->name, ret);
+			dev_err(dev,
+				"pcmcia: device %s (driver %s) did not want to go to sleep (%d)\n",
+				p_dev->devname, p_drv->name, ret);
 			mutex_lock(&p_dev->socket->ops_mutex);
 			p_dev->suspended = 0;
 			mutex_unlock(&p_dev->socket->ops_mutex);
@@ -1337,14 +1334,13 @@ static int __devinit pcmcia_bus_add_socket(struct device *dev,
 
 	socket = pcmcia_get_socket(socket);
 	if (!socket) {
-		dev_printk(KERN_ERR, dev,
-			   "PCMCIA obtaining reference to socket failed\n");
+		dev_err(dev, "PCMCIA obtaining reference to socket failed\n");
 		return -ENODEV;
 	}
 
 	ret = sysfs_create_bin_file(&dev->kobj, &pccard_cis_attr);
 	if (ret) {
-		dev_printk(KERN_ERR, dev, "PCMCIA registration failed\n");
+		dev_err(dev, "PCMCIA registration failed\n");
 		pcmcia_put_socket(socket);
 		return ret;
 	}
@@ -1356,7 +1352,7 @@ static int __devinit pcmcia_bus_add_socket(struct device *dev,
 
 	ret = pccard_register_pcmcia(socket, &pcmcia_bus_callback);
 	if (ret) {
-		dev_printk(KERN_ERR, dev, "PCMCIA registration failed\n");
+		dev_err(dev, "PCMCIA registration failed\n");
 		pcmcia_put_socket(socket);
 		return ret;
 	}
diff --git a/drivers/pcmcia/pcmcia_cis.c b/drivers/pcmcia/pcmcia_cis.c
index e2c9241..1c05d74 100644
--- a/drivers/pcmcia/pcmcia_cis.c
+++ b/drivers/pcmcia/pcmcia_cis.c
@@ -44,7 +44,7 @@ int pccard_read_tuple(struct pcmcia_socket *s, unsigned int function,
 
 	buf = kmalloc(256, GFP_KERNEL);
 	if (buf == NULL) {
-		dev_printk(KERN_WARNING, &s->dev, "no memory to read tuple\n");
+		dev_warn(&s->dev, "no memory to read tuple\n");
 		return -ENOMEM;
 	}
 	tuple.DesiredTuple = code;
@@ -94,7 +94,7 @@ int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
 
 	buf = kzalloc(256, GFP_KERNEL);
 	if (buf == NULL) {
-		dev_printk(KERN_WARNING, &s->dev, "no memory to read tuple\n");
+		dev_warn(&s->dev, "no memory to read tuple\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index e8c19de..34aad89 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -508,8 +508,7 @@ int pcmcia_enable_device(struct pcmcia_device *p_dev)
 	s->socket.Vpp = p_dev->vpp;
 	if (s->ops->set_socket(s, &s->socket)) {
 		mutex_unlock(&s->ops_mutex);
-		dev_printk(KERN_WARNING, &p_dev->dev,
-			   "Unable to set socket state\n");
+		dev_warn(&p_dev->dev, "Unable to set socket state\n");
 		return -EINVAL;
 	}
 
@@ -736,13 +735,11 @@ __pcmcia_request_exclusive_irq(struct pcmcia_device *p_dev,
 	ret = request_irq(p_dev->irq, handler, 0, p_dev->devname, p_dev->priv);
 	if (ret) {
 		ret = pcmcia_request_irq(p_dev, handler);
-		dev_printk(KERN_WARNING, &p_dev->dev, "pcmcia: "
-			"request for exclusive IRQ could not be fulfilled.\n");
-		dev_printk(KERN_WARNING, &p_dev->dev, "pcmcia: the driver "
-			"needs updating to supported shared IRQ lines.\n");
+		dev_warn(&p_dev->dev, "pcmcia: request for exclusive IRQ could not be fulfilled\n");
+		dev_warn(&p_dev->dev, "pcmcia: the driver needs updating to supported shared IRQ lines\n");
 	}
 	if (ret)
-		dev_printk(KERN_INFO, &p_dev->dev, "request_irq() failed\n");
+		dev_info(&p_dev->dev, "request_irq() failed\n");
 	else
 		p_dev->_irq = 1;
 
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 9da9656..4b9587a 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -191,15 +191,13 @@ static void do_io_probe(struct pcmcia_socket *s, unsigned int base,
 	int any;
 	u_char *b, hole, most;
 
-	dev_printk(KERN_INFO, &s->dev, "cs: IO port probe %#x-%#x:",
-		base, base+num-1);
+	dev_info(&s->dev, "cs: IO port probe %#x-%#x:", base, base+num - 1);
 
 	/* First, what does a floating port look like? */
 	b = kzalloc(256, GFP_KERNEL);
 	if (!b) {
 		printk("\n");
-		dev_printk(KERN_ERR, &s->dev,
-			"do_io_probe: unable to kmalloc 256 bytes");
+		dev_err(&s->dev, "do_io_probe: unable to kmalloc 256 bytes\n");
 		return;
 	}
 	for (i = base, most = 0; i < base+num; i += 8) {
@@ -413,8 +411,8 @@ static int do_mem_probe(struct pcmcia_socket *s, u_long base, u_long num,
 	struct socket_data *s_data = s->resource_data;
 	u_long i, j, bad, fail, step;
 
-	dev_printk(KERN_INFO, &s->dev, "cs: memory probe 0x%06lx-0x%06lx:",
-		base, base+num-1);
+	dev_info(&s->dev, "cs: memory probe 0x%06lx-0x%06lx:",
+		 base, base + num - 1);
 	bad = fail = 0;
 	step = (num < 0x20000) ? 0x2000 : ((num>>4) & ~0x1fff);
 	/* don't allow too large steps */
@@ -495,7 +493,7 @@ static int validate_mem(struct pcmcia_socket *s, unsigned int probe_mask)
 			return 0;
 		if (s_data->mem_db_valid.next != &s_data->mem_db_valid)
 			return 0;
-		dev_printk(KERN_NOTICE, &s->dev,
+		dev_notice(&s->dev,
 			   "cs: warning: no high memory space available!\n");
 		return -ENODEV;
 	}
@@ -975,9 +973,9 @@ static int nonstatic_autoadd_resources(struct pcmcia_socket *s)
 			if (res == &ioport_resource)
 				continue;
 
-			dev_printk(KERN_INFO, &s->cb_dev->dev,
-				   "pcmcia: parent PCI bridge window: %pR\n",
-				   res);
+			dev_info(&s->cb_dev->dev,
+				 "pcmcia: parent PCI bridge window: %pR\n",
+				 res);
 			if (!adjust_io(s, ADD_MANAGED_RESOURCE, res->start, res->end))
 				done |= IORESOURCE_IO;
 
@@ -990,9 +988,9 @@ static int nonstatic_autoadd_resources(struct pcmcia_socket *s)
 			if (res == &iomem_resource)
 				continue;
 
-			dev_printk(KERN_INFO, &s->cb_dev->dev,
-				   "pcmcia: parent PCI bridge window: %pR\n",
-				   res);
+			dev_info(&s->cb_dev->dev,
+				 "pcmcia: parent PCI bridge window: %pR\n",
+				 res);
 			if (!adjust_memory(s, ADD_MANAGED_RESOURCE, res->start, res->end))
 				done |= IORESOURCE_MEM;
 		}
diff --git a/drivers/pcmcia/ti113x.h b/drivers/pcmcia/ti113x.h
index a717894..727e560 100644
--- a/drivers/pcmcia/ti113x.h
+++ b/drivers/pcmcia/ti113x.h
@@ -372,8 +372,8 @@ static void ti12xx_irqroute_func0(struct yenta_socket *socket)
 
 	mfunc = mfunc_old = config_readl(socket, TI122X_MFUNC);
 	devctl = config_readb(socket, TI113X_DEVICE_CONTROL);
-	dev_printk(KERN_INFO, &socket->dev->dev,
-		   "TI: mfunc 0x%08x, devctl 0x%02x\n", mfunc, devctl);
+	dev_info(&socket->dev->dev,
+		 "TI: mfunc 0x%08x, devctl 0x%02x\n", mfunc, devctl);
 
 	/* make sure PCI interrupts are enabled before probing */
 	ti_init(socket);
@@ -387,8 +387,8 @@ static void ti12xx_irqroute_func0(struct yenta_socket *socket)
 	 * We're here which means PCI interrupts are _not_ delivered. try to
 	 * find the right setting (all serial or parallel)
 	 */
-	dev_printk(KERN_INFO, &socket->dev->dev,
-		   "TI: probing PCI interrupt failed, trying to fix\n");
+	dev_info(&socket->dev->dev,
+		 "TI: probing PCI interrupt failed, trying to fix\n");
 
 	/* for serial PCI make sure MFUNC3 is set to IRQSER */
 	if ((devctl & TI113X_DCR_IMODE_MASK) == TI12XX_DCR_IMODE_ALL_SERIAL) {
@@ -412,8 +412,8 @@ static void ti12xx_irqroute_func0(struct yenta_socket *socket)
 
 				pci_irq_status = yenta_probe_cb_irq(socket);
 				if (pci_irq_status == 1) {
-					dev_printk(KERN_INFO, &socket->dev->dev,
-					    "TI: all-serial interrupts ok\n");
+					dev_info(&socket->dev->dev,
+						 "TI: all-serial interrupts ok\n");
 					mfunc_old = mfunc;
 					goto out;
 				}
@@ -428,8 +428,8 @@ static void ti12xx_irqroute_func0(struct yenta_socket *socket)
 		}
 
 		/* serial PCI interrupts not working fall back to parallel */
-		dev_printk(KERN_INFO, &socket->dev->dev,
-			   "TI: falling back to parallel PCI interrupts\n");
+		dev_info(&socket->dev->dev,
+			 "TI: falling back to parallel PCI interrupts\n");
 		devctl &= ~TI113X_DCR_IMODE_MASK;
 		devctl |= TI113X_DCR_IMODE_SERIAL; /* serial ISA could be right */
 		config_writeb(socket, TI113X_DEVICE_CONTROL, devctl);
@@ -460,8 +460,7 @@ static void ti12xx_irqroute_func0(struct yenta_socket *socket)
 	pci_irq_status = yenta_probe_cb_irq(socket);
 	if (pci_irq_status == 1) {
 		mfunc_old = mfunc;
-		dev_printk(KERN_INFO, &socket->dev->dev,
-			   "TI: parallel PCI interrupts ok\n");
+		dev_info(&socket->dev->dev, "TI: parallel PCI interrupts ok\n");
 	} else {
 		/* not working, back to old value */
 		mfunc = mfunc_old;
@@ -473,9 +472,8 @@ static void ti12xx_irqroute_func0(struct yenta_socket *socket)
 out:
 	if (pci_irq_status < 1) {
 		socket->cb_irq = 0;
-		dev_printk(KERN_INFO, &socket->dev->dev,
-			   "Yenta TI: no PCI interrupts. Fish. "
-			   "Please report.\n");
+		dev_info(&socket->dev->dev,
+			 "Yenta TI: no PCI interrupts. Fish. Please report.\n");
 	}
 }
 
@@ -547,9 +545,8 @@ static void ti12xx_irqroute_func1(struct yenta_socket *socket)
 
 	mfunc = mfunc_old = config_readl(socket, TI122X_MFUNC);
 	devctl = config_readb(socket, TI113X_DEVICE_CONTROL);
-	dev_printk(KERN_INFO, &socket->dev->dev,
-		   "TI: mfunc 0x%08x, devctl 0x%02x\n",
-		   mfunc, devctl);
+	dev_info(&socket->dev->dev, "TI: mfunc 0x%08x, devctl 0x%02x\n",
+		 mfunc, devctl);
 
 	/* if IRQs are configured as tied, align irq of func1 with func0 */
 	sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
@@ -568,8 +565,8 @@ static void ti12xx_irqroute_func1(struct yenta_socket *socket)
 	 * We're here which means PCI interrupts are _not_ delivered. try to
 	 * find the right setting
 	 */
-	dev_printk(KERN_INFO, &socket->dev->dev,
-		   "TI: probing PCI interrupt failed, trying to fix\n");
+	dev_info(&socket->dev->dev,
+		 "TI: probing PCI interrupt failed, trying to fix\n");
 
 	/* if all serial: set INTRTIE, probe again */
 	if ((devctl & TI113X_DCR_IMODE_MASK) == TI12XX_DCR_IMODE_ALL_SERIAL) {
@@ -578,8 +575,8 @@ static void ti12xx_irqroute_func1(struct yenta_socket *socket)
 		if (ti12xx_tie_interrupts(socket, &old_irq)) {
 			pci_irq_status = yenta_probe_cb_irq(socket);
 			if (pci_irq_status == 1) {
-				dev_printk(KERN_INFO, &socket->dev->dev,
-					"TI: all-serial interrupts, tied ok\n");
+				dev_info(&socket->dev->dev,
+					 "TI: all-serial interrupts, tied ok\n");
 				goto out;
 			}
 
@@ -616,8 +613,8 @@ static void ti12xx_irqroute_func1(struct yenta_socket *socket)
 
 			pci_irq_status = yenta_probe_cb_irq(socket);
 			if (pci_irq_status == 1) {
-				dev_printk(KERN_INFO, &socket->dev->dev,
-					   "TI: parallel PCI interrupts ok\n");
+				dev_info(&socket->dev->dev,
+					 "TI: parallel PCI interrupts ok\n");
 				goto out;
 			}
 
@@ -632,8 +629,8 @@ static void ti12xx_irqroute_func1(struct yenta_socket *socket)
 		if (ti12xx_tie_interrupts(socket, &old_irq)) {
 			pci_irq_status = yenta_probe_cb_irq(socket);
 			if (pci_irq_status == 1) {
-				dev_printk(KERN_INFO, &socket->dev->dev,
-				    "TI: parallel PCI interrupts, tied ok\n");
+				dev_info(&socket->dev->dev,
+					 "TI: parallel PCI interrupts, tied ok\n");
 				goto out;
 			}
 
@@ -644,8 +641,8 @@ static void ti12xx_irqroute_func1(struct yenta_socket *socket)
 out:
 	if (pci_irq_status < 1) {
 		socket->cb_irq = 0;
-		dev_printk(KERN_INFO, &socket->dev->dev,
-			   "TI: no PCI interrupts. Fish. Please report.\n");
+		dev_info(&socket->dev->dev,
+			 "TI: no PCI interrupts. Fish. Please report.\n");
 	}
 }
 
@@ -849,13 +846,12 @@ static int ti12xx_override(struct yenta_socket *socket)
 	/* make sure that memory burst is active */
 	val_orig = val = config_readl(socket, TI113X_SYSTEM_CONTROL);
 	if (disable_clkrun && PCI_FUNC(socket->dev->devfn) == 0) {
-		dev_printk(KERN_INFO, &socket->dev->dev,
-			   "Disabling CLKRUN feature\n");
+		dev_info(&socket->dev->dev, "Disabling CLKRUN feature\n");
 		val |= TI113X_SCR_KEEPCLK;
 	}
 	if (!(val & TI122X_SCR_MRBURSTUP)) {
-		dev_printk(KERN_INFO, &socket->dev->dev,
-			   "Enabling burst memory read transactions\n");
+		dev_info(&socket->dev->dev,
+			 "Enabling burst memory read transactions\n");
 		val |= TI122X_SCR_MRBURSTUP;
 	}
 	if (val_orig != val)
@@ -866,12 +862,12 @@ static int ti12xx_override(struct yenta_socket *socket)
 	 * CSC interrupts to PCI rather than INTVAL.
 	 */
 	val = config_readb(socket, TI1250_DIAGNOSTIC);
-	dev_printk(KERN_INFO, &socket->dev->dev,
-		   "Using %s to route CSC interrupts to PCI\n",
-		   (val & TI1250_DIAG_PCI_CSC) ? "CSCINT" : "INTVAL");
-	dev_printk(KERN_INFO, &socket->dev->dev,
-		   "Routing CardBus interrupts to %s\n",
-		   (val & TI1250_DIAG_PCI_IREQ) ? "PCI" : "ISA");
+	dev_info(&socket->dev->dev,
+		 "Using %s to route CSC interrupts to PCI\n",
+		 (val & TI1250_DIAG_PCI_CSC) ? "CSCINT" : "INTVAL");
+	dev_info(&socket->dev->dev,
+		 "Routing CardBus interrupts to %s\n",
+		 (val & TI1250_DIAG_PCI_IREQ) ? "PCI" : "ISA");
 
 	/* do irqrouting, depending on function */
 	if (PCI_FUNC(socket->dev->devfn) == 0)
@@ -896,9 +892,9 @@ static int ti1250_override(struct yenta_socket *socket)
 		diag |= TI1250_DIAG_PCI_CSC | TI1250_DIAG_PCI_IREQ;
 
 	if (diag != old) {
-		dev_printk(KERN_INFO, &socket->dev->dev,
-			   "adjusting diagnostic: %02x -> %02x\n",
-			   old, diag);
+		dev_info(&socket->dev->dev,
+			 "adjusting diagnostic: %02x -> %02x\n",
+			 old, diag);
 		config_writeb(socket, TI1250_DIAGNOSTIC, diag);
 	}
 
@@ -963,9 +959,9 @@ static void ene_tune_bridge(struct pcmcia_socket *sock, struct pci_bus *bus)
 		/* default to clear TLTEnable bit, old behaviour */
 		test_c9 &= ~ENE_TEST_C9_TLTENABLE;
 
-	dev_printk(KERN_INFO, &socket->dev->dev,
-		   "EnE: chaning testregister 0xC9, %02x -> %02x\n",
-		   old_c9, test_c9);
+	dev_info(&socket->dev->dev,
+		 "EnE: chaning testregister 0xC9, %02x -> %02x\n",
+		 old_c9, test_c9);
 	config_writeb(socket, ENE_TEST_C9, test_c9);
 }
 
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 667678d..00a7628 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -712,10 +712,9 @@ static int yenta_allocate_res(struct yenta_socket *socket, int nr, unsigned type
 		pcibios_bus_to_resource(dev, res, &region);
 		if (pci_claim_resource(dev, PCI_BRIDGE_RESOURCES + nr) == 0)
 			return 0;
-		dev_printk(KERN_INFO, &dev->dev,
-			   "Preassigned resource %d busy or not available, "
-			   "reconfiguring...\n",
-			   nr);
+		dev_info(&dev->dev,
+			 "Preassigned resource %d busy or not available, reconfiguring...\n",
+			 nr);
 	}
 
 	if (type & IORESOURCE_IO) {
@@ -738,9 +737,9 @@ static int yenta_allocate_res(struct yenta_socket *socket, int nr, unsigned type
 			return 1;
 	}
 
-	dev_printk(KERN_INFO, &dev->dev,
-		   "no resource of type %x available, trying to continue...\n",
-		   type);
+	dev_info(&dev->dev,
+		 "no resource of type %x available, trying to continue...\n",
+		 type);
 	res->start = res->end = res->flags = 0;
 	return 0;
 }
@@ -979,8 +978,8 @@ static int yenta_probe_cb_irq(struct yenta_socket *socket)
 	socket->probe_status = 0;
 
 	if (request_irq(socket->cb_irq, yenta_probe_handler, IRQF_SHARED, "yenta", socket)) {
-		dev_printk(KERN_WARNING, &socket->dev->dev,
-			   "request_irq() in yenta_probe_cb_irq() failed!\n");
+		dev_warn(&socket->dev->dev,
+			 "request_irq() in yenta_probe_cb_irq() failed!\n");
 		return -1;
 	}
 
@@ -1019,9 +1018,8 @@ static void yenta_get_socket_capabilities(struct yenta_socket *socket, u32 isa_i
 	else
 		socket->socket.irq_mask = 0;
 
-	dev_printk(KERN_INFO, &socket->dev->dev,
-		   "ISA IRQ mask 0x%04x, PCI irq %d\n",
-		   socket->socket.irq_mask, socket->cb_irq);
+	dev_info(&socket->dev->dev, "ISA IRQ mask 0x%04x, PCI irq %d\n",
+		 socket->socket.irq_mask, socket->cb_irq);
 }
 
 /*
@@ -1111,9 +1109,9 @@ static void yenta_fixup_parent_bridge(struct pci_bus *cardbus_bridge)
 
 	/* Show that the wanted subordinate number is not possible: */
 	if (cardbus_bridge->busn_res.end > upper_limit)
-		dev_printk(KERN_WARNING, &cardbus_bridge->dev,
-			   "Upper limit for fixing this "
-			   "bridge's parent bridge: #%02x\n", upper_limit);
+		dev_warn(&cardbus_bridge->dev,
+			 "Upper limit for fixing this bridge's parent bridge: #%02x\n",
+			 upper_limit);
 
 	/* If we have room to increase the bridge's subordinate number, */
 	if (bridge_to_fix->busn_res.end < upper_limit) {
@@ -1122,11 +1120,11 @@ static void yenta_fixup_parent_bridge(struct pci_bus *cardbus_bridge)
 		unsigned char subordinate_to_assign =
 			min_t(int, cardbus_bridge->busn_res.end, upper_limit);
 
-		dev_printk(KERN_INFO, &bridge_to_fix->dev,
-			   "Raising subordinate bus# of parent "
-			   "bus (#%02x) from #%02x to #%02x\n",
-			   bridge_to_fix->number,
-			   (int)bridge_to_fix->busn_res.end, subordinate_to_assign);
+		dev_info(&bridge_to_fix->dev,
+			 "Raising subordinate bus# of parent bus (#%02x) from #%02x to #%02x\n",
+			 bridge_to_fix->number,
+			 (int)bridge_to_fix->busn_res.end,
+			 subordinate_to_assign);
 
 		/* Save the new subordinate in the bus struct of the bridge */
 		bridge_to_fix->busn_res.end = subordinate_to_assign;
@@ -1153,8 +1151,7 @@ static int __devinit yenta_probe(struct pci_dev *dev, const struct pci_device_id
 	 * Bail out if so.
 	 */
 	if (!dev->subordinate) {
-		dev_printk(KERN_ERR, &dev->dev, "no bus associated! "
-			   "(try 'pci=assign-busses')\n");
+		dev_err(&dev->dev, "no bus associated! (try 'pci=assign-busses')\n");
 		return -ENODEV;
 	}
 
@@ -1189,7 +1186,7 @@ static int __devinit yenta_probe(struct pci_dev *dev, const struct pci_device_id
 		goto disable;
 
 	if (!pci_resource_start(dev, 0)) {
-		dev_printk(KERN_ERR, &dev->dev, "No cardbus resource!\n");
+		dev_err(&dev->dev, "No cardbus resource!\n");
 		ret = -ENODEV;
 		goto release;
 	}
@@ -1208,8 +1205,8 @@ static int __devinit yenta_probe(struct pci_dev *dev, const struct pci_device_id
 	 * report the subsystem vendor and device for help debugging
 	 * the irq stuff...
 	 */
-	dev_printk(KERN_INFO, &dev->dev, "CardBus bridge found [%04x:%04x]\n",
-		   dev->subsystem_vendor, dev->subsystem_device);
+	dev_info(&dev->dev, "CardBus bridge found [%04x:%04x]\n",
+		 dev->subsystem_vendor, dev->subsystem_device);
 
 	yenta_config_init(socket);
 
@@ -1241,12 +1238,10 @@ static int __devinit yenta_probe(struct pci_dev *dev, const struct pci_device_id
 		socket->poll_timer.data = (unsigned long)socket;
 		socket->poll_timer.expires = jiffies + HZ;
 		add_timer(&socket->poll_timer);
-		dev_printk(KERN_INFO, &dev->dev,
-			   "no PCI IRQ, CardBus support disabled for this "
-			   "socket.\n");
-		dev_printk(KERN_INFO, &dev->dev,
-			   "check your BIOS CardBus, BIOS IRQ or ACPI "
-			   "settings.\n");
+		dev_info(&dev->dev,
+			 "no PCI IRQ, CardBus support disabled for this socket\n");
+		dev_info(&dev->dev,
+			 "check your BIOS CardBus, BIOS IRQ or ACPI settings\n");
 	} else {
 		socket->socket.features |= SS_CAP_CARDBUS;
 	}
@@ -1254,8 +1249,8 @@ static int __devinit yenta_probe(struct pci_dev *dev, const struct pci_device_id
 	/* Figure out what the dang thing can do for the PCMCIA layer... */
 	yenta_interrogate(socket);
 	yenta_get_socket_capabilities(socket, isa_interrupts);
-	dev_printk(KERN_INFO, &dev->dev,
-		   "Socket status: %08x\n", cb_readl(socket, CB_SOCKET_STATE));
+	dev_info(&dev->dev,
+		 "Socket status: %08x\n", cb_readl(socket, CB_SOCKET_STATE));
 
 	yenta_fixup_parent_bridge(dev->subordinate);
 
-- 
1.7.8.112.g3fd21

