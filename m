Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab1LMUR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:17:59 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:39190 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab1LMUR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:17:58 -0500
Date: Tue, 13 Dec 2011 15:17:52 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org
Subject: Re: REGRESSION: v3.2-rcX: iwlagn refuses to associate with my AP's
Message-ID: <20111213201752.GA5094@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org
References: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com>
 <1323800557.3355.31.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323800557.3355.31.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 07:22:37PM +0100, Johannes Berg wrote:
> 
> I think this is. It's interesting though that it is deauthenticating --
> is there anything in the log before? But since you bisected it to the TX
> sync commit, I'd say let's try the below patch. You might have to adjust
> the iwl-mac80211.c file to iwl-agn.c, I'm not entirely sure what version
> has the moved code.
> 
> Please let me know -- this commit is probably the right thing to do
> until we get rid of tx_sync completely.

Well, this patch seems to fix things for the non-authenticated case.
I can now associate with the GoogleGuest SSID without any problems.
I'm still having problems associating with the EAP-TLS encrypted
network, but that looks like it's a different bug.  (And that may
explain why I had so much trouble bisecting this; there are two issues
that have very similar symptoms.)

I did have to slightly modify your patch since at least as of 3.2-rc5,
the functions involved were in a different file (iwl-agn.c).

I tried Wey's patch, but it didn't seem to result in any change in
behavior, as you had suggested.

OK, now to see if I can figure out what's going on with the EAP-TLS
authentication case....

						- Ted

>From c1160e3b5dfadc8ac26f5a7ff0ff6ce1e8e7dbae Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@google.com>
Date: Tue, 13 Dec 2011 14:58:50 -0500
Subject: [PATCH] iwlwifi: disable tx_sync if p2p is not enabled

Test patch sent to LKML from by Johnnes Berg

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bacc06c..78ce547 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2850,6 +2850,9 @@ static int iwlagn_mac_tx_sync(struct ieee80211_hw *hw,
 	int ret;
 	u8 sta_id;
 
+	if (!vif->p2p)
+		return 0;
+
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
@@ -2898,6 +2901,9 @@ static void iwlagn_mac_finish_tx_sync(struct ieee80211_hw *hw,
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
 
+	if (!vif->p2p)
+		return;
+
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
-- 
1.7.3.1

