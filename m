Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965221Ab1KJEYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:24:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965199Ab1KJDj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:39:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:52 2011
Message-Id: <20111109213152.078443331@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [099/264] rtnetlink: Add missing manual netlink notification in dev_change_net_namespaces
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

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

Tested-by: Renato Westphal <renatowestphal@gmail.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6115,6 +6115,7 @@ int dev_change_net_namespace(struct net_
 	*/
 	call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
 	call_netdevice_notifiers(NETDEV_UNREGISTER_BATCH, dev);
+	rtmsg_ifinfo(RTM_DELLINK, dev, ~0U);
 
 	/*
 	 *	Flush the unicast and multicast chains


