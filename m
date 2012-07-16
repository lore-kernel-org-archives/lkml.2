Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2GPVbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:31:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43068 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2GPV2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:28:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 13/14] PM / Domains: Introduce pm_genpd_present()
Date: Mon, 16 Jul 2012 23:30:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Linux-sh list" <linux-sh@vger.kernel.org>
References: <201207032302.17805.rjw@sisk.pl> <201207052217.48086.rjw@sisk.pl> <201207162315.49073.rjw@sisk.pl>
In-Reply-To: <201207162315.49073.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207162331.00295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce function pm_genpd_present() allowing the caller to check if
the given generic PM domain has been initialized.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   22 ++++++++++++++++++++++
 include/linux/pm_domain.h   |    5 +++++
 2 files changed, 27 insertions(+)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -2089,3 +2089,25 @@ void pm_genpd_init(struct generic_pm_dom
 	list_add(&genpd->gpd_list_node, &gpd_list);
 	mutex_unlock(&gpd_list_lock);
 }
+
+/**
+ * pm_genpd_present - Check if the given PM domain has been initialized
+ * @genpd: PM domain to check.
+ */
+bool pm_genpd_present(struct generic_pm_domain *genpd)
+{
+	struct generic_pm_domain *gpd = NULL;
+
+	if (IS_ERR_OR_NULL(genpd))
+		return false;
+
+	mutex_lock(&gpd_list_lock);
+
+	list_for_each_entry(gpd, &gpd_list, gpd_list_node)
+		if (gpd == genpd)
+			break;
+
+	mutex_unlock(&gpd_list_lock);
+
+	return gpd == genpd;
+}
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -161,6 +161,7 @@ extern int genpd_attach_cpuidle(struct g
 extern int genpd_detach_cpuidle(struct generic_pm_domain *genpd);
 extern void pm_genpd_init(struct generic_pm_domain *genpd,
 			  struct dev_power_governor *gov, bool is_off);
+extern bool pm_genpd_present(struct generic_pm_domain *genpd);
 
 extern int pm_genpd_poweron(struct generic_pm_domain *genpd);
 extern int pm_genpd_name_poweron(const char *domain_name);
@@ -239,6 +240,10 @@ static inline void pm_genpd_init(struct
 				 struct dev_power_governor *gov, bool is_off)
 {
 }
+static inline bool pm_genpd_present(struct generic_pm_domain *genpd)
+{
+	return false;
+}
 static inline int pm_genpd_poweron(struct generic_pm_domain *genpd)
 {
 	return -ENOSYS;

