Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030882Ab2ERCzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:55:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40584 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030737Ab2ERCww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:52 -0400
Message-Id: <20120518023259.516750715@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arend van Spriel <arend@broadcom.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Alwin Beukers <alwin@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 38/53] brcm80211: smac: fix endless retry of A-MPDU transmissions
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arend van Spriel <arend@broadcom.com>

commit 5e379203c7788b7af01150bfadbc74d2797a2ef4 upstream.

The A-MPDU code checked against a retry limit, but it was using
the wrong variable to do so. This patch fixes this to assure
proper retry mechanism.

This problem had a side-effect causing the mac80211 flush callback
to remain waiting forever as well. That side effect has been fixed
by commit by Stanislaw Gruszka:

commit f96b08a7e6f69c0f0a576554df3df5b1b519c479
Date:   Tue Jan 17 12:38:50 2012 +0100

    brcmsmac: fix tx queue flush infinite loop

    Reference:
    https://bugzilla.kernel.org/show_bug.cgi?id=42576

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index d89dcb1..c1ce831 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -1051,17 +1051,13 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		}
 		/* either retransmit or send bar if ack not recd */
 		if (!ack_recd) {
-			struct ieee80211_tx_rate *txrate =
-			    tx_info->status.rates;
-			if (retry && (txrate[0].count < (int)retry_limit)) {
+			if (retry && (ini->txretry[index] < (int)retry_limit)) {
 				ini->txretry[index]++;
 				ini->tx_in_transit--;
 				/*
 				 * Use high prededence for retransmit to
 				 * give some punch
 				 */
-				/* brcms_c_txq_enq(wlc, scb, p,
-				 * BRCMS_PRIO_TO_PREC(tid)); */
 				brcms_c_txq_enq(wlc, scb, p,
 						BRCMS_PRIO_TO_HI_PREC(tid));
 			} else {
-- 
1.7.10



