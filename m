Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab1I1XVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:21:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827Ab1I1WmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:32 2011
Message-Id: <20110928220132.347853673@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chris Ball <cjb@laptop.org>
Subject: [067/244] mmc: core: use non-reentrant workqueue for clock gating
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 50a50f9248497484c678631a9c1a719f1aaeab79 upstream.

The default multithread workqueue can cause the same work to be executed
concurrently on a different CPUs. This isn't really suitable for clock
gating as it might already gated the clock and gating it twice results both
host->clk_old and host->ios.clock to be set to 0.

To prevent this from happening we use system_nrt_wq instead.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/host.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -179,7 +179,7 @@ void mmc_host_clk_release(struct mmc_hos
 	host->clk_requests--;
 	if (mmc_host_may_gate_card(host->card) &&
 	    !host->clk_requests)
-		schedule_work(&host->clk_gate_work);
+		queue_work(system_nrt_wq, &host->clk_gate_work);
 	spin_unlock_irqrestore(&host->clk_lock, flags);
 }
 


