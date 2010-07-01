Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab0GAVha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:37:30 -0400
Received: from kroah.org ([198.145.64.141]:33028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab0GAVOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:45 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:58 2010
Message-Id: <20100701174258.481975342@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [143/200] ath5k: retain promiscuous setting
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit 6b5dcccb495b66b3b0b9581cdccfed038e5d68a2 upstream.

Commit 56d1de0a21db28e41741cfa0a66e18bc8d920554, "ath5k: clean up
filter flags setting" introduced a regression in monitor mode such
that the promisc filter flag would get lost.

Although we set the promisc flag when it changed, we did not
preserve it across subsequent calls to configure_filter.  This patch
restores the original functionality.

Bisected-by: weedy2887@gmail.com
Tested-by: weedy2887@gmail.com
Tested-by: Rick Farina <sidhayn@gmail.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2994,13 +2994,15 @@ static void ath5k_configure_filter(struc
 
 	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
 		if (*new_flags & FIF_PROMISC_IN_BSS) {
-			rfilt |= AR5K_RX_FILTER_PROM;
 			__set_bit(ATH_STAT_PROMISC, sc->status);
 		} else {
 			__clear_bit(ATH_STAT_PROMISC, sc->status);
 		}
 	}
 
+	if (test_bit(ATH_STAT_PROMISC, sc->status))
+		rfilt |= AR5K_RX_FILTER_PROM;
+
 	/* Note, AR5K_RX_FILTER_MCAST is already enabled */
 	if (*new_flags & FIF_ALLMULTI) {
 		mfilt[0] =  ~0;


