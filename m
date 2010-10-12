Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab0JLPAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:00:08 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44206 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab0JLPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:00:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: fix build break from "ath5k: Print out opmode in debugfs"
Date: Tue, 12 Oct 2010 10:53:26 -0400
Message-Id: <1286895206-3030-1-git-send-email-linville@tuxdriver.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101012163519.a88f2040.sfr@canb.auug.org.au>
References: <20101012163519.a88f2040.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this and with CONFIG_ATH_DEBUG not set...

ERROR: ".ath_opmode_to_string" [drivers/net/wireless/ath/ath5k/ath5k.ko] undefined!

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Please don't make me commit such an ugly patch...

 drivers/net/wireless/ath/ath5k/base.c  |    4 ++++
 drivers/net/wireless/ath/ath5k/debug.c |    6 +++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c9732a6..b839a6b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -562,10 +562,14 @@ static void ath_do_set_opmode(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 	ath5k_hw_set_opmode(ah, sc->opmode);
+#ifdef CONFIG_ATH_DEBUG
 	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
 		  sc->opmode,
 		  ath_opmode_to_string(sc->opmode) ?
 		  ath_opmode_to_string(sc->opmode) : "UKNOWN");
+#else
+	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d\n", sc->opmode);
+#endif
 }
 
 void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index a3b2171..329187a 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -493,7 +493,7 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	char buf[700];
 	unsigned int len = 0;
 	u32 filt = ath5k_hw_get_rx_filter(sc->ah);
-	const char *tmp;
+	const char *tmp __maybe_unused;
 
 	len += snprintf(buf+len, sizeof(buf)-len, "bssid-mask: %pM\n",
 			sc->bssidmask);
@@ -526,6 +526,7 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	else
 		len += snprintf(buf+len, sizeof(buf)-len, "\n");
 
+#ifdef CONFIG_ATH_DEBUG
 	tmp = ath_opmode_to_string(sc->opmode);
 	if (tmp)
 		len += snprintf(buf+len, sizeof(buf)-len, "opmode: %s\n",
@@ -533,6 +534,9 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	else
 		len += snprintf(buf+len, sizeof(buf)-len,
 				"opmode: UNKNOWN-%i\n", sc->opmode);
+#else
+	len += snprintf(buf+len, sizeof(buf)-len, "opmode: %i\n", sc->opmode);
+#endif
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
-- 
1.7.2.3

