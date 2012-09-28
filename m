Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946051Ab2I1WAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:00:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031193Ab2I1UV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:21:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Cong Wang <amwang@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 009/218] ipv6: addrconf: Avoid calling netdevice notifiers with RCU read-side lock
Date: Fri, 28 Sep 2012 13:13:46 -0700
Message-Id: <20120928201502.374788425@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 4acd4945cd1e1f92b20d14e349c6c6a52acbd42d ]

Cong Wang reports that lockdep detected suspicious RCU usage while
enabling IPV6 forwarding:

 [ 1123.310275] ===============================
 [ 1123.442202] [ INFO: suspicious RCU usage. ]
 [ 1123.558207] 3.6.0-rc1+ #109 Not tainted
 [ 1123.665204] -------------------------------
 [ 1123.768254] include/linux/rcupdate.h:430 Illegal context switch in RCU read-side critical section!
 [ 1123.992320]
 [ 1123.992320] other info that might help us debug this:
 [ 1123.992320]
 [ 1124.307382]
 [ 1124.307382] rcu_scheduler_active = 1, debug_locks = 0
 [ 1124.522220] 2 locks held by sysctl/5710:
 [ 1124.648364]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81768498>] rtnl_trylock+0x15/0x17
 [ 1124.882211]  #1:  (rcu_read_lock){.+.+.+}, at: [<ffffffff81871df8>] rcu_lock_acquire+0x0/0x29
 [ 1125.085209]
 [ 1125.085209] stack backtrace:
 [ 1125.332213] Pid: 5710, comm: sysctl Not tainted 3.6.0-rc1+ #109
 [ 1125.441291] Call Trace:
 [ 1125.545281]  [<ffffffff8109d915>] lockdep_rcu_suspicious+0x109/0x112
 [ 1125.667212]  [<ffffffff8107c240>] rcu_preempt_sleep_check+0x45/0x47
 [ 1125.781838]  [<ffffffff8107c260>] __might_sleep+0x1e/0x19b
[...]
 [ 1127.445223]  [<ffffffff81757ac5>] call_netdevice_notifiers+0x4a/0x4f
[...]
 [ 1127.772188]  [<ffffffff8175e125>] dev_disable_lro+0x32/0x6b
 [ 1127.885174]  [<ffffffff81872d26>] dev_forward_change+0x30/0xcb
 [ 1128.013214]  [<ffffffff818738c4>] addrconf_forward_change+0x85/0xc5
[...]

addrconf_forward_change() uses RCU iteration over the netdev list,
which is unnecessary since it already holds the RTNL lock.  We also
cannot reasonably require netdevice notifier functions not to sleep.

Reported-by: Cong Wang <amwang@redhat.com>
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -493,8 +493,7 @@ static void addrconf_forward_change(stru
 	struct net_device *dev;
 	struct inet6_dev *idev;
 
-	rcu_read_lock();
-	for_each_netdev_rcu(net, dev) {
+	for_each_netdev(net, dev) {
 		idev = __in6_dev_get(dev);
 		if (idev) {
 			int changed = (!idev->cnf.forwarding) ^ (!newf);
@@ -503,7 +502,6 @@ static void addrconf_forward_change(stru
 				dev_forward_change(idev);
 		}
 	}
-	rcu_read_unlock();
 }
 
 static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int newf)


