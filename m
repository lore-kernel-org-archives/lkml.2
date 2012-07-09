Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2GIOxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:53:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38095 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754308Ab2GIOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:57 -0400
Message-Id: <20120709143117.225039250@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stone Piao <piaoyun@marvell.com>,
        Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 04/48] mwifiex: fix WPS eapol handshake failure
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stone Piao <piaoyun@marvell.com>

commit f03ba7e9a24e5e9efaad56bd1713b994ea556b16 upstream.

After association, STA will go through eapol handshake with WPS
enabled AP. It's observed that WPS handshake fails with some 11n
AP. The reason for the failure is that the eapol packet is sent
via 11n frame aggregation.

The eapol packet should be sent directly without 11n aggregation.

This patch fixes the problem by adding WPS session control while
dequeuing Tx packets for transmission.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: reformat the if-statement per earlier
 upstream commit c65a30f35f938b421ac67c34a9e70b0e49e6019a]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1211,10 +1211,12 @@ mwifiex_dequeue_tx_packet(struct mwifiex
 		return 0;
 	}
 
-	if (!ptr->is_11n_enabled || mwifiex_is_ba_stream_setup(priv, ptr, tid)
-	    || ((priv->sec_info.wpa_enabled
-		  || priv->sec_info.wpa2_enabled) && !priv->wpa_is_gtk_set)
-		) {
+	if (!ptr->is_11n_enabled ||
+	    mwifiex_is_ba_stream_setup(priv, ptr, tid) ||
+	    priv->wps.session_enable ||
+	    ((priv->sec_info.wpa_enabled ||
+	      priv->sec_info.wpa2_enabled) &&
+	     !priv->wpa_is_gtk_set)) {
 		mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_single_packet() */


