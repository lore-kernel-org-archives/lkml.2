Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0JVX4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:56:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0JVXy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=drfnk8r9YIS4cHHTX7X4eVX4h43EHmXqKHmXovkHW0gd7qGKLo3fBoVeB0rgQ8aWKk
         QCMz7o1GLqseEUjhbT51CFiwcw0HMGLrHJzJJB8VLVvXcwEaTRWaWhV2mZi+ZWeCiVKq
         wZ/845ux3PbMC2iyZvKTlTs7wdZeXQtY2ksKk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 26/29] memstick: jmb38x_ms: rework hardware setup/reset
Date: Sat, 23 Oct 2010 01:53:54 +0200
Message-Id: <1287791637-10329-27-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code into functions.
Reset clock on init - fixes serial mode

Signed-off-by: Maxim Levitsky<maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |  205 +++++++++++++++++++------------------
 drivers/memstick/host/jmb38x_ms.h |   11 +-
 2 files changed, 108 insertions(+), 108 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 725b485..86c003a 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -551,131 +551,132 @@ static void j38ms_next_request(struct j38ms_host *host)
 			return;
 }
 
-
 /* hardware reset */
-static int j38ms_reset(struct j38ms_host *host)
+static int j38ms_reset(struct j38ms_host *host, u32 reset_bit)
 {
-	int cnt;
-
-	writel(HOST_CONTROL_RESET_REQ | HOST_CONTROL_CLOCK_EN
-	       | readl(host->addr + HOST_CONTROL),
-	       host->addr + HOST_CONTROL);
-	mmiowb();
-
-	for (cnt = 0; cnt < 20; ++cnt) {
-		if (!(HOST_CONTROL_RESET_REQ
-		      & readl(host->addr + HOST_CONTROL)))
-			goto reset_next;
+	int i;
+	j38ms_set_reg_mask(host,
+			HOST_CONTROL, reset_bit | HOST_CONTROL_CLOCK_EN);
 
+	for (i = 0; i < 20; ++i) {
+		if (!(j38ms_read_reg(host, HOST_CONTROL) & reset_bit))
+			break;
 		ndelay(20);
 	}
-	dev_dbg(&host->chip->pdev->dev, "reset_req timeout\n");
-	/* return -EIO; */
+	return (j38ms_read_reg(host, HOST_CONTROL) & reset_bit) ? EIO : 0;
+}
+
+/* Enable/disable the device */
+static int j38ms_power_device(struct j38ms_host *host, bool enable)
+{
+	int error;
 
-reset_next:
-	writel(HOST_CONTROL_RESET | HOST_CONTROL_CLOCK_EN
-	       | readl(host->addr + HOST_CONTROL),
-	       host->addr + HOST_CONTROL);
-	mmiowb();
+	if (enable) {
 
-	for (cnt = 0; cnt < 20; ++cnt) {
-		if (!(HOST_CONTROL_RESET
-		      & readl(host->addr + HOST_CONTROL)))
-			goto reset_ok;
+		error = j38ms_reset(host, HOST_CONTROL_RESET_REQ);
+		error = j38ms_reset(host, HOST_CONTROL_RESET);
+
+		if (error)
+			return error;
+
+		j38ms_write_reg(host, INT_SIGNAL_ENABLE, INT_STATUS_ALL);
+		j38ms_write_reg(host, INT_STATUS_ENABLE, INT_STATUS_ALL);
+		j38ms_write_reg(host, CLOCK_CONTROL, CLOCK_CONTROL_RESET);
+
+		j38ms_write_reg(host, HOST_CONTROL,
+			HOST_CONTROL_POWER_EN |
+			HOST_CONTROL_CLOCK_EN |
+			HOST_CONTROL_HW_OC_P |
+			HOST_CONTROL_TDELAY_EN |
+			HOST_CONTROL_BSY_TIME);
+
+		j38ms_write_reg(host, PAD_PU_PD, host->id ?
+			PAD_PU_PD_ON_MS_SOCK1 : PAD_PU_PD_ON_MS_SOCK0);
+
+		j38ms_write_reg(host, PAD_OUTPUT_ENABLE, PAD_OUTPUT_ENABLE_MS);
+
+	} else {
+		j38ms_clear_reg_mask(host, HOST_CONTROL,
+			HOST_CONTROL_POWER_EN | HOST_CONTROL_CLOCK_EN);
+		j38ms_write_reg(host, PAD_OUTPUT_ENABLE, 0);
+		j38ms_write_reg(host, PAD_PU_PD, PAD_PU_PD_OFF);
+		j38ms_write_reg(host, CLOCK_CONTROL, CLOCK_CONTROL_OFF);
 
-		ndelay(20);
 	}
-	dev_dbg(&host->chip->pdev->dev, "reset timeout\n");
-	return -EIO;
+	msleep(100);
+	return 0;
+}
 
-reset_ok:
-	mmiowb();
-	writel(INT_STATUS_ALL, host->addr + INT_SIGNAL_ENABLE);
-	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
+/* Switch interface */
+static int j38ms_set_interface(struct j38ms_host *host, int interface)
+{
+	u32 host_ctl = j38ms_read_reg(host, HOST_CONTROL);
+	u32 clock_ctl = CLOCK_CONTROL_40MHZ;
+	u32 clock_delay;
+
+	host_ctl &= ~HOST_CONTROL_IF_MASK;
+	pci_read_config_dword(host->chip->pdev, PCI_CTL_CLOCK_DLY_ADDR,
+				&clock_delay);
+
+	clock_delay &= host->id ? ~PCI_CTL_CLOCK_DLY_MASK_B
+				: ~PCI_CTL_CLOCK_DLY_MASK_A;
+
+	if (interface == MEMSTICK_SERIAL) {
+
+		host_ctl |= HOST_CONTROL_IF_SERIAL;
+		clock_ctl = CLOCK_CONTROL_40MHZ;
+
+		host_ctl &= ~HOST_CONTROL_FAST_CLK;
+		host_ctl &= ~HOST_CONTROL_REO;
+		host_ctl |= HOST_CONTROL_REI;
+
+	} else if (interface == MEMSTICK_PAR4) {
+
+		host_ctl |= HOST_CONTROL_IF_PAR4;
+		clock_ctl = CLOCK_CONTROL_40MHZ;
+
+		host_ctl |= HOST_CONTROL_FAST_CLK;
+		host_ctl |= HOST_CONTROL_REO;
+		host_ctl &= ~HOST_CONTROL_REI;
+
+		clock_delay |= host->id ? (4 << 12) : (4 << 8);
+
+	} else if (interface == MEMSTICK_PAR8) {
+
+		host_ctl |= HOST_CONTROL_IF_PAR8;
+		clock_ctl = CLOCK_CONTROL_50MHZ;
+
+		host_ctl |= HOST_CONTROL_FAST_CLK;
+		host_ctl &= ~HOST_CONTROL_REO;
+		host_ctl &= ~HOST_CONTROL_REI;
+	} else
+		return -EINVAL;
+
+	j38ms_write_reg(host, HOST_CONTROL, host_ctl);
+	j38ms_write_reg(host, CLOCK_CONTROL, clock_ctl);
+
+	pci_write_config_dword(host->chip->pdev,
+		PCI_CTL_CLOCK_DLY_ADDR, clock_delay);
+
+	host->interface = interface;
 	return 0;
 }
 
+/* external interface: control hardware settings */
 static int j38ms_set_param(struct memstick_host *msh,
 			       enum memstick_param param,
 			       int value)
 {
 	struct j38ms_host *host = memstick_priv(msh);
-	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
-	unsigned int clock_ctl = CLOCK_CONTROL_40MHZ, clock_delay = 0;
-	int rc = 0;
 
 	switch (param) {
 	case MEMSTICK_POWER:
-		if (value == MEMSTICK_POWER_ON) {
-			rc = j38ms_reset(host);
-			if (rc)
-				return rc;
-
-			host_ctl = 7;
-			host_ctl |= HOST_CONTROL_POWER_EN
-				    | HOST_CONTROL_CLOCK_EN
-				    | HOST_CONTROL_HW_OC_P
-				    | HOST_CONTROL_TDELAY_EN;
-			writel(host_ctl, host->addr + HOST_CONTROL);
-
-			writel(host->id ? PAD_PU_PD_ON_MS_SOCK1
-					: PAD_PU_PD_ON_MS_SOCK0,
-			       host->addr + PAD_PU_PD);
-
-			writel(PAD_OUTPUT_ENABLE_MS,
-			       host->addr + PAD_OUTPUT_ENABLE);
-
-			msleep(10);
-			dev_dbg(&host->chip->pdev->dev, "power on\n");
-		} else if (value == MEMSTICK_POWER_OFF) {
-			host_ctl &= ~(HOST_CONTROL_POWER_EN
-				      | HOST_CONTROL_CLOCK_EN);
-			writel(host_ctl, host->addr +  HOST_CONTROL);
-			writel(0, host->addr + PAD_OUTPUT_ENABLE);
-			writel(PAD_PU_PD_OFF, host->addr + PAD_PU_PD);
-			dev_dbg(&host->chip->pdev->dev, "power off\n");
-		} else
-			return -EINVAL;
-		break;
+		return j38ms_power_device(host, (value == MEMSTICK_POWER_ON));
 	case MEMSTICK_INTERFACE:
-		host_ctl &= ~(3 << HOST_CONTROL_IF_SHIFT);
-		pci_read_config_dword(host->chip->pdev,
-				      PCI_CTL_CLOCK_DLY_ADDR,
-				      &clock_delay);
-		clock_delay &= host->id ? ~PCI_CTL_CLOCK_DLY_MASK_B
-					: ~PCI_CTL_CLOCK_DLY_MASK_A;
-
-		if (value == MEMSTICK_SERIAL) {
-			host_ctl &= ~HOST_CONTROL_FAST_CLK;
-			host_ctl &= ~HOST_CONTROL_REO;
-			host_ctl |= HOST_CONTROL_IF_SERIAL
-				    << HOST_CONTROL_IF_SHIFT;
-			host_ctl |= HOST_CONTROL_REI;
-			clock_ctl = CLOCK_CONTROL_40MHZ;
-		} else if (value == MEMSTICK_PAR4) {
-			host_ctl |= HOST_CONTROL_FAST_CLK | HOST_CONTROL_REO;
-			host_ctl |= HOST_CONTROL_IF_PAR4
-				    << HOST_CONTROL_IF_SHIFT;
-			host_ctl &= ~HOST_CONTROL_REI;
-			clock_ctl = CLOCK_CONTROL_40MHZ;
-			clock_delay |= host->id ? (4 << 12) : (4 << 8);
-		} else if (value == MEMSTICK_PAR8) {
-			host_ctl |= HOST_CONTROL_FAST_CLK;
-			host_ctl |= HOST_CONTROL_IF_PAR8
-				    << HOST_CONTROL_IF_SHIFT;
-			host_ctl &= ~(HOST_CONTROL_REI | HOST_CONTROL_REO);
-			clock_ctl = CLOCK_CONTROL_50MHZ;
-		} else
-			return -EINVAL;
-
-		writel(host_ctl, host->addr + HOST_CONTROL);
-		writel(clock_ctl, host->addr + CLOCK_CONTROL);
-		pci_write_config_dword(host->chip->pdev,
-				       PCI_CTL_CLOCK_DLY_ADDR,
-				       clock_delay);
-		break;
+		return j38ms_set_interface(host, value);
+	default:
+		return -EINVAL;
 	};
-	return 0;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
index 5d7ad18..4ece074 100644
--- a/drivers/memstick/host/jmb38x_ms.h
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -48,15 +48,13 @@
 #define HOST_CONTROL_FAST_CLK   0x00000200
 #define HOST_CONTROL_RESET      0x00000100
 #define HOST_CONTROL_POWER_EN   0x00000080
+#define HOST_CONTROL_IF_PAR4    0x00000010
+#define HOST_CONTROL_IF_PAR8    0x00000030
+#define HOST_CONTROL_IF_MASK    0x00000030
 #define HOST_CONTROL_CLOCK_EN   0x00000040
 #define HOST_CONTROL_REO        0x00000008
 #define HOST_CONTROL_BSY_TIME	0x00000007
-
-#define HOST_CONTROL_IF_SHIFT  4
-#define HOST_CONTROL_IF_SERIAL 0x0
-#define HOST_CONTROL_IF_PAR4   0x1
-#define HOST_CONTROL_IF_PAR8   0x3
-
+#define HOST_CONTROL_IF_SERIAL  0x00000000
 
 /* IO window for PIO access to internal FIFO*/
 #define	DATA                   0x1c
@@ -156,6 +154,7 @@ struct j38ms_host {
 	struct timer_list       timer;
 	struct memstick_request *req;
 	unsigned char           cmd_flags;
+	int                     interface;
 
 	/* PIO state */
 	struct sg_mapping_iter  pio_sg_iter;
-- 
1.7.1

