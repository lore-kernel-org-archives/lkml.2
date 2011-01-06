Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1AFAsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:48:05 -0500
Received: from kroah.org ([198.145.64.141]:35795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab1AFAaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:08 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:03 2011
Message-Id: <20110106002303.760260928@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [075/152] net/dst: dst_dev_event() called after other notifiers
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
---
 net/core/dst.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -343,6 +343,7 @@ static int dst_dev_event(struct notifier
 
 static struct notifier_block dst_dev_notifier = {
 	.notifier_call	= dst_dev_event,
+	.priority = -10, /* must be called after other network notifiers */
 };
 
 void __init dst_init(void)


