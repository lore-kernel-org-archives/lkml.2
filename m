Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030343Ab2ERJKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:10:33 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:41780 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967180Ab2ERJKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:10:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABMRtk9bdWOb/2dsb2JhbABFs2eBB4IWAQUnQBIQUVcGE4gSvBSQRQOVIIkihlOCaw
X-IronPort-AV: E=Sophos;i="4.75,616,1330902000"; 
   d="scan'208";a="915536499"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Staging: ipack: remove board_name and bus_name fields from struct ipack_device
Date: Fri, 18 May 2012 11:10:06 +0200
Message-Id: <1337332208-26057-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
References: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed board_name and bus_name fields from struct ipack_device that are
completely useless.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   20 ++++----------------
 drivers/staging/ipack/bridges/tpci200.h |    8 ++++----
 drivers/staging/ipack/ipack.h           |    4 ----
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 392aec0..b460587 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -371,9 +371,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 
 #ifdef CONFIG_SYSFS
 
-static struct ipack_device *tpci200_slot_register(const char *board_name,
-						  int size,
-						  unsigned int tpci200_number,
+static struct ipack_device *tpci200_slot_register(unsigned int tpci200_number,
 						  unsigned int slot_position)
 {
 	int found = 0;
@@ -437,7 +435,7 @@ static ssize_t tpci200_store_board(struct device *pdev, const char *buf,
 	if (dev != NULL)
 		return -EBUSY;
 
-	dev = tpci200_slot_register(buf, count, card->number, slot);
+	dev = tpci200_slot_register(card->number, slot);
 	if (dev == NULL)
 		return -ENODEV;
 
@@ -450,7 +448,7 @@ static ssize_t tpci200_show_board(struct device *pdev, char *buf, int slot)
 	struct ipack_device *dev = card->slots[slot].dev;
 
 	if (dev != NULL)
-		return snprintf(buf, PAGE_SIZE, "%s\n", dev->board_name);
+		return snprintf(buf, PAGE_SIZE, "%s\n", dev_name(&dev->dev));
 	else
 		return snprintf(buf, PAGE_SIZE, "none\n");
 }
@@ -975,17 +973,7 @@ static int tpci200_request_irq(struct ipack_device *dev, int vector,
 	slot_irq->vector = vector;
 	slot_irq->handler = handler;
 	slot_irq->arg = arg;
-	if (dev->board_name) {
-		if (strlen(dev->board_name) > IPACK_IRQ_NAME_SIZE) {
-			pr_warning("Slot [%s %d:%d] IRQ name too long (%d char > %d char MAX). Will be truncated!\n",
-				   TPCI200_SHORTNAME, dev->bus_nr, dev->slot,
-				   (int)strlen(dev->board_name),
-				   IPACK_IRQ_NAME_SIZE);
-		}
-		strncpy(slot_irq->name, dev->board_name, IPACK_IRQ_NAME_SIZE-1);
-	} else {
-		strcpy(slot_irq->name, "Unknown");
-	}
+	slot_irq->name = dev_name(&dev->dev);
 
 	tpci200->slots[dev->slot].irq = slot_irq;
 	res = __tpci200_request_irq(tpci200, dev);
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index e3a7e5d..7eb994d 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -112,10 +112,10 @@
  *
  */
 struct slot_irq {
-	int          vector;
-	int         (*handler)(void *);
-	void         *arg;
-	char         name[IPACK_IRQ_NAME_SIZE];
+	int		vector;
+	int		(*handler)(void *);
+	void		*arg;
+	const char	*name;
 };
 
 /**
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index d50af71..8bc001e 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -11,8 +11,6 @@
 
 #include <linux/device.h>
 
-#define IPACK_BOARD_NAME_SIZE			16
-#define IPACK_IRQ_NAME_SIZE			50
 #define IPACK_IDPROM_OFFSET_I			0x01
 #define IPACK_IDPROM_OFFSET_P			0x03
 #define IPACK_IDPROM_OFFSET_A			0x05
@@ -64,8 +62,6 @@ struct ipack_addr_space {
  * by the carrier board throught bus->ops.
  */
 struct ipack_device {
-	char board_name[IPACK_BOARD_NAME_SIZE];
-	char bus_name[IPACK_BOARD_NAME_SIZE];
 	unsigned int bus_nr;
 	unsigned int slot;
 	unsigned int irq;
-- 
1.7.10

