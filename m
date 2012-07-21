Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2GUVv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 17:51:28 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50974 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab2GUVvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 17:51:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 5/5] PM / shmobile: Allow device latencies to be read from a DT
Date: Sat, 21 Jul 2012 23:56:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
References: <201207212349.18294.rjw@sisk.pl>
In-Reply-To: <201207212349.18294.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207212356.28513.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify rmobile_read_domain_from_dt() so that it can read device
latency information from the device tree along with the PM
domain name and make it use rmobile_add_device_to_domain_td()
for adding the device to the PM domain along with the device latency
data.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-rmobile.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

Index: linux/arch/arm/mach-shmobile/pm-rmobile.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-rmobile.c
+++ linux/arch/arm/mach-shmobile/pm-rmobile.c
@@ -170,14 +170,34 @@ void rmobile_add_device_to_domain_td(con
 
 static void rmobile_read_domain_from_dt(struct device *dev)
 {
+	struct gpd_timing_data latencies = { 0 };
 	const char *domain_name;
+	u64 val;
 	int ret;
 
 	ret = of_property_read_string(dev->of_node, "renesas,pmdomain",
 				      &domain_name);
+	if (ret)
+		return;
+
+	ret = of_property_read_u64(dev->of_node, "pm-stop-latency", &val);
+	if (!ret)
+		latencies.stop_latency_ns = val;
+
+	ret = of_property_read_u64(dev->of_node, "pm-start-latency", &val);
+	if (!ret)
+		latencies.start_latency_ns = val;
+
+	ret = of_property_read_u64(dev->of_node, "pm-save-latency", &val);
+	if (!ret)
+		latencies.save_state_latency_ns = val;
+
+	ret = of_property_read_u64(dev->of_node, "pm-restore-latency", &val);
 	if (!ret)
-		rmobile_add_device_to_domain(domain_name,
-					     to_platform_device(dev));
+		latencies.restore_state_latency_ns = val;
+
+	rmobile_add_device_to_domain_td(domain_name, to_platform_device(dev),
+					&latencies);
 }
 
 static void rmobile_remove_from_domain(struct device *dev)

