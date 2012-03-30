Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653Ab2C3VKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:10:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761632Ab2C3VKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:10:41 -0400
Message-Id: <20120330194841.656234548@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 038/149] rtlwifi: rtl8192c_common: rtl8192de: Check for allocation failures
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 76a92be537f1c8c259e393632301446257ca3ea9 upstream.

In https://bugzilla.redhat.com/show_bug.cgi?id=771656, a kernel bug was
triggered due to a failed skb allocation that was not checked. This event
lead to an audit of all memory allocations in the complete rtlwifi family
of drivers. This patch fixes the rest.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/pci.c                |    2 ++
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |    2 ++
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c       |   14 +++++++++-----
 drivers/net/wireless/rtlwifi/usb.c                |   12 +++++++-----
 4 files changed, 20 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -657,6 +657,8 @@ static void _rtl_receive_one(struct ieee
 		return;
 
 	uskb = dev_alloc_skb(skb->len + 128);
+	if (!uskb)
+		return;		/* exit if allocation failed */
 	memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status, sizeof(rx_status));
 	pdata = (u8 *)skb_put(uskb, skb->len);
 	memcpy(pdata, skb->data, skb->len);
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -752,6 +752,8 @@ void rtl92c_set_fw_rsvdpagepkt(struct ie
 
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	memcpy((u8 *) skb_put(skb, totalpacketlen),
 	       &reserved_page_packet, totalpacketlen);
 
--- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
@@ -763,12 +763,16 @@ void rtl92d_set_fw_rsvdpagepkt(struct ie
 		      "rtl92d_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL\n",
 		      u1RsvdPageLoc, 3);
 	skb = dev_alloc_skb(totalpacketlen);
-	memcpy((u8 *) skb_put(skb, totalpacketlen), &reserved_page_packet,
-		totalpacketlen);
-	rtstatus = _rtl92d_cmd_send_packet(hw, skb);
+	if (!skb) {
+		dlok = false;
+	} else {
+		memcpy((u8 *) skb_put(skb, totalpacketlen),
+			&reserved_page_packet, totalpacketlen);
+		rtstatus = _rtl92d_cmd_send_packet(hw, skb);
 
-	if (rtstatus)
-		dlok = true;
+		if (rtstatus)
+			dlok = true;
+	}
 	if (dlok) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
 			("Set RSVD page location to Fw.\n"));
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -481,12 +481,14 @@ static void _rtl_usb_rx_process_noagg(st
 			u8 *pdata;
 
 			uskb = dev_alloc_skb(skb->len + 128);
-			memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
-			       sizeof(rx_status));
-			pdata = (u8 *)skb_put(uskb, skb->len);
-			memcpy(pdata, skb->data, skb->len);
+			if (uskb) {	/* drop packet on allocation failure */
+				memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
+				       sizeof(rx_status));
+				pdata = (u8 *)skb_put(uskb, skb->len);
+				memcpy(pdata, skb->data, skb->len);
+				ieee80211_rx_irqsafe(hw, uskb);
+			}
 			dev_kfree_skb_any(skb);
-			ieee80211_rx_irqsafe(hw, uskb);
 		} else {
 			dev_kfree_skb_any(skb);
 		}


