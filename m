Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab0EDRgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:36:41 -0400
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:43102 "EHLO
	relay1-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab0EDRgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:36:39 -0400
X-Greylist: delayed 1789 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2010 13:36:39 EDT
X-Originating-IP: 217.70.178.45
X-Originating-IP: 82.8.179.104
Subject: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 04 May 2010 18:36:34 +0100
Message-ID: <1272994594.13354.215.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.0.1 (2.30.0-3.fc13) 
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
 drivers/input/serio/i8042.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index d84a36e..2be7207 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1438,12 +1438,30 @@ static struct platform_driver i8042_driver = {
 	.shutdown	= i8042_shutdown,
 };
 
+static struct dmi_system_id __initdata dmi_system_table[] = {
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
 static int __init i8042_init(void)
 {
 	int err;
 
 	dbg_init();
 
+	/* Intel Apple Macs never have an i8042 controller */
+	if (dmi_check_system(dmi_system_table) > 0)
+		return -ENODEV;
+
 	err = i8042_platform_init();
 	if (err)
 		return err;
-- 
1.6.6



