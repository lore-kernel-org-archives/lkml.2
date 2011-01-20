Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1ATWSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:18:24 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23964 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1ATWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:18:23 -0500
Date: Thu, 20 Jan 2011 23:18:42 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH] Fix NULL dereference in rtlwifi driver
Message-ID: <alpine.LNX.2.00.1101202309030.11854@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/net/wireless/rtlwifi/pci.c::_rtl_pci_rx_interrupt() we call 
dev_alloc_skb(), which may fail and return NULL, but we do not check the 
returned value against NULL before dereferencing the returned pointer. 
This may lead to a NULL pointer dereference which means we'll crash - not 
good.

This patch tries to solve the issue by testing for NULL and bailing out if 
we couldn't allocate a skb. However, I don't know this code well, so I'm 
not sure that jumping to the 'done' label here is the correct action to 
take. Someone more knowledgable about this code than me should definately 
review it before it is applied anywhere.
While I was in the area I also moved an assignment in 
_rtl_pci_init_rx_ring() a bit - if the dev_alloc_skb() call in that 
function fails there's no reason to waste clock cycles assigning to the 
local variable 'entry', we may as well do that after the NULL check and 
potential bail out.

Here's the proposed patch, but please don't take it as much more than a 
bug report. If it happens to be correct, then by all means apply it, but 
I'm not personally making any guarantees.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 pci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

  compile tested only, I don't have the hardware to test for real.

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 0fa36aa..5e99f89 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -619,6 +619,13 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 					struct sk_buff *uskb = NULL;
 					u8 *pdata;
 					uskb = dev_alloc_skb(skb->len + 128);
+					if (!uskb) {
+						RT_TRACE(rtlpriv,
+							(COMP_INTR | COMP_RECV),
+							DBG_DMESG,
+							("can't alloc rx skb\n"));
+						goto done;
+					}
 					memcpy(IEEE80211_SKB_RXCB(uskb),
 							&rx_status,
 							sizeof(rx_status));
@@ -1066,9 +1073,9 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 			struct sk_buff *skb =
 			    dev_alloc_skb(rtlpci->rxbuffersize);
 			u32 bufferaddress;
-			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
 			if (!skb)
 				return 0;
+			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
 
 			/*skb->dev = dev; */
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

