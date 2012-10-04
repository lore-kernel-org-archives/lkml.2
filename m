Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2JDKkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:40:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50052 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab2JDKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:40:00 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] serial: i.MX: evaluate linux,stdout-path property
Date: Thu,  4 Oct 2012 12:39:51 +0200
Message-Id: <1349347191-7406-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devicetrees may have the linux,stdout-path property to specify the
console. This patch adds support to the i.MX serial driver for this.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

I was originally looking for a more generic way to handle this, but
since a struct console has no device associated to it, it's not
possible to match a console with a device in a generic way. So we
just call add_preferred_console from the driver and let it go down
to a string matching in the console code.
If anyone has a better idea how to handle this, please let me know.
Otherwise I'm happy to see this patch applied aswell.

Thanks
 Sascha

 drivers/tty/serial/imx.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index e309e8b..b52c4a7 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1397,6 +1397,32 @@ static int serial_imx_resume(struct platform_device *dev)
 
 #ifdef CONFIG_OF
 /*
+ * Check if this device matches the linux,stdout-path property
+ * in the chosen node. return true if yes, false otherwise
+ */
+static int serial_imx_is_stdoutpath(struct platform_device *pdev)
+{
+	struct device_node *dn;
+	const char *name;
+
+	if (!IS_ENABLED(CONFIG_SERIAL_IMX_CONSOLE))
+		return 0;
+
+	name = of_get_property(of_chosen, "linux,stdout-path", NULL);
+	if (name == NULL)
+		return 0;
+
+	dn = of_find_node_by_path(name);
+	if (!dn)
+		return 0;
+
+	if (dn == pdev->dev.of_node)
+		return 1;
+
+	return 0;
+}
+
+/*
  * This function returns 1 iff pdev isn't a device instatiated by dt, 0 iff it
  * could successfully get all information from dt or a negative errno.
  */
@@ -1427,6 +1453,9 @@ static int serial_imx_probe_dt(struct imx_port *sport,
 
 	sport->devdata = of_id->data;
 
+	if (serial_imx_is_stdoutpath(pdev))
+		add_preferred_console(imx_reg.cons->name, sport->port.line, 0);
+
 	return 0;
 }
 #else
-- 
1.7.10.4

