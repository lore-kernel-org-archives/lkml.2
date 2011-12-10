Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab1LJVxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 16:53:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1LJVxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 16:53:42 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: Suse Linux
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] power: Assume mains power by default
Date: Sat, 10 Dec 2011 22:53:36 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32.46-0.3-pae; KDE/4.3.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Alex Deucher <alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112102253.36940.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no power class device is found in power_supply_is_system_supplied(),
the function currently returns 0, which basically means that the system
is supposed to be running on battery. In practice, mobile devices tend
to always implement at least one power class device and more often two
(battery and AC adapter). Systems with no registered power class
devices are more likely to be desktop systems, where the system is
always powered by mains.

So, change the default return value of
power_supply_is_system_supplied() from 0 (running on battery) to 1
(running on mains.)

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
---
If anyone thinks that returning 1 in this case could cause problems
on some systems, I would be fine returning an error code instead.
Callers would then have to be adjusted accordingly.

Alex, with this change the "auto" power profile of the radeon driver
should finally work fine on all desktop systems (which could then
become the default?)

 drivers/power/power_supply_core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- linux-3.2-rc4.orig/drivers/power/power_supply_core.c	2011-07-22 04:17:23.000000000 +0200
+++ linux-3.2-rc4/drivers/power/power_supply_core.c	2011-12-10 10:04:52.000000000 +0100
@@ -98,7 +98,9 @@ static int __power_supply_is_system_supp
 {
 	union power_supply_propval ret = {0,};
 	struct power_supply *psy = dev_get_drvdata(dev);
+	unsigned int *count = data;
 
+	(*count)++;
 	if (psy->type != POWER_SUPPLY_TYPE_BATTERY) {
 		if (psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &ret))
 			return 0;
@@ -111,10 +113,18 @@ static int __power_supply_is_system_supp
 int power_supply_is_system_supplied(void)
 {
 	int error;
+	unsigned int count = 0;
 
-	error = class_for_each_device(power_supply_class, NULL, NULL,
+	error = class_for_each_device(power_supply_class, NULL, &count,
 				      __power_supply_is_system_supplied);
 
+	/*
+	 * If no power class device was found at all, most probably we are
+	 * running on a desktop system, so assume we are on mains power.
+	 */
+	if (count == 0)
+		return 1;
+
 	return error;
 }
 EXPORT_SYMBOL_GPL(power_supply_is_system_supplied);

-- 
Jean Delvare
Suse L3
