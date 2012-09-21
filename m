Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab2IUQFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:05:25 -0400
Received: from smtp.citrix.com ([66.165.176.89]:24192 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab2IUQFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:05:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,463,1344211200"; 
   d="scan'208";a="38744206"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/6] xen-netfront: handle backend CLOSED without CLOSING
Date: Fri, 21 Sep 2012 17:04:19 +0100
Message-ID: <1348243464-15903-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com>
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Backend drivers shouldn't transistion to CLOSED unless the frontend is
CLOSED.  If a backend does transition to CLOSED too soon then the
frontend may not see the CLOSING state and will not properly shutdown.

So, treat an unexpected backend CLOSED state the same as CLOSING.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: <netdev@vger.kernel.org>
---
 drivers/net/xen-netfront.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 3089990..843533a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1719,7 +1719,6 @@ static void netback_changed(struct xenbus_device *dev,
 	case XenbusStateReconfiguring:
 	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
-	case XenbusStateClosed:
 		break;
 
 	case XenbusStateInitWait:
@@ -1734,6 +1733,10 @@ static void netback_changed(struct xenbus_device *dev,
 		netif_notify_peers(netdev);
 		break;
 
+	case XenbusStateClosed:
+		if (dev->state == XenbusStateClosed)
+			break;
+		/* Missed the backend's CLOSING state -- fallthrough */
 	case XenbusStateClosing:
 		xenbus_frontend_closed(dev);
 		break;
-- 
1.7.2.5

