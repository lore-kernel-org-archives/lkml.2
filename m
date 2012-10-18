Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2JRKEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:04:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15884 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2JRKEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:04:06 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="211697518"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xen.org
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/5] xen-fbfront: handle backend CLOSED without CLOSING
Date: Thu, 18 Oct 2012 11:03:37 +0100
Message-ID: <1350554618-14582-4-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <507FD39F.4060601@citrix.com>
References: <507FD39F.4060601@citrix.com>
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
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
Cc: linux-fbdev@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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

