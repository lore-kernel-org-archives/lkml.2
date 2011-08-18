Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1HRMXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:23:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:41538 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab1HRMXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:23:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,245,1312182000"; 
   d="scan'208";a="42658627"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-mmc@vger.kernel.org
Cc: cjb@laptop.org, linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 1/3] mmc: rename mmc_host_clk_{ungate|gate} to mmc_host_clk_{hold|release}
Date: Thu, 18 Aug 2011 15:23:47 +0300
Message-Id: <60d2d7a9d5875c389d2a20642724497e3ad00616.1313664897.git.mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1313664897.git.mika.westerberg@linux.intel.com>
References: <cover.1313664897.git.mika.westerberg@linux.intel.com>
In-Reply-To: <cover.1313664897.git.mika.westerberg@linux.intel.com>
References: <cover.1313664897.git.mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per suggestion by Linus Walleij:

	> If you think the names of the functions are confusing then
	> you may rename them, say like this:
	>
	> mmc_host_clk_ungate() -> mmc_host_clk_hold()
	> mmc_host_clk_gate() -> mmc_host_clk_release()
	>
	> Which would make the usecases more clear

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/core/core.c |    4 ++--
 drivers/mmc/core/host.c |   10 +++++-----
 drivers/mmc/core/host.h |    8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 91a0a74..63ffc65 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -133,7 +133,7 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 		if (mrq->done)
 			mrq->done(mrq);
 
-		mmc_host_clk_gate(host);
+		mmc_host_clk_release(host);
 	}
 }
 
@@ -192,7 +192,7 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 			mrq->stop->mrq = mrq;
 		}
 	}
-	mmc_host_clk_ungate(host);
+	mmc_host_clk_hold(host);
 	led_trigger_event(host->led, LED_FULL);
 	host->ops->request(host, mrq);
 }
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index b29d3e8..96a26b2 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -119,14 +119,14 @@ static void mmc_host_clk_gate_work(struct work_struct *work)
 }
 
 /**
- *	mmc_host_clk_ungate - ungate hardware MCI clocks
+ *	mmc_host_clk_hold - ungate hardware MCI clocks
  *	@host: host to ungate.
  *
  *	Makes sure the host ios.clock is restored to a non-zero value
  *	past this call.	Increase clock reference count and ungate clock
  *	if we're the first user.
  */
-void mmc_host_clk_ungate(struct mmc_host *host)
+void mmc_host_clk_hold(struct mmc_host *host)
 {
 	unsigned long flags;
 
@@ -164,14 +164,14 @@ static bool mmc_host_may_gate_card(struct mmc_card *card)
 }
 
 /**
- *	mmc_host_clk_gate - gate off hardware MCI clocks
+ *	mmc_host_clk_release - gate off hardware MCI clocks
  *	@host: host to gate.
  *
  *	Calls the host driver with ios.clock set to zero as often as possible
  *	in order to gate off hardware MCI clocks. Decrease clock reference
  *	count and schedule disabling of clock.
  */
-void mmc_host_clk_gate(struct mmc_host *host)
+void mmc_host_clk_release(struct mmc_host *host)
 {
 	unsigned long flags;
 
@@ -231,7 +231,7 @@ static inline void mmc_host_clk_exit(struct mmc_host *host)
 	if (cancel_work_sync(&host->clk_gate_work))
 		mmc_host_clk_gate_delayed(host);
 	if (host->clk_gated)
-		mmc_host_clk_ungate(host);
+		mmc_host_clk_hold(host);
 	/* There should be only one user now */
 	WARN_ON(host->clk_requests > 1);
 }
diff --git a/drivers/mmc/core/host.h b/drivers/mmc/core/host.h
index de199f9..fb8a5cd 100644
--- a/drivers/mmc/core/host.h
+++ b/drivers/mmc/core/host.h
@@ -16,16 +16,16 @@ int mmc_register_host_class(void);
 void mmc_unregister_host_class(void);
 
 #ifdef CONFIG_MMC_CLKGATE
-void mmc_host_clk_ungate(struct mmc_host *host);
-void mmc_host_clk_gate(struct mmc_host *host);
+void mmc_host_clk_hold(struct mmc_host *host);
+void mmc_host_clk_release(struct mmc_host *host);
 unsigned int mmc_host_clk_rate(struct mmc_host *host);
 
 #else
-static inline void mmc_host_clk_ungate(struct mmc_host *host)
+static inline void mmc_host_clk_hold(struct mmc_host *host)
 {
 }
 
-static inline void mmc_host_clk_gate(struct mmc_host *host)
+static inline void mmc_host_clk_release(struct mmc_host *host)
 {
 }
 
-- 
1.7.5.4

