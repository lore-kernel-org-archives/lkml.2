Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab2HLGXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 02:23:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61157 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2HLGXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 02:23:18 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ian Campbell <ian.campbell@citrix.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH v2] macvtap: rcu_dereference outside read-lock section
Date: Sun, 12 Aug 2012 10:26:31 +0400
Message-Id: <1344752791-21140-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <20120811.181642.1587792778007257202.davem@davemloft.net>
References: <20120811.181642.1587792778007257202.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_dereference occurs in update section. Replacement by
rcu_dereference_protected in order to prevent lockdep
complaint.

Found by Linux Driver Verification project (linuxtesting.org)

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/net/macvtap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 0737bd4..0f0f9ce 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -94,7 +94,8 @@ static int get_slot(struct macvlan_dev *vlan, struct macvtap_queue *q)
 	int i;
 
 	for (i = 0; i < MAX_MACVTAP_QUEUES; i++) {
-		if (rcu_dereference(vlan->taps[i]) == q)
+		if (rcu_dereference_protected(vlan->taps[i],
+					      lockdep_is_held(&macvtap_lock)) == q)
 			return i;
 	}
 
-- 
1.7.7

