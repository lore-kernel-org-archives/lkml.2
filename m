Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965864Ab2EOC4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:56:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:49576 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2EOCRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:08 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 083/179] ath5k: fix memory leak when fewer than N_PD_CURVES are in use
Date: Mon, 14 May 2012 22:12:59 -0400
Message-ID: <1337048075-6132-84-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eugene A. Shatokhin" <dame_eugene@mail.ru>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a0b8de350be458b33248e48b2174d9af8a4c4798 upstream.

We would free the proper number of curves, but in the wrong
slots, due to a missing level of indirection through
the pdgain_idx table.

It's simpler just to try to free all four slots, so do that.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/ath5k/eeprom.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 67665cd..df1b8c4 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1590,14 +1590,12 @@ ath5k_eeprom_free_pcal_info(struct ath5k_hw *ah, int mode)
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
-- 
1.7.9.6

