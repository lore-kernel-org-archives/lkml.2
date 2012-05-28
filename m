Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2E1Dbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:31:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52196 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176Ab2E1D3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:53 -0400
Message-Id: <20120528031215.149138561@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Nicolas Pitre <nico@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [ 089/117] mmc: sdio: avoid spurious calls to interrupt handlers
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nicolas.pitre@linaro.org>

commit bbbc4c4d8c5face097d695f9bf3a39647ba6b7e7 upstream.

Commit 06e8935feb ("optimized SDIO IRQ handling for single irq")
introduced some spurious calls to SDIO function interrupt handlers,
such as when the SDIO IRQ thread is started, or the safety check
performed upon a system resume.  Let's add a flag to perform the
optimization only when a real interrupt is signaled by the host
driver and we know there is no point confirming it.

Reported-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/core/sdio.c     |    2 +-
 drivers/mmc/core/sdio_irq.c |   11 +++++++----
 include/linux/mmc/host.h    |    2 ++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 2c7c83f..13d0e95 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -947,7 +947,7 @@ static int mmc_sdio_resume(struct mmc_host *host)
 	}
 
 	if (!err && host->sdio_irqs)
-		mmc_signal_sdio_irq(host);
+		wake_up_process(host->sdio_irq_thread);
 	mmc_release_host(host);
 
 	/*
diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index f573e7f..3d8ceb4 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -28,18 +28,20 @@
 
 #include "sdio_ops.h"
 
-static int process_sdio_pending_irqs(struct mmc_card *card)
+static int process_sdio_pending_irqs(struct mmc_host *host)
 {
+	struct mmc_card *card = host->card;
 	int i, ret, count;
 	unsigned char pending;
 	struct sdio_func *func;
 
 	/*
 	 * Optimization, if there is only 1 function interrupt registered
-	 * call irq handler directly
+	 * and we know an IRQ was signaled then call irq handler directly.
+	 * Otherwise do the full probe.
 	 */
 	func = card->sdio_single_irq;
-	if (func) {
+	if (func && host->sdio_irq_pending) {
 		func->irq_handler(func);
 		return 1;
 	}
@@ -116,7 +118,8 @@ static int sdio_irq_thread(void *_host)
 		ret = __mmc_claim_host(host, &host->sdio_irq_thread_abort);
 		if (ret)
 			break;
-		ret = process_sdio_pending_irqs(host->card);
+		ret = process_sdio_pending_irqs(host);
+		host->sdio_irq_pending = false;
 		mmc_release_host(host);
 
 		/*
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index cbde4b7..0707d22 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -297,6 +297,7 @@ struct mmc_host {
 
 	unsigned int		sdio_irqs;
 	struct task_struct	*sdio_irq_thread;
+	bool			sdio_irq_pending;
 	atomic_t		sdio_irq_thread_abort;
 
 	mmc_pm_flag_t		pm_flags;	/* requested pm features */
@@ -352,6 +353,7 @@ extern int mmc_cache_ctrl(struct mmc_host *, u8);
 static inline void mmc_signal_sdio_irq(struct mmc_host *host)
 {
 	host->ops->enable_sdio_irq(host, 0);
+	host->sdio_irq_pending = true;
 	wake_up_process(host->sdio_irq_thread);
 }
 


