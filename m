Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457Ab2EQXWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 19:22:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:44471 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762452Ab2EQXWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 19:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144623732"
From: "Dave, Tushar N" <tushar.n.dave@intel.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Dean Nelson <dnelson@redhat.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] e1000: Reset rx ring index on receive overrun
Thread-Topic: [PATCH] e1000: Reset rx ring index on receive overrun
Thread-Index: AQHNNIHi+O7ymV9uaUqMk0/pJ2kJzJbOnHOQ
Date: Thu, 17 May 2012 23:22:31 +0000
Message-ID: <061C8A8601E8EE4CA8D8FD6990CEA891188439E0@ORSMSX102.amr.corp.intel.com>
References: <20120517230140.GZ683@type.famille.thibault.fr>
In-Reply-To: <20120517230140.GZ683@type.famille.thibault.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am interested in to see if you have actual test case and more importantly test data that shows that kernel and device indexes are not synchronized any more.


-Tushar

>-----Original Message-----
>From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
>On Behalf Of Samuel Thibault
>Sent: Thursday, May 17, 2012 4:02 PM
>To: Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
>Carolyn; Skidmore, Donald C; Rose, Gregory V; Waskiewicz Jr, Peter P;
>Duyck, Alexander H; Ronciak, John; David S. Miller; Jiri Pirko; Dean
>Nelson; e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org
>Subject: [PATCH] e1000: Reset rx ring index on receive overrun
>
>At high traffic rate, the rx ring may get completely filled before we
>manage to consume it.  After it is filled, the kernel and device indexes
>are not synchronized any more, so we have to reset them, otherwise the
>kernel will be stuck waiting for the wrong slot to be filled.
>
>Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
>
>---
>This is just a patch suggestion, I'm not an expert in network drivers, I
>leave to actual driver authors to bake a better version.
>
>diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c
>b/drivers/net/ethernet/intel/e1000/e1000_main.c
>index 37caa88..77c8dbc 100644
>--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
>+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
>@@ -3759,6 +3759,21 @@ static irqreturn_t e1000_intr(int irq, void *data)
> 	if (unlikely(test_bit(__E1000_DOWN, &adapter->flags)))
> 		return IRQ_HANDLED;
>
>+	if (unlikely(icr & E1000_ICR_RXO)) {
>+		/* Receive Overrun */
>+		u32 rctl;
>+		int i;
>+		rctl = er32(RCTL);
>+		ew32(RCTL, rctl & ~E1000_RCTL_EN);
>+		for (i = 0; i < adapter->num_rx_queues; i++) {
>+			memset(adapter->rx_ring[i].desc, 0, adapter-
>>rx_ring[i].size);
>+			adapter->rx_ring[i].next_to_clean = 0;
>+		}
>+		ew32(RDH, 0);
>+		ew32(RCTL, rctl);
>+		adapter->netdev->stats.rx_fifo_errors++;
>+	}
>+
> 	if (unlikely(icr & (E1000_ICR_RXSEQ | E1000_ICR_LSC))) {
> 		hw->get_link_status = 1;
> 		/* guard against interrupt when we're going down */
>--
>To unsubscribe from this list: send the line "unsubscribe netdev" in the
>body of a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html
