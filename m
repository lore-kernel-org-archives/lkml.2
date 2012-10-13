Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2JMBCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 21:02:23 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:58969 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab2JMBCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 21:02:22 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2012 21:02:22 EDT
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: [PATCH] sdhci: put regulator if probe fails
Date: Fri, 12 Oct 2012 21:55:17 -0300
Message-Id: <1350089717-4050-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the dummy regulator, SDHCI may fail its probing because the
regulator does not support any voltages.

When reloading the driver, you will get a warning about a duplicate
sysfs link.

[72211.963386] 0000:03:00.0 supply vmmc not found, using dummy regulator
[72211.963409] ------------[ cut here ]------------
[72211.963420] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0x99/0xad()
[72211.963424] Hardware name:
[72211.963429] sysfs: cannot create duplicate filename '/devices/platform/reg-dummy/regulator/regulator.0/0000:03:00.0-vmmc'

Avoid this by properly cleaning up when the probe fails calling
regulator_put. Other fail paths get fixed as well.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/mmc/host/sdhci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7922adb..dd6bc26 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2992,7 +2992,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (mmc->ocr_avail == 0) {
 		pr_err("%s: Hardware doesn't report any "
 			"support voltages.\n", mmc_hostname(mmc));
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_vmmc;
 	}
 
 	spin_lock_init(&host->lock);
@@ -3121,6 +3122,9 @@ reset:
 untasklet:
 	tasklet_kill(&host->card_tasklet);
 	tasklet_kill(&host->finish_tasklet);
+out_vmmc:
+	if (host->vmmc)
+		regulator_put(host->vmmc);
 
 	return ret;
 }
-- 
1.7.10

