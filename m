Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0JLSHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:07:47 -0400
Received: from mail.perches.com ([173.55.12.10]:2783 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab0JLSHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:07:45 -0400
Subject: Re: [PATCH] ath5k: fix build break from "ath5k: Print out opmode
 in debugfs"
From: Joe Perches <joe@perches.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTim0ryZ29w0ud9=sSbV6LdZhjW410ptpf3XJDYkm@mail.gmail.com>
References: <20101012163519.a88f2040.sfr@canb.auug.org.au>
	 <1286895206-3030-1-git-send-email-linville@tuxdriver.com>
	 <AANLkTikjp=dpOOfjnvg=ivkb40_dE+oRLSEkzrycwirV@mail.gmail.com>
	 <AANLkTim0ryZ29w0ud9=sSbV6LdZhjW410ptpf3XJDYkm@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 11:07:44 -0700
Message-ID: <1286906864.1117.65.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 13:42 -0400, Bob Copeland wrote:
> On Tue, Oct 12, 2010 at 12:54 PM, Bob Copeland <me@bobcopeland.com> wrote:
> >> +#ifdef CONFIG_ATH_DEBUG
> >>        ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
> >>                  sc->opmode,
> >>                  ath_opmode_to_string(sc->opmode) ?
> >>                  ath_opmode_to_string(sc->opmode) : "UKNOWN");
> 
> Just one other bikeshed color:
> 
> if ath_opmode_to_string() returned "UNKNOWN" in the failure case,
> we wouldn't need the double-call above.  Yes, it's used by ath9k
> too, but IMHO a debugging function that only converts some of the
> possible values to strings is pretty developer unfriendly.

Like this better?

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath5k/base.c  |    4 +---
 drivers/net/wireless/ath/ath5k/debug.c |   16 ++++------------
 drivers/net/wireless/ath/debug.c       |    2 +-
 drivers/net/wireless/ath/debug.h       |    7 +++++++
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c9732a6..7baaf04 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -563,9 +563,7 @@ static void ath_do_set_opmode(struct ath5k_softc *sc)
 	struct ath5k_hw *ah = sc->ah;
 	ath5k_hw_set_opmode(ah, sc->opmode);
 	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
-		  sc->opmode,
-		  ath_opmode_to_string(sc->opmode) ?
-		  ath_opmode_to_string(sc->opmode) : "UKNOWN");
+		  sc->opmode, ath_opmode_to_string(sc->opmode));
 }
 
 void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index a3b2171..7c77e5b7 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -493,7 +493,6 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	char buf[700];
 	unsigned int len = 0;
 	u32 filt = ath5k_hw_get_rx_filter(sc->ah);
-	const char *tmp;
 
 	len += snprintf(buf+len, sizeof(buf)-len, "bssid-mask: %pM\n",
 			sc->bssidmask);
@@ -522,17 +521,10 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	if (filt & AR5K_RX_FILTER_PHYERR_5211)
 		snprintf(buf+len, sizeof(buf)-len, " PHYERR-5211");
 	if (filt & AR5K_RX_FILTER_RADARERR_5211)
-		len += snprintf(buf+len, sizeof(buf)-len, " RADARERR-5211\n");
-	else
-		len += snprintf(buf+len, sizeof(buf)-len, "\n");
-
-	tmp = ath_opmode_to_string(sc->opmode);
-	if (tmp)
-		len += snprintf(buf+len, sizeof(buf)-len, "opmode: %s\n",
-				tmp);
-	else
-		len += snprintf(buf+len, sizeof(buf)-len,
-				"opmode: UNKNOWN-%i\n", sc->opmode);
+		len += snprintf(buf+len, sizeof(buf)-len, " RADARERR-5211");
+
+	len += snprintf(buf+len, sizeof(buf)-len, "\nopmode: %s (%d)\n",
+			ath_opmode_to_string(sc->opmode), sc->opmode);
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
diff --git a/drivers/net/wireless/ath/debug.c b/drivers/net/wireless/ath/debug.c
index a9eb787..dacfb23 100644
--- a/drivers/net/wireless/ath/debug.c
+++ b/drivers/net/wireless/ath/debug.c
@@ -55,7 +55,7 @@ const char *ath_opmode_to_string(enum nl80211_iftype opmode)
 	case NL80211_IFTYPE_P2P_GO:
 		return "P2P-GO";
 	default:
-		return NULL;
+		return "UNKNOWN";
 	}
 }
 EXPORT_SYMBOL(ath_opmode_to_string);
diff --git a/drivers/net/wireless/ath/debug.h b/drivers/net/wireless/ath/debug.h
index a3a5a62..64e4af2 100644
--- a/drivers/net/wireless/ath/debug.h
+++ b/drivers/net/wireless/ath/debug.h
@@ -78,6 +78,13 @@ ath_print(struct ath_common *common, int dbg_mask, const char *fmt, ...)
 #endif /* CONFIG_ATH_DEBUG */
 
 /** Returns string describing opmode, or NULL if unknown mode. */
+#ifdef CONFIG_ATH_DEBUG
 const char *ath_opmode_to_string(enum nl80211_iftype opmode);
+#else
+static inline const char *ath_opmode_to_string(enum nl80211_iftype opmode)
+{
+	return "UNKNOWN";
+}
+#endif
 
 #endif /* ATH_DEBUG_H */


