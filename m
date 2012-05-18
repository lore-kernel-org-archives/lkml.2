Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946311Ab2ERXcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:32:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38665 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946276Ab2ERXDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:03:21 -0400
Message-Id: <20120518211600.819370543@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/54] sky2: propogate rx hash when packet is copied
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: stephen hemminger <shemminger@vyatta.com>

[ Upstream commit 3f42941b5d1d13542b1a755a9e4f633aa72e4d3e ]

When a small packet is received, the driver copies it to a new skb to allow
reusing the full size Rx buffer. The copy was propogating the checksum offload
but not the receive hash information. The bug is impact was mostly harmless
and therefore not observed until reviewing this area of code.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sky2.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2344,8 +2344,11 @@ static struct sk_buff *receive_copy(stru
 		skb_copy_from_linear_data(re->skb, skb->data, length);
 		skb->ip_summed = re->skb->ip_summed;
 		skb->csum = re->skb->csum;
+		skb->rxhash = re->skb->rxhash;
+
 		pci_dma_sync_single_for_device(sky2->hw->pdev, re->data_addr,
 					       length, PCI_DMA_FROMDEVICE);
+		re->skb->rxhash = 0;
 		re->skb->ip_summed = CHECKSUM_NONE;
 		skb_put(skb, length);
 	}


