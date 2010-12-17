Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0LQIKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 03:10:52 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:64685 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0LQIKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 03:10:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qGHqZ8TsIkc0+PHbE47MjiHGbEGr0WAbzjiiwUCKdX+rQN2GhFB6uOs8XAYnqhHlBJ
         MYi3oBft1AeW/tYQqFiVdviSfnfv+E/TBAD20DGBgHaGE1yPieG90gPjuoC0Fbt94JR0
         ia/riT19KLzcDR/aSrvJEo+cy/dYjcv5ZD2AM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        chl.pixo@gmail.com, Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/2] staging: ft1000-pcmcia: Fix compilation errors.
Date: Fri, 17 Dec 2010 09:13:11 +0100
Message-Id: <1292573592-3624-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292573592-3624-1-git-send-email-marek.belisko@open-nandra.com>
References: <1292573592-3624-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch will fix all compilation errors. Main problems
was with pcmcia API changes. Also remove BROKEN as now driver
is properly build.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/Kconfig                   |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |  286 +++++-----------------
 2 files changed, 68 insertions(+), 220 deletions(-)

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
index 2163eae..71c3a83 100644
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
@@ -111,73 +106,7 @@ typedef struct local_info_t {
 
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
@@ -202,13 +131,10 @@ static int ft1000_attach(struct pcmcia_device *link)
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
@@ -235,7 +161,7 @@ static void ft1000_detach(struct pcmcia_device *link)
 		stop_ft1000_card(dev);
 	}
 
-	ft1000_release(link);
+	pcmcia_disable_device(link);
 
 	/* This points to the parent local_info_t struct */
 	free_netdev(dev);
@@ -244,166 +170,91 @@ static void ft1000_detach(struct pcmcia_device *link)
 
 /*======================================================================
 
-    ft1000_config() is scheduled to run after a CARD_INSERTION event
-    is received, to configure the PCMCIA socket, and to make the
-    device available to the system.
+    Check if the current tuple contains MAC address.
+    Return 0 if MAC was found else return 1.
 
 ======================================================================*/
-
-#define CS_CHECK(fn, ret) \
-	do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
-
-#define CFG_CHECK(fn, ret) \
-	last_fn = (fn); if ((last_ret = (ret)) != 0) goto next_entry
-
-static int ft1000_config(struct pcmcia_device * link)
+int ft1000_get_mac(struct pcmcia_device *p_dev, tuple_t *tuple, void *priv)
 {
-	tuple_t tuple;
+	int i;
 	cisparse_t parse;
-	int last_fn, last_ret, i;
-	u_char buf[64];
 	cistpl_lan_node_id_t *node_id;
-	cistpl_cftable_entry_t dflt = { 0 };
-	cistpl_cftable_entry_t *cfg;
-	unsigned char mac_address[6];
-
-	DEBUG(0, "ft1000_cs: ft1000_config(0x%p)\n", link);
 
+	if (!pcmcia_parse_tuple(tuple, &parse)) {
+		if (parse.funce.type == CISTPL_FUNCE_LAN_NODE_ID) {
+			node_id = (cistpl_lan_node_id_t *) parse.funce.data;
+			if (node_id->nb == 6) {
+				for (i = 0; i < 6; i++)
+					*((unsigned char *)priv + i) =
+						node_id->id[i];
+				/*
+				 *  we found MAC address and will
+				 * end the pcmcia_loop_tuple
+				 */
+				return 0;
+			}
+		}
+	}
 	/*
-	   This reads the card's CONFIG tuple to find its configuration
-	   registers.
+	 * we did not find MAC address in this tuple
+	 * continue pcmcia_loop_tuple
 	 */
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
+	return 1;
+}                               /* ft1000_get_mac */
 
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
+/*======================================================================
 
-		break;
+   Check if the io window is configured
 
-	 next_entry:
-		last_ret = pcmcia_get_next_tuple(link, &tuple);
-	}
-	if (last_ret != CS_SUCCESS) {
-		cs_error(link, RequestIO, last_ret);
-		goto failed;
-	}
+======================================================================*/
+int ft1000_confcheck(struct pcmcia_device *link, void *priv_data)
+{
 
-	/*
-	   Allocate an interrupt line.  Note that this does not assign a
-	   handler to the interrupt, unless the 'Handler' member of the
-	   irq structure is initialized.
-	 */
-		CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
+	return pcmcia_request_io(link);
+}				/* ft1000_confcheck */
 
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
-	}
+/*======================================================================
 
-	if (i == CS_SUCCESS) {
-		node_id = (cistpl_lan_node_id_t *) parse.funce.data;
-		if (node_id->nb == 6) {
-			for (i = 0; i < 6; i++)
-				mac_address[i] = node_id->id[i];
-		}
+    ft1000_config() is scheduled to run after a CARD_INSERTION event
+    is received, to configure the PCMCIA socket, and to make the
+    device available to the system.
+
+======================================================================*/
+
+static int ft1000_config(struct pcmcia_device *link)
+{
+	int  ret;
+	unsigned char mac_address[6];
+
+	dev_dbg(&link->dev, "ft1000_cs: ft1000_config(0x%p)\n", link);
+
+	/* setup IO window */
+	ret = pcmcia_loop_config(link, ft1000_confcheck, NULL);
+	if (ret) {
+		printk(KERN_INFO "ft1000: Could not configure pcmcia\n");
+		goto failed;
 	}
 
-	((local_info_t *) link->priv)->dev =
-		init_ft1000_card(link->irq.AssignedIRQ, link->io.BasePort1,
-				 &mac_address[0], ft1000_reset, link,
-				 &handle_to_dev(link));
+	/* configure device */
+	ret = pcmcia_enable_device(link);
+	if (ret)
+		goto failed;
 
-	/*
-	   At this point, the dev_node_t structure(s) need to be
-	   initialized and arranged in a linked list at link->dev.
-	 */
+	/* get the MAC address */
+	ret = pcmcia_loop_tuple(link, CISTPL_FUNCE,
+				ft1000_get_mac, mac_address);
+	if (ret)
+		goto failed;
+
+	((local_info_t *) link->priv)->dev =
+		init_ft1000_card(link->irq, link->resource[0]->start,
+				 &mac_address[0], &ft1000_reset, link,
+				 &link->dev);
 
 	/* Finally, report what we've done */
 
 	return 0;
 
-cs_failed:
-	cs_error(link, last_fn, last_ret);
 failed:
 	ft1000_release(link);
 	return -ENODEV;
@@ -429,9 +280,6 @@ static void ft1000_release(struct pcmcia_device * link)
 	   no one will try to access the device or its data structures.
 	 */
 
-	/* Unlink the device chain */
-	link->dev_node = NULL;
-
 	/*
 	   In a normal driver, additional code may be needed to release
 	   other kernel data structures associated with this device.
-- 
1.7.1

