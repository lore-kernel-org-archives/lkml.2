Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2GRAGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:06:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab2GRAEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Deepak Sikri <deepak.sikri@st.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 20/37] stmmac: Fix for nfs hang on multiple reboot
Date: Tue, 17 Jul 2012 17:02:57 -0700
Message-Id: <20120717232433.014403911@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepak Sikri <deepak.sikri@st.com>

commit 8e83989106562326bfd6aaf92174fe138efd026b upstream.

It was observed that during multiple reboots nfs hangs. The status of
receive descriptors shows that all the descriptors were in control of
CPU, and none were assigned to DMA.
Also the DMA status register confirmed that the Rx buffer is
unavailable.

This patch adds the fix for the same by adding the memory barriers to
ascertain that the all instructions before enabling the Rx or Tx DMA are
completed which involves the proper setting of the ownership bit in DMA
descriptors.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1158,6 +1158,7 @@ static netdev_tx_t stmmac_xmit(struct sk
 		priv->hw->desc->prepare_tx_desc(desc, 0, len, csum_insertion);
 		wmb();
 		priv->hw->desc->set_tx_owner(desc);
+		wmb();
 	}
 
 	/* Interrupt on completition only for the latest segment */
@@ -1173,6 +1174,7 @@ static netdev_tx_t stmmac_xmit(struct sk
 
 	/* To avoid raise condition */
 	priv->hw->desc->set_tx_owner(first);
+	wmb();
 
 	priv->cur_tx++;
 
@@ -1236,6 +1238,7 @@ static inline void stmmac_rx_refill(stru
 		}
 		wmb();
 		priv->hw->desc->set_rx_owner(p + entry);
+		wmb();
 	}
 }
 


