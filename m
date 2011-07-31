Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1GaRxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:53:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab1GaRw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:52:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/9] PM / Domains: Make pm_genpd_poweron() always survive parent removal
Date: Sun, 31 Jul 2011 19:49:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
References: <201107311946.06654.rjw@sisk.pl>
In-Reply-To: <201107311946.06654.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107311949.12503.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If pm_genpd_remove_subdomain() is called to remove a PM domain's
subdomain and pm_genpd_poweron() is called for that subdomain at
the same time, and the pm_genpd_poweron() called by it recursively
for the parent returns an error, the first pm_genpd_poweron()'s
error code path will attempt to decrement the subdomain counter of
a PM domain that it's not a subdomain of any more.

Rearrange the code in pm_genpd_poweron() to prevent this from
happening.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -89,12 +89,14 @@ static void genpd_set_active(struct gene
  */
 int pm_genpd_poweron(struct generic_pm_domain *genpd)
 {
-	struct generic_pm_domain *parent = genpd->parent;
+	struct generic_pm_domain *parent;
 	int ret = 0;
 
- start:
 	mutex_lock(&genpd->lock);
 
+	parent = genpd->parent;
+
+ start:
 	if (genpd->status == GPD_STATE_ACTIVE
 	    || (genpd->prepared_count > 0 && genpd->suspend_power_off))
 		goto out;
@@ -110,29 +112,34 @@ int pm_genpd_poweron(struct generic_pm_d
 		mutex_unlock(&genpd->lock);
 
 		ret = pm_genpd_poweron(parent);
-		if (ret) {
-			genpd_sd_counter_dec(parent);
-			return ret;
-		}
+
+		mutex_lock(&genpd->lock);
+
+		if (ret)
+			goto err;
 
 		parent = NULL;
 		goto start;
 	}
 
-	if (genpd->power_on)
+	if (genpd->power_on) {
 		ret = genpd->power_on(genpd);
-
-	if (ret) {
-		if (genpd->parent)
-			genpd_sd_counter_dec(genpd->parent);
-	} else {
-		genpd_set_active(genpd);
+		if (ret)
+			goto err;
 	}
 
+	genpd_set_active(genpd);
+
  out:
 	mutex_unlock(&genpd->lock);
 
 	return ret;
+
+ err:
+	if (genpd->parent)
+		genpd_sd_counter_dec(genpd->parent);
+
+	goto out;
 }
 
 #endif /* CONFIG_PM */

