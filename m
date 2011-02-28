Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1B1QtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:49:19 -0500
Received: from kroah.org ([198.145.64.141]:47986 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1B1QhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:07 2011
Message-Id: <20110228162407.878045010@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Milton Miller <miltonm@bga.com>, Anton Blanchard <anton@samba.org>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        maximilian attems <max@stro.at>
Subject: [22/68] ixgbe: prevent speculative processing of descriptors before ready
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Milton Miller <miltonm@bga.com>

commit 3c945e5b3719bcc18c6ddd31bbcae8ef94f3d19a upstream.

The PowerPC architecture does not require loads to independent bytes to be
ordered without adding an explicit barrier.

In ixgbe_clean_rx_irq we load the status bit then load the packet data.
With packet split disabled if these loads go out of order we get a
stale packet, but we will notice the bad sequence numbers and drop it.

The problem occurs with packet split enabled where the TCP/IP header and data
are in different descriptors. If the reads go out of order we may have data
that doesn't match the TCP/IP header. Since we use hardware checksumming this
bad data is never verified and it makes it all the way to the application.

This bug was found during stress testing and adding this barrier has been shown
to fix it.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Don Skidmore <donald.c.skidmore@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ixgbe/ixgbe_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -793,6 +793,7 @@ static bool ixgbe_clean_rx_irq(struct ix
 			break;
 		(*work_done)++;
 
+		rmb(); /* read descriptor and rx_buffer_info after status DD */
 		if (rx_ring->flags & IXGBE_RING_RX_PS_ENABLED) {
 			hdr_info = le16_to_cpu(ixgbe_get_hdr_info(rx_desc));
 			len = (hdr_info & IXGBE_RXDADV_HDRBUFLEN_MASK) >>


