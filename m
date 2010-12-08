Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0LHB5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:57:48 -0500
Received: from kroah.org ([198.145.64.141]:48510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab0LHA7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:31 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:25 2010
Message-Id: <20101208005724.956539543@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Greear <greearb@candelatech.com>,
        Kyungwan Nam <kyungwan.nam@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [036/289] ath9k: add locking for starting the PCU on RX
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 7583c550c3e635dcc61ab127c36ecefd59fb8dc8 upstream.

There was some locking for starting some parts of
RX but not for starting the PCU. Include this otherwise
we can content against stopping the PCU.

This can potentially lead to races against different
buffers on the PCU which can lead to to the DMA RX
engine writing to buffers which are already freed.

This is part of a series that will help resolve the bug:

https://bugzilla.kernel.org/show_bug.cgi?id=14624

For more details about this issue refer to:

http://marc.info/?l=linux-wireless&m=128629803703756&w=2

Cc: Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

index e581b1f..b3c9baf 100644
---
 drivers/net/wireless/ath/ath9k/recv.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -288,11 +288,11 @@ static void ath_edma_start_recv(struct a
 	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_LP,
 			      sc->rx.rx_edma[ATH9K_RX_QUEUE_LP].rx_fifo_hwsize);
 
-	spin_unlock_bh(&sc->rx.rxbuflock);
-
 	ath_opmode_init(sc);
 
 	ath9k_hw_startpcureceive(sc->sc_ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
+
+	spin_unlock_bh(&sc->rx.rxbuflock);
 }
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
@@ -494,10 +494,11 @@ int ath_startrecv(struct ath_softc *sc)
 	ath9k_hw_rxena(ah);
 
 start_recv:
-	spin_unlock_bh(&sc->rx.rxbuflock);
 	ath_opmode_init(sc);
 	ath9k_hw_startpcureceive(ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
 
+	spin_unlock_bh(&sc->rx.rxbuflock);
+
 	return 0;
 }
 


