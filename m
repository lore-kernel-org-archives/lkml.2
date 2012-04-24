Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab2DXWem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:34:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab2DXWed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:34:33 -0400
Message-Id: <20120424223243.120183666@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Drake <dsd@laptop.org>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>, Chris Ball <cjb@laptop.org>
Subject: [ 13/62] mmc: sdhci: refine non-removable card checking for card detection
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit 87b87a3fc0eec58d95e4216392f889a26439ad22 upstream.

Commit c79396c191bc19 ("mmc: sdhci: prevent card detection activity
for non-removable cards") disables card detection where the cards
are marked as non-removable.

This makes sense, but the implementation detail of calling
mmc_card_is_removable() causes some problems, because
mmc_card_is_removable() is overloaded with CONFIG_MMC_UNSAFE_RESUME
semantics.

In the OLPC XO case, we need CONFIG_MMC_UNSAFE_RESUME because our root
filesystem is stored on SD, but we also have external SD card slots
where we want automatic card detection.

Refine the check to only apply to hosts marked as MMC_CAP_NONREMOVABLE,
which is defined to mean that the card is *really* nonremovable. This
could be revisited in future if we find a way to improve
CONFIG_MMC_UNSAFE_RESUME semantics.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -147,7 +147,7 @@ static void sdhci_set_card_detection(str
 	u32 present, irqs;
 
 	if ((host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION) ||
-	    !mmc_card_is_removable(host->mmc))
+	    (host->mmc->caps & MMC_CAP_NONREMOVABLE))
 		return;
 
 	present = sdhci_readl(host, SDHCI_PRESENT_STATE) &


