Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348Ab1CATmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:42:15 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab1CAThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:20 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011934.p21JYcE1010300@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 13:32:14 -0500
Subject: [PATCH] arch/tile: warn and retry if an IPI is not accepted by the target cpu
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:38.0185 (UTC) FILETIME=[B3D99590:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we assumed this was impossible, but in fact it can happen.
Handle it gracefully by retrying after issuing a warning.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/smp.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 9575b37..a429310 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -36,6 +36,22 @@ static unsigned long __iomem *ipi_mappings[NR_CPUS];
 /* Set by smp_send_stop() to avoid recursive panics. */
 static int stopping_cpus;
 
+static void __send_IPI_many(HV_Recipient *recip, int nrecip, int tag)
+{
+	int sent = 0;
+	while (sent < nrecip) {
+		int rc = hv_send_message(recip, nrecip,
+					 (HV_VirtAddr)&tag, sizeof(tag));
+		if (rc < 0) {
+			if (!stopping_cpus)  /* avoid recursive panic */
+				panic("hv_send_message returned %d", rc);
+			break;
+		}
+		WARN_ONCE(rc == 0, "hv_send_message() returned zero\n");
+		sent += rc;
+	}
+}
+
 void send_IPI_single(int cpu, int tag)
 {
 	HV_Recipient recip = {
@@ -43,14 +59,13 @@ void send_IPI_single(int cpu, int tag)
 		.x = cpu % smp_width,
 		.state = HV_TO_BE_SENT
 	};
-	int rc = hv_send_message(&recip, 1, (HV_VirtAddr)&tag, sizeof(tag));
-	BUG_ON(rc <= 0);
+	__send_IPI_many(&recip, 1, tag);
 }
 
 void send_IPI_many(const struct cpumask *mask, int tag)
 {
 	HV_Recipient recip[NR_CPUS];
-	int cpu, sent;
+	int cpu;
 	int nrecip = 0;
 	int my_cpu = smp_processor_id();
 	for_each_cpu(cpu, mask) {
@@ -61,17 +76,7 @@ void send_IPI_many(const struct cpumask *mask, int tag)
 		r->x = cpu % smp_width;
 		r->state = HV_TO_BE_SENT;
 	}
-	sent = 0;
-	while (sent < nrecip) {
-		int rc = hv_send_message(recip, nrecip,
-					 (HV_VirtAddr)&tag, sizeof(tag));
-		if (rc <= 0) {
-			if (!stopping_cpus)  /* avoid recursive panic */
-				panic("hv_send_message returned %d", rc);
-			break;
-		}
-		sent += rc;
-	}
+	__send_IPI_many(recip, nrecip, tag);
 }
 
 void send_IPI_allbutself(int tag)
-- 
1.6.5.2

