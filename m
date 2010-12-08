Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab0LHBTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:19:08 -0500
Received: from kroah.org ([198.145.64.141]:33634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932645Ab0LHBDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:13 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:43 2010
Message-Id: <20101208005743.276128521@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anupam Chanda <anupamc@vmware.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [218/289] e1000: fix screaming IRQ
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anupam Chanda <anupamc@vmware.com>

commit ab08853fab2093e5c6f5de56827a4c93dce4b055 upstream.

VMWare reports that the e1000 driver has a bug when bringing down the
interface, such that interrupts are not disabled in the hardware but the
driver stops reporting that it consumed the interrupt.

The fix is to set the driver's "down" flag later in the routine,
after all the timers and such have exited, preventing the interrupt
handler from being called and exiting early without handling the
interrupt.

CC: Anupam Chanda <anupamc@vmware.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000/e1000_main.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -31,7 +31,7 @@
 
 char e1000_driver_name[] = "e1000";
 static char e1000_driver_string[] = "Intel(R) PRO/1000 Network Driver";
-#define DRV_VERSION "7.3.21-k6-NAPI"
+#define DRV_VERSION "7.3.21-k8-NAPI"
 const char e1000_driver_version[] = DRV_VERSION;
 static const char e1000_copyright[] = "Copyright (c) 1999-2006 Intel Corporation.";
 
@@ -483,9 +483,6 @@ void e1000_down(struct e1000_adapter *ad
 	struct net_device *netdev = adapter->netdev;
 	u32 rctl, tctl;
 
-	/* signal that we're down so the interrupt handler does not
-	 * reschedule our watchdog timer */
-	set_bit(__E1000_DOWN, &adapter->flags);
 
 	/* disable receives in the hardware */
 	rctl = er32(RCTL);
@@ -506,6 +503,13 @@ void e1000_down(struct e1000_adapter *ad
 
 	e1000_irq_disable(adapter);
 
+	/*
+	 * Setting DOWN must be after irq_disable to prevent
+	 * a screaming interrupt.  Setting DOWN also prevents
+	 * timers and tasks from rescheduling.
+	 */
+	set_bit(__E1000_DOWN, &adapter->flags);
+
 	del_timer_sync(&adapter->tx_fifo_stall_timer);
 	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);


