Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2L1TRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:17:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54943 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345Ab2L1TRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:05 -0500
Message-Id: <20121228190352.097882544@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU subframe fails
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Hartmann <andihartmann@01019freenet.de>

commit be03d4a45c09ee5100d3aaaedd087f19bc20d01f upstream.

There are connection stalls or very poor throughputs with rt2800
hardware using 802.11n in AP mode since patch "mac80211: retry sending
failed BAR frames later instead of tearing down aggr"[1][2].

Since rt2800 hardware is not able to correctly report the tx status of
BAR frames, this patch removes as workaround the existing error handling
on AP side, which lets mac80211 send a BAR when an AMPDU subframe fails.

As a result, most wifi clients (aside from Intel STAs on Windows)
instead will timeout now the reorder buffer and request the lost frame
again.

The correct solution would be, to tear down BA session on AP side.

This patch was born on the basis of "[RFT] rt2x00: Tear down BA
session on QoS frame failure"[3].

Thanks to Helmut Schaa for his support!

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/83297/focus=83304
[2] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=f0425beda4d404a6e751439b562100b902ba9c98
[3] http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/569

Signed-off-by: Andreas Hartmann <andihartmann@01019freenet.de>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 90cc5e7..dd87d41 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -391,9 +391,10 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 		tx_info->status.ampdu_len = 1;
 		tx_info->status.ampdu_ack_len = success ? 1 : 0;
-
-		if (!success)
-			tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+		/*
+		 * TODO: Need to tear down BA session here
+		 * if not successful.
+		 */
 	}
 
 	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {


