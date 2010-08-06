Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742Ab0HFTep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:34:45 -0400
Received: from kroah.org ([198.145.64.141]:43522 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935816Ab0HFT2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:28:00 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:15 2010
Message-Id: <20100806192115.668550775@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:19:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Rose <gregory.v.rose@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [14/36] igb: Use only a single Tx queue in SR-IOV mode
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Rose <gregory.v.rose@intel.com>

commit 5fa8517f038d51d571981fb495206cc30ed91b06 upstream.

The 82576 expects the second rx queue in any pool to receive L2 switch
loop back packets sent from the second tx queue in another pool.  The
82576 VF driver does not enable the second rx queue so if the PF driver
sends packets destined to a VF from its second tx queue then the VF
driver will never see them.  In SR-IOV mode limit the number of tx queues
used by the PF driver to one. This patch fixes a bug reported in which
the PF cannot communciate with the VF and should be considered for 2.6.34
stable.

Signed-off-by: Greg Rose <gregory.v.rose@intel.com>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igb/igb_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -322,9 +322,6 @@ static void igb_cache_ring_register(stru
 			for (; i < adapter->rss_queues; i++)
 				adapter->rx_ring[i]->reg_idx = rbase_offset +
 				                               Q_IDX_82576(i);
-			for (; j < adapter->rss_queues; j++)
-				adapter->tx_ring[j]->reg_idx = rbase_offset +
-				                               Q_IDX_82576(j);
 		}
 	case e1000_82575:
 	case e1000_82580:
@@ -685,7 +682,10 @@ static void igb_set_interrupt_capability
 
 	/* Number of supported queues. */
 	adapter->num_rx_queues = adapter->rss_queues;
-	adapter->num_tx_queues = adapter->rss_queues;
+	if (adapter->vfs_allocated_count)
+		adapter->num_tx_queues = 1;
+	else
+		adapter->num_tx_queues = adapter->rss_queues;
 
 	/* start with one vector for every rx queue */
 	numvecs = adapter->num_rx_queues;


