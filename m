Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2G0PjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab2G0PjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:39:11 -0400
From: Cong Wang <amwang@redhat.com>
To: netdev@vger.kernel.org
Cc: Cong Wang <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Gao feng <gaofeng@cn.fujitsu.com>, Lin Ming <ming.m.lin@intel.com>,
        Joe Perches <joe@perches.com>, Flavio Leitner <fbl@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] netconsole: do not release spin_lock before calling __netpoll_cleanup
Date: Fri, 27 Jul 2012 23:38:00 +0800
Message-Id: <1343403484-29347-4-git-send-email-amwang@redhat.com>
In-Reply-To: <1343403484-29347-1-git-send-email-amwang@redhat.com>
References: <1343403484-29347-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous patch applied, __netpoll_cleanup() is non-block now,
so we don't need to release the spin_lock before calling it.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/net/netconsole.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index f9347ea..f0ad56c 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -640,12 +640,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 				 * rtnl_lock already held
 				 */
 				if (nt->np.dev) {
-					spin_unlock_irqrestore(
-							      &target_list_lock,
-							      flags);
 					__netpoll_cleanup(&nt->np);
-					spin_lock_irqsave(&target_list_lock,
-							  flags);
 					dev_put(nt->np.dev);
 					nt->np.dev = NULL;
 					netconsole_target_put(nt);
-- 
1.7.7.6

