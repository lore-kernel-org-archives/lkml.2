Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2GRAFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:05:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2GRAEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eliad Peller <eliad@wizery.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 19/37] mac80211: destroy assoc_data correctly if assoc fails
Date: Tue, 17 Jul 2012 17:02:56 -0700
Message-Id: <20120717232432.929942695@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 10a9109f2705fdc3caa94d768b2559587a9a050c upstream.

If association failed due to internal error (e.g. no
supported rates IE), we call ieee80211_destroy_assoc_data()
with assoc=true, while we actually reject the association.

This results in the BSSID not being zeroed out.

After passing assoc=false, we no longer have to call
sta_info_destroy_addr() explicitly. While on it, move
the "associated" message after the assoc_success check.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2183,15 +2183,13 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 		       sdata->name, mgmt->sa, status_code);
 		ieee80211_destroy_assoc_data(sdata, false);
 	} else {
-		printk(KERN_DEBUG "%s: associated\n", sdata->name);
-
 		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
-			ieee80211_destroy_assoc_data(sdata, true);
-			sta_info_destroy_addr(sdata, mgmt->bssid);
+			ieee80211_destroy_assoc_data(sdata, false);
 			cfg80211_put_bss(*bss);
 			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
 		}
+		printk(KERN_DEBUG "%s: associated\n", sdata->name);
 
 		/*
 		 * destroy assoc_data afterwards, as otherwise an idle


