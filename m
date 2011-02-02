Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1BBAoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:47465 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1BBAoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960649"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: eric.dumazet@gmail.com, greearb@candelatech.com, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [72/139] net/dst: dst_dev_event() called after other notifiers
Message-Id: <20110202004429.280C23E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 332dd96f7ac15e937088fe11f15cfe0210e8edd1 ]

Followup of commit ef885afbf8a37689 (net: use rcu_barrier() in
rollback_registered_many)

dst_dev_event() scans a garbage dst list that might be feeded by various
network notifiers at device dismantle time.

Its important to call dst_dev_event() after other notifiers, or we might
enter the infamous msleep(250) in netdev_wait_allrefs(), and wait one
second before calling again call_netdevice_notifiers(NETDEV_UNREGISTER,
dev) to properly remove last device references.

Use priority -10 to let dst_dev_notifier be called after other network
notifiers (they have the default 0 priority)

Reported-by: Ben Greear <greearb@candelatech.com>
Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reported-by: Octavian Purdila <opurdila@ixiacom.com>
Reported-by: Benjamin LaHaise <bcrl@kvack.org>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/core/dst.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/net/core/dst.c
===================================================================
--- linux-2.6.35.y.orig/net/core/dst.c
+++ linux-2.6.35.y/net/core/dst.c
@@ -343,6 +343,7 @@ static int dst_dev_event(struct notifier
 
 static struct notifier_block dst_dev_notifier = {
 	.notifier_call	= dst_dev_event,
+	.priority = -10, /* must be called after other network notifiers */
 };
 
 void __init dst_init(void)
