Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1DKITg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:19:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48596 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab1DKITf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:19:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110411172004.0361.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 11 Apr 2011 17:19:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, Robert Mueller reported zone_reclaim_mode doesn't work
properly on his new NUMA server (Dual Xeon E5520 + Intel S5520UR MB).
He is using Cyrus IMAPd and it's built on a very traditional
single-process model.

  * a master process which reads config files and manages the other
    process
  * multiple imapd processes, one per connection
  * multiple pop3d processes, one per connection
  * multiple lmtpd processes, one per connection
  * periodical "cleanup" processes.

Then, there are thousands of independent processes. The problem is,
recent Intel motherboard turn on zone_reclaim_mode by default and
traditional prefork model software don't work fine on it.
Unfortunatelly, Such model is still typical one even though 21th
century. We can't ignore them.

This patch raise zone_reclaim_mode threshold to 30. 30 don't have
specific meaning. but 20 mean one-hop QPI/Hypertransport and such
relatively cheap 2-4 socket machine are often used for tradiotional
server as above. The intention is, their machine don't use
zone_reclaim_mode.

Note: ia64 and Power have arch specific RECLAIM_DISTANCE definition.
then this patch doesn't change such high-end NUMA machine behavior.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/topology.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index b91a40e..fc839bf 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -60,7 +60,7 @@ int arch_update_cpu_topology(void);
  * (in whatever arch specific measurement units returned by node_distance())
  * then switch on zone reclaim on boot.
  */
-#define RECLAIM_DISTANCE 20
+#define RECLAIM_DISTANCE 30
 #endif
 #ifndef PENALTY_FOR_NODE_WITH_CPUS
 #define PENALTY_FOR_NODE_WITH_CPUS	(1)
-- 
1.7.3.1



