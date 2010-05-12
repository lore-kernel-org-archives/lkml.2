Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0ELALj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:11:39 -0400
Received: from relay4-v.mail.gandi.net ([217.70.178.78]:59515 "EHLO
	relay4-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0ELALi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:11:38 -0400
X-Originating-IP: 217.70.178.40
X-Originating-IP: 82.8.179.104
Subject: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 01:11:23 +0100
Message-ID: <1273623083.2314.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As those computers never had any i8042 controllers, and the
current lookup code could potentially lock up/hang/wait for
timeout for long periods of time.

Fixes intermittent hangs on boot on a MacbookAir1,1

Signed-off-by: Bastien Nocera <hadess@hadess.net>
---
 drivers/input/serio/i8042-x86ia64io.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index ead0494..e859902 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -479,6 +479,22 @@ static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
 	{ }
 };
 
+/* Intel Apple Macs never have an i8042 controller,
+ * so we shouldn't even try to probe for it */
+static const struct dmi_system_id __initconst i8042_dmi_no_probe_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Apple Computer, Inc.")
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Apple Inc.")
+		},
+	},
+	{}
+};
+
 #ifdef CONFIG_PNP
 static const struct dmi_system_id __initconst i8042_dmi_nopnp_table[] = {
 	{
@@ -833,6 +849,8 @@ static int __init i8042_platform_init(void)
  *	if (!request_region(I8042_DATA_REG, 16, "i8042"))
  *		return -EBUSY;
  */
+	if (dmi_check_system(i8042_dmi_no_probe_table))
+		return -ENODEV;
 
 	i8042_kbd_irq = I8042_MAP_IRQ(1);
 	i8042_aux_irq = I8042_MAP_IRQ(12);
-- 
1.7.0.1


