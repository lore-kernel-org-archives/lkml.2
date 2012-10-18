Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab2JRKEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:04:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:51546 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab2JRKEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:04:09 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="41651130"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xen.org
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5/5] xen-kbdfront: handle backend CLOSED without CLOSING
Date: Thu, 18 Oct 2012 11:03:38 +0100
Message-ID: <1350554618-14582-5-git-send-email-david.vrabel@citrix.com>
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
Cc: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
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

