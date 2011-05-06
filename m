Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1EFASr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:18:47 -0400
Received: from kroah.org ([198.145.64.141]:32849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab1EFANW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:08 2011
Message-Id: <20110506001208.762427521@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <damm@opensource.se>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [patch 15/38] mmc: fix a race between card-detect rescan and clock-gate work instances
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 26fc8775b51484d8c0a671198639c6d5ae60533e upstream.

Currently there is a race in the MMC core between a card-detect
rescan work and the clock-gating work, scheduled from a command
completion. Fix it by removing the dedicated clock-gating mutex
and using the MMC standard locking mechanism instead.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <damm@opensource.se>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/host.c  |    9 ++++-----
 include/linux/mmc/host.h |    1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -94,7 +94,7 @@ static void mmc_host_clk_gate_delayed(st
 		spin_unlock_irqrestore(&host->clk_lock, flags);
 		return;
 	}
-	mutex_lock(&host->clk_gate_mutex);
+	mmc_claim_host(host);
 	spin_lock_irqsave(&host->clk_lock, flags);
 	if (!host->clk_requests) {
 		spin_unlock_irqrestore(&host->clk_lock, flags);
@@ -104,7 +104,7 @@ static void mmc_host_clk_gate_delayed(st
 		pr_debug("%s: gated MCI clock\n", mmc_hostname(host));
 	}
 	spin_unlock_irqrestore(&host->clk_lock, flags);
-	mutex_unlock(&host->clk_gate_mutex);
+	mmc_release_host(host);
 }
 
 /*
@@ -130,7 +130,7 @@ void mmc_host_clk_ungate(struct mmc_host
 {
 	unsigned long flags;
 
-	mutex_lock(&host->clk_gate_mutex);
+	mmc_claim_host(host);
 	spin_lock_irqsave(&host->clk_lock, flags);
 	if (host->clk_gated) {
 		spin_unlock_irqrestore(&host->clk_lock, flags);
@@ -140,7 +140,7 @@ void mmc_host_clk_ungate(struct mmc_host
 	}
 	host->clk_requests++;
 	spin_unlock_irqrestore(&host->clk_lock, flags);
-	mutex_unlock(&host->clk_gate_mutex);
+	mmc_release_host(host);
 }
 
 /**
@@ -218,7 +218,6 @@ static inline void mmc_host_clk_init(str
 	host->clk_gated = false;
 	INIT_WORK(&host->clk_gate_work, mmc_host_clk_gate_work);
 	spin_lock_init(&host->clk_lock);
-	mutex_init(&host->clk_gate_mutex);
 }
 
 /**
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -183,7 +183,6 @@ struct mmc_host {
 	struct work_struct	clk_gate_work; /* delayed clock gate */
 	unsigned int		clk_old;	/* old clock value cache */
 	spinlock_t		clk_lock;	/* lock for clk fields */
-	struct mutex		clk_gate_mutex;	/* mutex for clock gating */
 #endif
 
 	/* host specific block data */


