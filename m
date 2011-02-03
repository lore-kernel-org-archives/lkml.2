Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1BCJhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:37:52 -0500
Received: from sand.ocn.ne.jp ([122.28.30.136]:55152 "EHLO smtp.sand.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab1BCJhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:37:50 -0500
X-Greylist: delayed 1593 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Feb 2011 04:37:50 EST
From: Jon Povey <jon.povey@racelogic.co.uk>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: gilles.chanteperdrix@nexvision.fr, Jon Povey <jon.povey@racelogic.co.uk>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Chaithrika U S <chaithrika@ti.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] mmc: davinci: fix corruption after surprise card eject
Date: Thu,  3 Feb 2011 18:10:33 +0900
Message-Id: <1296724233-3903-1-git-send-email-jon.povey@racelogic.co.uk>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ejecting a card during a write results in a bad controller state which
corrupts all writes to subsequently inserted cards.

Work around this by resetting the controller in the set_ios() POWER_OFF
handler.

Tested on DM355.

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
---

This patch is against 2.6.36, it does not include the latest SDIO patch
at least.

To reproduce this in the unpatched sources, write heavily to the card
and eject it during a write. Note that for the first few seconds of
"writing a file" nothing is actually written to the card, it is cached
by Linux.

In the broken state that results, if a card is reinserted, the effect
is as if an internal write FIFO has not been cleared and contains 2
extra bytes. Tests suggest this is not the documented 32-byte FIFO but
something beyond that.
All blocks appear on the card starting with the last two bytes of the
previous block write, then the remaining sector data; the last two
bytes overflow into the next written sector, etc.

Toggling MMCCTL.CMDRST,DATRST clears this condition. These are toggled
several times during the error handlers called when the card is ejected
during write, but it seems the bad state is entered at some point later.

set_ios(MMC_POWER_OFF) seems to consistently be called at the end of
the cleanup process before a newly-inserted card is accessed, putting
an extra controller reset in here gets rid of the problem - but I'm not
sure this is the right way to fix this, it has a workaround feel.

Comments sought.. thanks.

---
 drivers/mmc/host/davinci_mmc.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 33d9f1b..e5ee1c1 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -795,6 +795,9 @@ static void calculate_clk_divider(struct mmc_host *mmc, struct mmc_ios *ios)
 	}
 }
 
+static void
+davinci_abort_data(struct mmc_davinci_host *host, struct mmc_data *data);
+
 static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct mmc_davinci_host *host = mmc_priv(mmc);
@@ -856,9 +859,14 @@ static void mmc_davinci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		}
 		if (lose)
 			dev_warn(mmc_dev(host->mmc), "powerup timeout\n");
-	}
 
-	/* FIXME on power OFF, reset things ... */
+	} else if (ios->power_mode == MMC_POWER_OFF) {
+
+		/* Controller maybe in bad state, e.g. card pulled while writing */
+		davinci_abort_data(host, NULL);
+
+		/* FIXME on power OFF, reset more things ...? */
+	}
 }
 
 static void
-- 
1.6.3.3

