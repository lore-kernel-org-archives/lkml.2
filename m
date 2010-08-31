Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab0HaPuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:50:06 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44544 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab0HaPsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:48:47 -0400
From: Julia Lawall <julia@diku.dk>
To: Timur Tabi <timur@freescale.com>
Cc: kernel-janitors@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/4] drivers/serial/ucc_uart.c: Add of_node_put to avoid memory leak
Date: Tue, 31 Aug 2010 17:48:55 +0200
Message-Id: <1283269738-14612-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283269738-14612-1-git-send-email-julia@diku.dk>
References: <1283269738-14612-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a call to of_node_put in the error handling code following a call to
of_find_compatible_node or of_find_node_by_type.

This patch also substantially reorganizes the error handling code in the
function, to that it is possible first to jump to code that frees qe_port
and then to jump to code that also puts np.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E,E1,E2;
statement S;
@@

*x = 
(of_find_node_by_path
|of_find_node_by_name
|of_find_node_by_phandle
|of_get_parent
|of_get_next_parent
|of_get_next_child
|of_find_compatible_node
|of_match_node
|of_find_node_by_type
|of_find_node_with_property
|of_find_matching_node
|of_parse_phandle
)(...);
...
if (x == NULL) S
<... when != x = E
*if (...) {
  ... when != of_node_put(x)
      when != if (...) { ... of_node_put(x); ... }
(
  return <+...x...+>;
|
*  return ...;
)
}
...>
(
E2 = x;
|
of_node_put(x);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/ucc_uart.c |   67 ++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 3f4848e..38a5ef0 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -1270,13 +1270,12 @@ static int ucc_uart_probe(struct platform_device *ofdev,
 	ret = of_address_to_resource(np, 0, &res);
 	if (ret) {
 		dev_err(&ofdev->dev, "missing 'reg' property in device tree\n");
-		kfree(qe_port);
-		return ret;
+		goto out_free;
 	}
 	if (!res.start) {
 		dev_err(&ofdev->dev, "invalid 'reg' property in device tree\n");
-		kfree(qe_port);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_free;
 	}
 	qe_port->port.mapbase = res.start;
 
@@ -1286,17 +1285,17 @@ static int ucc_uart_probe(struct platform_device *ofdev,
 	if (!iprop) {
 		iprop = of_get_property(np, "device-id", NULL);
 		if (!iprop) {
-			kfree(qe_port);
 			dev_err(&ofdev->dev, "UCC is unspecified in "
 				"device tree\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_free;
 		}
 	}
 
 	if ((*iprop < 1) || (*iprop > UCC_MAX_NUM)) {
 		dev_err(&ofdev->dev, "no support for UCC%u\n", *iprop);
-		kfree(qe_port);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free;
 	}
 	qe_port->ucc_num = *iprop - 1;
 
@@ -1310,16 +1309,16 @@ static int ucc_uart_probe(struct platform_device *ofdev,
 	sprop = of_get_property(np, "rx-clock-name", NULL);
 	if (!sprop) {
 		dev_err(&ofdev->dev, "missing rx-clock-name in device tree\n");
-		kfree(qe_port);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free;
 	}
 
 	qe_port->us_info.rx_clock = qe_clock_source(sprop);
 	if ((qe_port->us_info.rx_clock < QE_BRG1) ||
 	    (qe_port->us_info.rx_clock > QE_BRG16)) {
 		dev_err(&ofdev->dev, "rx-clock-name must be a BRG for UART\n");
-		kfree(qe_port);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free;
 	}
 
 #ifdef LOOPBACK
@@ -1329,39 +1328,39 @@ static int ucc_uart_probe(struct platform_device *ofdev,
 	sprop = of_get_property(np, "tx-clock-name", NULL);
 	if (!sprop) {
 		dev_err(&ofdev->dev, "missing tx-clock-name in device tree\n");
-		kfree(qe_port);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free;
 	}
 	qe_port->us_info.tx_clock = qe_clock_source(sprop);
 #endif
 	if ((qe_port->us_info.tx_clock < QE_BRG1) ||
 	    (qe_port->us_info.tx_clock > QE_BRG16)) {
 		dev_err(&ofdev->dev, "tx-clock-name must be a BRG for UART\n");
-		kfree(qe_port);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free;
 	}
 
 	/* Get the port number, numbered 0-3 */
 	iprop = of_get_property(np, "port-number", NULL);
 	if (!iprop) {
 		dev_err(&ofdev->dev, "missing port-number in device tree\n");
-		kfree(qe_port);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_free;
 	}
 	qe_port->port.line = *iprop;
 	if (qe_port->port.line >= UCC_MAX_UART) {
 		dev_err(&ofdev->dev, "port-number must be 0-%u\n",
 			UCC_MAX_UART - 1);
-		kfree(qe_port);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_free;
 	}
 
 	qe_port->port.irq = irq_of_parse_and_map(np, 0);
 	if (qe_port->port.irq == NO_IRQ) {
 		dev_err(&ofdev->dev, "could not map IRQ for UCC%u\n",
 		       qe_port->ucc_num + 1);
-		kfree(qe_port);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_free;
 	}
 
 	/*
@@ -1373,8 +1372,8 @@ static int ucc_uart_probe(struct platform_device *ofdev,
 		np = of_find_node_by_type(NULL, "qe");
 		if (!np) {
 			dev_err(&ofdev->dev, "could not find 'qe' node\n");
-			kfree(qe_port);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_free;
 		}
 	}
 
@@ -1382,8 +1381,8 @@ static int ucc_uart_probe(struct platform_device *ofdev,
 	if (!iprop) {
 		dev_err(&ofdev->dev,
 		       "missing brg-frequency in device tree\n");
-		kfree(qe_port);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_np;
 	}
 
 	if (*iprop)
@@ -1398,16 +1397,16 @@ static int ucc_uart_probe(struct platform_device *ofdev,
 		if (!iprop) {
 			dev_err(&ofdev->dev,
 				"missing QE bus-frequency in device tree\n");
-			kfree(qe_port);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_np;
 		}
 		if (*iprop)
 			qe_port->port.uartclk = *iprop / 2;
 		else {
 			dev_err(&ofdev->dev,
 				"invalid QE bus-frequency in device tree\n");
-			kfree(qe_port);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_np;
 		}
 	}
 
@@ -1445,8 +1444,7 @@ static int ucc_uart_probe(struct platform_device *ofdev,
 	if (ret) {
 		dev_err(&ofdev->dev, "could not add /dev/ttyQE%u\n",
 		       qe_port->port.line);
-		kfree(qe_port);
-		return ret;
+		goto out_np;
 	}
 
 	dev_set_drvdata(&ofdev->dev, qe_port);
@@ -1460,6 +1458,11 @@ static int ucc_uart_probe(struct platform_device *ofdev,
 	       SERIAL_QE_MINOR + qe_port->port.line);
 
 	return 0;
+out_np:
+	of_node_put(np);
+out_free:
+	kfree(qe_port);
+	return ret;
 }
 
 static int ucc_uart_remove(struct platform_device *ofdev)

