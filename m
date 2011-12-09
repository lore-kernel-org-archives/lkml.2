Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1LIWnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:43:35 -0500
Received: from claw.goop.org ([74.207.240.146]:35574 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab1LIWnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:43:32 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH RFC V2 3/4] power_supply: add scope properties to some self-powered HID devices
Date: Fri,  9 Dec 2011 14:43:18 -0800
Message-Id: <73db88137bc732d01b615af9a9cdb24f3e47e78d.1323454016.git.jeremy@goop.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1323454016.git.jeremy@goop.org>
References: <cover.1323454016.git.jeremy@goop.org>
In-Reply-To: <cover.1323454016.git.jeremy@goop.org>
References: <cover.1323454016.git.jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Wacom and Wiimote HID drivers register power supplies for themselves
to indicate their battery levels.  Make those power supplies device scope.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-wacom.c   |   12 ++++++++++--
 drivers/hid/hid-wiimote.c |    8 +++++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 17bb88f..ad39777 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -47,12 +47,14 @@ static unsigned short batcap[8] = { 1, 15, 25, 35, 50, 70, 100, 0 };
 
 static enum power_supply_property wacom_battery_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
-	POWER_SUPPLY_PROP_CAPACITY
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_SCOPE,
 };
 
 static enum power_supply_property wacom_ac_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
-	POWER_SUPPLY_PROP_ONLINE
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_SCOPE,
 };
 
 static int wacom_battery_get_property(struct power_supply *psy,
@@ -68,6 +70,9 @@ static int wacom_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = 1;
 		break;
+	case POWER_SUPPLY_PROP_SCOPE:
+		val->intval = POWER_SUPPLY_SCOPE_DEVICE;
+		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		/* show 100% battery capacity when charging */
 		if (power_state == 0)
@@ -99,6 +104,9 @@ static int wacom_ac_get_property(struct power_supply *psy,
 		else
 			val->intval = 0;
 		break;
+	case POWER_SUPPLY_PROP_SCOPE:
+		val->intval = POWER_SUPPLY_SCOPE_DEVICE;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/drivers/hid/hid-wiimote.c b/drivers/hid/hid-wiimote.c
index 76739c0..98e4828 100644
--- a/drivers/hid/hid-wiimote.c
+++ b/drivers/hid/hid-wiimote.c
@@ -136,7 +136,8 @@ static __u16 wiiproto_keymap[] = {
 };
 
 static enum power_supply_property wiimote_battery_props[] = {
-	POWER_SUPPLY_PROP_CAPACITY
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_SCOPE,
 };
 
 /* requires the state.lock spinlock to be held */
@@ -468,6 +469,11 @@ static int wiimote_battery_get_property(struct power_supply *psy,
 	int ret = 0, state;
 	unsigned long flags;
 
+	if (psp == POWER_SUPPLY_PROP_SCOPE) {
+		val->intval = POWER_SUPPLY_SCOPE_DEVICE;
+		return 0;
+	}
+
 	ret = wiimote_cmd_acquire(wdata);
 	if (ret)
 		return ret;
-- 
1.7.7.3

