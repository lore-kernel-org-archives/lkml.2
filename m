Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1I1WmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:42:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab1I1WmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:32 2011
Message-Id: <20110928220132.122720116@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chris Ball <cjb@laptop.org>
Subject: [065/244] mmc: rename mmc_host_clk_{ungate|gate} to mmc_host_clk_{hold|release}
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 08c14071fda4e69abb9d5b1566651cd092b158d3 upstream.

As per suggestion by Linus Walleij:

  > If you think the names of the functions are confusing then
  > you may rename them, say like this:
  >
  > mmc_host_clk_ungate() -> mmc_host_clk_hold()
  > mmc_host_clk_gate() -> mmc_host_clk_release()
  >
  > Which would make the usecases more clear

(This is CC'd to stable@ because the next two patches, which fix
observable races, depend on it.)

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/core.c |    4 ++--
 drivers/mmc/core/host.c |   10 +++++-----
 drivers/mmc/core/host.h |    8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -132,7 +132,7 @@ void mmc_request_done(struct mmc_host *h
 		if (mrq->done)
 			mrq->done(mrq);
 
-		mmc_host_clk_gate(host);
+		mmc_host_clk_release(host);
 	}
 }
 
@@ -191,7 +191,7 @@ mmc_start_request(struct mmc_host *host,
 			mrq->stop->mrq = mrq;
 		}
 	}
-	mmc_host_clk_ungate(host);
+	mmc_host_clk_hold(host);
 	led_trigger_event(host->led, LED_FULL);
 	host->ops->request(host, mrq);
 }
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -119,14 +119,14 @@ static void mmc_host_clk_gate_work(struc
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
 
@@ -164,14 +164,14 @@ static bool mmc_host_may_gate_card(struc
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
 
@@ -231,7 +231,7 @@ static inline void mmc_host_clk_exit(str
 	if (cancel_work_sync(&host->clk_gate_work))
 		mmc_host_clk_gate_delayed(host);
 	if (host->clk_gated)
-		mmc_host_clk_ungate(host);
+		mmc_host_clk_hold(host);
 	/* There should be only one user now */
 	WARN_ON(host->clk_requests > 1);
 }
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
 


