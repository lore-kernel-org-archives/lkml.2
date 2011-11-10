Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab1KJJsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:48:47 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4393 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab1KJJsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:48:45 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Arend van Spriel" <arend@broadcom.com>, stable@kernel.org
Subject: [PATCH 3.1-stable] staging: brcm80211: fix for rate index in
 receive status
Date: Thu, 10 Nov 2011 10:48:34 +0100
Message-ID: <1320918514-5916-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
X-WSS-ID: 62A5404F3JW16256114-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix resolves an issue on 5GHz as posted on LKML:

BUG: All network processes hang (brcmsmac/wpa_supplicant)
ID: <20111018111422.GA1979@schottelius.org>

Cc: stable@kernel.org
Reported-by: Nico Schottelius <nico-linux-20111017@schottelius.org>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Greg,

This change is in the mainline brcmsmac driver, but I do not have a commit
message to refer to as we transitioned from staging to mainline in the last
merge window. Can you process this patch without that info?

Gr. AvS
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    6 ++++++
 drivers/staging/brcm80211/brcmsmac/main.c        |    8 ++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 40e3d37..3be8655 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -20,6 +20,12 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 
+/*
+ * Starting index for 5G rates in the
+ * legacy rate table.
+ */
+#define BRCMS_LEGACY_5G_RATE_OFFSET	4
+
 /* softmac ioctl definitions */
 #define BRCMS_SET_SHORTSLOT_OVERRIDE		146
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 1763c45..9654163 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4608,6 +4608,14 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 			wiphy_err(wlc->wiphy, "%s: Unknown rate\n", __func__);
 		}
 
+		/*
+		 * For 5GHz, we should decrease the index as it is
+		 * a subset of the 2.4G rates. See bitrates field
+		 * of brcms_band_5GHz_nphy (in mac80211_if.c).
+		 */
+		if (rx_status->band == IEEE80211_BAND_5GHZ)
+			rx_status->rate_idx -= BRCMS_LEGACY_5G_RATE_OFFSET;
+
 		/* Determine short preamble and rate_idx */
 		preamble = 0;
 		if (IS_CCK(rspec)) {
-- 
1.7.5.4


