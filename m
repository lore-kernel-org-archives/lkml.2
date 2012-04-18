Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2DREgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:36:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48903 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2DREgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:36:45 -0400
Subject: [PATCH net-next] netfilter: nf_conntrack.h: use this_cpu_inc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Apr 2012 06:36:40 +0200
Message-ID: <1334723800.2472.88.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

this_cpu_inc() is IRQ safe and faster than
local_bh_disable()/__this_cpu_inc()/local_bh_enable(), at least on x86.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
---
 include/net/netfilter/nf_conntrack.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index ab86036..cce7f6a 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -321,14 +321,8 @@ extern unsigned int nf_conntrack_max;
 extern unsigned int nf_conntrack_hash_rnd;
 void init_nf_conntrack_hash_rnd(void);
 
-#define NF_CT_STAT_INC(net, count)	\
-	__this_cpu_inc((net)->ct.stat->count)
-#define NF_CT_STAT_INC_ATOMIC(net, count)		\
-do {							\
-	local_bh_disable();				\
-	__this_cpu_inc((net)->ct.stat->count);		\
-	local_bh_enable();				\
-} while (0)
+#define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
+#define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
 
 #define MODULE_ALIAS_NFCT_HELPER(helper) \
         MODULE_ALIAS("nfct-helper-" helper)


