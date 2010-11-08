Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0KHUcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:32:33 -0500
Received: from smtp-out.google.com ([74.125.121.35]:2891 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab0KHUcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:32:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=kjYiXlJpIMXZ95tZkxl1aTwj6lG8F67Dwn09hGKrP3/ZOT1ypJZzf7pKdFizTLXCX
	tp+T7JljPKGcMHUxd6l8w==
Subject: [PATCH v2 04/23] netconsole: Call netpoll_cleanup() in process context
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Date: Mon, 08 Nov 2010 12:32:00 -0800
Message-ID: <20101108203159.22479.48774.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The netconsole driver currently deadlocks if a NETDEV_UNREGISTER event
is received while netconsole is in use, which in turn causes it to pin a
reference to the network device.  The first deadlock was dealt with in
3b410a31 so that we wouldn't recursively grab RTNL, but even calling
__netpoll_cleanup isn't safe to do considering that we are in atomic
context.  __netpoll_cleanup assumes it can sleep and has several
sleeping calls, such as synchronize_rcu_bh and
cancel_rearming_delayed_work.

Fix this by deferring netpoll_cleanup using scheduling work that
operates in process context.  We have to grab a reference to the
config_item in this case as we need to pin the item in place until it is
operated on.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/net/netconsole.c |   55 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 288a025..02ba5c4 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -106,6 +106,7 @@ struct netconsole_target {
 #endif
 	int			np_state;
 	struct netpoll		np;
+	struct work_struct	cleanup_work;
 };
 
 #ifdef	CONFIG_NETCONSOLE_DYNAMIC
@@ -166,6 +167,22 @@ static void netconsole_target_put(struct netconsole_target *nt)
 
 #endif	/* CONFIG_NETCONSOLE_DYNAMIC */
 
+static void deferred_netpoll_cleanup(struct work_struct *work)
+{
+	struct netconsole_target *nt;
+	unsigned long flags;
+
+	nt = container_of(work, struct netconsole_target, cleanup_work);
+	netpoll_cleanup(&nt->np);
+
+	spin_lock_irqsave(&target_list_lock, flags);
+	BUG_ON(nt->np_state != NETPOLL_CLEANING);
+	nt->np_state = NETPOLL_DISABLED;
+	spin_unlock_irqrestore(&target_list_lock, flags);
+
+	netconsole_target_put(nt);
+}
+
 /* Allocate new target (from boot/module param) and setup netpoll for it */
 static struct netconsole_target *alloc_param_target(char *target_config)
 {
@@ -187,6 +204,7 @@ static struct netconsole_target *alloc_param_target(char *target_config)
 	nt->np.local_port = 6665;
 	nt->np.remote_port = 6666;
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
+	INIT_WORK(&nt->cleanup_work, deferred_netpoll_cleanup);
 
 	/* Parse parameters and setup netpoll */
 	err = netpoll_parse_options(&nt->np, target_config);
@@ -209,7 +227,9 @@ fail:
 /* Cleanup netpoll for given target (from boot/module param) and free it */
 static void free_param_target(struct netconsole_target *nt)
 {
-	netpoll_cleanup(&nt->np);
+	cancel_work_sync(&nt->cleanup_work);
+	if (nt->np_state == NETPOLL_CLEANING || nt->np_state == NETPOLL_ENABLED)
+		netpoll_cleanup(&nt->np);
 	kfree(nt);
 }
 
@@ -350,6 +370,13 @@ static ssize_t store_enabled(struct netconsole_target *nt,
 			goto busy;
 		else {
 			nt->np_state = NETPOLL_SETTINGUP;
+			/*
+			 * Nominally, we would grab an extra reference on the
+			 * config_item here for dynamic targets while we let go
+			 * of the lock, but this isn't required in this case
+			 * because there is a reference implicitly held by the
+			 * caller of the store operation.
+			 */
 			spin_unlock_irqrestore(&target_list_lock, flags);
 		}
 
@@ -635,6 +662,7 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 	nt->np.local_port = 6665;
 	nt->np.remote_port = 6666;
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
+	INIT_WORK(&nt->cleanup_work, deferred_netpoll_cleanup);
 
 	/* Initialize the config_item member */
 	config_item_init_type_name(&nt->item, name, &netconsole_target_type);
@@ -660,6 +688,9 @@ static void drop_netconsole_target(struct config_group *group,
 	/*
 	 * The target may have never been enabled, or was manually disabled
 	 * before being removed so netpoll may have already been cleaned up.
+	 *
+	 * If it queued for cleanup already, that is fine, as that path holds a
+	 * reference to the config_item.
 	 */
 	if (nt->np_state == NETPOLL_ENABLED)
 		netpoll_cleanup(&nt->np);
@@ -689,6 +720,19 @@ static struct configfs_subsystem netconsole_subsys = {
 
 #endif	/* CONFIG_NETCONSOLE_DYNAMIC */
 
+/*
+ * Call netpoll_cleanup on this target asynchronously.
+ * target_list_lock is required.
+ */
+static void defer_netpoll_cleanup(struct netconsole_target *nt)
+{
+	if (nt->np_state != NETPOLL_ENABLED)
+		return;
+	netconsole_target_get(nt);
+	nt->np_state = NETPOLL_CLEANING;
+	schedule_work(&nt->cleanup_work);
+}
+
 /* Handle network interface device notifications */
 static int netconsole_netdev_event(struct notifier_block *this,
 				   unsigned long event,
@@ -712,13 +756,10 @@ static int netconsole_netdev_event(struct notifier_block *this,
 			case NETDEV_BONDING_DESLAVE:
 			case NETDEV_UNREGISTER:
 				/*
-				 * rtnl_lock already held
+				 * We can't cleanup netpoll in atomic context.
+				 * Kick it off as deferred work.
 				 */
-				if (nt->np.dev) {
-					__netpoll_cleanup(&nt->np);
-					dev_put(nt->np.dev);
-					nt->np.dev = NULL;
-				}
+				defer_netpoll_cleanup(nt);
 			}
 		}
 	}

