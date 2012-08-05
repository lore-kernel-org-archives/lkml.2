Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2HEXts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:49:48 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43004 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab2HEXtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:49:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 11/15] PM / Domains: Do not measure start time for "irq safe" devices
Date: Mon, 6 Aug 2012 01:47:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201207291612.43138.rjw@sisk.pl> <201208060138.03950.rjw@sisk.pl>
In-Reply-To: <201208060138.03950.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208060147.29559.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The genpd_start_dev() routine used by pm_genpd_runtime_resume()
to put "irq safe" devices into the full power state measures the
time necessary to "start" the device and updates its PM QoS timing
data if necessary.  This may lead to a deadlock if the given device
is a clock source and genpd_start_dev() is invoked from within the
clock source's .enable() routine, which will happen if that routine
uses pm_runtime_get_sync(), for example, to ensure that the device
is operational.

For this reason, introduce a special routine analogous to
genpd_start_dev(), called genpd_start_dev_no_timing(), that doesn't
carry out the time measurement, and make pm_genpd_runtime_resume()
use it instead of genpd_start_dev() to power up "irq safe" devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -75,6 +75,12 @@ static int genpd_start_dev(struct generi
 					start_latency_ns, "start");
 }
 
+static int genpd_start_dev_no_timing(struct generic_pm_domain *genpd,
+				     struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, start, dev);
+}
+
 static bool genpd_sd_counter_dec(struct generic_pm_domain *genpd)
 {
 	bool ret = false;
@@ -626,7 +632,7 @@ static int pm_genpd_runtime_resume(struc
 
 	/* If power.irq_safe, the PM domain is never powered off. */
 	if (dev->power.irq_safe)
-		return genpd_start_dev(genpd, dev);
+		return genpd_start_dev_no_timing(genpd, dev);
 
 	mutex_lock(&genpd->lock);
 	ret = __pm_genpd_poweron(genpd);

