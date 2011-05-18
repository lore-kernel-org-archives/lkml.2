Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab1ERP1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:27:42 -0400
Received: from mail4.comsite.net ([205.238.176.238]:63160 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1ERP1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:27:40 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Miller <davem@davemloft.net>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <sparclinux@vger.kernel.org>
In-Reply-To: <alpine.SOC.1.00.1105021259220.6200@math.ut.ee>
References: <BANLkTikhKqcpdadpM3RQdYvDrPn46_v6_Q@mail.gmail.com>
	<20110517.134312.226762699.davem@davemloft.net>
	<alpine.SOC.1.00.1105021259220.6200@math.ut.ee>
Subject: [PATCH] of: fix race when matching drivers
Date: Wed, 18 May 2011 10:27:39 -0500
X-Originating-IP: 71.22.127.106
Message-ID: <1305732459_6563@mail4.comsite.net>
X-HeloNotChecked: Helo response was not checked before commands sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If two drivers are probing devices at the same time, both will write
their match table result to the dev->of_match cache at the same time.

Only write the result if the device matches.

In a thread titled "SBus devices sometimes detected, sometimes not",
Meelis reported his SBus hme was not detected about 50% of the time.
>From the debug suggested by Grant it was obvious another driver matched
some devices between the call to match the hme and the hme discovery
failling.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Milton Miller <miltonm@bga.com>
---

Grant, I really think this of_match cache in the device node is bad a
bad tradeoff, and am willing to submit patches to remove it for 2.6.40.
It is only used by about 26 drivers and all use it once during probe
to fill out their driver data.  It comes at the cost of a long for
every struct device in every system.

I'll even offer to throw in a patch to cache the parsing of the
compatible property to speed up of_device_is_compatible if needed.



Index: work.git/include/linux/of_device.h
===================================================================
--- work.git.orig/include/linux/of_device.h	2011-05-18 09:57:01.014386816 -0500
+++ work.git/include/linux/of_device.h	2011-05-18 09:58:27.537431575 -0500
@@ -21,8 +21,15 @@ extern void of_device_make_bus_id(struct
 static inline int of_driver_match_device(struct device *dev,
 					 const struct device_driver *drv)
 {
-	dev->of_match = of_match_device(drv->of_match_table, dev);
-	return dev->of_match != NULL;
+	const struct of_device_id *match;
+
+	match = of_match_device(drv->of_match_table, dev);
+	if (match) {
+		dev->of_match = of_match_device(drv->of_match_table, dev);
+		return 1;
+	}
+
+	return 0;
 }
 
 extern struct platform_device *of_dev_get(struct platform_device *dev);
