Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162571Ab2GLXYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:24:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934311Ab2GLXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 08/68] dummy: fix rcu_sched self-detected stalls
Date: Thu, 12 Jul 2012 16:01:42 -0700
Message-Id: <20120712175036.147190749@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 16b0dc29c1af9df341428f4c49ada4f626258082 ]

Trying to "modprobe dummy numdummies=30000" triggers :

INFO: rcu_sched self-detected stall on CPU { 8} (t=60000 jiffies)

After this splat, RTNL is locked and reboot is needed.

We must call cond_resched() to avoid this, even holding RTNL.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dummy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -186,8 +186,10 @@ static int __init dummy_init_module(void
 	rtnl_lock();
 	err = __rtnl_link_register(&dummy_link_ops);
 
-	for (i = 0; i < numdummies && !err; i++)
+	for (i = 0; i < numdummies && !err; i++) {
 		err = dummy_init_one();
+		cond_resched();
+	}
 	if (err < 0)
 		__rtnl_link_unregister(&dummy_link_ops);
 	rtnl_unlock();


