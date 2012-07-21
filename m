Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2GUVvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 17:51:31 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50966 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab2GUVvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 17:51:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 3/5] PM / shmobile: Specify device latencies for SH7372 devices directly
Date: Sat, 21 Jul 2012 23:54:58 +0200
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
Message-Id: <201207212354.58375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The results of adaptive latency computations in
GENPD_DEV_TIMED_CALLBACK() show that the start/stop and save/restore
state latencies of all devices on SH7372 I have tried are a little
below 250 us.  Therefore, if the 250 us is used as the common initial
value of the latency fields in struct gpd_timing_data for all devices
on SH7372, the latency values will never have to change at run time
and there won't be any overhead related to re-computation of the
corresponding PM QoS data.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/setup-sh7372.c |   57 +++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 24 deletions(-)

Index: linux/arch/arm/mach-shmobile/setup-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/setup-sh7372.c
+++ linux/arch/arm/mach-shmobile/setup-sh7372.c
@@ -999,8 +999,17 @@ static struct platform_device *sh7372_la
 	&spu1_device,
 };
 
+#define DEV_LATENCY_NS	250000
+
 void __init sh7372_add_standard_devices(void)
 {
+	struct gpd_timing_data latencies = {
+		.stop_latency_ns = DEV_LATENCY_NS,
+		.start_latency_ns = DEV_LATENCY_NS,
+		.save_state_latency_ns = DEV_LATENCY_NS,
+		.restore_state_latency_ns = DEV_LATENCY_NS,
+	};
+
 	sh7372_init_pm_domains();
 
 	platform_add_devices(sh7372_early_devices,
@@ -1009,30 +1018,30 @@ void __init sh7372_add_standard_devices(
 	platform_add_devices(sh7372_late_devices,
 			    ARRAY_SIZE(sh7372_late_devices));
 
-	rmobile_add_device_to_domain("A3RV", &vpu_device);
-	rmobile_add_device_to_domain("A4MP", &spu0_device);
-	rmobile_add_device_to_domain("A4MP", &spu1_device);
-	rmobile_add_device_to_domain("A3SP", &scif0_device);
-	rmobile_add_device_to_domain("A3SP", &scif1_device);
-	rmobile_add_device_to_domain("A3SP", &scif2_device);
-	rmobile_add_device_to_domain("A3SP", &scif3_device);
-	rmobile_add_device_to_domain("A3SP", &scif4_device);
-	rmobile_add_device_to_domain("A3SP", &scif5_device);
-	rmobile_add_device_to_domain("A3SP", &scif6_device);
-	rmobile_add_device_to_domain("A3SP", &iic1_device);
-	rmobile_add_device_to_domain("A3SP", &dma0_device);
-	rmobile_add_device_to_domain("A3SP", &dma1_device);
-	rmobile_add_device_to_domain("A3SP", &dma2_device);
-	rmobile_add_device_to_domain("A3SP", &usb_dma0_device);
-	rmobile_add_device_to_domain("A3SP", &usb_dma1_device);
-	rmobile_add_device_to_domain("A4R", &iic0_device);
-	rmobile_add_device_to_domain("A4R", &veu0_device);
-	rmobile_add_device_to_domain("A4R", &veu1_device);
-	rmobile_add_device_to_domain("A4R", &veu2_device);
-	rmobile_add_device_to_domain("A4R", &veu3_device);
-	rmobile_add_device_to_domain("A4R", &jpu_device);
-	rmobile_add_device_to_domain("A4R", &tmu00_device);
-	rmobile_add_device_to_domain("A4R", &tmu01_device);
+	rmobile_add_device_to_domain_td("A3RV", &vpu_device, &latencies);
+	rmobile_add_device_to_domain_td("A4MP", &spu0_device, &latencies);
+	rmobile_add_device_to_domain_td("A4MP", &spu1_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &scif0_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &scif1_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &scif2_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &scif3_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &scif4_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &scif5_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &scif6_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &iic1_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &dma0_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &dma1_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &dma2_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &usb_dma0_device, &latencies);
+	rmobile_add_device_to_domain_td("A3SP", &usb_dma1_device, &latencies);
+	rmobile_add_device_to_domain_td("A4R", &iic0_device, &latencies);
+	rmobile_add_device_to_domain_td("A4R", &veu0_device, &latencies);
+	rmobile_add_device_to_domain_td("A4R", &veu1_device, &latencies);
+	rmobile_add_device_to_domain_td("A4R", &veu2_device, &latencies);
+	rmobile_add_device_to_domain_td("A4R", &veu3_device, &latencies);
+	rmobile_add_device_to_domain_td("A4R", &jpu_device, &latencies);
+	rmobile_add_device_to_domain_td("A4R", &tmu00_device, &latencies);
+	rmobile_add_device_to_domain_td("A4R", &tmu01_device, &latencies);
 }
 
 static void __init sh7372_earlytimer_init(void)

