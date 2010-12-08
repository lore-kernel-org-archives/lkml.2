Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab0LHBDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:30 -0500
Received: from kroah.org ([198.145.64.141]:33698 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697Ab0LHBDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:25 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:44 2010
Message-Id: <20101208005744.541761664@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [231/289] ath9k: fix timeout on stopping rx dma
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit d47844a014fada1a788719f6426bc7044f2a0fd8 upstream.

It seems that using ath9k_hw_stoppcurecv to stop rx dma is not enough.
When it's time to stop DMA, the PCU is still busy, so the rx enable
bit never clears.
Using ath9k_hw_abortpcurecv helps with getting rx stopped much faster,
with this change, I cannot reproduce the rx stop related WARN_ON anymore.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -508,7 +508,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 	bool stopped;
 
 	spin_lock_bh(&sc->rx.rxbuflock);
-	ath9k_hw_stoppcurecv(ah);
+	ath9k_hw_abortpcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah);
 


