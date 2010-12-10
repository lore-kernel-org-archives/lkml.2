Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0LJUpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:45:51 -0500
Received: from mxout1.idt.com ([157.165.5.25]:39667 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab0LJUps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:45:48 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2010 15:45:44 EST
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH -mm 1/4] RapidIO: Add definitions of Component Tag fields
Date: Fri, 10 Dec 2010 15:38:15 -0500
Message-Id: <1292013498-31406-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
References: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add definition of the unique device identifier field in the component tag.
RIO_CTAG_UDEVID does not take all 32 bits of the component tag value to
allow future extensions to the component tag use.

Selected size of the RIO_CTAG_UDEVID field (17 bits) is sufficient to accommodate
maximum number of endpoints in large RIO network (16-bit id) plus switches.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/rio.c |    2 +-
 include/linux/rio.h   |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index c13289e..cc2a3b7 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -710,7 +710,7 @@ int rio_inb_pwrite_handler(union rio_pw_msg *pw_msg)
 	u32 err_status, em_perrdet, em_ltlerrdet;
 	int rc, portnum;
 
-	rdev = rio_get_comptag(pw_msg->em.comptag, NULL);
+	rdev = rio_get_comptag((pw_msg->em.comptag & RIO_CTAG_UDEVID), NULL);
 	if (rdev == NULL) {
 		/* Device removed or enumeration error */
 		pr_debug("RIO: %s No matching device for CTag 0x%08x\n",
diff --git a/include/linux/rio.h b/include/linux/rio.h
index 9b55885..ff681eb 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -66,6 +66,16 @@
 
 #define RIO_PW_MSG_SIZE		64
 
+/*
+ * A component tag value (stored in the component tag CSR) is used as device's
+ * unique identifier assigned during enumeration. Besides being used for
+ * identifying switches (which do not have device ID register), it also is used
+ * by error management notification and therefore has to be assigned
+ * to endpoints as well.
+ */
+#define RIO_CTAG_RESRVD	0xfffe0000 /* Reserved */
+#define RIO_CTAG_UDEVID	0x0001ffff /* Unique device identifier */
+
 extern struct bus_type rio_bus_type;
 extern struct device rio_bus;
 extern struct list_head rio_devices;	/* list of all devices */
-- 
1.7.3.1

