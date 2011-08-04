Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1HDKaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:30:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45427 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1HDKaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:30:30 -0400
Subject: [PATCH] dt: remove of_alias_get_id() reference
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Shawn Guo <shawn.guo@linaro.org>
Date: Thu, 04 Aug 2011 11:30:27 +0100
Message-ID: <20110804102950.10845.67898.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_alias_get_id() is broken and being reverted.  Remove the reference
to it and replace with a single incrementing id number.

There is no risk of regression here on the imx driver since the imx
change to use of_alias_get_id() is commit 22698aa2, "serial/imx: add
device tree probe support" which is new for v3.1, and it won't get
used unless CONFIG_OF is enabled and the board is booted using a
device tree.  A single incrementing integer is sufficient for now.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---

I'm about to ask Linus to pull this patch through the devicetree/merge
branch along with the of_alias revert.

 drivers/tty/serial/imx.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 827db76..7e91b3d 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1286,22 +1286,17 @@ static int serial_imx_resume(struct platform_device *dev)
 static int serial_imx_probe_dt(struct imx_port *sport,
 		struct platform_device *pdev)
 {
+	static int portnum = 0;
 	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *of_id =
 			of_match_device(imx_uart_dt_ids, &pdev->dev);
-	int ret;
 
 	if (!np)
 		return -ENODEV;
 
-	ret = of_alias_get_id(np, "serial");
-	if (ret < 0) {
-		pr_err("%s: failed to get alias id, errno %d\n",
-			__func__, ret);
-		return -ENODEV;
-	} else {
-		sport->port.line = ret;
-	}
+	sport->port.line = portnum++;
+	if (sport->port.line >= UART_NR)
+		return -EINVAL;
 
 	if (of_get_property(np, "fsl,uart-has-rtscts", NULL))
 		sport->have_rtscts = 1;

