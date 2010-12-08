Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0LHCB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:01:56 -0500
Received: from kroah.org ([198.145.64.141]:48368 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab0LHA7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:10 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:22 2010
Message-Id: <20101208005722.895008263@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [015/289] ath9k: Fix tx struck state with paprd
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit 9094537c3a9ef9e127e844254a74186735c9a90b upstream.

Paprd needs to be done only on active chains(not for all the chains
that hw can support). The paprd training frames which are sent
for inactive chains would be hanging on the hw queue without
getting transmitted and would make the connection so unstable.
This issue happens only with the hw which supports paprd cal(ar9003).

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -269,6 +269,7 @@ static void ath_paprd_activate(struct at
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	struct ath_common *common = ath9k_hw_common(ah);
 	int chain;
 
 	if (!caldata || !caldata->paprd_done)
@@ -277,7 +278,7 @@ static void ath_paprd_activate(struct at
 	ath9k_ps_wakeup(sc);
 	ar9003_paprd_enable(ah, false);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(ah->caps.tx_chainmask & BIT(chain)))
+		if (!(common->tx_chainmask & BIT(chain)))
 			continue;
 
 		ar9003_paprd_populate_single_table(ah, caldata, chain);
@@ -299,6 +300,7 @@ void ath_paprd_calibrate(struct work_str
 	struct ieee80211_supported_band *sband = &sc->sbands[band];
 	struct ath_tx_control txctl;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	struct ath_common *common = ath9k_hw_common(ah);
 	int qnum, ftype;
 	int chain_ok = 0;
 	int chain;
@@ -332,7 +334,7 @@ void ath_paprd_calibrate(struct work_str
 	ath9k_ps_wakeup(sc);
 	ar9003_paprd_init_table(ah);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(ah->caps.tx_chainmask & BIT(chain)))
+		if (!(common->tx_chainmask & BIT(chain)))
 			continue;
 
 		chain_ok = 0;


