Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab1LMSWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:22:41 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:39364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab1LMSWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:22:39 -0500
Subject: Re: REGRESSION: v3.2-rcX: iwlagn refuses to associate with my AP's
From: Johannes Berg <johannes@sipsolutions.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org
In-Reply-To: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com> (sfid-20111212_204303_180958_202A47DB)
References: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com>
	 (sfid-20111212_204303_180958_202A47DB)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 19:22:37 +0100
Message-ID: <1323800557.3355.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

> The failure to associate with access points happens at work, with
> whatever AP's are in use at the Cambridge Google office.  When I tried
> v3.2-rc5 at home, I was able to associate with a consumer-grade NetGear
> AP, although it was flaky --- that is, it completely failed to associate
> initially, but then I tried rebooting and I was eventually able to get
> it to work.   At work, I was able to reproduce the problem with a
> v3.2-rc5 and v3.2-rc2 kernel, but the problem did not manifest itself
> with a v3.1 kernel.
> 
> One interesting thing is that I'm getting the following WARNING message
> triggering in my dmesg logs:
> 
> [   48.518246] wlan0: deauthenticating from 00:1a:1e:26:2b:30 by local choice (r
> eason=3)
> [   48.525625] ------------[ cut here ]------------
> [   48.525653] WARNING: at net/wireless/mlme.c:309 __cfg80211_auth_remove+0xc2/0xcf [cfg80211]()

> This seems to be happening after the failure to associate with the AP,
> so it could be a red herring.

I think this is. It's interesting though that it is deauthenticating --
is there anything in the log before? But since you bisected it to the TX
sync commit, I'd say let's try the below patch. You might have to adjust
the iwl-mac80211.c file to iwl-agn.c, I'm not entirely sure what version
has the moved code.

Please let me know -- this commit is probably the right thing to do
until we get rid of tx_sync completely.

Thanks,
Johannes

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-mac80211.c	2011-12-13 09:06:14.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-mac80211.c	2011-12-13 19:20:24.000000000 +0100
@@ -1014,6 +1014,9 @@ static int iwlagn_mac_tx_sync(struct iee
 	int ret;
 	u8 sta_id;
 
+	if (!vif->p2p)
+		return 0;
+
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
@@ -1063,6 +1066,9 @@ static void iwlagn_mac_finish_tx_sync(st
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
 
+	if (!vif->p2p)
+		return;
+
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 


