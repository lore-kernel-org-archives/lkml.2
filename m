Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2HFXLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:11:19 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44950 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab2HFXLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:11:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 4/12] PM / Domains: Make it possible to use names when adding subdomains
Date: Tue, 7 Aug 2012 01:08:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201208070105.23262.rjw@sisk.pl>
In-Reply-To: <201208070105.23262.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208070108.38081.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a new helper function, pm_genpd_add_subdomain_names(), allowing
the caller to add a subdomain to a generic PM domain using names for
domain identification (both domains have to be initialized before).

This function is useful for adding subdomains to PM domains whose
representations are stored in tables, when the caller doesn't know
the indices of the domain to add the subdomain to and of the
subdomain itself, but it knows the domains' names.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   32 +++++++++++++++++++++++++++++++-
 include/linux/pm_domain.h   |    7 +++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -1584,7 +1584,8 @@ int pm_genpd_add_subdomain(struct generi
 	struct gpd_link *link;
 	int ret = 0;
 
-	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(subdomain))
+	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(subdomain)
+	    || genpd == subdomain)
 		return -EINVAL;
 
  start:
@@ -1631,6 +1632,35 @@ int pm_genpd_add_subdomain(struct generi
 }
 
 /**
+ * pm_genpd_add_subdomain_names - Add a subdomain to an I/O PM domain.
+ * @master_name: Name of the master PM domain to add the subdomain to.
+ * @subdomain_name: Name of the subdomain to be added.
+ */
+int pm_genpd_add_subdomain_names(const char *master_name,
+				 const char *subdomain_name)
+{
+	struct generic_pm_domain *master = NULL, *subdomain = NULL, *gpd;
+
+	if (IS_ERR_OR_NULL(master_name) || IS_ERR_OR_NULL(subdomain_name))
+		return -EINVAL;
+
+	mutex_lock(&gpd_list_lock);
+	list_for_each_entry(gpd, &gpd_list, gpd_list_node) {
+		if (!master && !strcmp(gpd->name, master_name))
+			master = gpd;
+
+		if (!subdomain && !strcmp(gpd->name, subdomain_name))
+			subdomain = gpd;
+
+		if (master && subdomain)
+			break;
+	}
+	mutex_unlock(&gpd_list_lock);
+
+	return pm_genpd_add_subdomain(master, subdomain);
+}
+
+/**
  * pm_genpd_remove_subdomain - Remove a subdomain from an I/O PM domain.
  * @genpd: Master PM domain to remove the subdomain from.
  * @subdomain: Subdomain to be removed.
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -147,6 +147,8 @@ extern int pm_genpd_remove_device(struct
 extern void pm_genpd_dev_need_restore(struct device *dev, bool val);
 extern int pm_genpd_add_subdomain(struct generic_pm_domain *genpd,
 				  struct generic_pm_domain *new_subdomain);
+extern int pm_genpd_add_subdomain_names(const char *master_name,
+					const char *subdomain_name);
 extern int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
 				     struct generic_pm_domain *target);
 extern int pm_genpd_add_callbacks(struct device *dev,
@@ -201,6 +203,11 @@ static inline int pm_genpd_add_subdomain
 {
 	return -ENOSYS;
 }
+static inline int pm_genpd_add_subdomain_names(const char *master_name,
+					       const char *subdomain_name)
+{
+	return -ENOSYS;
+}
 static inline int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
 					    struct generic_pm_domain *target)
 {

