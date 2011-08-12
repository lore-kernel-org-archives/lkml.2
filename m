Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1HNQGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab1HNQGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:53 2011
Message-Id: <20110812210553.171257915@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [12/90] iwlegacy: set tx power after rxon_assoc
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 17e859a899712d16c3e70b045d61ad9e02c53f8a upstream.

If settings of tx power was deferred during scan or changing channel we
have to setup them during commit rxon. Fix problem on 3945 (4965 already
has this fix).

Optimize code to apply tx settings only when tx power was actually
changed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlegacy/iwl-3945.c |    6 +++++-
 drivers/net/wireless/iwlegacy/iwl-4965.c |    8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -1747,7 +1747,11 @@ int iwl3945_commit_rxon(struct iwl_priv
 		}
 
 		memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
-
+		/*
+		 * We do not commit tx power settings while channel changing,
+		 * do it now if tx power changed.
+		 */
+		iwl_legacy_set_tx_power(priv, priv->tx_power_next, false);
 		return 0;
 	}
 
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1237,7 +1237,12 @@ static int iwl4965_commit_rxon(struct iw
 
 		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
 		iwl_legacy_print_rx_config_cmd(priv, ctx);
-		goto set_tx_power;
+		/*
+		 * We do not commit tx power settings while channel changing,
+		 * do it now if tx power changed.
+		 */
+		iwl_legacy_set_tx_power(priv, priv->tx_power_next, false);
+		return 0;
 	}
 
 	/* If we are currently associated and the new config requires
@@ -1317,7 +1322,6 @@ static int iwl4965_commit_rxon(struct iw
 
 	iwl4965_init_sensitivity(priv);
 
-set_tx_power:
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
 	ret = iwl_legacy_set_tx_power(priv, priv->tx_power_next, true);


