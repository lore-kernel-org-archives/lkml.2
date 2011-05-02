Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab1EBSaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:30:55 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47468 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1EBSay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:30:54 -0400
Date: Mon, 2 May 2011 14:20:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2011-05-02
Message-ID: <20110502182013.GA6768@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here are a few more intended for 2.6.39.  There is a one-liner for b43
which adds a missing MODULE_FIRMWARE declaration (so maybe someone's
initrd will get generated correctly), an iwlegacy fix from Wey-Yi that
corrects an LED flashing change that people are complaining about,
an iwl4965 WARNING fix from Stanislaw, and a matching pair of iwlagn
and iwl4965 regression fixes also from Stanislaw that correct problems
with using the wrong station ID for block ACK sessions.

Please let me know if there are problems!

John

P.S.  I know the LED flashing fix is questionable, but it is an
annoyance and it should not effect any other hardware.

---

The following changes since commit 7cfd260910b881250cde76ba92ebe3cbf8493a8f:

  ipv4: don't spam dmesg with "Using LC-trie" messages (2011-05-01 23:17:50 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Rafał Miłecki (1):
      b43: trivial: update module info about ucode16_mimo firmware

Stanislaw Gruszka (3):
      iwl4965: fix "TX Power requested while scanning"
      iwlagn: fix "Received BA when not expected"
      iwl4965: fix "Received BA when not expected"

Wey-Yi Guy (1):
      iwlegacy: led stay solid on when no traffic

 drivers/net/wireless/b43/main.c              |    1 +
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c  |   18 ++++++++++++------
 drivers/net/wireless/iwlegacy/iwl-led.c      |   20 +++++++++++++++++++-
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   17 +++++++++++------
 5 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 57eb5b6..7841b95 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -72,6 +72,7 @@ MODULE_FIRMWARE("b43/ucode11.fw");
 MODULE_FIRMWARE("b43/ucode13.fw");
 MODULE_FIRMWARE("b43/ucode14.fw");
 MODULE_FIRMWARE("b43/ucode15.fw");
+MODULE_FIRMWARE("b43/ucode16_mimo.fw");
 MODULE_FIRMWARE("b43/ucode5.fw");
 MODULE_FIRMWARE("b43/ucode9.fw");
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index fbec88d..79ac081 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -316,12 +316,18 @@ int iwl4965_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	hdr_len = ieee80211_hdrlen(fc);
 
-	/* Find index into station table for destination station */
-	sta_id = iwl_legacy_sta_id_or_broadcast(priv, ctx, info->control.sta);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
-			       hdr->addr1);
-		goto drop_unlock;
+	/* For management frames use broadcast id to do not break aggregation */
+	if (!ieee80211_is_data(fc))
+		sta_id = ctx->bcast_sta_id;
+	else {
+		/* Find index into station table for destination station */
+		sta_id = iwl_legacy_sta_id_or_broadcast(priv, ctx, info->control.sta);
+
+		if (sta_id == IWL_INVALID_STATION) {
+			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
+				       hdr->addr1);
+			goto drop_unlock;
+		}
 	}
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
diff --git a/drivers/net/wireless/iwlegacy/iwl-led.c b/drivers/net/wireless/iwlegacy/iwl-led.c
index 15eb8b7..bda0d61 100644
--- a/drivers/net/wireless/iwlegacy/iwl-led.c
+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
@@ -48,8 +48,21 @@ module_param(led_mode, int, S_IRUGO);
 MODULE_PARM_DESC(led_mode, "0=system default, "
 		"1=On(RF On)/Off(RF Off), 2=blinking");
 
+/* Throughput		OFF time(ms)	ON time (ms)
+ *	>300			25		25
+ *	>200 to 300		40		40
+ *	>100 to 200		55		55
+ *	>70 to 100		65		65
+ *	>50 to 70		75		75
+ *	>20 to 50		85		85
+ *	>10 to 20		95		95
+ *	>5 to 10		110		110
+ *	>1 to 5			130		130
+ *	>0 to 1			167		167
+ *	<=0					SOLID ON
+ */
 static const struct ieee80211_tpt_blink iwl_blink[] = {
-	{ .throughput = 0 * 1024 - 1, .blink_time = 334 },
+	{ .throughput = 0, .blink_time = 334 },
 	{ .throughput = 1 * 1024 - 1, .blink_time = 260 },
 	{ .throughput = 5 * 1024 - 1, .blink_time = 220 },
 	{ .throughput = 10 * 1024 - 1, .blink_time = 190 },
@@ -101,6 +114,11 @@ static int iwl_legacy_led_cmd(struct iwl_priv *priv,
 	if (priv->blink_on == on && priv->blink_off == off)
 		return 0;
 
+	if (off == 0) {
+		/* led is SOLID_ON */
+		on = IWL_LED_SOLID;
+	}
+
 	IWL_DEBUG_LED(priv, "Led blink time compensation=%u\n",
 			priv->cfg->base_params->led_compensation);
 	led_cmd.on = iwl_legacy_blink_compensation(priv, on,
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index d484c36..a62fe24 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2984,15 +2984,15 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 			txpower_work);
 
+	mutex_lock(&priv->mutex);
+
 	/* If a scan happened to start before we got here
 	 * then just return; the statistics notification will
 	 * kick off another scheduled work to compensate for
 	 * any temperature delta we missed here. */
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
 	    test_bit(STATUS_SCANNING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
+		goto out;
 
 	/* Regardless of if we are associated, we must reconfigure the
 	 * TX power since frames can be sent on non-radar channels while
@@ -3002,7 +3002,7 @@ static void iwl4965_bg_txpower_work(struct work_struct *work)
 	/* Update last_temperature to keep is_calib_needed from running
 	 * when it isn't needed... */
 	priv->last_temperature = priv->temperature;
-
+out:
 	mutex_unlock(&priv->mutex);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 2dd7d54..0712b67 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -568,12 +568,17 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	hdr_len = ieee80211_hdrlen(fc);
 
-	/* Find index into station table for destination station */
-	sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
-			       hdr->addr1);
-		goto drop_unlock;
+	/* For management frames use broadcast id to do not break aggregation */
+	if (!ieee80211_is_data(fc))
+		sta_id = ctx->bcast_sta_id;
+	else {
+		/* Find index into station table for destination station */
+		sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
+		if (sta_id == IWL_INVALID_STATION) {
+			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
+				       hdr->addr1);
+			goto drop_unlock;
+		}
 	}
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
