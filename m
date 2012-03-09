Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031191Ab2CITuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:50:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56992 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031143Ab2CITuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:01 -0500
Message-Id: <20120309190208.760529318@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Cavallari <cavallar@lri.fr>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 80/95] carl9170: Fix memory accounting when sta is in power-save mode.
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>

commit 992d52529d7840236d3059b51c15d5eb9e81a869 upstream.

On Access Point mode, when transmitting a packet, if the destination
station is in powersave mode, we abort transmitting the packet to the
device queue, but we do not reclaim the allocated memory.  Given enough
packets, we can go in a state where there is no packet on the device
queue, but we think the device has no memory left, so no packet gets
transmitted, connections breaks and the AP stops working.

This undo the allocation done in the TX path when the station is in
power-save mode.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/carl9170/tx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1251,6 +1251,7 @@ static bool carl9170_tx_ps_drop(struct a
 			atomic_dec(&ar->tx_ampdu_upload);
 
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+		carl9170_release_dev_space(ar, skb);
 		carl9170_tx_status(ar, skb, false);
 		return true;
 	}


