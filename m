Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0LFUfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:35:08 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:55076 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172Ab0LFUfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:35:06 -0500
From: Daniel Drake <dsd@laptop.org>
To: cbou@mail.ru
To: dwmw2@infradead.org
Cc: pgf@laptop.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] power_supply: allow control of attribute visibility
Message-Id: <20101206203501.9D8BE9D401B@zog.reactivated.net>
Date: Mon,  6 Dec 2010 20:35:01 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=X0sWjjQ37bMP4yB/pNNinY3VxVB2n/hmdAjhihaCFGs= c=1 sm=0 a=fgPuYRNnNckA:10 a=Op-mwl0xAAAA:8 a=Y-KqmgIGl8z7dHC3RUUA:9 a=hXBSHGH_gfqlONEEsbhB6BmdvSAA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A power supply driver could support a certain attribute that is not
available at runtime (e.g. because the specific host doesn't support
that functionality).

Add a mechanism for power supplies to be able to specify this.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/power/power_supply_sysfs.c |    4 ++++
 include/linux/power_supply.h       |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index cd1f907..8df9e4c 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -191,6 +191,10 @@ static mode_t power_supply_attr_is_visible(struct kobject *kobj,
 		int property = psy->properties[i];
 
 		if (property == attrno) {
+			if (psy->property_is_available &&
+			    !psy->property_is_available(psy, property))
+				return 0;
+
 			if (psy->property_is_writeable &&
 			    psy->property_is_writeable(psy, property) > 0)
 				mode |= S_IWUSR;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 7d73256..b481458 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -152,6 +152,8 @@ struct power_supply {
 	int (*set_property)(struct power_supply *psy,
 			    enum power_supply_property psp,
 			    const union power_supply_propval *val);
+	bool (*property_is_available)(struct power_supply *psy,
+				      enum power_supply_property psp);
 	int (*property_is_writeable)(struct power_supply *psy,
 				     enum power_supply_property psp);
 	void (*external_power_changed)(struct power_supply *psy);
-- 
1.7.3.2

