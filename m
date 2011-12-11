Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab1LKLrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 06:47:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1LKLr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 06:47:28 -0500
From: Laszlo Ersek <lersek@redhat.com>
To: konrad.wilk@oracle.com, jeremy@goop.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4] xen-netfront: delay gARP until backend switches to Connected
Date: Sun, 11 Dec 2011 12:48:59 +0100
Message-Id: <1323604139-3890-1-git-send-email-lersek@redhat.com>
In-Reply-To: <20111209.192439.275865894437319638.davem@davemloft.net>
References: <20111209.192439.275865894437319638.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a guest is live migrated, the xen-netfront driver emits a gratuitous
ARP message, so that networking hardware on the target host's subnet can
take notice, and public routing to the guest is re-established. However,
if the packet appears on the backend interface before the backend is added
to the target host's bridge, the packet is lost, and the migrated guest's
peers become unable to talk to the guest.

A sufficient two-parts condition to prevent the above is:

(1) ensure that the backend only moves to Connected xenbus state after its
hotplug scripts completed, ie. the netback interface got added to the
bridge; and

(2) ensure the frontend only queues the gARP when it sees the backend move
to Connected.

These two together provide complete ordering. Sub-condition (1) is already
satisfied by commit f942dc2552b8 in Linus' tree, based on commit
6b0b80ca7165 from [1].

In general, the full condition is sufficient, not necessary, because,
according to [2], live migration has been working for a long time without
satisfying sub-condition (2). However, after 6b0b80ca7165 was backported
to the RHEL-5 host to ensure (1), (2) still proved necessary in the RHEL-6
guest. This patch intends to provide (2) for upstream.

The Reviewed-by line comes from [3].

[1] git://xenbits.xen.org/people/ianc/linux-2.6.git#upstream/dom0/backend/netback-history
[2] http://old-list-archives.xen.org/xen-devel/2011-06/msg01969.html
[3] http://old-list-archives.xen.org/xen-devel/2011-07/msg00484.html

Signed-off-by: Laszlo Ersek <lersek@redhat.com>
Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/net/xen-netfront.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index d29365a..f033656 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1646,7 +1646,6 @@ static void netback_changed(struct xenbus_device *dev,
 	case XenbusStateInitialised:
 	case XenbusStateReconfiguring:
 	case XenbusStateReconfigured:
-	case XenbusStateConnected:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
@@ -1657,6 +1656,9 @@ static void netback_changed(struct xenbus_device *dev,
 		if (xennet_connect(netdev) != 0)
 			break;
 		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+
+	case XenbusStateConnected:
 		netif_notify_peers(netdev);
 		break;
 
-- 
1.7.4.4

