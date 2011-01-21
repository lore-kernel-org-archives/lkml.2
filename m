Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1AUTkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 14:40:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54249 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab1AUTkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 14:40:22 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=qYN2uNOaYOoA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=0azM3ZO7AAAA:8 a=yQdBAQUQAAAA:8 a=qPMUy1G03DIk8DHJfZwA:9 a=DHrXGpnVugrvO9x12gIA:7 a=EbbRfs98Ksj_t0rqWwxP93seJ6wA:4 a=CjuIK1q_8ugA:10 a=BGWj8ct6lkoA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Fri, 21 Jan 2011 13:40:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix possible NULL dereference
Message-ID: <4d39e146.pMRUu8w8cfc0mj0L%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

In drivers/net/wireless/rtlwifi/pci.c::_rtl_pci_rx_interrupt() we call 
dev_alloc_skb(), which may fail and return NULL, but we do not check the 
returned value against NULL before dereferencing the returned pointer. 
This may lead to a NULL pointer dereference which means we'll crash - not 
good.

In a separate call to dev_alloc_skb(), the debug level is changed so that
the failure message will always be logged.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Material for 2.6.38.

Larry

Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -619,6 +619,13 @@ static void _rtl_pci_rx_interrupt(struct
 					struct sk_buff *uskb = NULL;
 					u8 *pdata;
 					uskb = dev_alloc_skb(skb->len + 128);
+					if (!uskb) {
+						RT_TRACE(rtlpriv,
+							(COMP_INTR | COMP_RECV),
+							DBG_EMERG,
+							("can't alloc rx skb\n"));
+						goto done;
+					}
 					memcpy(IEEE80211_SKB_RXCB(uskb),
 							&rx_status,
 							sizeof(rx_status));
@@ -641,7 +648,7 @@ static void _rtl_pci_rx_interrupt(struct
 			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
 			if (unlikely(!new_skb)) {
 				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
-					 DBG_DMESG,
+					 DBG_EMERG,
 					 ("can't alloc skb for rx\n"));
 				goto done;
 			}
@@ -1066,9 +1073,9 @@ static int _rtl_pci_init_rx_ring(struct
 			struct sk_buff *skb =
 			    dev_alloc_skb(rtlpci->rxbuffersize);
 			u32 bufferaddress;
-			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
 			if (!skb)
 				return 0;
+			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
 
 			/*skb->dev = dev; */
 
