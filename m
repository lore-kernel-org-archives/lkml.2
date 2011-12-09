Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1LIWni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:43:38 -0500
Received: from claw.goop.org ([74.207.240.146]:35575 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1LIWnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:43:32 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Richard Hughes <richard@hughsie.com>
Subject: [PATCH RFC V2 1/4] power_supply: add SCOPE attribute to power supplies
Date: Fri,  9 Dec 2011 14:43:16 -0800
Message-Id: <25a0bc2dfc2ea732f40af2dae52426ead66ae76e.1323454016.git.jeremy@goop.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1323454016.git.jeremy@goop.org>
References: <cover.1323454016.git.jeremy@goop.org>
In-Reply-To: <cover.1323454016.git.jeremy@goop.org>
References: <cover.1323454016.git.jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a "scope" attribute to a power_supply, which indicates how
much of the system it powers.  It appears in sysfs as "scope" or in
the uevent file as POWER_SUPPLY_SCOPE=.  There are presently three
possible values:
	Unknown - unknown power topology
	System - the power supply powers the whole system
	Device - it powers a specific device, or tree of devices

A power supply which doesn't have a "scope" attribute should be assumed to
have "System" scope.

In general, usermode should assume that loss of all System-scoped power
supplies will power off the whole system, but any single one is sufficient
to power the system.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Richard Hughes <richard@hughsie.com>
---
 drivers/power/power_supply_sysfs.c |    6 ++++++
 include/linux/power_supply.h       |    7 +++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index e15d4c9..21178eb 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -63,6 +63,9 @@ static ssize_t power_supply_show_property(struct device *dev,
 	static char *capacity_level_text[] = {
 		"Unknown", "Critical", "Low", "Normal", "High", "Full"
 	};
+	static char *scope_text[] = {
+		"Unknown", "System", "Device"
+	};
 	ssize_t ret = 0;
 	struct power_supply *psy = dev_get_drvdata(dev);
 	const ptrdiff_t off = attr - power_supply_attrs;
@@ -95,6 +98,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 		return sprintf(buf, "%s\n", capacity_level_text[value.intval]);
 	else if (off == POWER_SUPPLY_PROP_TYPE)
 		return sprintf(buf, "%s\n", type_text[value.intval]);
+	else if (off == POWER_SUPPLY_PROP_SCOPE)
+		return sprintf(buf, "%s\n", scope_text[value.intval]);
 	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
 		return sprintf(buf, "%s\n", value.strval);
 
@@ -167,6 +172,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(time_to_full_now),
 	POWER_SUPPLY_ATTR(time_to_full_avg),
 	POWER_SUPPLY_ATTR(type),
+	POWER_SUPPLY_ATTR(scope),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 204c18d..040a7b0 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -74,6 +74,12 @@ enum {
 	POWER_SUPPLY_CAPACITY_LEVEL_FULL,
 };
 
+enum {
+	POWER_SUPPLY_SCOPE_UNKNOWN = 0,
+	POWER_SUPPLY_SCOPE_SYSTEM,
+	POWER_SUPPLY_SCOPE_DEVICE,
+};
+
 enum power_supply_property {
 	/* Properties of type `int' */
 	POWER_SUPPLY_PROP_STATUS = 0,
@@ -116,6 +122,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
 	POWER_SUPPLY_PROP_TYPE, /* use power_supply.type instead */
+	POWER_SUPPLY_PROP_SCOPE,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
-- 
1.7.7.3

