Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2JWHak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:30:40 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59591 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2JWHaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:30:39 -0400
Date: Tue, 23 Oct 2012 00:30:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mischa Jonker <mischa.jonker@synopsys.com>
Cc: m.d.s.x.jonker@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, arc-linux-dev@synopsys.com
Subject: Re: [PATCH v4 1/1] Input: serio - Add ARC PS/2 driver
Message-ID: <20121023073033.GA19595@core.coreip.homeip.net>
References: <1350552538-24343-1-git-send-email-mischa.jonker@synopsys.com>
 <1350552538-24343-2-git-send-email-mischa.jonker@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350552538-24343-2-git-send-email-mischa.jonker@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:28:58AM +0200, Mischa Jonker wrote:
> This adds support for the PS/2 block that is used in various ARC FPGA
> platforms.

Applied with minor edits, please take a look at my 'next' branch and
holler if you see something wrong.

BTW, does the patch below work for you?

Thanks.

-- 
Dmitry


Input: arc_ps2 - switch to using managed resources

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

 drivers/input/serio/arc_ps2.c |  123 ++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 64 deletions(-)


diff --git a/drivers/input/serio/arc_ps2.c b/drivers/input/serio/arc_ps2.c
index f8c026a..89ad763 100644
--- a/drivers/input/serio/arc_ps2.c
+++ b/drivers/input/serio/arc_ps2.c
@@ -38,8 +38,6 @@ struct arc_ps2_port {
 
 struct arc_ps2_data {
 	struct arc_ps2_port port[ARC_PS2_PORTS];
-	struct resource *iomem_res;
-	int irq;
 	void __iomem *addr;
 	unsigned int frame_error;
 	unsigned int buf_overflow;
@@ -125,6 +123,32 @@ static void arc_ps2_close(struct serio *io)
 		  port->status_addr);
 }
 
+static void __iomem * __devinit arc_ps2_calc_addr(struct arc_ps2_data *arc_ps2,
+						  int index, bool status)
+{
+	void __iomem *addr;
+
+	addr = arc_ps2->addr + 4 + 4 * index;
+	if (status)
+		addr += ARC_PS2_PORTS * 4;
+
+	return addr;
+}
+
+static void __devinit arc_ps2_inhibit_ports(struct arc_ps2_data *arc_ps2)
+{
+	void __iomem *addr;
+	u32 val;
+	int i;
+
+	for (i = 0; i < ARC_PS2_PORTS; i++) {
+		addr = arc_ps2_calc_addr(arc_ps2, i, true);
+		val = ioread32(addr);
+		val &= ~(PS2_STAT_RX_INT_EN | PS2_STAT_TX_INT_EN);
+		iowrite32(val, addr);
+	}
+}
+
 static int __devinit arc_ps2_create_port(struct platform_device *pdev,
 					 struct arc_ps2_data *arc_ps2,
 					 int index)
@@ -146,8 +170,8 @@ static int __devinit arc_ps2_create_port(struct platform_device *pdev,
 
 	port->io = io;
 
-	port->data_addr = arc_ps2->addr + 4 + index * 4;
-	port->status_addr = arc_ps2->addr + 4 + ARC_PS2_PORTS * 4 + index * 4;
+	port->data_addr = arc_ps2_calc_addr(arc_ps2, index, false);
+	port->status_addr = arc_ps2_calc_addr(arc_ps2, index, true);
 
 	dev_dbg(&pdev->dev, "port%d is allocated (data = 0x%p, status = 0x%p)\n",
 		index, port->data_addr, port->status_addr);
@@ -159,85 +183,63 @@ static int __devinit arc_ps2_create_port(struct platform_device *pdev,
 static int __devinit arc_ps2_probe(struct platform_device *pdev)
 {
 	struct arc_ps2_data *arc_ps2;
+	struct resource *res;
+	int irq;
 	int error, id, i;
 
-	arc_ps2 = kzalloc(sizeof(struct arc_ps2_data), GFP_KERNEL);
-	if (!arc_ps2) {
-		dev_err(&pdev->dev, "out of memory\n");
-		return -ENOMEM;
-	}
-
-	arc_ps2->iomem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!arc_ps2->iomem_res) {
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
 		dev_err(&pdev->dev, "no IO memory defined\n");
-		error = -EINVAL;
-		goto err_free_mem;
+		return -EINVAL;
 	}
 
-	arc_ps2->irq = platform_get_irq_byname(pdev, "arc_ps2_irq");
-	if (arc_ps2->irq < 0) {
+	irq = platform_get_irq_byname(pdev, "arc_ps2_irq");
+	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ defined\n");
-		error = -EINVAL;
-		goto err_free_mem;
+		return -EINVAL;
 	}
 
-	if (!request_mem_region(arc_ps2->iomem_res->start,
-	    resource_size(arc_ps2->iomem_res), pdev->name)) {
-		dev_err(&pdev->dev, "memory region allocation failed for %pR\n",
-			arc_ps2->iomem_res);
-
-		error = -EBUSY;
-		goto err_free_mem;
+	arc_ps2 = devm_kzalloc(&pdev->dev, sizeof(struct arc_ps2_data),
+				GFP_KERNEL);
+	if (!arc_ps2) {
+		dev_err(&pdev->dev, "out of memory\n");
+		return -ENOMEM;
 	}
 
-	arc_ps2->addr = ioremap_nocache(arc_ps2->iomem_res->start,
-					resource_size(arc_ps2->iomem_res));
-	if (!arc_ps2->addr) {
-		dev_err(&pdev->dev, "memory mapping failed\n");
-		error = -ENOMEM;
-		goto err_release_region;
-	}
+	arc_ps2->addr = devm_request_and_ioremap(&pdev->dev, res);
+	if (!arc_ps2->addr)
+		return -EBUSY;
 
 	dev_info(&pdev->dev, "irq = %d, address = 0x%p, ports = %i\n",
-		 arc_ps2->irq, arc_ps2->addr, ARC_PS2_PORTS);
+		 irq, arc_ps2->addr, ARC_PS2_PORTS);
 
 	id = ioread32(arc_ps2->addr);
 	if (id != ARC_ARC_PS2_ID) {
 		dev_err(&pdev->dev, "device id does not match\n");
-		error = -ENXIO;
-		goto err_unmap;
+		return -ENXIO;
 	}
 
-	for (i = 0; i < ARC_PS2_PORTS; i++) {
-		error = arc_ps2_create_port(pdev, arc_ps2, i);
-		if (error)
-			goto err_unregister_ports;
-	}
+	arc_ps2_inhibit_ports(arc_ps2);
 
-	error = request_irq(arc_ps2->irq, arc_ps2_interrupt, 0,
-			    "arc_ps2", arc_ps2);
+	error = devm_request_irq(&pdev->dev, irq, arc_ps2_interrupt,
+				 0, "arc_ps2", arc_ps2);
 	if (error) {
 		dev_err(&pdev->dev, "Could not allocate IRQ\n");
-		goto err_unregister_ports;
+		return error;
+	}
+
+	for (i = 0; i < ARC_PS2_PORTS; i++) {
+		error = arc_ps2_create_port(pdev, arc_ps2, i);
+		if (error) {
+			while (--i >= 0)
+				serio_unregister_port(arc_ps2->port[i].io);
+			return error;
+		}
 	}
 
 	platform_set_drvdata(pdev, arc_ps2);
 
 	return 0;
-
-err_unregister_ports:
-	for (i = 0; i < ARC_PS2_PORTS; i++) {
-		if (arc_ps2->port[i].io)
-			serio_unregister_port(arc_ps2->port[i].io);
-	}
-err_unmap:
-	iounmap(arc_ps2->addr);
-err_release_region:
-	release_mem_region(arc_ps2->iomem_res->start,
-			   resource_size(arc_ps2->iomem_res));
-err_free_mem:
-	kfree(arc_ps2);
-	return error;
 }
 
 static int __devexit arc_ps2_remove(struct platform_device *pdev)
@@ -248,18 +250,11 @@ static int __devexit arc_ps2_remove(struct platform_device *pdev)
 	for (i = 0; i < ARC_PS2_PORTS; i++)
 		serio_unregister_port(arc_ps2->port[i].io);
 
-	free_irq(arc_ps2->irq, arc_ps2);
-	iounmap(arc_ps2->addr);
-	release_mem_region(arc_ps2->iomem_res->start,
-			   resource_size(arc_ps2->iomem_res));
-
 	dev_dbg(&pdev->dev, "interrupt count = %i\n", arc_ps2->total_int);
 	dev_dbg(&pdev->dev, "frame error count = %i\n", arc_ps2->frame_error);
 	dev_dbg(&pdev->dev, "buffer overflow count = %i\n",
 		arc_ps2->buf_overflow);
 
-	kfree(arc_ps2);
-
 	return 0;
 }
 
