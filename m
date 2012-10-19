Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab2JSCyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:54:01 -0400
Received: from mail.kernel.org ([198.145.19.201]:52537 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965050Ab2JSCtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>, eric.dumazet@gmail.com,
        therbert@google.com
Subject: [ 65/76] e1000e: Change wthresh to 1 to avoid possible Tx stalls
Date: Thu, 18 Oct 2012 19:47:29 -0700
Message-Id: <20121019024400.583943010@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

commit 8edc0e624db3756783233e464879eb2e3b904c13 upstream.

This patch originated from Hiroaki SHIMODA but has been modified
by Intel with some minor cleanups and additional commit log text.

Denys Fedoryshchenko and others reported Tx stalls on e1000e with
BQL enabled.  Issue was root caused to hardware delays. They were
introduced because some of the e1000e hardware with transmit
writeback bursting enabled, waits until the driver does an
explict flush OR there are WTHRESH descriptors to write back.

Sometimes the delays in question were on the order of seconds,
causing visible lag for ssh sessions and unacceptable tx
completion latency, especially for BQL enabled kernels.

To avoid possible Tx stalls, change WTHRESH back to 1.

The current plan is to investigate a method for re-enabling
WTHRESH while not harming BQL, but those patches will be later
for net-next if they work.

please enqueue for stable since v3.3 as this bug was introduced in
commit 3f0cfa3bc11e7f00c9994e0f469cbc0e7da7b00c
Author: Tom Herbert <therbert@google.com>
Date:   Mon Nov 28 16:33:16 2011 +0000

    e1000e: Support for byte queue limits

    Changes to e1000e to use byte queue limits.

Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
Tested-by: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
CC: eric.dumazet@gmail.com
CC: therbert@google.com
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/e1000.h  |    6 +++---
 drivers/net/ethernet/intel/e1000e/netdev.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -175,13 +175,13 @@ struct e1000_info;
 /*
  * in the case of WTHRESH, it appears at least the 82571/2 hardware
  * writes back 4 descriptors when WTHRESH=5, and 3 descriptors when
- * WTHRESH=4, and since we want 64 bytes at a time written back, set
- * it to 5
+ * WTHRESH=4, so a setting of 5 gives the most efficient bus
+ * utilization but to avoid possible Tx stalls, set it to 1
  */
 #define E1000_TXDCTL_DMA_BURST_ENABLE                          \
 	(E1000_TXDCTL_GRAN | /* set descriptor granularity */  \
 	 E1000_TXDCTL_COUNT_DESC |                             \
-	 (5 << 16) | /* wthresh must be +1 more than desired */\
+	 (1 << 16) | /* wthresh must be +1 more than desired */\
 	 (1 << 8)  | /* hthresh */                             \
 	 0x1f)       /* pthresh */
 
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -2831,7 +2831,7 @@ static void e1000_configure_tx(struct e1
 		 * set up some performance related parameters to encourage the
 		 * hardware to use the bus more efficiently in bursts, depends
 		 * on the tx_int_delay to be enabled,
-		 * wthresh = 5 ==> burst write a cacheline (64 bytes) at a time
+		 * wthresh = 1 ==> burst write is disabled to avoid Tx stalls
 		 * hthresh = 1 ==> prefetch when one or more available
 		 * pthresh = 0x1f ==> prefetch if internal cache 31 or less
 		 * BEWARE: this seems to work but should be considered first if


