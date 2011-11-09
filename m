Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab1KJDUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:20:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933745Ab1KJDUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:20:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:02 2011
Message-Id: <20111109212702.775920364@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ulf Hansson <ulf.hansson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [025/262] mmc: core: Fix hangs related to insert/remove of cards
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@stericsson.com>

commit 7f7e4129c23f0419257184dff6fec89d2d5a8964 upstream.

During a rescan operation mmc_attach(sd|mmc|sdio) functions are
called. The error handling in these function can trigger a detach
of the bus, which also meant a power off. This is not notified by
the rescan operation which then continues to the next attach function.

If a power off has been done, the framework must never send any
new commands to the host driver, without first doing a new power up.
This will most likely trigger any host driver to hang.

Moving power off out of detach and instead handle power off
separately when it is actually needed, solves the issue.

Signed-off-by: Ulf Hansson <ulf.hansson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/core.c |   10 +++++-----
 drivers/mmc/core/core.h |    1 +
 drivers/mmc/core/mmc.c  |    1 +
 drivers/mmc/core/sd.c   |    1 +
 drivers/mmc/core/sdio.c |    1 +
 5 files changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1057,7 +1057,7 @@ static void mmc_power_up(struct mmc_host
 	mmc_host_clk_release(host);
 }
 
-static void mmc_power_off(struct mmc_host *host)
+void mmc_power_off(struct mmc_host *host)
 {
 	mmc_host_clk_hold(host);
 
@@ -1147,8 +1147,7 @@ void mmc_attach_bus(struct mmc_host *hos
 }
 
 /*
- * Remove the current bus handler from a host. Assumes that there are
- * no interesting cards left, so the bus is powered down.
+ * Remove the current bus handler from a host.
  */
 void mmc_detach_bus(struct mmc_host *host)
 {
@@ -1165,8 +1164,6 @@ void mmc_detach_bus(struct mmc_host *hos
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
-	mmc_power_off(host);
-
 	mmc_bus_put(host);
 }
 
@@ -1675,6 +1672,7 @@ void mmc_stop_host(struct mmc_host *host
 
 		mmc_claim_host(host);
 		mmc_detach_bus(host);
+		mmc_power_off(host);
 		mmc_release_host(host);
 		mmc_bus_put(host);
 		return;
@@ -1796,6 +1794,7 @@ int mmc_suspend_host(struct mmc_host *ho
 				host->bus_ops->remove(host);
 			mmc_claim_host(host);
 			mmc_detach_bus(host);
+			mmc_power_off(host);
 			mmc_release_host(host);
 			host->pm_flags = 0;
 			err = 0;
@@ -1883,6 +1882,7 @@ int mmc_pm_notify(struct notifier_block
 			host->bus_ops->remove(host);
 
 		mmc_detach_bus(host);
+		mmc_power_off(host);
 		mmc_release_host(host);
 		host->pm_flags = 0;
 		break;
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -43,6 +43,7 @@ int mmc_set_signal_voltage(struct mmc_ho
 			   bool cmd11);
 void mmc_set_timing(struct mmc_host *host, unsigned int timing);
 void mmc_set_driver_type(struct mmc_host *host, unsigned int drv_type);
+void mmc_power_off(struct mmc_host *host);
 
 static inline void mmc_delay(unsigned int ms)
 {
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -891,6 +891,7 @@ static void mmc_detect(struct mmc_host *
 
 		mmc_claim_host(host);
 		mmc_detach_bus(host);
+		mmc_power_off(host);
 		mmc_release_host(host);
 	}
 }
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1008,6 +1008,7 @@ static void mmc_sd_detect(struct mmc_hos
 
 		mmc_claim_host(host);
 		mmc_detach_bus(host);
+		mmc_power_off(host);
 		mmc_release_host(host);
 	}
 }
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -597,6 +597,7 @@ out:
 
 		mmc_claim_host(host);
 		mmc_detach_bus(host);
+		mmc_power_off(host);
 		mmc_release_host(host);
 	}
 }


