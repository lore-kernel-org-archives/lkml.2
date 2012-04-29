Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2D2BK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 21:10:56 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43751 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab2D2BKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 21:10:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/3] PM / Domains: Make device removal more straightforward
Date: Sun, 29 Apr 2012 03:12:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
References: <201204272346.44145.rjw@sisk.pl> <201204290308.52416.rjw@sisk.pl>
In-Reply-To: <201204290308.52416.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204290312.34612.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The removal of a device from a PM domain doesn't have to browse
the domain's device list, because it can check directly if the
device belongs to the given domain.  Moreover, it should clear
the domain_data pointer in dev->power.subsys_data, because
dev_pm_put_subsys_data(dev) may not remove dev->power.subsys_data
and the stale domain data pointer may cause problems to happen.

Rework pm_genpd_remove_device() taking the above observations into
account.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -1279,11 +1279,13 @@ int pm_genpd_remove_device(struct generi
 			   struct device *dev)
 {
 	struct pm_domain_data *pdd;
-	int ret = -EINVAL;
+	int ret = 0;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
+	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev)
+	    ||  IS_ERR_OR_NULL(dev->pm_domain)
+	    ||  pd_to_genpd(dev->pm_domain) != genpd)
 		return -EINVAL;
 
 	genpd_acquire_lock(genpd);
@@ -1293,21 +1295,14 @@ int pm_genpd_remove_device(struct generi
 		goto out;
 	}
 
-	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
-		if (pdd->dev != dev)
-			continue;
-
-		list_del_init(&pdd->list_node);
-		pdd->dev = NULL;
-		dev_pm_put_subsys_data(dev);
-		dev->pm_domain = NULL;
-		kfree(to_gpd_data(pdd));
+	dev->pm_domain = NULL;
+	pdd = dev->power.subsys_data->domain_data;
+	list_del_init(&pdd->list_node);
+	dev->power.subsys_data->domain_data = NULL;
+	dev_pm_put_subsys_data(dev);
+	kfree(to_gpd_data(pdd));
 
-		genpd->device_count--;
-
-		ret = 0;
-		break;
-	}
+	genpd->device_count--;
 
  out:
 	genpd_release_lock(genpd);

