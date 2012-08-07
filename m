Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2HGXdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:33:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34616 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab2HGWaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:30:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eliad Peller <eliad@wizery.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 049/122] mac80211: fail authentication when AP denied authentication
Date: Tue,  7 Aug 2012 15:25:37 -0700
Message-Id: <20120807221952.625386716@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit dac211ec10d268b9d09000093a9fa2ac1773894f upstream.

ieee80211_rx_mgmt_auth() doesn't handle denied authentication
properly - it authenticates the station and waits for association
(for 5 seconds) instead of failing the authentication.

Fix it by destroying auth_data and bailing out instead.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1805,7 +1805,8 @@ ieee80211_rx_mgmt_auth(struct ieee80211_
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: %pM denied authentication (status %d)\n",
 		       sdata->name, mgmt->sa, status_code);
-		goto out;
+		ieee80211_destroy_auth_data(sdata, false);
+		return RX_MGMT_CFG80211_RX_AUTH;
 	}
 
 	switch (ifmgd->auth_data->algorithm) {
@@ -1827,7 +1828,6 @@ ieee80211_rx_mgmt_auth(struct ieee80211_
 	}
 
 	printk(KERN_DEBUG "%s: authenticated\n", sdata->name);
- out:
 	ifmgd->auth_data->done = true;
 	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
 	run_again(ifmgd, ifmgd->auth_data->timeout);


