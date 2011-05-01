Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602Ab1EANbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:31:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38961 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012Ab1EANWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 54/86] ixgbe,rcu: convert call_rcu(ring_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:34 -0700
Message-Id: <1304256126-26015-54-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback ring_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ring_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 drivers/net/ixgbe/ixgbe_main.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 6f8adc7..e145f2c 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -5100,11 +5100,6 @@ err_set_interrupt:
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
@@ -5126,7 +5121,7 @@ void ixgbe_clear_interrupt_scheme(struct ixgbe_adapter *adapter)
 		/* ixgbe_get_stats64() might access this ring, we must wait
 		 * a grace period before freeing it.
 		 */
-		call_rcu(&ring->rcu, ring_free_rcu);
+		kfree_rcu(ring, rcu);
 		adapter->rx_ring[i] = NULL;
 	}
 
-- 
1.7.3.2

