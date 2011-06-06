Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab1FFV6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:58:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53564 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1FFV6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:58:23 -0400
Date: Mon, 06 Jun 2011 14:58:18 -0700 (PDT)
Message-Id: <20110606.145818.802224963792889208.davem@davemloft.net>
To: cmdkhh@gmail.com
Cc: hadi@cyberus.ca, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sch_generic unused variable warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307143106-14523-1-git-send-email-cmdkhh@gmail.com>
References: <1307143106-14523-1-git-send-email-cmdkhh@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Jun 2011 14:58:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Connor Hansen <cmdkhh@gmail.com>
Date: Fri,  3 Jun 2011 16:18:26 -0700

> during randconfig testing net/sched/sch_generic produced
> net/sched/sch_generic.c: In function dev_watchdog
> net/sched/sch_generic.c:254:10: warning: unused variable drivername
> 
> drivername is only used in the scope of the WARN_ONCE
> 
> Signed-off-by: Connor Hansen <cmdkhh@gmail.com>

I think this warning is telling us to fix the netdev_drivername()
helper instead.

I'll commit the following:

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ca333e7..54b8b4d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2555,7 +2555,7 @@ extern void netdev_class_remove_file(struct class_attribute *class_attr);
 
 extern struct kobj_ns_type_operations net_ns_type_operations;
 
-extern char *netdev_drivername(const struct net_device *dev, char *buffer, int len);
+extern const char *netdev_drivername(const struct net_device *dev);
 
 extern void linkwatch_run_queue(void);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 9393078..1af6cb2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6264,29 +6264,23 @@ err_name:
 /**
  *	netdev_drivername - network driver for the device
  *	@dev: network device
- *	@buffer: buffer for resulting name
- *	@len: size of buffer
  *
  *	Determine network driver for device.
  */
-char *netdev_drivername(const struct net_device *dev, char *buffer, int len)
+const char *netdev_drivername(const struct net_device *dev)
 {
 	const struct device_driver *driver;
 	const struct device *parent;
-
-	if (len <= 0 || !buffer)
-		return buffer;
-	buffer[0] = 0;
+	const char *empty = "";
 
 	parent = dev->dev.parent;
-
 	if (!parent)
-		return buffer;
+		return empty;
 
 	driver = parent->driver;
 	if (driver && driver->name)
-		strlcpy(buffer, driver->name, len);
-	return buffer;
+		return driver->name;
+	return empty;
 }
 
 static int __netdev_printk(const char *level, const struct net_device *dev,
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index b1721d7..b4c6809 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -251,9 +251,8 @@ static void dev_watchdog(unsigned long arg)
 			}
 
 			if (some_queue_timedout) {
-				char drivername[64];
 				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
-				       dev->name, netdev_drivername(dev, drivername, 64), i);
+				       dev->name, netdev_drivername(dev), i);
 				dev->netdev_ops->ndo_tx_timeout(dev);
 			}
 			if (!mod_timer(&dev->watchdog_timer,
