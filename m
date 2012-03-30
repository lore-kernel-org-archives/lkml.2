Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935591Ab2C3WeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:34:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935481Ab2C3VJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:09:24 -0400
Message-Id: <20120330194835.796886489@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [ 013/149] staging: r8712u: Add missing initialization and remove configuration parameter CONFIG_R8712_AP
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 073863432f7eaa23c7c09733414d4be2eabf5eef upstream.

When this driver was upgraded to the vendor 20100831 version in
commit 93c55dda092c7 et al,, one listhead initialization was missed.
This broke complete operation of the driver whenever AP mode was
enabled. This fixes https://bugs.archlinux.org/task/27996.

The configuration parameter R8712_AP is misleading as the driver cannot
function as an AP without a heavily hacked version of hostapd. Thus, it
makes sense to remove the parameter; however the code and data configured
for the option is left in.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/Kconfig           |    7 -------
 drivers/staging/rtl8712/rtl871x_sta_mgt.c |    5 +----
 drivers/staging/rtl8712/sta_info.h        |    4 ----
 3 files changed, 1 insertion(+), 15 deletions(-)

--- a/drivers/staging/rtl8712/Kconfig
+++ b/drivers/staging/rtl8712/Kconfig
@@ -9,13 +9,6 @@ config R8712U
 	This option adds the Realtek RTL8712 USB device such as the D-Link DWA-130.
 	If built as a module, it will be called r8712u.
 
-config R8712_AP
-	bool "Realtek RTL8712U AP code"
-	depends on R8712U
-	default N
-	---help---
-	This option allows the Realtek RTL8712 USB device to be an Access Point.
-
 config R8712_TX_AGGR
 	bool "Realtek RTL8712U Transmit Aggregation code"
 	depends on R8712U && BROKEN
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -42,9 +42,8 @@ static void _init_stainfo(struct sta_inf
 	_init_listhead(&psta->hash_list);
 	_r8712_init_sta_xmit_priv(&psta->sta_xmitpriv);
 	_r8712_init_sta_recv_priv(&psta->sta_recvpriv);
-#ifdef CONFIG_R8712_AP
+	_init_listhead(&psta->asoc_list);
 	_init_listhead(&psta->auth_list);
-#endif
 }
 
 u32 _r8712_init_sta_priv(struct	sta_priv *pstapriv)
@@ -71,10 +70,8 @@ u32 _r8712_init_sta_priv(struct	sta_priv
 				 get_list_head(&pstapriv->free_sta_queue));
 		psta++;
 	}
-#ifdef CONFIG_R8712_AP
 	_init_listhead(&pstapriv->asoc_list);
 	_init_listhead(&pstapriv->auth_list);
-#endif
 	return _SUCCESS;
 }
 
--- a/drivers/staging/rtl8712/sta_info.h
+++ b/drivers/staging/rtl8712/sta_info.h
@@ -90,7 +90,6 @@ struct sta_info {
 	 * curr_network(mlme_priv/security_priv/qos/ht) : AP CAP/INFO
 	 * sta_info: (AP & STA) CAP/INFO
 	 */
-#ifdef CONFIG_R8712_AP
 	struct list_head asoc_list;
 	struct list_head auth_list;
 	unsigned int expire_to;
@@ -98,7 +97,6 @@ struct sta_info {
 	unsigned int authalg;
 	unsigned char chg_txt[128];
 	unsigned int tx_ra_bitmap;
-#endif
 };
 
 struct	sta_priv {
@@ -111,13 +109,11 @@ struct	sta_priv {
 	struct  __queue sleep_q;
 	struct  __queue wakeup_q;
 	struct _adapter *padapter;
-#ifdef CONFIG_R8712_AP
 	struct list_head asoc_list;
 	struct list_head auth_list;
 	unsigned int auth_to;  /* sec, time to expire in authenticating. */
 	unsigned int assoc_to; /* sec, time to expire before associating. */
 	unsigned int expire_to; /* sec , time to expire after associated. */
-#endif
 };
 
 static inline u32 wifi_mac_hash(u8 *mac)


