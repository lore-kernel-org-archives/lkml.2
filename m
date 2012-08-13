Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab2HMWSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:18:38 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36943 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab2HMWSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:18:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/3] PM / Domains: Add operations related to cpuidle using domain names
Date: Tue, 14 Aug 2012 00:23:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201208140019.19288.rjw@sisk.pl>
In-Reply-To: <201208140019.19288.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208140023.49263.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make it possible to use domain names in operations connecting cpuidle
to and disconnecting it from a PM domain.  This is useful on
platforms where PM domain objects are organized in such a way that
the names of the domains are easier to use than the addresses of
those objects.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   19 +++++++++++++++++++
 include/linux/pm_domain.h   |   10 ++++++++++
 2 files changed, 29 insertions(+)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -1888,6 +1888,16 @@ int pm_genpd_attach_cpuidle(struct gener
 }
 
 /**
+ * pm_genpd_name_attach_cpuidle - Find PM domain and connect cpuidle to it.
+ * @name: Name of the domain to connect to cpuidle.
+ * @state: cpuidle state this domain can manipulate.
+ */
+int pm_genpd_name_attach_cpuidle(const char *name, int state)
+{
+	return pm_genpd_attach_cpuidle(pm_genpd_lookup_name(name), state);
+}
+
+/**
  * pm_genpd_detach_cpuidle - Remove the cpuidle connection from a PM domain.
  * @genpd: PM domain to remove the cpuidle connection from.
  *
@@ -1925,6 +1935,15 @@ int pm_genpd_detach_cpuidle(struct gener
 	return ret;
 }
 
+/**
+ * pm_genpd_name_detach_cpuidle - Find PM domain and disconnect cpuidle from it.
+ * @name: Name of the domain to disconnect cpuidle from.
+ */
+int pm_genpd_name_detach_cpuidle(const char *name)
+{
+	return pm_genpd_detach_cpuidle(pm_genpd_lookup_name(name));
+}
+
 /* Default device callbacks for generic PM domains. */
 
 /**
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -156,7 +156,9 @@ extern int pm_genpd_add_callbacks(struct
 				  struct gpd_timing_data *td);
 extern int __pm_genpd_remove_callbacks(struct device *dev, bool clear_td);
 extern int pm_genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state);
+extern int pm_genpd_name_attach_cpuidle(const char *name, int state);
 extern int pm_genpd_detach_cpuidle(struct generic_pm_domain *genpd);
+extern int pm_genpd_name_detach_cpuidle(const char *name);
 extern void pm_genpd_init(struct generic_pm_domain *genpd,
 			  struct dev_power_governor *gov, bool is_off);
 
@@ -229,10 +231,18 @@ static inline int pm_genpd_attach_cpuidl
 {
 	return -ENOSYS;
 }
+static inline int pm_genpd_name_attach_cpuidle(const char *name, int state)
+{
+	return -ENOSYS;
+}
 static inline int pm_genpd_detach_cpuidle(struct generic_pm_domain *genpd)
 {
 	return -ENOSYS;
 }
+static inline int pm_genpd_name_detach_cpuidle(const char *name)
+{
+	return -ENOSYS;
+}
 static inline void pm_genpd_init(struct generic_pm_domain *genpd,
 				 struct dev_power_governor *gov, bool is_off)
 {

