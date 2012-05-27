Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946009Ab2E0BUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:20:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422844Ab2E0BUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:20:43 -0400
Message-Id: <20120527002524.246590324@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:26 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Nicolas Pitre <nico@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [ 80/91] mmc: sdio: avoid spurious calls to interrupt handlers
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sdio.c     |    2 +-
 drivers/mmc/core/sdio_irq.c |   11 +++++++----
 include/linux/mmc/host.h    |    2 ++
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -947,7 +947,7 @@ static int mmc_sdio_resume(struct mmc_ho
 	}
 
 	if (!err && host->sdio_irqs)
-		mmc_signal_sdio_irq(host);
+		wake_up_process(host->sdio_irq_thread);
 	mmc_release_host(host);
 
 	/*
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
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -297,6 +297,7 @@ struct mmc_host {
 
 	unsigned int		sdio_irqs;
 	struct task_struct	*sdio_irq_thread;
+	bool			sdio_irq_pending;
 	atomic_t		sdio_irq_thread_abort;
 
 	mmc_pm_flag_t		pm_flags;	/* requested pm features */
@@ -352,6 +353,7 @@ extern int mmc_cache_ctrl(struct mmc_hos
 static inline void mmc_signal_sdio_irq(struct mmc_host *host)
 {
 	host->ops->enable_sdio_irq(host, 0);
+	host->sdio_irq_pending = true;
 	wake_up_process(host->sdio_irq_thread);
 }
 


