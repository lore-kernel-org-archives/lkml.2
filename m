Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1HITlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:41:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53986 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1HITjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:39:16 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 6/8] drivers:misc: ti-st: wait for completion at fail
Date: Tue, 9 Aug 2011 14:38:58 -0500
Message-ID: <1312918749-29627-7-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1312918749-29627-6-git-send-email-pavan_savoy@ti.com>
References: <1312918749-29627-1-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-2-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-3-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-4-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-5-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-6-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

When the line discipline install fails for reasons such as missing user-space
UIM or broken communication between UIM and ST driver, then the ST
attempts/retries to request for ldisc installation again.
based out of: OMAPS00246156

Change-Id: Ib1cd03ebd078bbbc2d93b68a37ba2ce1e7fa497e
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 1748a93..d8ca406 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -473,6 +473,12 @@ long st_kim_start(void *kim_data)
 			pr_info("ldisc_install = 0");
 			sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
 					NULL, "install");
+			/* the following wait is never going to be completed,
+			 * since the ldisc was never installed, hence serving
+			 * as a mdelay of LDISC_TIME msecs */
+			err = wait_for_completion_timeout
+				(&kim_gdata->ldisc_installed,
+				 msecs_to_jiffies(LDISC_TIME));
 			err = -ETIMEDOUT;
 			continue;
 		} else {
@@ -485,6 +491,13 @@ long st_kim_start(void *kim_data)
 				pr_info("ldisc_install = 0");
 				sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
 						NULL, "install");
+				/* this wait might be completed, though in the
+				 * tty_close() since the ldisc is already
+				 * installed */
+				err = wait_for_completion_timeout
+					(&kim_gdata->ldisc_installed,
+					 msecs_to_jiffies(LDISC_TIME));
+				err = -EINVAL;
 				continue;
 			} else {	/* on success don't retry */
 				break;
-- 
1.7.4.1

