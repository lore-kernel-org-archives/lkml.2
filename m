Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0C3Xbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:31:40 -0400
Received: from kroah.org ([198.145.64.141]:46598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925Ab0C3XVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:32 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:39 2010
Message-Id: <20100330224838.884108218@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vitaliy Gusev <vgusev@openvz.org>, Neil Horman <nhorman@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [120/156] route: Fix caught BUG_ON during rt_secret_rebuild_oneshot()
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vitaliy Gusev <vgusev@openvz.org>

[ Upstream commit 858a18a6a2f74e8f0e5b2e9671d4b74694aba708 ]

route: Fix caught BUG_ON during rt_secret_rebuild_oneshot()

Call rt_secret_rebuild can cause BUG_ON(timer_pending(&net->ipv4.rt_secret_timer)) in
add_timer as there is not any synchronization for call rt_secret_rebuild_oneshot()
for the same net namespace.

Also this issue affects to rt_secret_reschedule().

Thus use mod_timer enstead.

Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/route.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -922,10 +922,8 @@ static void rt_secret_rebuild_oneshot(st
 {
 	del_timer_sync(&net->ipv4.rt_secret_timer);
 	rt_cache_invalidate(net);
-	if (ip_rt_secret_interval) {
-		net->ipv4.rt_secret_timer.expires += ip_rt_secret_interval;
-		add_timer(&net->ipv4.rt_secret_timer);
-	}
+	if (ip_rt_secret_interval)
+		mod_timer(&net->ipv4.rt_secret_timer, jiffies + ip_rt_secret_interval);
 }
 
 static void rt_emergency_hash_rebuild(struct net *net)
@@ -3072,22 +3070,20 @@ static void rt_secret_reschedule(int old
 	rtnl_lock();
 	for_each_net(net) {
 		int deleted = del_timer_sync(&net->ipv4.rt_secret_timer);
+		long time;
 
 		if (!new)
 			continue;
 
 		if (deleted) {
-			long time = net->ipv4.rt_secret_timer.expires - jiffies;
+			time = net->ipv4.rt_secret_timer.expires - jiffies;
 
 			if (time <= 0 || (time += diff) <= 0)
 				time = 0;
-
-			net->ipv4.rt_secret_timer.expires = time;
 		} else
-			net->ipv4.rt_secret_timer.expires = new;
+			time = new;
 
-		net->ipv4.rt_secret_timer.expires += jiffies;
-		add_timer(&net->ipv4.rt_secret_timer);
+		mod_timer(&net->ipv4.rt_secret_timer, jiffies + time);
 	}
 	rtnl_unlock();
 }


