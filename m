Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0C3Rjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:39:45 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:55007 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0C3Rjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:39:43 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Alagu Sankar <alagusankar@embwise.com>,
       Volker Ernst <volker.ernst@txtr.com>, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH] libertas/sdio: set ECSI and SCSI bits for 1-bit transfers
Date: Tue, 30 Mar 2010 19:38:53 +0200
Message-Id: <1269970733-24681-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When operating in 1-bit mode, SDAT1 is used as dedicated interrupt line.
However, the 8686 will only drive this line when the ECSI and SCSI bits
are set in the CCCR_IF register.

Thanks to Alagu Sankar for pointing me in the right direction.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Alagu Sankar <alagusankar@embwise.com>
Cc: Volker Ernst <volker.ernst@txtr.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: linux-mmc@vger.kernel.org
---
 drivers/net/wireless/libertas/if_sdio.c |   24 ++++++++++++++++++++++++
 include/linux/mmc/sdio.h                |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 7a73f62..d3170f2 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -34,6 +34,8 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/host.h>
 
 #include "host.h"
 #include "decl.h"
@@ -942,6 +944,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	int ret, i;
 	unsigned int model;
 	struct if_sdio_packet *packet;
+	struct mmc_host *host = func->card->host;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
@@ -1022,6 +1025,27 @@ static int if_sdio_probe(struct sdio_func *func,
 	if (ret)
 		goto disable;
 
+	/* For 1-bit transfers, we need to enable the interrupt flags in
+	 * the CCCR register. Temporarily set the function number to 0
+	 * for that. */
+	if ((host->caps & MMC_CAP_SDIO_IRQ) &&
+	    (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
+		unsigned int num = func->num;
+		u8 reg;
+
+		func->num = 0;
+		reg = sdio_readb(func, SDIO_CCCR_IF, &ret);
+		if (ret)
+			goto release_int;
+
+		reg |= SDIO_BUS_ECSI | SDIO_BUS_SCSI;
+		sdio_writeb(func, reg, SDIO_CCCR_IF, &ret);
+		if (ret)
+			goto release_int;
+
+		func->num = num;
+	}
+
 	card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
 	if (ret)
 		goto release_int;
diff --git a/include/linux/mmc/sdio.h b/include/linux/mmc/sdio.h
index 0ebaef5..329a8fa 100644
--- a/include/linux/mmc/sdio.h
+++ b/include/linux/mmc/sdio.h
@@ -94,6 +94,8 @@
 
 #define  SDIO_BUS_WIDTH_1BIT	0x00
 #define  SDIO_BUS_WIDTH_4BIT	0x02
+#define  SDIO_BUS_ECSI		0x20	/* Enable continuous SPI interrupt */
+#define  SDIO_BUS_SCSI		0x40	/* Support continuous SPI interrupt */
 
 #define  SDIO_BUS_ASYNC_INT	0x20
 
-- 
1.7.0

