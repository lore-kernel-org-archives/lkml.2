Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1GHFCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:02:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab1GHFCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:57 2011
Message-Id: <20110708001657.068788111@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [045/107] ath5k: fix memory leak when fewer than N_PD_CURVES are in use
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Eugene A. Shatokhin" <dame_eugene@mail.ru>

commit a0b8de350be458b33248e48b2174d9af8a4c4798 upstream.

We would free the proper number of curves, but in the wrong
slots, due to a missing level of indirection through
the pdgain_idx table.

It's simpler just to try to free all four slots, so do that.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/eeprom.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1565,14 +1565,12 @@ ath5k_eeprom_free_pcal_info(struct ath5k
 		if (!chinfo[pier].pd_curves)
 			continue;
 
-		for (pdg = 0; pdg < ee->ee_pd_gains[mode]; pdg++) {
+		for (pdg = 0; pdg < AR5K_EEPROM_N_PD_CURVES; pdg++) {
 			struct ath5k_pdgain_info *pd =
 					&chinfo[pier].pd_curves[pdg];
 
-			if (pd != NULL) {
-				kfree(pd->pd_step);
-				kfree(pd->pd_pwr);
-			}
+			kfree(pd->pd_step);
+			kfree(pd->pd_pwr);
 		}
 
 		kfree(chinfo[pier].pd_curves);


