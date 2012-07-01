Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab2GASVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:21:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47054 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414Ab2GASQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:43 -0400
Message-Id: <20120701172010.952716529@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        Rolf Offermanns <rolf.offermanns@gmx.net>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 30/48] ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

commit f18e3c6b67f448ec47b3a5b242789bd3d5644879 upstream.

"ath9k: Fix softlockup in AR9485" with commit id
64bc1239c790e051ff677e023435d770d2ffa174 fixed the reported
issue, yet its better to avoid the possible infinite loop
in ar9003_get_pll_sqsum_dvc by having a timeout as suggested
by ath9k maintainers.
http://www.spinics.net/lists/linux-wireless/msg92126.html.
Based on my testing PLL's locking measurement is done in
~200us (2 iterations).

Cc: Rolf Offermanns <rolf.offermanns@gmx.net>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/hw.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7db1890..1c68e56 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -784,13 +784,25 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 
 u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+	int i = 0;
+
 	REG_CLR_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
 	udelay(100);
 	REG_SET_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
 
-	while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) == 0)
+	while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) == 0) {
+
 		udelay(100);
 
+		if (WARN_ON_ONCE(i >= 100)) {
+			ath_err(common, "PLL4 meaurement not done\n");
+			break;
+		}
+
+		i++;
+	}
+
 	return (REG_READ(ah, PLL3) & SQSUM_DVC_MASK) >> 3;
 }
 EXPORT_SYMBOL(ar9003_get_pll_sqsum_dvc);


