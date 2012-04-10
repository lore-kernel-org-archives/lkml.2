Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab2DJQ2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:28:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44601 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2DJQ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:28:41 -0400
Date: Tue, 10 Apr 2012 11:28:33 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
        "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Michael Green <green@qca.qualcomm.com>,
        David Quan <dquan@qca.qualcomm.com>,
        Henry Ptasinski <henry@logout.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120410162833.GD21994@thinkpad-t410>
Mail-Followup-To: Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Henry Ptasinski <henry@logout.com>, linux-kernel@vger.kernel.org
References: <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
 <20120320220706.GA17272@thinkpad-t410>
 <4F69B604.4030303@broadcom.com>
 <20120321141916.GA23643@thinkpad-t410>
 <4F6A1514.9090907@broadcom.com>
 <20120321181753.GC24075@tux>
 <20120321193706.GC23643@thinkpad-t410>
 <20120322002715.GA3709@tux>
 <20120326193608.GE17126@thinkpad-t410>
 <20120404024632.GA13090@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404024632.GA13090@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 09:46:32PM -0500, Seth Forshee wrote:
> Below is a diff of the changes I've made locally to the brcmsmac
> regulatory support. I haven't started thinking about dividing it up into
> more digestible chunks, so for now it's just one massive diff. I've made
> a lot of progress towards moving brcmsmac away from its custom formats
> for regulatory information, but there are a few points I'm still having
> difficulty with.

Please find an updated diff below. I've made some progress, but it still
isn't complete.

> The patch builds, and kind of works. Scanning seems to be fine; I can
> see all the APs I expect in my area, including the one on a DFS channel
> that I couldn't see previously. I can associate with my 2.4 GHz APs, but
> not the 5 GHz AP. I see timme outs waiting for probe responses, and I'm
> hitting the WARN_ON_ONCE in brcms_c_wait_for_tx_completion(). I haven't
> really debugged this yet -- I thought I'd send out the patch to collect
> comments while I debug. Suggestions of what's causing this are also
> welcome :)

This was due to always passing true for the value of mute_tx to
brcms_b_set_chanspec() on passive channels. For now I'm just always
passing false, which looks like it ought to be okay as we shouldn't have
any tx on passive channels unless beacons are seen on the channel.

> One of the major unresolved issues in the patch is what to do with the
> data in struct locale_mimo_info. The regulatory rules only hold one
> power level. I'm unsure why the brcmsmac implementation differs in this
> regard. Suggestions?

This is still one of the largest unsolved issues. I'm probably going to
need some advice on how to fill out the txpwr information when
regualtory rules external to the driver can be applied.

> The txpwr calculations are modified, both to use the regdomain data so
> far as possible and to eliminate redundant code. I'd appreciate review
> of these changes in addition to the suggestions on how to handle the
> MIMO power limits as I've already mentioned.
> 
> Initialization has also changed somewhat. The piece that looks most
> significant to me is that wlc_phy_txpower_limit_set() gets called later,
> not until after the ieee80211_hw device is registered.
> 
> Beyond these I still have a number of comments with my initials (SAF)
> that contain questions, comments, and TODOs. Feedback regarding these
> items, or anything else, are greatly appreciated.
> 
> Looking forward to your comments.
> 
> Thanks,
> Seth

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 55e9f45..a31a15b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -15,7 +15,10 @@
  */
 
 #include <linux/types.h>
+#include <linux/bitops.h>
 #include <net/mac80211.h>
+#include <net/cfg80211.h>
+#include <net/regulatory.h>
 
 #include <defs.h>
 #include "pub.h"
@@ -23,54 +26,49 @@
 #include "main.h"
 #include "stf.h"
 #include "channel.h"
+#include "mac80211_if.h"
+
+/* SAF: Some of the 5G rules might be able to be combinded */
+#define BRCM_2GHZ_2412_2462	REG_RULE(2412-10, 2462+10, 40, 0, 19, 0)
+#define BRCM_2GHZ_2467_2472	REG_RULE(2467-10, 2472+10, 20, 0, 19, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_NO_IBSS)
+#define BRCM_2GHZ_2484		REG_RULE(2484-10, 2484+10, 40, 0, 19, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_NO_OFDM)
+
+#define BRCM_5GHZ_5180_5240	REG_RULE(5180-10, 5240+10, 40, 0, 21, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_NO_IBSS)
+#define BRCM_5GHZ_5260_5320	REG_RULE(5260-10, 5320+10, 40, 0, 21, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_DFS | \
+					 NL80211_RRF_NO_IBSS)
+#define BRCM_5GHZ_5500_5700	REG_RULE(5500-10, 5700+10, 40, 0, 21, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_DFS | \
+					 NL80211_RRF_NO_IBSS)
+#define BRCM_5GHZ_5745_5825	REG_RULE(5745-10, 5825+10, 40, 0, 21, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_NO_IBSS)
+
+static const struct ieee80211_regdomain brcms_regdom_x2 = {
+	.n_reg_rules = 7,
+	.alpha2 = "X2",
+	.reg_rules = {
+		BRCM_2GHZ_2412_2462,
+		BRCM_2GHZ_2467_2472,
+		BRCM_2GHZ_2484,
+		BRCM_5GHZ_5180_5240,
+		BRCM_5GHZ_5260_5320,
+		BRCM_5GHZ_5500_5700,
+		BRCM_5GHZ_5745_5825,
+	}
+};
 
 /* QDB() macro takes a dB value and converts to a quarter dB value */
 #define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
 
-#define  LOCALE_CHAN_01_11	 (1<<0)
-#define  LOCALE_CHAN_12_13	 (1<<1)
-#define  LOCALE_CHAN_14		 (1<<2)
-#define  LOCALE_SET_5G_LOW_JP1   (1<<3)	/* 34-48, step 2 */
-#define  LOCALE_SET_5G_LOW_JP2   (1<<4)	/* 34-46, step 4 */
-#define  LOCALE_SET_5G_LOW1      (1<<5)	/* 36-48, step 4 */
-#define  LOCALE_SET_5G_LOW2      (1<<6)	/* 52 */
-#define  LOCALE_SET_5G_LOW3      (1<<7)	/* 56-64, step 4 */
-#define  LOCALE_SET_5G_MID1      (1<<8)	/* 100-116, step 4 */
-#define  LOCALE_SET_5G_MID2	 (1<<9)	/* 120-124, step 4 */
-#define  LOCALE_SET_5G_MID3      (1<<10)	/* 128 */
-#define  LOCALE_SET_5G_HIGH1     (1<<11)	/* 132-140, step 4 */
-#define  LOCALE_SET_5G_HIGH2     (1<<12)	/* 149-161, step 4 */
-#define  LOCALE_SET_5G_HIGH3     (1<<13)	/* 165 */
-#define  LOCALE_CHAN_52_140_ALL  (1<<14)
-#define  LOCALE_SET_5G_HIGH4     (1<<15)	/* 184-216 */
-
-#define  LOCALE_CHAN_36_64	(LOCALE_SET_5G_LOW1 | \
-				 LOCALE_SET_5G_LOW2 | \
-				 LOCALE_SET_5G_LOW3)
-#define  LOCALE_CHAN_52_64	(LOCALE_SET_5G_LOW2 | LOCALE_SET_5G_LOW3)
-#define  LOCALE_CHAN_100_124	(LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2)
-#define  LOCALE_CHAN_100_140	(LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2 | \
-				  LOCALE_SET_5G_MID3 | LOCALE_SET_5G_HIGH1)
-#define  LOCALE_CHAN_149_165	(LOCALE_SET_5G_HIGH2 | LOCALE_SET_5G_HIGH3)
-#define  LOCALE_CHAN_184_216	LOCALE_SET_5G_HIGH4
-
-#define  LOCALE_CHAN_01_14	(LOCALE_CHAN_01_11 | \
-				 LOCALE_CHAN_12_13 | \
-				 LOCALE_CHAN_14)
-
-#define  LOCALE_RADAR_SET_NONE		  0
-#define  LOCALE_RADAR_SET_1		  1
-
-#define  LOCALE_RESTRICTED_NONE		  0
-#define  LOCALE_RESTRICTED_SET_2G_SHORT   1
-#define  LOCALE_RESTRICTED_CHAN_165       2
-#define  LOCALE_CHAN_ALL_5G		  3
-#define  LOCALE_RESTRICTED_JAPAN_LEGACY   4
-#define  LOCALE_RESTRICTED_11D_2G	  5
-#define  LOCALE_RESTRICTED_11D_5G	  6
-#define  LOCALE_RESTRICTED_LOW_HI	  7
-#define  LOCALE_RESTRICTED_12_13_14	  8
-
 #define LOCALE_2G_IDX_i			0
 #define LOCALE_5G_IDX_11		0
 #define LOCALE_MIMO_IDX_bn		0
@@ -118,18 +116,12 @@
 				 (((c) < 100) ? 2 : \
 				 (((c) < 149) ? 3 : 4))))
 
-#define ISDFS_EU(fl)		(((fl) & BRCMS_DFS_EU) == BRCMS_DFS_EU)
-
+/*
+ * SAF: This can be eliminated once we know what to do with locale_flags
+ */
 struct brcms_cm_band {
 	/* struct locale_info flags */
 	u8 locale_flags;
-	/* List of valid channels in the country */
-	struct brcms_chanvec valid_channels;
-	/* List of restricted use channels */
-	const struct brcms_chanvec *restricted_channels;
-	/* List of radar sensitive channels */
-	const struct brcms_chanvec *radar_channels;
-	u8 PAD[8];
 };
 
  /* locale per-channel tx power limits for MIMO frames
@@ -141,6 +133,8 @@ struct locale_mimo_info {
 	s8 maxpwr20[BRCMS_MAXPWR_MIMO_TBL_SIZE];
 	/* tx 40 MHz power limits, qdBm units */
 	s8 maxpwr40[BRCMS_MAXPWR_MIMO_TBL_SIZE];
+	/* SAF: Flags here and in locale_info are essentially unused,
+	 * should be able to eliminate them with a little effort */
 	u8 flags;
 };
 
@@ -152,304 +146,36 @@ struct country_info {
 	const u8 locale_mimo_5G;	/* 5G mimo info */
 };
 
+struct brcms_regd {
+	char abbrev[BRCM_CNTRY_BUF_SZ];	/* country abbreviation */
+	struct country_info country;
+	const struct ieee80211_regdomain *regdomain;
+};
+
 struct brcms_cm_info {
 	struct brcms_pub *pub;
 	struct brcms_c_info *wlc;
+	const struct brcms_regd *world_regd;
 	char srom_ccode[BRCM_CNTRY_BUF_SZ];	/* Country Code in SROM */
-	uint srom_regrev;	/* Regulatory Rev for the SROM ccode */
-	const struct country_info *country;	/* current country def */
-	char ccode[BRCM_CNTRY_BUF_SZ];	/* current internal Country Code */
-	uint regrev;		/* current Regulatory Revision */
-	char country_abbrev[BRCM_CNTRY_BUF_SZ];	/* current advertised ccode */
 	/* per-band state (one per phy/radio) */
 	struct brcms_cm_band bandstate[MAXBANDS];
-	/* quiet channels currently for radar sensitivity or 11h support */
-	/* channels on which we cannot transmit */
-	struct brcms_chanvec quiet_channels;
 };
 
 /* locale channel and power info. */
 struct locale_info {
-	u32 valid_channels;
-	/* List of radar sensitive channels */
-	u8 radar_channels;
-	/* List of channels used only if APs are detected */
-	u8 restricted_channels;
-	/* Max tx pwr in qdBm for each sub-band */
-	s8 maxpwr[BRCMS_MAXPWR_TBL_SIZE];
-	/* Country IE advertised max tx pwr in dBm per sub-band */
-	s8 pub_maxpwr[BAND_5G_PWR_LVLS];
+	/* SAF: We should be able to get rid of flags */
 	u8 flags;
 };
 
-/* Regulatory Matrix Spreadsheet (CLM) MIMO v3.7.9 */
-
-/*
- * Some common channel sets
- */
-
-/* No channels */
-static const struct brcms_chanvec chanvec_none = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* All 2.4 GHz HW channels */
-static const struct brcms_chanvec chanvec_all_2G = {
-	{0xfe, 0x7f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* All 5 GHz HW channels */
-static const struct brcms_chanvec chanvec_all_5G = {
-	{0x00, 0x00, 0x00, 0x00, 0x54, 0x55, 0x11, 0x11,
-	 0x01, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x11,
-	 0x11, 0x11, 0x20, 0x22, 0x22, 0x00, 0x00, 0x11,
-	 0x11, 0x11, 0x11, 0x01}
-};
-
-/*
- * Radar channel sets
- */
-
-/* Channels 52 - 64, 100 - 140 */
-static const struct brcms_chanvec radar_set1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x11,  /* 52 - 60 */
-	 0x01, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x11,  /* 64, 100 - 124 */
-	 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  /* 128 - 140 */
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/*
- * Restricted channel sets
- */
-
-/* Channels 34, 38, 42, 46 */
-static const struct brcms_chanvec restricted_set_japan_legacy = {
-	{0x00, 0x00, 0x00, 0x00, 0x44, 0x44, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* Channels 12, 13 */
-static const struct brcms_chanvec restricted_set_2g_short = {
-	{0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* Channel 165 */
-static const struct brcms_chanvec restricted_chan_165 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* Channels 36 - 48 & 149 - 165 */
-static const struct brcms_chanvec restricted_low_hi = {
-	{0x00, 0x00, 0x00, 0x00, 0x10, 0x11, 0x01, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x20, 0x22, 0x22, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* Channels 12 - 14 */
-static const struct brcms_chanvec restricted_set_12_13_14 = {
-	{0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* global memory to provide working buffer for expanded locale */
-
-static const struct brcms_chanvec *g_table_radar_set[] = {
-	&chanvec_none,
-	&radar_set1
-};
-
-static const struct brcms_chanvec *g_table_restricted_chan[] = {
-	&chanvec_none,		/* restricted_set_none */
-	&restricted_set_2g_short,
-	&restricted_chan_165,
-	&chanvec_all_5G,
-	&restricted_set_japan_legacy,
-	&chanvec_all_2G,	/* restricted_set_11d_2G */
-	&chanvec_all_5G,	/* restricted_set_11d_5G */
-	&restricted_low_hi,
-	&restricted_set_12_13_14
-};
-
-static const struct brcms_chanvec locale_2g_01_11 = {
-	{0xfe, 0x0f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_2g_12_13 = {
-	{0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_2g_14 = {
-	{0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW_JP1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x54, 0x55, 0x01, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW_JP2 = {
-	{0x00, 0x00, 0x00, 0x00, 0x44, 0x44, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x10, 0x11, 0x01, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW2 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW3 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11,
-	 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_MID1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_MID2 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_MID3 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_HIGH1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x10, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_HIGH2 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x20, 0x22, 0x02, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_HIGH3 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_52_140_ALL = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x11,
-	 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11,
-	 0x11, 0x11, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_HIGH4 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11,
-	 0x11, 0x11, 0x11, 0x11}
-};
-
-static const struct brcms_chanvec *g_table_locale_base[] = {
-	&locale_2g_01_11,
-	&locale_2g_12_13,
-	&locale_2g_14,
-	&locale_5g_LOW_JP1,
-	&locale_5g_LOW_JP2,
-	&locale_5g_LOW1,
-	&locale_5g_LOW2,
-	&locale_5g_LOW3,
-	&locale_5g_MID1,
-	&locale_5g_MID2,
-	&locale_5g_MID3,
-	&locale_5g_HIGH1,
-	&locale_5g_HIGH2,
-	&locale_5g_HIGH3,
-	&locale_5g_52_140_ALL,
-	&locale_5g_HIGH4
-};
-
-static void brcms_c_locale_add_channels(struct brcms_chanvec *target,
-				    const struct brcms_chanvec *channels)
+static inline struct wiphy *brcms_c_get_wiphy(struct brcms_cm_info *wlc_cm)
 {
-	u8 i;
-	for (i = 0; i < sizeof(struct brcms_chanvec); i++)
-		target->vec[i] |= channels->vec[i];
-}
-
-static void brcms_c_locale_get_channels(const struct locale_info *locale,
-				    struct brcms_chanvec *channels)
-{
-	u8 i;
-
-	memset(channels, 0, sizeof(struct brcms_chanvec));
-
-	for (i = 0; i < ARRAY_SIZE(g_table_locale_base); i++) {
-		if (locale->valid_channels & (1 << i))
-			brcms_c_locale_add_channels(channels,
-						g_table_locale_base[i]);
-	}
+	return wlc_cm->pub->ieee_hw->wiphy;
 }
 
 /*
  * Locale Definitions - 2.4 GHz
  */
 static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
-	LOCALE_CHAN_01_11 | LOCALE_CHAN_12_13,
-	LOCALE_RADAR_SET_NONE,
-	LOCALE_RESTRICTED_SET_2G_SHORT,
-	{QDB(19), QDB(19), QDB(19),
-	 QDB(19), QDB(19), QDB(19)},
-	{20, 20, 20, 0},
 	BRCMS_EIRP
 };
 
@@ -457,12 +183,6 @@ static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
  * Locale Definitions - 5 GHz
  */
 static const struct locale_info locale_11 = {
-	/* locale 11. channel 36 - 48, 52 - 64, 100 - 140, 149 - 165 */
-	LOCALE_CHAN_36_64 | LOCALE_CHAN_100_140 | LOCALE_CHAN_149_165,
-	LOCALE_RADAR_SET_1,
-	LOCALE_RESTRICTED_NONE,
-	{QDB(21), QDB(21), QDB(21), QDB(21), QDB(21)},
-	{23, 23, 23, 30, 30},
 	BRCMS_EIRP | BRCMS_DFS_EU
 };
 
@@ -504,90 +224,34 @@ static const struct locale_mimo_info *g_mimo_5g_table[] = {
 	&locale_11n
 };
 
-static const struct {
-	char abbrev[BRCM_CNTRY_BUF_SZ];	/* country abbreviation */
-	struct country_info country;
-} cntry_locales[] = {
+static const struct brcms_regd cntry_locales[] = {
+	/* Worldwide Row 2, must always be at index 0 */
 	{
-	"X2", LOCALES(i, 11, bn, 11n)},	/* Worldwide RoW 2 */
+		.abbrev = "X2",
+		.country = LOCALES(i, 11, bn, 11n),
+		.regdomain = &brcms_regdom_x2,
+	},
 };
 
-#ifdef SUPPORT_40MHZ
-/* 20MHz channel info for 40MHz pairing support */
-struct chan20_info {
-	u8 sb;
-	u8 adj_sbs;
-};
+static const struct brcms_regd *brcms_world_regd(const char *regdom)
+{
+	const struct brcms_regd *regd = NULL;
+	int i;
 
-/* indicates adjacent channels that are allowed for a 40 Mhz channel and
- * those that permitted by the HT
- */
-struct chan20_info chan20_info[] = {
-	/* 11b/11g */
-/* 0 */ {1, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 1 */ {2, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 2 */ {3, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 3 */ {4, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 4 */ {5, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 5 */ {6, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 6 */ {7, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 7 */ {8, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 8 */ {9, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 9 */ {10, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 10 */ {11, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 11 */ {12, (CH_LOWER_SB)},
-/* 12 */ {13, (CH_LOWER_SB)},
-/* 13 */ {14, (CH_LOWER_SB)},
-
-/* 11a japan high */
-/* 14 */ {34, (CH_UPPER_SB)},
-/* 15 */ {38, (CH_LOWER_SB)},
-/* 16 */ {42, (CH_LOWER_SB)},
-/* 17 */ {46, (CH_LOWER_SB)},
-
-/* 11a usa low */
-/* 18 */ {36, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 19 */ {40, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 20 */ {44, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 21 */ {48, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 22 */ {52, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 23 */ {56, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 24 */ {60, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 25 */ {64, (CH_LOWER_SB | CH_EWA_VALID)},
-
-/* 11a Europe */
-/* 26 */ {100, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 27 */ {104, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 28 */ {108, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 29 */ {112, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 30 */ {116, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 31 */ {120, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 32 */ {124, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 33 */ {128, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 34 */ {132, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 35 */ {136, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 36 */ {140, (CH_LOWER_SB)},
-
-/* 11a usa high, ref5 only */
-/* The 0x80 bit in pdiv means these are REF5, other entries are REF20 */
-/* 37 */ {149, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 38 */ {153, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 39 */ {157, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 40 */ {161, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 41 */ {165, (CH_LOWER_SB)},
-
-/* 11a japan */
-/* 42 */ {184, (CH_UPPER_SB)},
-/* 43 */ {188, (CH_LOWER_SB)},
-/* 44 */ {192, (CH_UPPER_SB)},
-/* 45 */ {196, (CH_LOWER_SB)},
-/* 46 */ {200, (CH_UPPER_SB)},
-/* 47 */ {204, (CH_LOWER_SB)},
-/* 48 */ {208, (CH_UPPER_SB)},
-/* 49 */ {212, (CH_LOWER_SB)},
-/* 50 */ {216, (CH_LOWER_SB)}
-};
-#endif				/* SUPPORT_40MHZ */
+	for (i = 0; i < ARRAY_SIZE(cntry_locales); i++) {
+		if (!strcmp(regdom, cntry_locales[i].abbrev)) {
+			regd = &cntry_locales[i];
+			break;
+		}
+	}
+
+	return regd;
+}
+
+static const struct brcms_regd *brcms_default_world_regd(void)
+{
+	return &cntry_locales[0];
+}
 
 static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx)
 {
@@ -621,164 +285,6 @@ static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx)
 	return g_mimo_5g_table[locale_idx];
 }
 
-static int
-brcms_c_country_aggregate_map(struct brcms_cm_info *wlc_cm, const char *ccode,
-			  char *mapped_ccode, uint *mapped_regrev)
-{
-	return false;
-}
-
-/* Lookup a country info structure from a null terminated country
- * abbreviation and regrev directly with no translation.
- */
-static const struct country_info *
-brcms_c_country_lookup_direct(const char *ccode, uint regrev)
-{
-	uint size, i;
-
-	/* Should just return 0 for single locale driver. */
-	/* Keep it this way in case we add more locales. (for now anyway) */
-
-	/*
-	 * all other country def arrays are for regrev == 0, so if
-	 * regrev is non-zero, fail
-	 */
-	if (regrev > 0)
-		return NULL;
-
-	/* find matched table entry from country code */
-	size = ARRAY_SIZE(cntry_locales);
-	for (i = 0; i < size; i++) {
-		if (strcmp(ccode, cntry_locales[i].abbrev) == 0)
-			return &cntry_locales[i].country;
-	}
-	return NULL;
-}
-
-static const struct country_info *
-brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
-			char *mapped_ccode, uint *mapped_regrev)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
-	const struct country_info *country;
-	uint srom_regrev = wlc_cm->srom_regrev;
-	const char *srom_ccode = wlc_cm->srom_ccode;
-	int mapped;
-
-	/* check for currently supported ccode size */
-	if (strlen(ccode) > (BRCM_CNTRY_BUF_SZ - 1)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: ccode \"%s\" too long for "
-			  "match\n", wlc->pub->unit, __func__, ccode);
-		return NULL;
-	}
-
-	/* default mapping is the given ccode and regrev 0 */
-	strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
-	*mapped_regrev = 0;
-
-	/* If the desired country code matches the srom country code,
-	 * then the mapped country is the srom regulatory rev.
-	 * Otherwise look for an aggregate mapping.
-	 */
-	if (!strcmp(srom_ccode, ccode)) {
-		*mapped_regrev = srom_regrev;
-		mapped = 0;
-		wiphy_err(wlc->wiphy, "srom_code == ccode %s\n", __func__);
-	} else {
-		mapped =
-		    brcms_c_country_aggregate_map(wlc_cm, ccode, mapped_ccode,
-					      mapped_regrev);
-	}
-
-	/* find the matching built-in country definition */
-	country = brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
-
-	/* if there is not an exact rev match, default to rev zero */
-	if (country == NULL && *mapped_regrev != 0) {
-		*mapped_regrev = 0;
-		country =
-		    brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
-	}
-
-	return country;
-}
-
-/* Lookup a country info structure from a null terminated country code
- * The lookup is case sensitive.
- */
-static const struct country_info *
-brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode)
-{
-	const struct country_info *country;
-	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
-	uint mapped_regrev;
-
-	/*
-	 * map the country code to a built-in country code, regrev, and
-	 * country_info struct
-	 */
-	country = brcms_c_countrycode_map(wlc->cmi, ccode, mapped_ccode,
-					  &mapped_regrev);
-
-	return country;
-}
-
-/*
- * reset the quiet channels vector to the union
- * of the restricted and radar channel sets
- */
-static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
-	uint i, j;
-	struct brcms_band *band;
-	const struct brcms_chanvec *chanvec;
-
-	memset(&wlc_cm->quiet_channels, 0, sizeof(struct brcms_chanvec));
-
-	band = wlc->band;
-	for (i = 0; i < wlc->pub->_nbands;
-	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
-
-		/* initialize quiet channels for restricted channels */
-		chanvec = wlc_cm->bandstate[band->bandunit].restricted_channels;
-		for (j = 0; j < sizeof(struct brcms_chanvec); j++)
-			wlc_cm->quiet_channels.vec[j] |= chanvec->vec[j];
-
-	}
-}
-
-/* Is the channel valid for the current locale and current band? */
-static bool brcms_c_valid_channel20(struct brcms_cm_info *wlc_cm, uint val)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
-
-	return ((val < MAXCHANNEL) &&
-		isset(wlc_cm->bandstate[wlc->band->bandunit].valid_channels.vec,
-		      val));
-}
-
-/* Is the channel valid for the current locale and specified band? */
-static bool brcms_c_valid_channel20_in_band(struct brcms_cm_info *wlc_cm,
-					    uint bandunit, uint val)
-{
-	return ((val < MAXCHANNEL)
-		&& isset(wlc_cm->bandstate[bandunit].valid_channels.vec, val));
-}
-
-/* Is the channel valid for the current locale? (but don't consider channels not
- *   available due to bandlocking)
- */
-static bool brcms_c_valid_channel20_db(struct brcms_cm_info *wlc_cm, uint val)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
-
-	return brcms_c_valid_channel20(wlc->cmi, val) ||
-		(!wlc->bandlocked
-		 && brcms_c_valid_channel20_in_band(wlc->cmi,
-						    OTHERBANDUNIT(wlc), val));
-}
-
 /* JP, J1 - J10 are Japan ccodes */
 static bool brcms_c_japan_ccode(const char *ccode)
 {
@@ -786,12 +292,6 @@ static bool brcms_c_japan_ccode(const char *ccode)
 		(ccode[1] == 'P' || (ccode[1] >= '1' && ccode[1] <= '9')));
 }
 
-/* Returns true if currently set country is Japan or variant */
-static bool brcms_c_japan(struct brcms_c_info *wlc)
-{
-	return brcms_c_japan_ccode(wlc->cmi->country_abbrev);
-}
-
 static void
 brcms_c_channel_min_txpower_limits_with_local_constraint(
 		struct brcms_cm_info *wlc_cm, struct txpwr_limits *txpwr,
@@ -867,74 +367,45 @@ brcms_c_channel_min_txpower_limits_with_local_constraint(
 
 }
 
+/*
+ * SAF: Is this needed? We don't have channel information until
+ * ieee80211_register_hw is called.
+ */
+#if 0
 /* Update the radio state (enable/disable) and tx power targets
  * based on a new set of channel/regulatory information
  */
 static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 {
+	struct ieee80211_channel *ch = wlc_cm->pub->ieee_hw->conf.channel;
+	u16 chanspec = ch20mhz_chspec(ch->hw_value);
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	uint chan;
 	struct txpwr_limits txpwr;
 
-	/* search for the existence of any valid channel */
-	for (chan = 0; chan < MAXCHANNEL; chan++) {
-		if (brcms_c_valid_channel20_db(wlc->cmi, chan))
-			break;
-	}
-	if (chan == MAXCHANNEL)
-		chan = INVCHANNEL;
-
-	/*
-	 * based on the channel search above, set or
-	 * clear WL_RADIO_COUNTRY_DISABLE.
-	 */
-	if (chan == INVCHANNEL) {
-		/*
-		 * country/locale with no valid channels, set
-		 * the radio disable bit
-		 */
-		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
-		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\" "
-			  "nbands %d bandlocked %d\n", wlc->pub->unit,
-			  __func__, wlc_cm->country_abbrev, wlc->pub->_nbands,
-			  wlc->bandlocked);
-	} else if (mboolisset(wlc->pub->radio_disabled,
-			      WL_RADIO_COUNTRY_DISABLE)) {
-		/*
-		 * country/locale with valid channel, clear
-		 * the radio disable bit
-		 */
-		mboolclr(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
-	}
-
-	/*
-	 * Now that the country abbreviation is set, if the radio supports 2G,
-	 * then set channel 14 restrictions based on the new locale.
-	 */
-	if (wlc->pub->_nbands > 1 || wlc->band->bandtype == BRCM_BAND_2G)
-		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
-						     brcms_c_japan(wlc) ? true :
-						     false);
-
-	if (wlc->pub->up && chan != INVCHANNEL) {
-		brcms_c_channel_reg_limits(wlc_cm, wlc->chanspec, &txpwr);
+	if (wlc->pub->up) {
+		brcms_c_channel_reg_limits(wlc_cm, chanspec, ch, &txpwr);
 		brcms_c_channel_min_txpower_limits_with_local_constraint(wlc_cm,
 			&txpwr, BRCMS_TXPWR_MAX);
-		wlc_phy_txpower_limit_set(wlc->band->pi, &txpwr, wlc->chanspec);
+		wlc_phy_txpower_limit_set(wlc->band->pi, &txpwr, chanspec);
 	}
 }
+#endif
 
 static int
 brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 		      const struct country_info *country)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	uint i, j;
+	uint i;
 	struct brcms_band *band;
 	const struct locale_info *li;
-	struct brcms_chanvec sup_chan;
 	const struct locale_mimo_info *li_mimo;
 
+	/*
+	 * SAF: The only thing we're left doing here right now is locale
+	 * flags, which are used very little. It shouldn't be difficult
+	 * to eliminate them entirely.
+	 */
 	band = wlc->band;
 	for (i = 0; i < wlc->pub->_nbands;
 	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
@@ -950,28 +421,15 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 		/* merge the mimo non-mimo locale flags */
 		wlc_cm->bandstate[band->bandunit].locale_flags |=
 		    li_mimo->flags;
-
-		wlc_cm->bandstate[band->bandunit].restricted_channels =
-		    g_table_restricted_chan[li->restricted_channels];
-		wlc_cm->bandstate[band->bandunit].radar_channels =
-		    g_table_radar_set[li->radar_channels];
-
-		/*
-		 * set the channel availability, masking out the channels
-		 * that may not be supported on this phy.
-		 */
-		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
-					      &sup_chan);
-		brcms_c_locale_get_channels(li,
-					&wlc_cm->bandstate[band->bandunit].
-					valid_channels);
-		for (j = 0; j < sizeof(struct brcms_chanvec); j++)
-			wlc_cm->bandstate[band->bandunit].valid_channels.
-			    vec[j] &= sup_chan.vec[j];
 	}
 
-	brcms_c_quiet_channels_reset(wlc_cm);
+	/*
+	 * SAF: Can't really do this here since we don't have a channel
+	 * or regulatory information yet.
+	 */
+#if 0
 	brcms_c_channels_commit(wlc_cm);
+#endif
 
 	return 0;
 }
@@ -982,25 +440,11 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
  * information found with the country code.
  */
 static void
-brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
-		       const char *country_abbrev,
-		       const char *ccode, uint regrev,
-		       const struct country_info *country)
+brcms_c_set_country(struct brcms_cm_info *wlc_cm,
+		    const struct brcms_regd *regd)
 {
-	const struct locale_info *locale;
+	const struct country_info *country = &regd->country;
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	char prev_country_abbrev[BRCM_CNTRY_BUF_SZ];
-
-	/* save current country state */
-	wlc_cm->country = country;
-
-	memset(&prev_country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
-	strncpy(prev_country_abbrev, wlc_cm->country_abbrev,
-		BRCM_CNTRY_BUF_SZ - 1);
-
-	strncpy(wlc_cm->country_abbrev, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
-	strncpy(wlc_cm->ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
-	wlc_cm->regrev = regrev;
 
 	if ((wlc->pub->_n_enab & SUPPORT_11N) !=
 	    wlc->protection->nmode_user)
@@ -1009,74 +453,18 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
 	/* set or restore gmode as required by regulatory */
-	locale = brcms_c_get_locale_2g(country->locale_2G);
-	if (locale && (locale->flags & BRCMS_NO_OFDM))
-		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
-	else
-		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
+	brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
 
 	brcms_c_channels_init(wlc_cm, country);
 
 	return;
 }
 
-static int
-brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
-			const char *country_abbrev,
-			const char *ccode, int regrev)
-{
-	const struct country_info *country;
-	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
-	uint mapped_regrev;
-
-	/* if regrev is -1, lookup the mapped country code,
-	 * otherwise use the ccode and regrev directly
-	 */
-	if (regrev == -1) {
-		/*
-		 * map the country code to a built-in country
-		 * code, regrev, and country_info
-		 */
-		country =
-		    brcms_c_countrycode_map(wlc_cm, ccode, mapped_ccode,
-					&mapped_regrev);
-	} else {
-		/* find the matching built-in country definition */
-		country = brcms_c_country_lookup_direct(ccode, regrev);
-		strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
-		mapped_regrev = regrev;
-	}
-
-	if (country == NULL)
-		return -EINVAL;
-
-	/* set the driver state for the country */
-	brcms_c_set_country_common(wlc_cm, country_abbrev, mapped_ccode,
-			       mapped_regrev, country);
-
-	return 0;
-}
-
-/*
- * set the driver's current country and regulatory information using
- * a country code as the source. Lookup built in country information
- * found with the country code.
- */
-static int
-brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm, const char *ccode)
-{
-	char country_abbrev[BRCM_CNTRY_BUF_SZ];
-	strncpy(country_abbrev, ccode, BRCM_CNTRY_BUF_SZ);
-	return brcms_c_set_countrycode_rev(wlc_cm, country_abbrev, ccode, -1);
-}
-
 struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 {
 	struct brcms_cm_info *wlc_cm;
-	char country_abbrev[BRCM_CNTRY_BUF_SZ];
-	const struct country_info *country;
 	struct brcms_pub *pub = wlc->pub;
-	char *ccode;
+	const char *ccode;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -1089,24 +477,32 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 
 	/* store the country code for passing up as a regulatory hint */
 	ccode = getvar(wlc->hw->sih, BRCMS_SROM_CCODE);
-	if (ccode)
+	if (ccode) {
 		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
+		wlc_cm->world_regd = brcms_world_regd(ccode);
+	}
 
 	/*
-	 * internal country information which must match
-	 * regulatory constraints in firmware
+	 * If no custom world domain is found in the SROM, use the
+	 * default "X2" domain.
 	 */
-	memset(country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
-	strncpy(country_abbrev, "X2", sizeof(country_abbrev) - 1);
-	country = brcms_c_country_lookup(wlc, country_abbrev);
+	if (!wlc_cm->world_regd) {
+		ccode = "X2";
+		wlc_cm->world_regd = brcms_default_world_regd();
+	}
 
+	/*
+	 * SAF: country_default and autocountry_default aren't really
+	 * used, can they be removed? Need to consider what needs to
+	 * be done to exit 11d regulatory mode.
+	 */
 	/* save default country for exiting 11d regulatory mode */
-	strncpy(wlc->country_default, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
+	strncpy(wlc->country_default, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
 	/* initialize autocountry_default to driver default */
-	strncpy(wlc->autocountry_default, "X2", BRCM_CNTRY_BUF_SZ - 1);
+	strncpy(wlc->autocountry_default, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
-	brcms_c_set_countrycode(wlc_cm, country_abbrev);
+	brcms_c_set_country(wlc_cm, wlc_cm->world_regd);
 
 	return wlc_cm;
 }
@@ -1116,6 +512,9 @@ void brcms_c_channel_mgr_detach(struct brcms_cm_info *wlc_cm)
 	kfree(wlc_cm);
 }
 
+/*
+ * SAF: Need to use info from struct ieee80211_channel for this instead
+ */
 u8
 brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
 				     uint bandunit)
@@ -1123,38 +522,39 @@ brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
 	return wlc_cm->bandstate[bandunit].locale_flags;
 }
 
-static bool
-brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, u16 chspec)
-{
-	return (wlc_cm->wlc->pub->_n_enab & SUPPORT_11N) &&
-		CHSPEC_IS40(chspec) ?
-		(isset(wlc_cm->quiet_channels.vec,
-		       lower_20_sb(CHSPEC_CHANNEL(chspec))) ||
-		 isset(wlc_cm->quiet_channels.vec,
-		       upper_20_sb(CHSPEC_CHANNEL(chspec)))) :
-		isset(wlc_cm->quiet_channels.vec, CHSPEC_CHANNEL(chspec));
-}
-
 void
 brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
-			 u8 local_constraint_qdbm)
+			     u8 local_constraint_qdbm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
+	struct ieee80211_conf *conf = &wlc_cm->pub->ieee_hw->conf;
+	struct ieee80211_channel *ch = conf->channel;
 	struct txpwr_limits txpwr;
 
-	brcms_c_channel_reg_limits(wlc_cm, chanspec, &txpwr);
+	brcms_c_channel_reg_limits(wlc_cm, chanspec, ch, &txpwr);
 
 	brcms_c_channel_min_txpower_limits_with_local_constraint(
 		wlc_cm, &txpwr, local_constraint_qdbm
 	);
 
-	brcms_b_set_chanspec(wlc->hw, chanspec,
-			      (brcms_c_quiet_chanspec(wlc_cm, chanspec) != 0),
-			      &txpwr);
+	/*
+	 * SAF: Passing false for mute_tx. Not sure if this is okay,
+	 * but I'm also not sure how to tell whether or not mute_tx
+	 * should be set ...
+	 */
+	brcms_b_set_chanspec(wlc->hw, chanspec, false, &txpwr);
 }
 
+/*
+ * SAF: Much of the data here still comes from internal structures, but
+ * I'm not sure where else to store this data.
+ *
+ * Also I wonder whether we ought to be getting the power from
+ * ieee80211_conf instead.
+ */
 void
 brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
+		       struct ieee80211_channel *channel,
 		       struct txpwr_limits *txpwr)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
@@ -1166,7 +566,6 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	struct brcms_band *band;
 	const struct locale_info *li;
 	int conducted_max = BRCMS_TXPWR_MAX;
-	int conducted_ofdm_max = BRCMS_TXPWR_MAX;
 	const struct locale_mimo_info *li_mimo;
 	int maxpwr20, maxpwr40;
 	int maxpwr_idx;
@@ -1174,14 +573,23 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 
 	memset(txpwr, 0, sizeof(struct txpwr_limits));
 
-	if (!brcms_c_valid_chanspec_db(wlc_cm, chanspec)) {
-		country = brcms_c_country_lookup(wlc, wlc->autocountry_default);
-		if (country == NULL)
-			return;
-	} else {
-		country = wlc_cm->country;
-	}
+	/*
+	 * SAF: What to do if we don't have a channel?
+	 */
+	if (WARN_ON(!channel))
+		return;
+
+	/*
+	 * SAF: Will this even work properly if the chanspec isn't valid?
+	 * Previously the code would proceed, but for now let's warn and
+	 * return. In reality if channel is valid then chanspec should be
+	 * valid as well, but we can also get all the information we need
+	 * without using chanspec at all.
+	 */
+	if (WARN_ON(!brcms_c_valid_chanspec_db(wlc_cm, chanspec)))
+		return;
 
+	country = &wlc_cm->world_regd->country;
 	chan = CHSPEC_CHANNEL(chanspec);
 	band = wlc->bandstate[chspec_bandunit(chanspec)];
 	li = (band->bandtype == BRCM_BAND_5G) ?
@@ -1192,6 +600,10 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
 	    brcms_c_get_mimo_2g(country->locale_mimo_2G);
 
+	/*
+	 * SAF: Currently all locales have BRCMS_EIRP set, so only first
+	 * case matters.
+	 */
 	if (li->flags & BRCMS_EIRP) {
 		delta = band->antgain;
 	} else {
@@ -1200,41 +612,28 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 			delta = band->antgain - QDB(6);	/* Excess over 6 dB */
 	}
 
-	if (li == &locale_i) {
+	/*
+	 * SAF: After this function is done,
+	 * brcms_c_channel_min_txpower_limits_with_local_constraint() is
+	 * going to clamp down all these values to BRCMS_TXPWR_MAX anyway.
+	 * So what's the point of conducted_max?
+	 */
+	if (li == &locale_i)
 		conducted_max = QDB(22);
-		conducted_ofdm_max = QDB(22);
-	}
+
+	maxpwr = QDB(channel->max_power) - delta;
+	maxpwr = max(maxpwr, 0);
+	maxpwr = min(maxpwr, conducted_max);
 
 	/* CCK txpwr limits for 2.4G band */
 	if (band->bandtype == BRCM_BAND_2G) {
-		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_2G_CCK(chan)];
-
-		maxpwr = maxpwr - delta;
-		maxpwr = max(maxpwr, 0);
-		maxpwr = min(maxpwr, conducted_max);
-
 		for (i = 0; i < BRCMS_NUM_RATES_CCK; i++)
 			txpwr->cck[i] = (u8) maxpwr;
 	}
 
-	/* OFDM txpwr limits for 2.4G or 5G bands */
-	if (band->bandtype == BRCM_BAND_2G)
-		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_2G_OFDM(chan)];
-	else
-		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_5G(chan)];
-
-	maxpwr = maxpwr - delta;
-	maxpwr = max(maxpwr, 0);
-	maxpwr = min(maxpwr, conducted_ofdm_max);
-
-	/* Keep OFDM lmit below CCK limit */
-	if (band->bandtype == BRCM_BAND_2G)
-		maxpwr = min_t(int, maxpwr, txpwr->cck[0]);
-
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
 		txpwr->ofdm[i] = (u8) maxpwr;
 
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
 		/*
 		 * OFDM 40 MHz SISO has the same power as the corresponding
 		 * MCS0-7 rate unless overriden by the locale specific code.
@@ -1249,6 +648,15 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		txpwr->ofdm_40_cdd[i] = 0;
 	}
 
+	/*
+	 * SAF: I'm not sure how to transition the MIMO limits to using the
+	 * standard regulatory structures.
+	 */
+
+	/*
+	 * SAF: none of the MIMO locales have BRCMS_EIRP set, so only the
+	 * second case currently matters.
+	 */
 	/* MIMO/HT specific limits */
 	if (li_mimo->flags & BRCMS_EIRP) {
 		delta = band->antgain;
@@ -1392,14 +800,8 @@ static bool brcms_c_chspec_malformed(u16 chanspec)
 	return false;
 }
 
-/*
- * Validate the chanspec for this locale, for 40MHZ we need to also
- * check that the sidebands are valid 20MZH channels in this locale
- * and they are also a legal HT combination
- */
 static bool
-brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
-			   bool dualband)
+brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	u8 channel = CHSPEC_CHANNEL(chspec);
@@ -1415,59 +817,148 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 	    chspec_bandunit(chspec))
 		return false;
 
-	/* Check a 20Mhz channel */
-	if (CHSPEC_IS20(chspec)) {
-		if (dualband)
-			return brcms_c_valid_channel20_db(wlc_cm->wlc->cmi,
-							  channel);
-		else
-			return brcms_c_valid_channel20(wlc_cm->wlc->cmi,
-						       channel);
+	return true;
+}
+
+bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm, u16 chspec)
+{
+	return brcms_c_valid_chanspec_ext(wlc_cm, chspec);
+}
+
+bool brcms_is_world_regd(const char *regdom)
+{
+	return !!brcms_world_regd(regdom);
+}
+
+static inline bool brcms_is_radar_freq(u16 center_freq)
+{
+	return center_freq >= 5260 && center_freq <= 5700;
+}
+
+static void brcms_reg_apply_radar_flags(struct wiphy *wiphy)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	int i;
+
+	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+	if (!sband)
+		return;
+
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+
+		if (!brcms_is_radar_freq(ch->center_freq))
+			continue;
+
+		/*
+		 * All channels in this range should be passive and have
+		 * DFS enabled.
+		 */
+		if (!(ch->flags & IEEE80211_CHAN_DISABLED))
+			ch->flags |= IEEE80211_CHAN_RADAR |
+				     IEEE80211_CHAN_NO_IBSS |
+				     IEEE80211_CHAN_PASSIVE_SCAN;
 	}
-#ifdef SUPPORT_40MHZ
-	/*
-	 * We know we are now checking a 40MHZ channel, so we should
-	 * only be here for NPHYS
-	 */
-	if (BRCMS_ISNPHY(wlc->band) || BRCMS_ISSSLPNPHY(wlc->band)) {
-		u8 upper_sideband = 0, idx;
-		u8 num_ch20_entries =
-		    sizeof(chan20_info) / sizeof(struct chan20_info);
-
-		if (!VALID_40CHANSPEC_IN_BAND(wlc, chspec_bandunit(chspec)))
-			return false;
-
-		if (dualband) {
-			if (!brcms_c_valid_channel20_db(wlc->cmi,
-							lower_20_sb(channel)) ||
-			    !brcms_c_valid_channel20_db(wlc->cmi,
-							upper_20_sb(channel)))
-				return false;
-		} else {
-			if (!brcms_c_valid_channel20(wlc->cmi,
-						     lower_20_sb(channel)) ||
-			    !brcms_c_valid_channel20(wlc->cmi,
-						     upper_20_sb(channel)))
-				return false;
-		}
+}
 
-		/* find the lower sideband info in the sideband array */
-		for (idx = 0; idx < num_ch20_entries; idx++) {
-			if (chan20_info[idx].sb == lower_20_sb(channel))
-				upper_sideband = chan20_info[idx].adj_sbs;
+static void brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
+					    enum nl80211_reg_initiator initiator)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	const struct ieee80211_reg_rule *reg_rule;
+	int band, i, ret;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		sband = wiphy->bands[band];
+		if (!sband)
+			continue;
+
+		for (i = 0; i < sband->n_channels; i++) {
+			ch = &sband->channels[i];
+
+			if (brcms_is_radar_freq(ch->center_freq) ||
+			    (ch->flags & IEEE80211_CHAN_RADAR))
+				continue;
+
+			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+				ret = freq_reg_info(wiphy, ch->center_freq,
+						    0, &reg_rule);
+				if (ret)
+					continue;
+
+				if (!(reg_rule->flags & NL80211_RRF_NO_IBSS))
+					ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
+				if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
+					ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+			} else {
+				if (ch->beacon_found)
+					ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
+						IEEE80211_CHAN_PASSIVE_SCAN);
+			}
 		}
-		/* check that the lower sideband allows an upper sideband */
-		if ((upper_sideband & (CH_UPPER_SB | CH_EWA_VALID)) ==
-		    (CH_UPPER_SB | CH_EWA_VALID))
-			return true;
-		return false;
 	}
-#endif				/* 40 MHZ */
+}
 
-	return false;
+static int brcms_reg_notifier(struct wiphy *wiphy,
+			      struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct brcms_info *wl = hw->priv;
+	struct brcms_c_info *wlc = wl->wlc;
+	/*
+	 * SAF: Do we need any special handling for channels 12 and 13?
+	 */
+
+	brcms_reg_apply_radar_flags(wiphy);
+
+	if (request && request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
+		brcms_reg_apply_beaconing_flags(wiphy, request->initiator);
+
+	/*
+	 * SAF: Should this still be based off alpha2? And is it really
+	 * needed? The channel_14_wide_filter flag isn't actually used
+	 * anywhere.
+	 */
+	if (wlc->pub->_nbands > 1 || wlc->band->bandtype == BRCM_BAND_2G)
+		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
+					brcms_c_japan_ccode(request->alpha2));
+
+	return 0;
 }
 
-bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm, u16 chspec)
+void brcms_c_regd_init(struct brcms_c_info *wlc)
 {
-	return brcms_c_valid_chanspec_ext(wlc_cm, chspec, true);
+	struct wiphy *wiphy = brcms_c_get_wiphy(wlc->cmi);
+	const struct brcms_regd *regd = wlc->cmi->world_regd;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	struct brcms_chanvec sup_chan;
+	struct brcms_band *band;
+	int band_idx, i;
+
+	/* Disable any channels not supported by the phy */
+	for (band_idx = 0; band_idx < IEEE80211_NUM_BANDS; band_idx++) {
+		if (band_idx == IEEE80211_BAND_2GHZ)
+			band = wlc->bandstate[BAND_2G_INDEX];
+		else
+			band = wlc->bandstate[BAND_5G_INDEX];
+		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
+					      &sup_chan);
+
+		sband = wiphy->bands[band_idx];
+		for (i = 0; i < sband->n_channels; i++) {
+			ch = &sband->channels[i];
+			if (!isset(sup_chan.vec, ch->hw_value))
+				ch->flags |= IEEE80211_CHAN_DISABLED;
+		}
+	}
+
+	wlc->wiphy->reg_notifier = brcms_reg_notifier;
+	wlc->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
+			     WIPHY_FLAG_STRICT_REGULATORY;
+	wiphy_apply_custom_regulatory(wlc->wiphy, regd->regdomain);
+	brcms_reg_apply_radar_flags(wiphy);
+	brcms_reg_apply_beaconing_flags(wiphy, NL80211_REGDOM_SET_BY_DRIVER);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.h b/drivers/net/wireless/brcm80211/brcmsmac/channel.h
index 808cb4f..4758108 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.h
@@ -44,10 +44,15 @@ extern bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm,
 				      u16 chspec);
 
 extern void brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm,
-				   u16 chanspec,
-				   struct txpwr_limits *txpwr);
+				       u16 chanspec,
+				       struct ieee80211_channel *channel,
+		       		       struct txpwr_limits *txpwr);
 extern void brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm,
-				     u16 chanspec,
-				     u8 local_constraint_qdbm);
+					 u16 chanspec,
+					 u8 local_constraint_qdbm);
+
+extern bool brcms_is_world_regd(const char *regdom);
+
+extern void brcms_c_regd_init(struct brcms_c_info *wlc);
 
 #endif				/* _WLC_CHANNEL_H */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 569ab8a..a9703eb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -396,8 +396,7 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		if (conf->channel_type == NL80211_CHAN_HT20 ||
 		    conf->channel_type == NL80211_CHAN_NO_HT)
-			err = brcms_c_set_channel(wl->wlc,
-						  conf->channel->hw_value);
+			err = brcms_c_set_channel(wl->wlc, conf->channel);
 		else
 			err = -ENOTSUPP;
 	}
@@ -727,7 +726,9 @@ static const struct ieee80211_ops brcms_ops = {
  */
 static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
 {
-	return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
+	if (!brcms_is_world_regd(abbrev))
+		return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
+	return 0;
 }
 
 void brcms_dpc(unsigned long data)
@@ -1059,6 +1060,8 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 		goto fail;
 	}
 
+	brcms_c_regd_init(wl->wlc);
+
 	memcpy(perm, &wl->pub->cur_etheraddr, ETH_ALEN);
 	if (WARN_ON(!is_valid_ether_addr(perm)))
 		goto fail;
@@ -1071,8 +1074,6 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 
 	if (wl->pub->srom_ccode[0])
 		err = brcms_set_hint(wl, wl->pub->srom_ccode);
-	else
-		err = brcms_set_hint(wl, "US");
 	if (err)
 		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
 			  __func__, err);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 86186fa..2b8734b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3150,20 +3150,6 @@ void brcms_c_reset(struct brcms_c_info *wlc)
 	brcms_b_reset(wlc->hw);
 }
 
-/* Return the channel the driver should initialize during brcms_c_init.
- * the channel may have to be changed from the currently configured channel
- * if other configurations are in conflict (bandlocked, 11n mode disabled,
- * invalid channel for current country, etc.)
- */
-static u16 brcms_c_init_chanspec(struct brcms_c_info *wlc)
-{
-	u16 chanspec =
-	    1 | WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE |
-	    WL_CHANSPEC_BAND_2G;
-
-	return chanspec;
-}
-
 void brcms_c_init_scb(struct scb *scb)
 {
 	int i;
@@ -3409,8 +3395,7 @@ static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec) {
 		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 }
 
-static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
-				     u16 chanspec)
+static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 {
 	/* Save our copy of the chanspec */
 	wlc->chanspec = chanspec;
@@ -3530,8 +3515,7 @@ static void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
 	}
 }
 
-static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
-				     u16 chanspec)
+static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc, u16 chanspec)
 {
 	struct brcms_c_rateset default_rateset;
 	uint parkband;
@@ -5152,6 +5136,8 @@ static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
 /* make interface operational */
 int brcms_c_up(struct brcms_c_info *wlc)
 {
+	struct ieee80211_channel *ch;
+
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	/* HW is turned off so don't try to access it */
@@ -5218,8 +5204,9 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	wlc->pub->up = true;
 
 	if (wlc->bandinit_pending) {
+		ch = wlc->pub->ieee_hw->conf.channel;
 		brcms_c_suspend_mac_and_wait(wlc);
-		brcms_c_set_chanspec(wlc, wlc->default_bss->chanspec);
+		brcms_c_set_chanspec(wlc, ch20mhz_chspec(ch->hw_value));
 		wlc->bandinit_pending = false;
 		brcms_c_enable_mac(wlc);
 	}
@@ -5421,6 +5408,8 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		return -EINVAL;
 
 	/* Legacy or bust when no OFDM is supported by regulatory */
+	/*
+	 * SAF: Use actual reg rule to check for OFDM? */
 	if ((brcms_c_channel_locale_flags_in_band(wlc->cmi, band->bandunit) &
 	     BRCMS_NO_OFDM) && (gmode != GMODE_LEGACY_B))
 		return -EINVAL;
@@ -5576,8 +5565,9 @@ static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
 	wlc_phy_ofdm_rateset_war(wlc->band->pi, war);
 }
 
-int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel)
+int brcms_c_set_channel(struct brcms_c_info *wlc, struct ieee80211_channel *ch)
 {
+	int channel = ch->hw_value;
 	u16 chspec = ch20mhz_chspec(channel);
 
 	if (channel < 0 || channel > MAXCHANNEL)
@@ -5586,7 +5576,6 @@ int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel)
 	if (!brcms_c_valid_chanspec_db(wlc->cmi, chspec))
 		return -EINVAL;
 
-
 	if (!wlc->pub->up && brcms_is_mband_unlocked(wlc)) {
 		if (wlc->band->bandunit != chspec_bandunit(chspec))
 			wlc->bandinit_pending = true;
@@ -8216,19 +8205,12 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 {
 	struct bcma_device *core = wlc->hw->d11core;
+	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
 	u16 chanspec;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
-	/*
-	 * This will happen if a big-hammer was executed. In
-	 * that case, we want to go back to the channel that
-	 * we were on and not new channel
-	 */
-	if (wlc->pub->associated)
-		chanspec = wlc->home_chanspec;
-	else
-		chanspec = brcms_c_init_chanspec(wlc);
+	chanspec = ch20mhz_chspec(ch->hw_value);
 
 	brcms_b_init(wlc->hw, chanspec);
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index f0038ad..4de7f1d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -18,6 +18,8 @@
 #define _BRCM_PUB_H_
 
 #include <linux/bcma/bcma.h>
+#include <net/mac80211.h>
+#include <net/cfg80211.h>
 #include <brcmu_wifi.h>
 #include "types.h"
 #include "defs.h"
@@ -580,7 +582,8 @@ extern void brcms_c_scan_stop(struct brcms_c_info *wlc);
 extern int brcms_c_get_curband(struct brcms_c_info *wlc);
 extern void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc,
 					   bool drop);
-extern int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel);
+extern int brcms_c_set_channel(struct brcms_c_info *wlc,
+			       struct ieee80211_channel *channel);
 extern int brcms_c_set_rate_limit(struct brcms_c_info *wlc, u16 srl, u16 lrl);
 extern void brcms_c_get_current_rateset(struct brcms_c_info *wlc,
 				 struct brcm_rateset *currs);
