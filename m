Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1EPQ6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:58:22 -0400
Received: from void.printf.net ([89.145.121.20]:42210 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1EPQ6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:58:21 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fix for 2.6.39.
Date: Mon, 16 May 2011 13:00:18 -0400
Message-ID: <m3wrhqinrx.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to revert mainline commit 26fc8775b51484 ("mmc: fix a race between
card-detect rescan and clock-gate work instances"), merged in .39-rc6.

We've received reports from Archlinux users that this patch causes
a boot time crash when probing MMC cards with CONFIG_MMC_CLKGATE=y.
I can't reproduce this myself, but I'd be more comfortable releasing
.39 with the previous behavior while we investigate.  Thanks.

The following changes since commit eed631e0d741d1a1067cfc6d709fdf2363126f9c:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../mason/btrfs-unstable

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Chris Ball (1):
      Revert "mmc: fix a race between card-detect rescan and clock-gate work instances"

 drivers/mmc/core/host.c  |    9 +++++----
 include/linux/mmc/host.h |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

From: Chris Ball <cjb@laptop.org>
Date: Mon, 16 May 2011 11:32:26 -0400
Subject: [PATCH] Revert "mmc: fix a race between card-detect rescan and clock-gate work instances"

This reverts commit 26fc8775b51484d8c0a671198639c6d5ae60533e, which has
been reported to cause boot/resume-time crashes for some users:

https://bbs.archlinux.org/viewtopic.php?id=118751.

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: <stable@kernel.org>
---
 drivers/mmc/core/host.c  |    9 +++++----
 include/linux/mmc/host.h |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 2b200c1..461e6a1 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -94,7 +94,7 @@ static void mmc_host_clk_gate_delayed(struct mmc_host *host)
 		spin_unlock_irqrestore(&host->clk_lock, flags);
 		return;
 	}
-	mmc_claim_host(host);
+	mutex_lock(&host->clk_gate_mutex);
 	spin_lock_irqsave(&host->clk_lock, flags);
 	if (!host->clk_requests) {
 		spin_unlock_irqrestore(&host->clk_lock, flags);
@@ -104,7 +104,7 @@ static void mmc_host_clk_gate_delayed(struct mmc_host *host)
 		pr_debug("%s: gated MCI clock\n", mmc_hostname(host));
 	}
 	spin_unlock_irqrestore(&host->clk_lock, flags);
-	mmc_release_host(host);
+	mutex_unlock(&host->clk_gate_mutex);
 }
 
 /*
@@ -130,7 +130,7 @@ void mmc_host_clk_ungate(struct mmc_host *host)
 {
 	unsigned long flags;
 
-	mmc_claim_host(host);
+	mutex_lock(&host->clk_gate_mutex);
 	spin_lock_irqsave(&host->clk_lock, flags);
 	if (host->clk_gated) {
 		spin_unlock_irqrestore(&host->clk_lock, flags);
@@ -140,7 +140,7 @@ void mmc_host_clk_ungate(struct mmc_host *host)
 	}
 	host->clk_requests++;
 	spin_unlock_irqrestore(&host->clk_lock, flags);
-	mmc_release_host(host);
+	mutex_unlock(&host->clk_gate_mutex);
 }
 
 /**
@@ -215,6 +215,7 @@ static inline void mmc_host_clk_init(struct mmc_host *host)
 	host->clk_gated = false;
 	INIT_WORK(&host->clk_gate_work, mmc_host_clk_gate_work);
 	spin_lock_init(&host->clk_lock);
+	mutex_init(&host->clk_gate_mutex);
 }
 
 /**
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index eb792cb..bcb793e 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -183,6 +183,7 @@ struct mmc_host {
 	struct work_struct	clk_gate_work; /* delayed clock gate */
 	unsigned int		clk_old;	/* old clock value cache */
 	spinlock_t		clk_lock;	/* lock for clk fields */
+	struct mutex		clk_gate_mutex;	/* mutex for clock gating */
 #endif
 
 	/* host specific block data */
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
