Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2IUQGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:06:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64690 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab2IUQFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:05:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,463,1344211200"; 
   d="scan'208";a="38744201"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, <linux-input@vger.kernel.org>
Subject: [PATCH 5/6] xen-kbdfront: handle backend CLOSED without CLOSING
Date: Fri, 21 Sep 2012 17:04:23 +0100
Message-ID: <1348243464-15903-6-git-send-email-david.vrabel@citrix.com>
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
Cc: <linux-input@vger.kernel.org>
---
 drivers/input/misc/xen-kbdfront.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 02ca868..6f7d990 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -311,7 +311,6 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 	case XenbusStateReconfiguring:
 	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
-	case XenbusStateClosed:
 		break;
 
 	case XenbusStateInitWait:
@@ -350,6 +349,10 @@ InitWait:
 
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

