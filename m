Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2IUQGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:06:00 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58717 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab2IUQFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:05:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,463,1344211200"; 
   d="scan'208";a="38744205"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, <linux-fbdev@vger.kernel.org>
Subject: [PATCH 4/6] xen-fbfront: handle backend CLOSED without CLOSING
Date: Fri, 21 Sep 2012 17:04:22 +0100
Message-ID: <1348243464-15903-5-git-send-email-david.vrabel@citrix.com>
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
Cc: <linux-fbdev@vger.kernel.org>
---
 drivers/video/xen-fbfront.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index b7f5173..917bb56 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -641,7 +641,6 @@ static void xenfb_backend_changed(struct xenbus_device *dev,
 	case XenbusStateReconfiguring:
 	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
-	case XenbusStateClosed:
 		break;
 
 	case XenbusStateInitWait:
@@ -670,6 +669,10 @@ InitWait:
 		info->feature_resize = val;
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

