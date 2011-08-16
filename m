Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1HPRwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:52:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63982 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1HPRw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:52:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110529142"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2 1/4] msm_serial: Use relative resources for iomem
Date: Tue, 16 Aug 2011 10:52:13 -0700
Message-Id: <1313517136-27414-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313517136-27414-1-git-send-email-davidb@codeaurora.org>
References: <1313517136-27414-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree iomem resources are only accessible by index, and not by
name.  The msm_serial devices always have either 1 or 2 iomem
resources, that are always in the same order.  Convert the
platform_get_resource_byname into just platform_get_resource to
facilitate device tree conversion.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index e6ba838..d9863b2 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -589,9 +589,8 @@ static void msm_release_port(struct uart_port *port)
 		iowrite32(GSBI_PROTOCOL_IDLE, msm_port->gsbi_base +
 			  GSBI_CONTROL);
 
-		gsbi_resource = platform_get_resource_byname(pdev,
-							     IORESOURCE_MEM,
-							     "gsbi_resource");
+		gsbi_resource = platform_get_resource(pdev,
+							IORESOURCE_MEM, 1);
 
 		if (unlikely(!gsbi_resource))
 			return;
@@ -612,8 +611,7 @@ static int msm_request_port(struct uart_port *port)
 	resource_size_t size;
 	int ret;
 
-	uart_resource = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						     "uart_resource");
+	uart_resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (unlikely(!uart_resource))
 		return -ENXIO;
 
@@ -628,8 +626,7 @@ static int msm_request_port(struct uart_port *port)
 		goto fail_release_port;
 	}
 
-	gsbi_resource = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						     "gsbi_resource");
+	gsbi_resource = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	/* Is this a GSBI-based port? */
 	if (gsbi_resource) {
 		size = resource_size(gsbi_resource);
@@ -875,7 +872,7 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	port->dev = &pdev->dev;
 	msm_port = UART_TO_MSM(port);
 
-	if (platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsbi_resource"))
+	if (platform_get_resource(pdev, IORESOURCE_MEM, 1))
 		msm_port->is_uartdm = 1;
 	else
 		msm_port->is_uartdm = 0;
@@ -899,8 +896,7 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	printk(KERN_INFO "uartclk = %d\n", port->uartclk);
 
 
-	resource = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						     "uart_resource");
+	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (unlikely(!resource))
 		return -ENXIO;
 	port->mapbase = resource->start;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

