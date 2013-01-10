Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3AJJ1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:27:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:43416 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3AJJYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:24:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="244528127"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 8/8] serial: 8250_dw: Enable DMA support with ACPI
Date: Thu, 10 Jan 2013 11:25:12 +0200
Message-Id: <1357809912-25790-9-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357809912-25790-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1357809912-25790-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With ACPI 5.0 we can use the FixedDMA Resource Descriptor to
extract the needed information for DMA support.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |   65 +++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index f6eeff0..ceacf5e 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -27,6 +27,8 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 
+#include "8250.h"
+
 /* Offsets for the DesignWare specific registers */
 #define DW_UART_USR	0x1f /* UART Status Register */
 #define DW_UART_CPR	0xf4 /* Component Parameter Register */
@@ -143,9 +145,64 @@ static int dw8250_probe_of(struct uart_port *p)
 	return 0;
 }
 
+static bool dw8250_acpi_dma_filter(struct dma_chan *chan, void *parm)
+{
+	return chan->chan_id == *(int *)parm;
+}
+
+static acpi_status
+dw8250_acpi_walk_resource(struct acpi_resource *res, void *data)
+{
+	struct uart_port		*p = data;
+	struct uart_8250_port		*port;
+	struct uart_8250_dma		*dma;
+	struct acpi_resource_fixed_dma	*fixed_dma;
+	struct dma_slave_config		*slave;
+
+	port = container_of(p, struct uart_8250_port, port);
+
+	switch (res->type) {
+	case ACPI_RESOURCE_TYPE_FIXED_DMA:
+		fixed_dma = &res->data.fixed_dma;
+
+		/* TX comes first */
+		if (!port->dma) {
+			dma = devm_kzalloc(p->dev, sizeof(*dma), GFP_KERNEL);
+			if (!dma)
+				return AE_NO_MEMORY;
+
+			port->dma = dma;
+			slave = &dma->txconf;
+
+			slave->direction	= DMA_MEM_TO_DEV;
+			slave->dst_addr_width	= DMA_SLAVE_BUSWIDTH_1_BYTE;
+			slave->slave_id		= fixed_dma->request_lines;
+
+			dma->tx_chan_id		= fixed_dma->channels;
+			dma->tx_param		= &dma->tx_chan_id;
+			dma->fn			= dw8250_acpi_dma_filter;
+		} else {
+			dma = port->dma;
+			slave = &dma->rxconf;
+
+			slave->direction	= DMA_DEV_TO_MEM;
+			slave->src_addr_width	= DMA_SLAVE_BUSWIDTH_1_BYTE;
+			slave->slave_id		= fixed_dma->request_lines;
+
+			dma->rx_chan_id		= fixed_dma->channels;
+			dma->rx_param		= &dma->rx_chan_id;
+		}
+
+		break;
+	}
+
+	return AE_OK;
+}
+
 static int dw8250_probe_acpi(struct uart_port *p)
 {
 	const struct acpi_device_id *id;
+	acpi_status status;
 	u32 reg;
 
 	id = acpi_match_device(p->dev->driver->acpi_match_table, p->dev);
@@ -158,6 +215,14 @@ static int dw8250_probe_acpi(struct uart_port *p)
 	p->regshift = 2;
 	p->uartclk = (unsigned int)id->driver_data;
 
+	status = acpi_walk_resources(ACPI_HANDLE(p->dev), METHOD_NAME__CRS,
+				     dw8250_acpi_walk_resource, p);
+	if (ACPI_FAILURE(status)) {
+		dev_err_ratelimited(p->dev, "%s failed \"%s\"\n", __func__,
+				    acpi_format_exception(status));
+		return -ENODEV;
+	}
+
 	/* Fix Haswell issue where the clocks do not get enabled */
 	if (!strcmp(id->id, "INT33C4") || !strcmp(id->id, "INT33C5")) {
 		reg = readl(p->membase + LPSS_PRV_CLOCK_PARAMS);
-- 
1.7.10.4

