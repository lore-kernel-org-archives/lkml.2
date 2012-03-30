Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965864Ab2C3VTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:19:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965758Ab2C3VTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:31 -0400
Message-Id: <20120330194833.599963954@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 049/175] ath9k: fix going to full-sleep on PS idle
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit c1afdaff90538ef085b756454f12b29575411214 upstream.

The check for PS_WAIT_FOR_TX_ACK was inverted, the hardware should only go
to full sleep if no tx is pending.

Reported-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -118,13 +118,15 @@ void ath9k_ps_restore(struct ath_softc *
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
-	if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
+	if (sc->ps_flags & PS_WAIT_FOR_TX_ACK)
+		goto unlock;
+
+	if (sc->ps_idle)
 		mode = ATH9K_PM_FULL_SLEEP;
 	else if (sc->ps_enabled &&
 		 !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
 			      PS_WAIT_FOR_CAB |
-			      PS_WAIT_FOR_PSPOLL_DATA |
-			      PS_WAIT_FOR_TX_ACK)))
+			      PS_WAIT_FOR_PSPOLL_DATA)))
 		mode = ATH9K_PM_NETWORK_SLEEP;
 	else
 		goto unlock;


