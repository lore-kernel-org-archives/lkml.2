Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab2GLMmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:42:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34034 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab2GLMkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:40:46 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-11-4ffec5cc8c7b
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH v3 2/6] mmc: dw_mmc: allow probe to succeed even if one slot is
 initialized
Date: Thu, 12 Jul 2012 18:24:24 +0530
Message-id: <1342097668-25243-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
References: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t9jAd2zR//5G3y6xmZxedccNosj//sZ
	LWac38fkwOzxeZNcAGMUl01Kak5mWWqRvl0CV8bRj3tZCybxVqw9/IOlgXETVxcjJ4eEgInE
	3/2v2SBsMYkL99aD2UICixglfs9h6WLkArLbmCQmvvrLCpJgEzCQeLTwHTuILSLgJLFk7gRm
	kCJmgTuMEo9mnWQESQgLxEpM/ncJrIFFQFXizczpYFN5BTwlvjadY4LYpiSxofcomM0p4CVx
	fWULUD0H0DZPiVd/HCYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwEz6R2MK5s
	sDjEKMDBqMTD++HAP38h1sSy4srcQ4wSHMxKIrz9uUAh3pTEyqrUovz4otKc1OJDjNIcLEri
	vMbeX/2FBNITS1KzU1MLUotgskwcnFINjA4qvm+1HSWXzzq7co0G88ajrx+H3V39+dbbJ91F
	EjfiophF7HVF/nx/sWeX6+9/Rs+eK+1S1vl0UiPu0unnLvKNP5j+J3Vp60ZVr1y+VOFMFhNr
	ajWb0aYbca9vCD8490zvr9K+33kLbQPDNPfNu7vuN0+h1cH8vsW5G5bI/2m6Mylj7gHpSSJK
	LMUZiYZazEXFiQCbn9/O/gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of aborting the probe in case a slot initialization fails, allow
initialization of as many slots as possible. If there are atleast one
instance of slot that is successfully initialized, allow the driver probe
to succeed.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/mmc/host/dw_mmc.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 948a7ac..cd58063 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1939,6 +1939,7 @@ int dw_mci_probe(struct dw_mci *host)
 {
 	int width, i, ret = 0;
 	u32 fifo_size;
+	int init_slots = 0;
 
 	if (!host->pdata || !host->pdata->init) {
 		dev_err(host->dev,
@@ -2047,10 +2048,18 @@ int dw_mci_probe(struct dw_mci *host)
 	/* We need at least one slot to succeed */
 	for (i = 0; i < host->num_slots; i++) {
 		ret = dw_mci_init_slot(host, i);
-		if (ret) {
-			ret = -ENODEV;
-			goto err_init_slot;
-		}
+		if (ret)
+			dev_dbg(host->dev, "slot %d init failed\n", i);
+		else
+			init_slots++;
+	}
+
+	if (init_slots) {
+		dev_info(host->dev, "%d slots initialized\n", init_slots);
+	} else {
+		dev_dbg(host->dev, "attempted to initialize %d slots, "
+					"but failed on all\n", host->num_slots);
+		goto err_init_slot;
 	}
 
 	/*
@@ -2085,12 +2094,6 @@ int dw_mci_probe(struct dw_mci *host)
 	return 0;
 
 err_init_slot:
-	/* De-init any initialized slots */
-	while (i > 0) {
-		if (host->slot[i])
-			dw_mci_cleanup_slot(host->slot[i], i);
-		i--;
-	}
 	free_irq(host->irq, host);
 
 err_workqueue:
-- 
1.6.6.rc2

