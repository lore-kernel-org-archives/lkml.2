Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab2LNLEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:04:05 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:50841 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2LNLDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:03:05 -0500
Subject: [PATCH 09/12] pps: fix device destruction ordering
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Date: Fri, 14 Dec 2012 15:02:59 +0400
Message-ID: <20121214110259.11019.63158.stgit@zurg>
In-Reply-To: <20121214110229.11019.63713.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_destroy() calls final kfree(), thus cdev_del() must be called before it.
Catched as overwritten poison in kmalloc-512.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
---
 drivers/pps/pps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2420d5a..769bb84 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -352,8 +352,8 @@ free_idr:
 
 void pps_unregister_cdev(struct pps_device *pps)
 {
-	device_destroy(pps_class, pps->dev->devt);
 	cdev_del(&pps->cdev);
+	device_destroy(pps_class, pps->dev->devt);
 }
 
 /*

