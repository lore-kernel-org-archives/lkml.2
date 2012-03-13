Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965339Ab2CMA17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:27:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:49037 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965278Ab2CMAZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 192/196] rtnetlink: Add missing manual netlink notification in dev_change_net_namespaces
Date: Mon, 12 Mar 2012 20:21:45 -0400
Message-Id: <1331598109-31424-147-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d2237d35748e7f448a9c2d9dc6a85ef637466e24 upstream.

Renato Westphal noticed that since commit a2835763e130c343ace5320c20d33c281e7097b7
"rtnetlink: handle rtnl_link netlink notifications manually" was merged
we no longer send a netlink message when a networking device is moved
from one network namespace to another.

Fix this by adding the missing manual notification in dev_change_net_namespaces.

Since all network devices that are processed by dev_change_net_namspaces are
in the initialized state the complicated tests that guard the manual
rtmsg_ifinfo calls in rollback_registered and register_netdevice are
unnecessary and we can just perform a plain notification.

Cc: stable@kernel.org
Tested-by: Renato Westphal <renatowestphal@gmail.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1bde8b7..bcd5f6e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5693,6 +5693,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	*/
 	call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
 	call_netdevice_notifiers(NETDEV_UNREGISTER_BATCH, dev);
+	rtmsg_ifinfo(RTM_DELLINK, dev, ~0U);
 
 	/*
 	 *	Flush the unicast and multicast chains
-- 
1.7.9.3

