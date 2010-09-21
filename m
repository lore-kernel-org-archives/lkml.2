Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab0IUHYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 03:24:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62204 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab0IUHYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 03:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KS1fKvY2Dm/RRva0joj9KmNY2LhBqank+NjpA6H0+3gnva2cmOYDFbbbsziX2Q4yTf
         Qfoa7PInqGKkWXwbtI6vR4Evo0xWQEDHcTDZv7xw2LbAuLR//B/w8Vcr0If6eLSkRUTG
         9xECcJ/83z8De5Pfd7F4QQKLKa76Euw3zwEjc=
Message-ID: <4C985DFC.7020203@gmail.com>
Date: Tue, 21 Sep 2010 09:25:48 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Michael Tokarev <mjt@tls.msk.ru>,
        Pedro Francisco <pedrogfrancisco@gmail.com>,
        linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: [PATCH #upstream-fixes] ahci: fix module refcount breakage introduced
 by libahci split
References: <201009162256.04765.pedrogfrancisco@gmail.com> <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net> <4C933A8F.2080305@gmail.com> <1284892106.2650.4.camel@sundae-v2> <4C9602E4.4090007@gmail.com> <1284974726.11757.9.camel@sundae-v2> <4C9729D7.70500@gmail.com>  <4C972C60.8010506@gmail.com> <1285015465.26023.10.camel@sundae-v2> <4C97DB80.4060403@gmail.com> <4C97DBE2.8070707@gmail.com> <4C984D44.1080109@msgid.tls.msk.ru>
In-Reply-To: <4C984D44.1080109@msgid.tls.msk.ru>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libata depends on scsi_host_template for module reference counting and
sht's should be owned by each low level driver.  During libahci split,
the sht was left with libahci.ko leaving the actual low level drivers
not reference counted.  This made ahci and ahci_platform always
unloadable even while they're being actively used.

Fix it by defining AHCI_SHT() macro in ahci.h and defining a sht for
each low level ahci driver.

stable: only applicable to 2.6.35.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Cc: stable@kernel.org
---
Michael, thanks a lot for spotting it and bearing with me.

 drivers/ata/ahci.c          |    4 ++++
 drivers/ata/ahci.h          |   12 +++++++++++-
 drivers/ata/ahci_platform.c |    6 +++++-
 drivers/ata/libahci.c       |   16 ++++------------
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ff1c945..99d0e5a 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -90,6 +90,10 @@ static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif

+static struct scsi_host_template ahci_sht = {
+	AHCI_SHT("ahci"),
+};
+
 static struct ata_port_operations ahci_vt8251_ops = {
 	.inherits		= &ahci_ops,
 	.hardreset		= ahci_vt8251_hardreset,
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 474427b..e5fdeeb 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -298,7 +298,17 @@ struct ahci_host_priv {

 extern int ahci_ignore_sss;

-extern struct scsi_host_template ahci_sht;
+extern struct device_attribute *ahci_shost_attrs[];
+extern struct device_attribute *ahci_sdev_attrs[];
+
+#define AHCI_SHT(drv_name)						\
+	ATA_NCQ_SHT(drv_name),						\
+	.can_queue		= AHCI_MAX_CMDS - 1,			\
+	.sg_tablesize		= AHCI_MAX_SG,				\
+	.dma_boundary		= AHCI_DMA_BOUNDARY,			\
+	.shost_attrs		= ahci_shost_attrs,			\
+	.sdev_attrs		= ahci_sdev_attrs
+
 extern struct ata_port_operations ahci_ops;

 void ahci_save_initial_config(struct device *dev,
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 4e97f33..84b6432 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -23,6 +23,10 @@
 #include <linux/ahci_platform.h>
 #include "ahci.h"

+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int __init ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -145,7 +149,7 @@ static int __init ahci_probe(struct platform_device *pdev)
 	ahci_print_info(host, "platform");

 	rc = ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
-			       &ahci_sht);
+			       &ahci_platform_sht);
 	if (rc)
 		goto err0;

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 68dc678..8eea309 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -121,7 +121,7 @@ static DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
 static DEVICE_ATTR(em_buffer, S_IWUSR | S_IRUGO,
 		   ahci_read_em_buffer, ahci_store_em_buffer);

-static struct device_attribute *ahci_shost_attrs[] = {
+struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
 	&dev_attr_em_message_type,
 	&dev_attr_em_message,
@@ -132,22 +132,14 @@ static struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_em_buffer,
 	NULL
 };
+EXPORT_SYMBOL_GPL(ahci_shost_attrs);

-static struct device_attribute *ahci_sdev_attrs[] = {
+struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
 	&dev_attr_unload_heads,
 	NULL
 };
-
-struct scsi_host_template ahci_sht = {
-	ATA_NCQ_SHT("ahci"),
-	.can_queue		= AHCI_MAX_CMDS - 1,
-	.sg_tablesize		= AHCI_MAX_SG,
-	.dma_boundary		= AHCI_DMA_BOUNDARY,
-	.shost_attrs		= ahci_shost_attrs,
-	.sdev_attrs		= ahci_sdev_attrs,
-};
-EXPORT_SYMBOL_GPL(ahci_sht);
+EXPORT_SYMBOL_GPL(ahci_sdev_attrs);

 struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
