Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab0I2FxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:53:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0I2FxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:53:16 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, edgar.iglesias@gmail.com, duyl@xilinx.com,
        linnj@xilinx.com, grant.likely@secretlab.ca,
        microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 3/7] of: Fix uart16550 initialization on little-endian systems
Date: Wed, 29 Sep 2010 15:52:14 +1000
Message-Id: <1285739538-29058-4-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1285739538-29058-3-git-send-email-monstr@monstr.eu>
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
 <1285739538-29058-2-git-send-email-monstr@monstr.eu>
 <1285739538-29058-3-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert values from big-endian to cpu-endian.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: "David S. Miller" <davem@davemloft.net>
CC: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
CC: devicetree-discuss@lists.ozlabs.org
---
 drivers/serial/of_serial.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
index 2af8fd1..0e4d894 100644
--- a/drivers/serial/of_serial.c
+++ b/drivers/serial/of_serial.c
@@ -31,17 +31,19 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 {
 	struct resource resource;
 	struct device_node *np = ofdev->dev.of_node;
-	const unsigned int *clk, *spd;
+	const unsigned int *spd;
+	unsigned int clk;
 	const u32 *prop;
 	int ret, prop_size;
 
 	memset(port, 0, sizeof *port);
 	spd = of_get_property(np, "current-speed", NULL);
-	clk = of_get_property(np, "clock-frequency", NULL);
-	if (!clk) {
+	prop = of_get_property(np, "clock-frequency", NULL);
+	if (!prop) {
 		dev_warn(&ofdev->dev, "no clock-frequency property set\n");
 		return -ENODEV;
 	}
+	clk = be32_to_cpup(prop);
 
 	ret = of_address_to_resource(np, 0, &resource);
 	if (ret) {
@@ -55,23 +57,24 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 	/* Check for shifted address mapping */
 	prop = of_get_property(np, "reg-offset", &prop_size);
 	if (prop && (prop_size == sizeof(u32)))
-		port->mapbase += *prop;
+		port->mapbase += be32_to_cpup(prop);
 
 	/* Check for registers offset within the devices address range */
 	prop = of_get_property(np, "reg-shift", &prop_size);
 	if (prop && (prop_size == sizeof(u32)))
-		port->regshift = *prop;
+		port->regshift = be32_to_cpup(prop);
 
 	port->irq = irq_of_parse_and_map(np, 0);
 	port->iotype = UPIO_MEM;
 	port->type = type;
-	port->uartclk = *clk;
+	port->uartclk = clk;
 	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
 		| UPF_FIXED_PORT | UPF_FIXED_TYPE;
 	port->dev = &ofdev->dev;
+
 	/* If current-speed was set, then try not to change it. */
 	if (spd)
-		port->custom_divisor = *clk / (16 * (*spd));
+		port->custom_divisor = clk / (16 * be32_to_cpup(spd));
 
 	return 0;
 }
-- 
1.5.5.1

