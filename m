Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1BGK6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:58:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47194 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1BGK5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:57:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=N9BJ3JrFcy8Wym+zCp8QlhEZy9Uginpu/TIMWB9R68FR/xsfzUGL0aToFbIpVGFLCI
         ENUme66GjH0N3Frdj/Q2Z+JN66hIEzELjXMBj5+y9iy68NkXayjYADKvIKj8trqJJRCo
         FHr/He2QTeK3BwDomE8BiunanzPp+lT3u8OAk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-cs: housekeeping
Date: Mon, 7 Feb 2011 11:51:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071151.08396.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove needless includes
* remove stale comments
* remove struct ide_info_t
* remove legacy dev_dbg() debugging
* inline ide_{config,release}()

Compile-tested only.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cs.c |   83 
+++++++--------------------------------------------
 1 file changed, 12 insertions(+), 71 deletions(-)

Index: b/drivers/ide/ide-cs.c
===================================================================
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -32,13 +32,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/ptrace.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/timer.h>
-#include <linux/ioport.h>
 #include <linux/ide.h>
-#include <linux/major.h>
 #include <linux/delay.h>
 #include <asm/io.h>
 #include <asm/system.h>
@@ -50,58 +44,10 @@
 
 #define DRV_NAME "ide-cs"
 
-/*====================================================================*/
-
-/* Module parameters */
-
 MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
 MODULE_DESCRIPTION("PCMCIA ATA/IDE card driver");
 MODULE_LICENSE("Dual MPL/GPL");
 
-/*====================================================================*/
-
-typedef struct ide_info_t {
-	struct pcmcia_device	*p_dev;
-	struct ide_host		*host;
-	int			ndev;
-} ide_info_t;
-
-static void ide_release(struct pcmcia_device *);
-static int ide_config(struct pcmcia_device *);
-
-static void ide_detach(struct pcmcia_device *p_dev);
-
-static int ide_probe(struct pcmcia_device *link)
-{
-    ide_info_t *info;
-
-    dev_dbg(&link->dev, "ide_attach()\n");
-
-    /* Create new ide device */
-    info = kzalloc(sizeof(*info), GFP_KERNEL);
-    if (!info)
-	return -ENOMEM;
-
-    info->p_dev = link;
-    link->priv = info;
-
-    link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO |
-	    CONF_AUTO_SET_VPP | CONF_AUTO_CHECK_VCC;
-
-    return ide_config(link);
-} /* ide_attach */
-
-static void ide_detach(struct pcmcia_device *link)
-{
-    ide_info_t *info = link->priv;
-
-    dev_dbg(&link->dev, "ide_detach(0x%p)\n", link);
-
-    ide_release(link);
-
-    kfree(info);
-} /* ide_detach */
-
 static const struct ide_port_ops idecs_port_ops = {
 	.quirkproc		= ide_undecoded_slave,
 };
@@ -186,14 +132,14 @@ static int pcmcia_check_one_config(struc
 	return pcmcia_request_io(pdev);
 }
 
-static int ide_config(struct pcmcia_device *link)
+static int ide_probe(struct pcmcia_device *link)
 {
-    ide_info_t *info = link->priv;
     int ret = 0, is_kme = 0;
     unsigned long io_base, ctl_base;
     struct ide_host *host;
 
-    dev_dbg(&link->dev, "ide_config(0x%p)\n", link);
+    link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO |
+	    CONF_AUTO_SET_VPP | CONF_AUTO_CHECK_VCC;
 
     is_kme = ((link->manf_id == MANFID_KME) &&
 	      ((link->card_id == PRODID_KME_KXLC005_A) ||
@@ -234,8 +180,7 @@ static int ide_config(struct pcmcia_devi
     if (host == NULL)
 	goto failed;
 
-    info->ndev = 1;
-    info->host = host;
+    link->priv = host;
     dev_info(&link->dev, "ide-cs: hd%c: Vpp = %d.%d\n",
 	    'a' + host->ports[0]->index * 2,
 	    link->vpp / 10, link->vpp % 10);
@@ -243,18 +188,15 @@ static int ide_config(struct pcmcia_devi
     return 0;
 
 failed:
-    ide_release(link);
+    pcmcia_disable_device(link);
     return -ENODEV;
-} /* ide_config */
+}
 
-static void ide_release(struct pcmcia_device *link)
+static void ide_detach(struct pcmcia_device *link)
 {
-    ide_info_t *info = link->priv;
-    struct ide_host *host = info->host;
+    struct ide_host *host = link->priv;
 
-    dev_dbg(&link->dev, "ide_release(0x%p)\n", link);
-
-    if (info->ndev) {
+    if (host) {
 	ide_hwif_t *hwif = host->ports[0];
 	unsigned long data_addr, ctl_addr;
 
@@ -262,15 +204,14 @@ static void ide_release(struct pcmcia_de
 	ctl_addr = hwif->io_ports.ctl_addr;
 
 	ide_host_remove(host);
-	info->ndev = 0;
+	link->priv = NULL;
 
 	release_region(ctl_addr, 1);
 	release_region(data_addr, 8);
     }
 
     pcmcia_disable_device(link);
-} /* ide_release */
-
+}
 
 static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_FUNC_ID(4),
@@ -344,7 +285,7 @@ MODULE_DEVICE_TABLE(pcmcia, ide_ids);
 
 static struct pcmcia_driver ide_cs_driver = {
 	.owner		= THIS_MODULE,
-	.name		= "ide-cs",
+	.name		= DRV_NAME,
 	.probe		= ide_probe,
 	.remove		= ide_detach,
 	.id_table       = ide_ids,
