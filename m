Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2CKKyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 06:54:36 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:44820 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752723Ab2CKKyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 06:54:31 -0400
From: Roland Stigge <stigge@antcom.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v7 4/4] USB: ohci-nxp: Remove i2c_write(), use smbus
Date: Sun, 11 Mar 2012 11:53:39 +0100
Message-Id: <1331463219-23293-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331463219-23293-1-git-send-email-stigge@antcom.de>
References: <1331463219-23293-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the re-coded i2c_write function from the ohci-nxp driver
in favour of using just smbus functions.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/usb/host/ohci-nxp.c |   58 ++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- linux-2.6.orig/drivers/usb/host/ohci-nxp.c
+++ linux-2.6/drivers/usb/host/ohci-nxp.c
@@ -151,38 +151,36 @@ static struct i2c_driver isp1301_driver
 	.id_table = isp1301_id,
 };
 
-static void i2c_write(u8 buf, u8 subaddr)
-{
-	char tmpbuf[2];
-
-	tmpbuf[0] = subaddr;	/*register number */
-	tmpbuf[1] = buf;	/*register data */
-	i2c_master_send(isp1301_i2c_client, &tmpbuf[0], 2);
-}
-
 static void isp1301_configure_pnx4008(void)
 {
 	/* PNX4008 only supports DAT_SE0 USB mode */
 	/* PNX4008 R2A requires setting the MAX603 to output 3.6V */
 	/* Power up externel charge-pump */
 
-	i2c_write(MC1_DAT_SE0 | MC1_SPEED_REG, ISP1301_I2C_MODE_CONTROL_1);
-	i2c_write(~(MC1_DAT_SE0 | MC1_SPEED_REG),
-		  ISP1301_I2C_MODE_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR);
-	i2c_write(MC2_BI_DI | MC2_PSW_EN | MC2_SPD_SUSP_CTRL,
-		  ISP1301_I2C_MODE_CONTROL_2);
-	i2c_write(~(MC2_BI_DI | MC2_PSW_EN | MC2_SPD_SUSP_CTRL),
-		  ISP1301_I2C_MODE_CONTROL_2 | ISP1301_I2C_REG_CLEAR_ADDR);
-	i2c_write(OTG1_DM_PULLDOWN | OTG1_DP_PULLDOWN,
-		  ISP1301_I2C_OTG_CONTROL_1);
-	i2c_write(~(OTG1_DM_PULLDOWN | OTG1_DP_PULLDOWN),
-		  ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR);
-	i2c_write(0xFF,
-		  ISP1301_I2C_INTERRUPT_LATCH | ISP1301_I2C_REG_CLEAR_ADDR);
-	i2c_write(0xFF,
-		  ISP1301_I2C_INTERRUPT_FALLING | ISP1301_I2C_REG_CLEAR_ADDR);
-	i2c_write(0xFF,
-		  ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_MODE_CONTROL_1, MC1_DAT_SE0 | MC1_SPEED_REG);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_MODE_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR,
+		~(MC1_DAT_SE0 | MC1_SPEED_REG));
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_MODE_CONTROL_2,
+		MC2_BI_DI | MC2_PSW_EN | MC2_SPD_SUSP_CTRL);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_MODE_CONTROL_2 | ISP1301_I2C_REG_CLEAR_ADDR,
+		~(MC2_BI_DI | MC2_PSW_EN | MC2_SPD_SUSP_CTRL));
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_OTG_CONTROL_1, OTG1_DM_PULLDOWN | OTG1_DP_PULLDOWN);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR,
+		~(OTG1_DM_PULLDOWN | OTG1_DP_PULLDOWN));
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_INTERRUPT_LATCH | ISP1301_I2C_REG_CLEAR_ADDR, 0xFF);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_INTERRUPT_FALLING | ISP1301_I2C_REG_CLEAR_ADDR,
+		0xFF);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR,
+		0xFF);
 }
 
 static void isp1301_configure_lpc32xx(void)
@@ -244,13 +242,15 @@ static void isp1301_configure(void)
 
 static inline void isp1301_vbus_on(void)
 {
-	i2c_write(OTG1_VBUS_DRV, ISP1301_I2C_OTG_CONTROL_1);
+	i2c_smbus_write_byte_data(isp1301_i2c_client, ISP1301_I2C_OTG_CONTROL_1,
+				  OTG1_VBUS_DRV);
 }
 
 static inline void isp1301_vbus_off(void)
 {
-	i2c_write(OTG1_VBUS_DRV,
-		  ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR,
+		OTG1_VBUS_DRV);
 }
 
 static void nxp_start_hc(void)
