Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab2BAVaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:30:20 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48319 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757377Ab2BAVTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:19 -0500
X-Sasl-enc: QBnpVbKuCOdfghaLluCyZP4BwwKlGJgBr77RCj7W1DmM 1328131158
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:45 2012
Message-Id: <20120201210045.388593487@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [17/89] brcmsmac: fix tx queue flush infinite loop
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit f96b08a7e6f69c0f0a576554df3df5b1b519c479 upstream.

This patch workaround live deadlock problem caused by infinite loop
in brcms_c_wait_for_tx_completion(). I do not consider the patch as
the proper fix, which should fix the real reason of tx queue flush
failure, but patch helps with system lockup.

Reference:
https://bugzilla.kernel.org/show_bug.cgi?id=42576

Reported-and-tested-by: Patrick <ragamuffin@datacomm.ch>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -8217,13 +8217,21 @@ int brcms_c_get_curband(struct brcms_c_i
 
 void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
 {
+	int timeout = 20;
+
 	/* flush packet queue when requested */
 	if (drop)
 		brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
 
 	/* wait for queue and DMA fifos to run dry */
-	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0)
+	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0) {
 		brcms_msleep(wlc->wl, 1);
+
+		if (--timeout == 0)
+			break;
+	}
+
+	WARN_ON_ONCE(timeout == 0);
 }
 
 void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)


