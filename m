Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1EFATH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:19:07 -0400
Received: from kroah.org ([198.145.64.141]:32835 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab1EFANU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:08 2011
Message-Id: <20110506001208.453902190@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jie Yang <jie.yang@atheros.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/38] atl1c: Fix work event interrupt/task races
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tim Gardner <timg@tpi.com>

commit cb771838715b1c470bc5735bdae709b33b18e0ad upstream.

The mechanism used to initiate work events from the interrupt
handler has a classic read/modify/write race between the interrupt
handler that sets the condition, and the worker task that reads and
clears the condition. Close these races by using atomic
bit fields.

Cc: Jie Yang <jie.yang@atheros.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1c/atl1c.h      |    6 +++---
 drivers/net/atl1c/atl1c_main.c |   14 +++++---------
 2 files changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/net/atl1c/atl1c.h
+++ b/drivers/net/atl1c/atl1c.h
@@ -566,9 +566,9 @@ struct atl1c_adapter {
 #define __AT_TESTING        0x0001
 #define __AT_RESETTING      0x0002
 #define __AT_DOWN           0x0003
-	u8 work_event;
-#define ATL1C_WORK_EVENT_RESET 		0x01
-#define ATL1C_WORK_EVENT_LINK_CHANGE	0x02
+	unsigned long work_event;
+#define	ATL1C_WORK_EVENT_RESET		0
+#define	ATL1C_WORK_EVENT_LINK_CHANGE	1
 	u32 msg_enable;
 
 	bool have_msi;
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -325,7 +325,7 @@ static void atl1c_link_chg_event(struct
 		}
 	}
 
-	adapter->work_event |= ATL1C_WORK_EVENT_LINK_CHANGE;
+	set_bit(ATL1C_WORK_EVENT_LINK_CHANGE, &adapter->work_event);
 	schedule_work(&adapter->common_task);
 }
 
@@ -337,20 +337,16 @@ static void atl1c_common_task(struct wor
 	adapter = container_of(work, struct atl1c_adapter, common_task);
 	netdev = adapter->netdev;
 
-	if (adapter->work_event & ATL1C_WORK_EVENT_RESET) {
-		adapter->work_event &= ~ATL1C_WORK_EVENT_RESET;
+	if (test_and_clear_bit(ATL1C_WORK_EVENT_RESET, &adapter->work_event)) {
 		netif_device_detach(netdev);
 		atl1c_down(adapter);
 		atl1c_up(adapter);
 		netif_device_attach(netdev);
-		return;
 	}
 
-	if (adapter->work_event & ATL1C_WORK_EVENT_LINK_CHANGE) {
-		adapter->work_event &= ~ATL1C_WORK_EVENT_LINK_CHANGE;
+	if (test_and_clear_bit(ATL1C_WORK_EVENT_LINK_CHANGE,
+		&adapter->work_event))
 		atl1c_check_link_status(adapter);
-	}
-	return;
 }
 
 
@@ -369,7 +365,7 @@ static void atl1c_tx_timeout(struct net_
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
 	/* Do the reset outside of interrupt context */
-	adapter->work_event |= ATL1C_WORK_EVENT_RESET;
+	set_bit(ATL1C_WORK_EVENT_RESET, &adapter->work_event);
 	schedule_work(&adapter->common_task);
 }
 


