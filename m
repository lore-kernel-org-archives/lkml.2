Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab1I1XLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:11:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755Ab1I1WpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:40 2011
Message-Id: <20110928220140.514405807@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [144/244] ixgbe: fix possible null buffer error
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit b811ce9104a7f7663ddae4f7795a194a103b8f90 upstream.

It seems that at least one PPC machine would occasionally give a (valid) 0 as
the return value from dma_map, this caused the ixgbe code to not work
correctly.  A fix is pending in the PPC tree to not return 0 from dma map, but
we can also fix the driver to make sure we don't mess up in other arches as
well.

This patch is applicable to all current stable kernels.

Ref: https://bugzilla.redhat.com/show_bug.cgi?id=683611

Reported-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Alexander Duyck <alexander.h.duyck@intel.com>
Tested-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ixgbe/ixgbe_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -1366,8 +1366,8 @@ static void ixgbe_clean_rx_irq(struct ix
 		if (ring_is_rsc_enabled(rx_ring))
 			pkt_is_rsc = ixgbe_get_rsc_state(rx_desc);
 
-		/* if this is a skb from previous receive DMA will be 0 */
-		if (rx_buffer_info->dma) {
+		/* linear means we are building an skb from multiple pages */
+		if (!skb_is_nonlinear(skb)) {
 			u16 hlen;
 			if (pkt_is_rsc &&
 			    !(staterr & IXGBE_RXD_STAT_EOP) &&


