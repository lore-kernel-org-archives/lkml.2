Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2H0K0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 06:26:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5900 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab2H0K0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 06:26:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 27 Aug 2012 03:26:19 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>, <brudley@broadcom.com>, <rvossen@broadcom.com>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list@broadcom.com>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 2/6] brcmfmac: Handling the interrupt in ISR directly for non-OOB
Date: Mon, 27 Aug 2012 18:25:10 +0800
Message-ID: <1346063114-30361-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346063114-30361-1-git-send-email-wni@nvidia.com>
References: <1346063114-30361-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of inband interrupts, if we handle the interrupt in dpc thread,
two level of thread switching takes place to process wifi interrupts.
One in SDHCI driver and the other in Wifi driver. This may cause the system
instability.
Because the SDHCI calls sdio_irq_thread() to handle the irq, this thread locks
mmc host and calls wifi handler. It expects WiFi handler to be quick and
enables sdio interrupt from card at end. If wifi handler defers this work for
a different thread, sdio_irq_thread() will be stuck on next wifi interrupt
since mmc lock is not freed.

Handling the interrupt in ISR directly will prevent thread context switching in
wifi driver. It can fix the instability problems.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 +++++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 8e7e692..5cf6c3b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -121,7 +121,9 @@ static void brcmf_sdio_irqhandler(struct sdio_func *func)
 
 	brcmf_dbg(INTR, "ib intr triggered\n");
 
+	sdio_release_host(sdiodev->func[1]);
 	brcmf_sdbrcm_isr(sdiodev->bus);
+	sdio_claim_host(sdiodev->func[1]);
 }
 
 /* dummy handler for SDIO function 2 interrupt */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 472f2ef..4576d59 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2347,7 +2347,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
 	bool rxdone = true;	/* Flag for no more read data */
 	bool resched = false;	/* Flag indicating resched wanted */
-	int err;
+	int err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3786,11 +3786,17 @@ void brcmf_sdbrcm_isr(void *arg)
 	if (!bus->intr)
 		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
 
+
+#ifndef CONFIG_BRCMFMAC_SDIO_OOB
+	while (brcmf_sdbrcm_dpc(bus))
+		;
+#else
 	bus->dpc_sched = true;
 	if (bus->dpc_tsk) {
 		brcmf_sdbrcm_adddpctsk(bus);
 		complete(&bus->dpc_wait);
 	}
+#endif
 }
 
 static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
-- 
1.7.1

