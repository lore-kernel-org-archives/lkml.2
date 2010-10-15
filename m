Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0JOMzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:55:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56480 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab0JOMyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:54:10 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 4/7] drivers/power/wm97xx_battery.c: Return -ENOMEM on memory allocation failure
Date: Fri, 15 Oct 2010 15:00:07 +0200
Message-Id: <1287147610-8041-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this code, 0 is returned on memory allocation failure, even though other
failures return -ENOMEM or other similar values.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
expression x,e1,e2,e3;
@@

ret = 0
... when != ret = e1
*x = \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != ret = e2
if (x == NULL) { ... when != ret = e3
  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/power/wm97xx_battery.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -u -p a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -215,8 +215,10 @@ static int __devinit wm97xx_bat_probe(st
 		props++;	/* POWER_SUPPLY_PROP_VOLTAGE_MIN */
 
 	prop = kzalloc(props * sizeof(*prop), GFP_KERNEL);
-	if (!prop)
+	if (!prop) {
+		ret = -ENOMEM;
 		goto err3;
+	}
 
 	prop[i++] = POWER_SUPPLY_PROP_PRESENT;
 	if (pdata->charge_gpio >= 0)

