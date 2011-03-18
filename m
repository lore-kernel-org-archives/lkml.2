Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1CRDzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:55:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51855 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab1CRDzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:55:37 -0400
Message-ID: <4D82D821.1070101@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:57:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/36] ixgbe,rcu: convert call_rcu(ring_free_rcu) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:54:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:54:14,
	Serialize complete at 2011-03-18 11:54:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback ring_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ring_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/net/ixgbe/ixgbe_main.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 30f9ccf..3e7fff5 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -5003,11 +5003,6 @@ err_set_interrupt:
 	return err;
 }
 
-static void ring_free_rcu(struct rcu_head *head)
-{
-	kfree(container_of(head, struct ixgbe_ring, rcu));
-}
-
 /**
  * ixgbe_clear_interrupt_scheme - Clear the current interrupt scheme settings
  * @adapter: board private structure to clear interrupt scheme on
@@ -5029,7 +5024,7 @@ void ixgbe_clear_interrupt_scheme(struct ixgbe_adapter *adapter)
 		/* ixgbe_get_stats64() might access this ring, we must wait
 		 * a grace period before freeing it.
 		 */
-		call_rcu(&ring->rcu, ring_free_rcu);
+		kfree_rcu(ring, rcu);
 		adapter->rx_ring[i] = NULL;
 	}
 
-- 
1.7.4
