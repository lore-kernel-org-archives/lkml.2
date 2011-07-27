Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1G0Aiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:38:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:17764 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab1G0AfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="34855731"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: cjb@laptop.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [23/98] mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish
Message-Id: <20110727003515.6092B2403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Chris Ball <cjb@laptop.org>

commit 0c9c99a765321104cc5f9c97f949382a9ba4927e upstream.

It seems that under certain circumstances the sdhci_tasklet_finish()
call can be entered with mrq set to NULL, causing the system to crash
with a NULL pointer de-reference.

Seen on S3C6410 system.  Based on a patch by Dimitris Papastamos.

Reported-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mmc/host/sdhci.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.35.y/drivers/mmc/host/sdhci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mmc/host/sdhci.c
+++ linux-2.6.35.y/drivers/mmc/host/sdhci.c
@@ -1278,6 +1278,13 @@ static void sdhci_tasklet_finish(unsigne
 
 	host = (struct sdhci_host*)param;
 
+        /*
+         * If this tasklet gets rescheduled while running, it will
+         * be run again afterwards but without any active request.
+         */
+	if (!host->mrq)
+		return;
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	del_timer(&host->timer);
