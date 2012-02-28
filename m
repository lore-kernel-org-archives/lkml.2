Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138Ab2B1B2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:28:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49705 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964948Ab2B1BIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:08:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.217.72 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010215.118706222@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:03:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Federico Quagliata <federico@quagliata.org>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 65/73] jme: Fix FIFO flush issue
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo-Fu Tseng <cooldavid@cooldavid.org>

commit ba9adbe67e288823ac1deb7f11576ab5653f833e upstream.

Set the RX FIFO flush watermark lower.
According to Federico and JMicron's reply,
setting it to 16QW would be stable on most platforms.
Otherwise, user might experience packet drop issue.

Reported-by: Federico Quagliata <federico@quagliata.org>
Fixed-by: Federico Quagliata <federico@quagliata.org>
Signed-off-by: Guo-Fu Tseng <cooldavid@cooldavid.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/jme.c |   10 +---------
 drivers/net/jme.h |    2 +-
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -2228,19 +2228,11 @@ jme_change_mtu(struct net_device *netdev
 		((new_mtu) < IPV6_MIN_MTU))
 		return -EINVAL;
 
-	if (new_mtu > 4000) {
-		jme->reg_rxcs &= ~RXCS_FIFOTHNP;
-		jme->reg_rxcs |= RXCS_FIFOTHNP_64QW;
-		jme_restart_rx_engine(jme);
-	} else {
-		jme->reg_rxcs &= ~RXCS_FIFOTHNP;
-		jme->reg_rxcs |= RXCS_FIFOTHNP_128QW;
-		jme_restart_rx_engine(jme);
-	}
 
 	netdev->mtu = new_mtu;
 	netdev_update_features(netdev);
 
+	jme_restart_rx_engine(jme);
 	jme_reset_link(jme);
 
 	return 0;
--- a/drivers/net/jme.h
+++ b/drivers/net/jme.h
@@ -734,7 +734,7 @@ enum jme_rxcs_values {
 	RXCS_RETRYCNT_60	= 0x00000F00,
 
 	RXCS_DEFAULT		= RXCS_FIFOTHTP_128T |
-				  RXCS_FIFOTHNP_128QW |
+				  RXCS_FIFOTHNP_16QW |
 				  RXCS_DMAREQSZ_128B |
 				  RXCS_RETRYGAP_256ns |
 				  RXCS_RETRYCNT_32,


