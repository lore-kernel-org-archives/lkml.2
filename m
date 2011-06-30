Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1F3TAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:00:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64900 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1F3TAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:00:37 -0400
Subject: [PATCH] tty/serial: change of_serial to use new
 of_property_read_u32() api
To: devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 30 Jun 2011 13:00:33 -0600
Message-ID: <20110630185921.13784.3823.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplifies the code a bit and drops a few lines.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

I've only actually build tested this, but this shows some of the cleanup
achieved using the of_property_read_u32() API.  If this gets merged in the
v3.1 merge window then it will need to go via the devicetree/next branch.

g.

 drivers/tty/serial/of_serial.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 36038ed..dbfbfda 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -32,17 +32,17 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 {
 	struct resource resource;
 	struct device_node *np = ofdev->dev.of_node;
-	const __be32 *clk, *spd;
-	const __be32 *prop;
-	int ret, prop_size;
+	u32 clk, spd, prop;
+	int ret;
 
 	memset(port, 0, sizeof *port);
-	spd = of_get_property(np, "current-speed", NULL);
-	clk = of_get_property(np, "clock-frequency", NULL);
-	if (!clk) {
+	if (of_property_read_u32(np, "clock-frequency", &clk)) {
 		dev_warn(&ofdev->dev, "no clock-frequency property set\n");
 		return -ENODEV;
 	}
+	/* If current-speed was set, then try not to change it. */
+	if (of_property_read_u32(np, "current-speed", &spd) == 0)
+		port->custom_divisor = clk / (16 * spd);
 
 	ret = of_address_to_resource(np, 0, &resource);
 	if (ret) {
@@ -54,20 +54,17 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 	port->mapbase = resource.start;
 
 	/* Check for shifted address mapping */
-	prop = of_get_property(np, "reg-offset", &prop_size);
-	if (prop && (prop_size == sizeof(u32)))
-		port->mapbase += be32_to_cpup(prop);
+	if (of_property_read_u32(np, "reg-offset", &prop) == 0)
+		port->mapbase += prop;
 
 	/* Check for registers offset within the devices address range */
-	prop = of_get_property(np, "reg-shift", &prop_size);
-	if (prop && (prop_size == sizeof(u32)))
-		port->regshift = be32_to_cpup(prop);
+	if (of_property_read_u32(np, "reg-shift", &prop) == 0)
+		port->regshift = prop;
 
 	port->irq = irq_of_parse_and_map(np, 0);
 	port->iotype = UPIO_MEM;
-	prop = of_get_property(np, "reg-io-width", &prop_size);
-	if (prop && (prop_size == sizeof(u32))) {
-		switch (be32_to_cpup(prop)) {
+	if (of_property_read_u32(np, "reg-io-width", &prop) == 0) {
+		switch (prop) {
 		case 1:
 			port->iotype = UPIO_MEM;
 			break;
@@ -75,21 +72,17 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 			port->iotype = UPIO_MEM32;
 			break;
 		default:
-			dev_warn(&ofdev->dev,
-				 "unsupported io width (%d bytes)\n",
-				 be32_to_cpup(prop));
+			dev_warn(&ofdev->dev, "unsupported reg-io-width (%d)\n",
+				 prop);
 			return -EINVAL;
 		}
 	}
 
 	port->type = type;
-	port->uartclk = be32_to_cpup(clk);
+	port->uartclk = clk;
 	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
 		| UPF_FIXED_PORT | UPF_FIXED_TYPE;
 	port->dev = &ofdev->dev;
-	/* If current-speed was set, then try not to change it. */
-	if (spd)
-		port->custom_divisor = be32_to_cpup(clk) / (16 * (be32_to_cpup(spd)));
 
 	return 0;
 }

