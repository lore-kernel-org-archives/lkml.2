Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab1G0VtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:40913 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab1G0VtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900978"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: dame_eugene@mail.ru, me@bobcopeland.com, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [72/99] ath5k: fix memory leak when fewer than N_PD_CURVES are in use
Message-Id: <20110727214911.9608C2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/ath/ath5k/eeprom.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/ath/ath5k/eeprom.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/ath/ath5k/eeprom.c
+++ linux-2.6.35.y/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1592,14 +1592,12 @@ ath5k_eeprom_free_pcal_info(struct ath5k
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
