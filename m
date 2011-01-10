Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1AJMOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:14:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40517 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1AJMOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:14:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=QaamcjUnWNdhNjdD0JhDEwtO40j34DCwBtjiZwUbHcqfvv64AbBdYPmjg/lGINTyA1
         W1hSn8FVojAFMfi4voFiniLvAn/A84PNevYGg90oLW+viWZFgftHsoNGm4/qexULZpev
         W8sIksm5mXlwOx86xpdwNjk6sHDodBTYZ/npY=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Marek Belisko <marek.belisko@open-nandra.com>,
        Stano Lanci <chl.pixo@gmail.com>
Subject: [PATCH v2] staging: ft1000-pcmcia: Fix compilation errors.
Date: Mon, 10 Jan 2011 13:14:28 +0100
Message-Id: <1294661668-21051-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294661668-21051-1-git-send-email-marek.belisko@open-nandra.com>
References: <1294661668-21051-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch will fix all compilation errors. Main problems
was with pcmcia API changes. Also remove BROKEN as now driver
is properly build.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
Signed-off-by: Stano Lanci <chl.pixo@gmail.com>
---
 drivers/staging/ft1000/Kconfig                     |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |  263 +++-----------------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.h   |    1 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   34 ++--
 5 files changed, 55 insertions(+), 247 deletions(-)
 delete mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.h

diff --git a/drivers/staging/ft1000/Kconfig b/drivers/staging/ft1000/Kconfig
index d6da130..c54b4e8 100644
--- a/drivers/staging/ft1000/Kconfig
+++ b/drivers/staging/ft1000/Kconfig
@@ -13,7 +13,7 @@ config FT1000_USB
 
 config FT1000_PCMCIA
 	tristate "Driver for ft1000 pcmcia device."
-	depends on PCMCIA && BROKEN
+	depends on PCMCIA
 	depends on NET
 	help
 	  Say Y if you want to have support for Flarion card also called
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index 2163eae..874919c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -39,9 +39,6 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 
-//#include <pcmcia/version.h>		// Slavius 21.10.2009 removed from kernel
-#include <pcmcia/cs_types.h>
-#include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ds.h>
@@ -51,8 +48,6 @@
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 
-#include "ft1000_cs.h"			// Slavius 21.10.2009 because CS_SUCCESS constant is missing due to removed pcmcia/version.h
-
 /*====================================================================*/
 
 /* Module parameters */
@@ -82,9 +77,8 @@ MODULE_LICENSE("GPL");
 
 /*====================================================================*/
 
-struct net_device *init_ft1000_card(int, int, unsigned char *,
-					void *ft1000_reset, struct pcmcia_device * link,
-					struct device *fdev);
+struct net_device *init_ft1000_card(struct pcmcia_device *link,
+					void *ft1000_reset);
 void stop_ft1000_card(struct net_device *);
 
 static int ft1000_config(struct pcmcia_device *link);
@@ -111,73 +105,7 @@ typedef struct local_info_t {
 
 static void ft1000_reset(struct pcmcia_device * link)
 {
-	conf_reg_t reg;
-
-	DEBUG(0, "ft1000_cs:ft1000_reset is called................\n");
-
-	/* Soft-Reset card */
-	reg.Action = CS_WRITE;
-	reg.Offset = CISREG_COR;
-	reg.Value = COR_SOFT_RESET;
-	pcmcia_access_configuration_register(link, &reg);
-
-	/* Wait until the card has acknowledged our reset */
-	udelay(2);
-
-	/* Restore original COR configuration index */
-	/* Need at least 2 write to respond */
-	reg.Action = CS_WRITE;
-	reg.Offset = CISREG_COR;
-	reg.Value = COR_DEFAULT;
-	pcmcia_access_configuration_register(link, &reg);
-
-	/* Wait until the card has finished restarting */
-	udelay(1);
-
-	reg.Action = CS_WRITE;
-	reg.Offset = CISREG_COR;
-	reg.Value = COR_DEFAULT;
-	pcmcia_access_configuration_register(link, &reg);
-
-	/* Wait until the card has finished restarting */
-	udelay(1);
-
-	reg.Action = CS_WRITE;
-	reg.Offset = CISREG_COR;
-	reg.Value = COR_DEFAULT;
-	pcmcia_access_configuration_register(link, &reg);
-
-	/* Wait until the card has finished restarting */
-	udelay(1);
-
-}
-
-/*====================================================================*/
-
-static int get_tuple_first(struct pcmcia_device *link, tuple_t * tuple,
-			   cisparse_t * parse)
-{
-	int i;
-	i = pcmcia_get_first_tuple(link, tuple);
-	if (i != CS_SUCCESS)
-		return i;
-	i = pcmcia_get_tuple_data(link, tuple);
-	if (i != CS_SUCCESS)
-		return i;
-	return pcmcia_parse_tuple(tuple, parse);	// Slavius 21.10.2009 removed unused link parameter
-}
-
-static int get_tuple_next(struct pcmcia_device *link, tuple_t * tuple,
-			  cisparse_t * parse)
-{
-	int i;
-	i = pcmcia_get_next_tuple(link, tuple);
-	if (i != CS_SUCCESS)
-		return i;
-	i = pcmcia_get_tuple_data(link, tuple);
-	if (i != CS_SUCCESS)
-		return i;
-	return pcmcia_parse_tuple(tuple, parse);	// Slavius 21.10.2009 removed unused link parameter
+	pcmcia_reset_card(link->socket);
 }
 
 /*======================================================================
@@ -202,13 +130,10 @@ static int ft1000_attach(struct pcmcia_device *link)
 	link->priv = local;
 	local->dev = NULL;
 
-	link->irq.Attributes = IRQ_TYPE_EXCLUSIVE;
-	link->irq.IRQInfo1 = IRQ_LEVEL_ID;
-	link->conf.Attributes = CONF_ENABLE_IRQ;
-	link->conf.IntType = INT_MEMORY_AND_IO;
-	link->irq.Handler = NULL;
+	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 
 	return ft1000_config(link);
+
 }				/* ft1000_attach */
 
 /*======================================================================
@@ -235,7 +160,7 @@ static void ft1000_detach(struct pcmcia_device *link)
 		stop_ft1000_card(dev);
 	}
 
-	ft1000_release(link);
+	pcmcia_disable_device(link);
 
 	/* This points to the parent local_info_t struct */
 	free_netdev(dev);
@@ -244,166 +169,53 @@ static void ft1000_detach(struct pcmcia_device *link)
 
 /*======================================================================
 
+   Check if the io window is configured
+
+======================================================================*/
+int ft1000_confcheck(struct pcmcia_device *link, void *priv_data)
+{
+
+	return pcmcia_request_io(link);
+}				/* ft1000_confcheck */
+
+/*======================================================================
+
     ft1000_config() is scheduled to run after a CARD_INSERTION event
     is received, to configure the PCMCIA socket, and to make the
     device available to the system.
 
 ======================================================================*/
 
-#define CS_CHECK(fn, ret) \
-	do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
-
-#define CFG_CHECK(fn, ret) \
-	last_fn = (fn); if ((last_ret = (ret)) != 0) goto next_entry
-
-static int ft1000_config(struct pcmcia_device * link)
+static int ft1000_config(struct pcmcia_device *link)
 {
-	tuple_t tuple;
-	cisparse_t parse;
-	int last_fn, last_ret, i;
-	u_char buf[64];
-	cistpl_lan_node_id_t *node_id;
-	cistpl_cftable_entry_t dflt = { 0 };
-	cistpl_cftable_entry_t *cfg;
-	unsigned char mac_address[6];
+	int  ret;
 
-	DEBUG(0, "ft1000_cs: ft1000_config(0x%p)\n", link);
-
-	/*
-	   This reads the card's CONFIG tuple to find its configuration
-	   registers.
-	 */
-//	tuple.DesiredTuple = CISTPL_CONFIG;
-//	tuple.Attributes = 0;
-	tuple.TupleData = buf;
-	tuple.TupleDataMax = sizeof(buf);
-	tuple.TupleOffset = 0;
-//	CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(link, &tuple));
-//	CS_CHECK(GetTupleData, pcmcia_get_tuple_data(link, &tuple));
-//	CS_CHECK(ParseTuple, pcmcia_parse_tuple(link, &tuple, &parse));
-//	link->conf.ConfigBase = parse.config.base;
-//	link->conf.Present = parse.config.rmask[0];
+	dev_dbg(&link->dev, "ft1000_cs: ft1000_config(0x%p)\n", link);
 
-	/*
-	   In this loop, we scan the CIS for configuration table entries,
-	   each of which describes a valid card configuration, including
-	   voltage, IO window, memory window, and interrupt settings.
-
-	   We make no assumptions about the card to be configured: we use
-	   just the information available in the CIS.  In an ideal world,
-	   this would work for any PCMCIA card, but it requires a complete
-	   and accurate CIS.  In practice, a driver usually "knows" most of
-	   these things without consulting the CIS, and most client drivers
-	   will only use the CIS to fill in implementation-defined details.
-	 */
-	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
-	tuple.Attributes = 0;
-	CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(link, &tuple));
-	while (1) {
-		cfg = &(parse.cftable_entry);
-		CFG_CHECK(GetTupleData, pcmcia_get_tuple_data(link, &tuple));
-		CFG_CHECK(ParseTuple,
-			  pcmcia_parse_tuple(&tuple, &parse));		// Slavius 21.10.2009 removed unused link parameter
-
-		if (cfg->flags & CISTPL_CFTABLE_DEFAULT)
-			dflt = *cfg;
-		if (cfg->index == 0)
-			goto next_entry;
-		link->conf.ConfigIndex = cfg->index;
-
-		/* Do we need to allocate an interrupt? */
-		if (cfg->irq.IRQInfo1 || dflt.irq.IRQInfo1)
-			link->conf.Attributes |= CONF_ENABLE_IRQ;
-
-		/* IO window settings */
-		link->io.NumPorts1 = link->io.NumPorts2 = 0;
-		if ((cfg->io.nwin > 0) || (dflt.io.nwin > 0)) {
-			cistpl_io_t *io = (cfg->io.nwin) ? &cfg->io : &dflt.io;
-			link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
-			if (!(io->flags & CISTPL_IO_8BIT)) {
-				DEBUG(0, "ft1000_cs: IO_DATA_PATH_WIDTH_16\n");
-				link->io.Attributes1 = IO_DATA_PATH_WIDTH_16;
-			}
-			if (!(io->flags & CISTPL_IO_16BIT)) {
-				DEBUG(0, "ft1000_cs: IO_DATA_PATH_WIDTH_8\n");
-				link->io.Attributes1 = IO_DATA_PATH_WIDTH_8;
-			}
-			link->io.IOAddrLines = io->flags & CISTPL_IO_LINES_MASK;
-			link->io.BasePort1 = io->win[0].base;
-			link->io.NumPorts1 = io->win[0].len;
-			if (io->nwin > 1) {
-				link->io.Attributes2 = link->io.Attributes1;
-				link->io.BasePort2 = io->win[1].base;
-				link->io.NumPorts2 = io->win[1].len;
-			}
-			/* This reserves IO space but doesn't actually enable it */
-			pcmcia_request_io(link, &link->io);
-		}
-
-		break;
-
-	 next_entry:
-		last_ret = pcmcia_get_next_tuple(link, &tuple);
-	}
-	if (last_ret != CS_SUCCESS) {
-		cs_error(link, RequestIO, last_ret);
-		goto failed;
+	/* setup IO window */
+	ret = pcmcia_loop_config(link, ft1000_confcheck, NULL);
+	if (ret) {
+		printk(KERN_INFO "ft1000: Could not configure pcmcia\n");
+		return -ENODEV;
 	}
 
-	/*
-	   Allocate an interrupt line.  Note that this does not assign a
-	   handler to the interrupt, unless the 'Handler' member of the
-	   irq structure is initialized.
-	 */
-		CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
-
-	/*
-	   This actually configures the PCMCIA socket -- setting up
-	   the I/O windows and the interrupt mapping, and putting the
-	   card and host interface into "Memory and IO" mode.
-	 */
-	CS_CHECK(RequestConfiguration,
-		 pcmcia_request_configuration(link, &link->conf));
-
-	/* Get MAC address from tuples */
-
-	tuple.Attributes = tuple.TupleOffset = 0;
-	tuple.TupleData = buf;
-	tuple.TupleDataMax = sizeof(buf);
-
-	/* Check for a LAN function extension tuple */
-	tuple.DesiredTuple = CISTPL_FUNCE;
-	i = get_tuple_first(link, &tuple, &parse);
-	while (i == CS_SUCCESS) {
-		if (parse.funce.type == CISTPL_FUNCE_LAN_NODE_ID)
-			break;
-		i = get_tuple_next(link, &tuple, &parse);
+	/* configure device */
+	ret = pcmcia_enable_device(link);
+	if (ret) {
+		printk(KERN_INFO "ft1000: could not enable pcmcia\n");
+		goto failed;
 	}
 
-	if (i == CS_SUCCESS) {
-		node_id = (cistpl_lan_node_id_t *) parse.funce.data;
-		if (node_id->nb == 6) {
-			for (i = 0; i < 6; i++)
-				mac_address[i] = node_id->id[i];
-		}
+	((local_info_t *) link->priv)->dev = init_ft1000_card(link,
+								&ft1000_reset);
+	if (((local_info_t *) link->priv)->dev == NULL) {
+		printk(KERN_INFO "ft1000: Could not register as network device\n");
+		goto failed;
 	}
 
-	((local_info_t *) link->priv)->dev =
-		init_ft1000_card(link->irq.AssignedIRQ, link->io.BasePort1,
-				 &mac_address[0], ft1000_reset, link,
-				 &handle_to_dev(link));
-
-	/*
-	   At this point, the dev_node_t structure(s) need to be
-	   initialized and arranged in a linked list at link->dev.
-	 */
-
 	/* Finally, report what we've done */
 
 	return 0;
-
-cs_failed:
-	cs_error(link, last_fn, last_ret);
 failed:
 	ft1000_release(link);
 	return -ENODEV;
@@ -429,14 +241,11 @@ static void ft1000_release(struct pcmcia_device * link)
 	   no one will try to access the device or its data structures.
 	 */
 
-	/* Unlink the device chain */
-	link->dev_node = NULL;
-
 	/*
 	   In a normal driver, additional code may be needed to release
 	   other kernel data structures associated with this device.
 	 */
-
+	kfree((local_info_t *) link->priv);
 	/* Don't bother checking to see if these succeed or not */
 
 	 pcmcia_disable_device(link);
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.h
deleted file mode 100644
index 2b5e383..0000000
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.h
+++ /dev/null
@@ -1 +0,0 @@
-#define CS_SUCCESS	0x00
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index 0bf398d..c56f588 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -310,7 +310,7 @@ USHORT hdr_checksum(PPSEUDO_HDR pHdr)
 	return chksum;
 }
 
-int card_download(struct net_device *dev, void *pFileStart, UINT FileLength)
+int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 {
 	FT1000_INFO *info = (PFT1000_INFO) netdev_priv(dev);
 	int Status = SUCCESS;
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 588afd5..5bc6811 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -43,6 +43,10 @@
 #include <linux/firmware.h>
 #include <linux/ethtool.h>
 
+#include <pcmcia/cistpl.h>
+#include <pcmcia/cisreg.h>
+#include <pcmcia/ds.h>
+
 #ifdef FT_DEBUG
 #define DEBUG(n, args...) printk(KERN_DEBUG args);
 #else
@@ -53,7 +57,7 @@
 #include "ft1000_dev.h"
 #include "ft1000.h"
 
-int card_download(struct net_device *dev, void *pFileStart, UINT FileLength);
+int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength);
 
 void ft1000InitProc(struct net_device *dev);
 void ft1000CleanupProc(struct net_device *dev);
@@ -2148,13 +2152,11 @@ static const struct ethtool_ops ops = {
 	.get_link = ft1000_get_link
 };
 
-struct net_device *init_ft1000_card(unsigned short irq, int port,
-					unsigned char *mac_addr, void *ft1000_reset,
-					void *link, struct device *fdev)
+struct net_device *init_ft1000_card(struct pcmcia_device *link,
+					void *ft1000_reset)
 {
 	FT1000_INFO *info;
 	struct net_device *dev;
-	int i;
 
 	static const struct net_device_ops ft1000ops =		// Slavius 21.10.2009 due to kernel changes
 	{
@@ -2165,8 +2167,8 @@ struct net_device *init_ft1000_card(unsigned short irq, int port,
 	};
 
 	DEBUG(1, "ft1000_hw: init_ft1000_card()\n");
-	DEBUG(1, "ft1000_hw: irq = %d\n", irq);
-	DEBUG(1, "ft1000_hw: port = 0x%04x\n", port);
+	DEBUG(1, "ft1000_hw: irq = %d\n", link->irq);
+	DEBUG(1, "ft1000_hw: port = 0x%04x\n", link->resource[0]->start);
 
 	flarion_ft1000_cnt++;
 
@@ -2184,7 +2186,7 @@ struct net_device *init_ft1000_card(unsigned short irq, int port,
 		return NULL;
 	}
 
-	SET_NETDEV_DEV(dev, fdev);
+	SET_NETDEV_DEV(dev, &link->dev);
 	info = netdev_priv(dev);
 
 	memset(info, 0, sizeof(FT1000_INFO));
@@ -2227,15 +2229,13 @@ struct net_device *init_ft1000_card(unsigned short irq, int port,
 
 	DEBUG(0, "device name = %s\n", dev->name);
 
-	for (i = 0; i < 6; i++) {
-		dev->dev_addr[i] = mac_addr[i];
-		DEBUG(1, "ft1000_hw: mac_addr %d = 0x%02x\n", i, mac_addr[i]);
+	dev->irq = link->irq;
+	dev->base_addr = link->resource[0]->start;
+	if (pcmcia_get_mac_from_cis(link, dev)) {
+		printk(KERN_ERR "ft1000: Could not read mac address\n");
+		goto err_dev;
 	}
 
-	netif_stop_queue(dev);
-	dev->irq = irq;
-	dev->base_addr = port;
-
 	if (request_irq(dev->irq, ft1000_interrupt, IRQF_SHARED, dev->name, dev)) {
 		printk(KERN_ERR "ft1000: Could not request_irq\n");
 		goto err_dev;
@@ -2254,13 +2254,13 @@ struct net_device *init_ft1000_card(unsigned short irq, int port,
 	info->AsicID = ft1000_read_reg(dev, FT1000_REG_ASIC_ID);
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		DEBUG(0, "ft1000_hw: ELECTRABUZZ ASIC\n");
-		if (request_firmware(&fw_entry, "ft1000.img", fdev) != 0) {
+		if (request_firmware(&fw_entry, "ft1000.img", &link->dev) != 0) {
 			printk(KERN_INFO "ft1000: Could not open ft1000.img\n");
 			goto err_unreg;
 		}
 	} else {
 		DEBUG(0, "ft1000_hw: MAGNEMITE ASIC\n");
-		if (request_firmware(&fw_entry, "ft2000.img", fdev) != 0) {
+		if (request_firmware(&fw_entry, "ft2000.img", &link->dev) != 0) {
 			printk(KERN_INFO "ft1000: Could not open ft2000.img\n");
 			goto err_unreg;
 		}
-- 
1.7.1

