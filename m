Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab1LGQRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:17:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057Ab1LGQRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:17:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:25 2011
Message-Id: <20111207160825.541355918@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:55 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [35/80] mac80211: fix race between the AGG SM and the Tx data path
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 2a1e0fd175dcfd72096ba9291d31e3b1b5342e60 upstream.

When a packet is supposed to sent be as an a-MPDU, mac80211 sets
IEEE80211_TX_CTL_AMPDU to let the driver know. On the other
hand, mac80211 configures the driver for aggregration with the
ampdu_action callback.
There is race between these two mechanisms since the following
scenario can occur when the BA agreement is torn down:

Tx softIRQ	 			drv configuration
==========				=================

check OPERATIONAL bit
Set the TX_CTL_AMPDU bit in the packet

					clear OPERATIONAL bit
					stop Tx AGG
Pass Tx packet to the driver.

In that case the driver would get a packet with TX_CTL_AMPDU set
although it has already been notified that the BA session has been
torn down.

To fix this, we need to synchronize all the Qdisc activity after we
cleared the OPERATIONAL bit. After that step, all the following
packets will be buffered until the driver reports it is ready to get
new packets for this RA / TID. This buffering allows not to run into
another race that would send packets with TX_CTL_AMPDU unset while
the driver hasn't been requested to tear down the BA session yet.

This race occurs in practice and iwlwifi complains with a WARN_ON
when it happens.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/agg-tx.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -194,6 +194,20 @@ int ___ieee80211_stop_tx_ba_session(stru
 	 */
 	clear_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
 
+	/*
+	 * There might be a few packets being processed right now (on
+	 * another CPU) that have already gotten past the aggregation
+	 * check when it was still OPERATIONAL and consequently have
+	 * IEEE80211_TX_CTL_AMPDU set. In that case, this code might
+	 * call into the driver at the same time or even before the
+	 * TX paths calls into it, which could confuse the driver.
+	 *
+	 * Wait for all currently running TX paths to finish before
+	 * telling the driver. New packets will not go through since
+	 * the aggregation session is no longer OPERATIONAL.
+	 */
+	synchronize_net();
+
 	tid_tx->stop_initiator = initiator;
 	tid_tx->tx_stop = tx;
 


