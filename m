Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab0G3RpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:45:04 -0400
Received: from kroah.org ([198.145.64.141]:36133 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438Ab0G3Rf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:13 2010
Message-Id: <20100730173113.259977401@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <daniel@caiaq.de>, Alagu Sankar <alagusankar@embwise.com>,
        Volker Ernst <volker.ernst@txtr.com>, Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Holger Schurig <hs4233@mail.mn-solutions.de>,
        Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [117/140] libertas/sdio: 8686: set ECSI bit for 1-bit transfers
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Mack <daniel@caiaq.de>

commit 8a64c0f6b7ec7f758c4ef445e49f479e27fa2236 upstream.

When operating in 1-bit mode, SDAT1 is used as dedicated interrupt line.
However, the 8686 will only drive this line when the ECSI bit is set in
the CCCR_IF register.

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
Acked-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/libertas/if_sdio.c |   22 ++++++++++++++++++++++
 include/linux/mmc/sdio.h                |    2 ++
 2 files changed, 24 insertions(+)

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
@@ -942,6 +944,7 @@ static int if_sdio_probe(struct sdio_fun
 	int ret, i;
 	unsigned int model;
 	struct if_sdio_packet *packet;
+	struct mmc_host *host = func->card->host;
 
 	lbs_deb_enter(LBS_DEB_SDIO);
 
@@ -1022,6 +1025,25 @@ static int if_sdio_probe(struct sdio_fun
 	if (ret)
 		goto disable;
 
+	/* For 1-bit transfers to the 8686 model, we need to enable the
+	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
+	 * bit to allow access to non-vendor registers. */
+	if ((card->model == IF_SDIO_MODEL_8686) &&
+	    (host->caps & MMC_CAP_SDIO_IRQ) &&
+	    (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
+		u8 reg;
+
+		func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
+		reg = sdio_f0_readb(func, SDIO_CCCR_IF, &ret);
+		if (ret)
+			goto release_int;
+
+		reg |= SDIO_BUS_ECSI;
+		sdio_f0_writeb(func, reg, SDIO_CCCR_IF, &ret);
+		if (ret)
+			goto release_int;
+	}
+
 	card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
 	if (ret)
 		goto release_int;
--- a/include/linux/mmc/sdio.h
+++ b/include/linux/mmc/sdio.h
@@ -94,6 +94,8 @@
 
 #define  SDIO_BUS_WIDTH_1BIT	0x00
 #define  SDIO_BUS_WIDTH_4BIT	0x02
+#define  SDIO_BUS_ECSI		0x20	/* Enable continuous SPI interrupt */
+#define  SDIO_BUS_SCSI		0x40	/* Support continuous SPI interrupt */
 
 #define  SDIO_BUS_CD_DISABLE     0x80	/* disable pull-up on DAT3 (pin 1) */
 


