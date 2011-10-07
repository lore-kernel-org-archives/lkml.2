Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab1JGMov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:44:51 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46891 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951Ab1JGMou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:44:50 -0400
X-AuditID: b753bd60-a2688ba000000655-5c-4e8ef4401672
X-AuditID: b753bd60-a2688ba000000655-5c-4e8ef4401672
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH net 2/2] [BUGFIX] bonding: use flush_delayed_work_sync in
 bond_close
To: Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>
Date: Fri, 07 Oct 2011 21:50:06 +0900
Message-ID: <20111007125006.7089.9539.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20111007124925.7089.27260.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111007124925.7089.27260.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bond_close() calls cancel_delayed_work() to cancel delayed works.
It, however, cannot cancel works that were already queued in workqueue.
The bond_open() initializes work->data, and proccess_one_work() refers
get_work_cwq(work)->wq->flags. The get_work_cwq() returns NULL when
work->data has been initialized. Thus, a panic occurs.

This patch uses flush_delayed_work_sync() instead of cancel_delayed_work()
in bond_close(). It cancels delayed timer and waits for work to finish
execution. So, it can avoid the null pointer dereference due to the
parallel executions of proccess_one_work() and initializing proccess
of bond_open().

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
---

 drivers/net/bonding/bond_main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index f1baec5..cd490b7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3504,27 +3504,27 @@ static int bond_close(struct net_device *bond_dev)
 	write_unlock_bh(&bond->lock);
 
 	if (bond->params.miimon) {  /* link check interval, in milliseconds. */
-		cancel_delayed_work(&bond->mii_work);
+		flush_delayed_work_sync(&bond->mii_work);
 	}
 
 	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
-		cancel_delayed_work(&bond->arp_work);
+		flush_delayed_work_sync(&bond->arp_work);
 	}
 
 	switch (bond->params.mode) {
 	case BOND_MODE_8023AD:
-		cancel_delayed_work(&bond->ad_work);
+		flush_delayed_work_sync(&bond->ad_work);
 		break;
 	case BOND_MODE_TLB:
 	case BOND_MODE_ALB:
-		cancel_delayed_work(&bond->alb_work);
+		flush_delayed_work_sync(&bond->alb_work);
 		break;
 	default:
 		break;
 	}
 
 	if (delayed_work_pending(&bond->mcast_work))
-		cancel_delayed_work(&bond->mcast_work);
+		flush_delayed_work_sync(&bond->mcast_work);
 
 	if (bond_is_lb(bond)) {
 		/* Must be called only after all

