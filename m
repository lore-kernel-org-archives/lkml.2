Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab0G3Rfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:35:51 -0400
Received: from kroah.org ([198.145.64.141]:35678 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758753Ab0G3Reb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:31 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:06 2010
Message-Id: <20100730173106.550895385@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Javier Cardona <javier@cozybit.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [042/140] mac80211: Handle mesh action frames in ieee80211_rx_h_action
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit 1cb561f83793191cf86a2db3948d28f5f42df9ff upstream.

This fixes the problem introduced in commit
8404080568613d93ad7cf0a16dfb68 which broke mesh peer link establishment.

changes:
v2 	Added missing break (Johannes)
v3 	Broke original patch into two (Johannes)

Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 include/linux/ieee80211.h |    2 ++
 net/mac80211/rx.c         |    5 +++++
 2 files changed, 7 insertions(+)

--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1137,6 +1137,8 @@ enum ieee80211_category {
 	WLAN_CATEGORY_SA_QUERY = 8,
 	WLAN_CATEGORY_PROTECTED_DUAL_OF_ACTION = 9,
 	WLAN_CATEGORY_WMM = 17,
+	WLAN_CATEGORY_MESH_PLINK = 30,		/* Pending ANA approval */
+	WLAN_CATEGORY_MESH_PATH_SEL = 32,	/* Pending ANA approval */
 	WLAN_CATEGORY_VENDOR_SPECIFIC_PROTECTED = 126,
 	WLAN_CATEGORY_VENDOR_SPECIFIC = 127,
 };
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2023,6 +2023,11 @@ ieee80211_rx_h_action(struct ieee80211_r
 			return RX_CONTINUE;
 		}
 		break;
+	case WLAN_CATEGORY_MESH_PLINK:
+	case WLAN_CATEGORY_MESH_PATH_SEL:
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
+		break;
 	default:
 		/* do not process rejected action frames */
 		if (mgmt->u.action.category & 0x80)


