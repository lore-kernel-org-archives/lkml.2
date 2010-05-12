Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab0ELXzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:55:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:57222 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751261Ab0ELXy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:54:59 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19C+C9UpMJCwKRdd2LKLIj1RnjTJOaFKhh/GmB0uu
	i3PDq0CX+p1SEt
From: Peter Huewe <PeterHuewe@gmx.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [PATCH] power: Rename get_current to fix build failure / name conflict
Date: Thu, 13 May 2010 01:54:57 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Mike Rapoport <mike@compulab.co.il>, Wolfram Sang <w.sang@pengutronix.de>,
       Tejun Heo <tj@kernel.org>, Ryan Mallon <ryan@bluewatersys.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005130154.58459.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch changes the name of get_current function pointer to
get_battery_current to resolve a name conflict with the get_current
macro defined in current.h.

This conflict resulted in a build-failure[1] for the sh4 arch
allyesconfig which is resolved by this patch.

To be consistent the other function pointers (_voltage,_capacity) were
renamed too.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next 20100512
References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2572665/

 drivers/power/ds2782_battery.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index d762a0c..9b3b4b7 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -43,10 +43,9 @@
 struct ds278x_info;
 
 struct ds278x_battery_ops {
-	int	(*get_current)(struct ds278x_info *info, int *current_uA);
-	int	(*get_voltage)(struct ds278x_info *info, int *voltage_uA);
-	int	(*get_capacity)(struct ds278x_info *info, int *capacity_uA);
-
+	int (*get_battery_current)(struct ds278x_info *info, int *current_uA);
+	int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uA);
+	int (*get_battery_capacity)(struct ds278x_info *info, int *capacity_uA);
 };
 
 #define to_ds278x_info(x) container_of(x, struct ds278x_info, battery)
@@ -213,11 +212,11 @@ static int ds278x_get_status(struct ds278x_info *info, int *status)
 	int current_uA;
 	int capacity;
 
-	err = info->ops->get_current(info, &current_uA);
+	err = info->ops->get_battery_current(info, &current_uA);
 	if (err)
 		return err;
 
-	err = info->ops->get_capacity(info, &capacity);
+	err = info->ops->get_battery_capacity(info, &capacity);
 	if (err)
 		return err;
 
@@ -246,15 +245,15 @@ static int ds278x_battery_get_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_CAPACITY:
-		ret = info->ops->get_capacity(info, &val->intval);
+		ret = info->ops->get_battery_capacity(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		ret = info->ops->get_voltage(info, &val->intval);
+		ret = info->ops->get_battery_voltage(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		ret = info->ops->get_current(info, &val->intval);
+		ret = info->ops->get_battery_current(info, &val->intval);
 		break;
 
 	case POWER_SUPPLY_PROP_TEMP:
@@ -307,14 +306,14 @@ enum ds278x_num_id {
 
 static struct ds278x_battery_ops ds278x_ops[] = {
 	[DS2782] = {
-		.get_current  = ds2782_get_current,
-		.get_voltage  = ds2782_get_voltage,
-		.get_capacity = ds2782_get_capacity,
+		.get_battery_current  = ds2782_get_current,
+		.get_battery_voltage  = ds2782_get_voltage,
+		.get_battery_capacity = ds2782_get_capacity,
 	},
 	[DS2786] = {
-		.get_current  = ds2786_get_current,
-		.get_voltage  = ds2786_get_voltage,
-		.get_capacity = ds2786_get_capacity,
+		.get_battery_current  = ds2786_get_current,
+		.get_battery_voltage  = ds2786_get_voltage,
+		.get_battery_capacity = ds2786_get_capacity,
 	}
 };
 
-- 
1.6.4.4

