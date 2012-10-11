Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997Ab2JKTHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 15:07:21 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36138 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab2JKTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 15:04:10 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH v2 09/16] dmaengine: add dma_request_slave_channel_compat()
Date: Thu, 11 Oct 2012 15:04:34 -0400
Message-Id: <1349982281-10785-10-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349982281-10785-1-git-send-email-mporter@ti.com>
References: <1349982281-10785-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a dma_request_slave_channel_compat() wrapper which accepts
both the arguments from dma_request_channel() and
dma_request_slave_channel(). Based on whether the driver is
instantiated via DT, the appropriate channel request call will be
made.

This allows for a much cleaner migration of drivers to the
dmaengine DT API as platforms continue to be mixed between those
that boot using DT and those that do not.

Suggested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Matt Porter <mporter@ti.com>
---
 include/linux/dmaengine.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c88f302..11d9e25 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1007,6 +1007,16 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
 struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
 struct dma_chan *net_dma_find_channel(void);
 #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
+static inline struct dma_chan
+*dma_request_slave_channel_compat(dma_cap_mask_t mask, dma_filter_fn fn,
+				  void *fn_param, struct device *dev,
+				  char *name)
+{
+	if (dev->of_node)
+		return dma_request_slave_channel(dev, name);
+	else
+		return dma_request_channel(mask, fn, fn_param);
+}
 
 /* --- Helper iov-locking functions --- */
 
-- 
1.7.9.5

