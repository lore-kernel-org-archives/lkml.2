Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1HZUeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab1HZUed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/13] drivers:misc: ti-st: wait for completion at fail
Date: Fri, 26 Aug 2011 13:33:52 -0700
Message-Id: <1314390834-3411-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

When the line discipline install fails for reasons such as missing user-space
UIM or broken communication between UIM and ST driver, then the ST
attempts/retries to request for ldisc installation again.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.6.1

