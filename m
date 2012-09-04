Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2IDPKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:10:24 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2IDPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:20 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCHwcCAlcGE4gRp3uSYIEhkAyBEgOVWZJ/
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821813"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 03/16] Staging: ipack/devices/ipoctal: Convert ipoctal to directly use ioread/write functions.
Date: Tue,  4 Sep 2012 17:01:08 +0200
Message-Id: <1346770881-4723-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Before it was using the functions in ipack_bus_ops.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 963ed20..085b6c0 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -20,6 +20,7 @@
 #include <linux/tty_flip.h>
 #include <linux/slab.h>
 #include <linux/atomic.h>
+#include <linux/io.h>
 #include "../ipack.h"
 #include "ipoctal.h"
 #include "scc2698.h"
@@ -61,16 +62,12 @@ static inline void ipoctal_write_io_reg(struct ipoctal *ipoctal,
 					unsigned char *dest,
 					unsigned char value)
 {
-	unsigned long offset;
-
-	offset = ((void __iomem *) dest) - ipoctal->dev->io_space.address;
-	ipoctal->dev->bus->ops->write8(ipoctal->dev, IPACK_IO_SPACE, offset,
-				       value);
+	iowrite8(value, dest);
 }
 
 static inline void ipoctal_write_cr_cmd(struct ipoctal *ipoctal,
-					unsigned char *dest,
-					unsigned char value)
+					u8 __iomem *dest,
+					u8 value)
 {
 	ipoctal_write_io_reg(ipoctal, dest, value);
 }
@@ -78,13 +75,7 @@ static inline void ipoctal_write_cr_cmd(struct ipoctal *ipoctal,
 static inline unsigned char ipoctal_read_io_reg(struct ipoctal *ipoctal,
 						unsigned char *src)
 {
-	unsigned long offset;
-	unsigned char value;
-
-	offset = ((void __iomem *) src) - ipoctal->dev->io_space.address;
-	ipoctal->dev->bus->ops->read8(ipoctal->dev, IPACK_IO_SPACE, offset,
-				      &value);
-	return value;
+	return ioread8(src);
 }
 
 static struct ipoctal *ipoctal_find_board(struct tty_struct *tty)
@@ -331,14 +322,11 @@ static int ipoctal_check_model(struct ipack_device *dev, unsigned char *id)
 	unsigned char manufacturerID;
 	unsigned char board_id;
 
-	dev->bus->ops->read8(dev, IPACK_ID_SPACE,
-			IPACK_IDPROM_OFFSET_MANUFACTURER_ID, &manufacturerID);
+	manufacturerID = ioread8(dev->id_space.address + IPACK_IDPROM_OFFSET_MANUFACTURER_ID);
 	if (manufacturerID != IP_OCTAL_MANUFACTURER_ID)
 		return -ENODEV;
 
-	dev->bus->ops->read8(dev, IPACK_ID_SPACE,
-			IPACK_IDPROM_OFFSET_MODEL, (unsigned char *)&board_id);
-
+	board_id = ioread8(dev->id_space.address + IPACK_IDPROM_OFFSET_MODEL);
 	switch (board_id) {
 	case IP_OCTAL_232_ID:
 	case IP_OCTAL_422_ID:
@@ -449,8 +437,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	 */
 	ipoctal->dev->bus->ops->request_irq(ipoctal->dev, vector,
 				       ipoctal_irq_handler, ipoctal);
-	ipoctal->dev->bus->ops->write8(ipoctal->dev, IPACK_MEM_SPACE, 1,
-				       vector);
+	iowrite8(vector, ipoctal->dev->mem_space.address + 1);
 
 	/* Register the TTY device */
 
-- 
1.7.10.4

