Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570Ab1DNR4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:56:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:38346 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262Ab1DNRqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segooon@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 077/209] usb: core: fix information leak to userland
Date: Thu, 14 Apr 2011 13:41:47 -0400
Message-Id: <1302803039-9400-78-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 886ccd4520064408ce5876cfe00554ce52ecf4a7 upstream.

Structure usbdevfs_connectinfo is copied to userland with padding byted
after "slow" field uninitialized.  It leads to leaking of contents of
kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/devio.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 3466fdc..6088192 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -966,10 +966,11 @@ static int proc_getdriver(struct dev_state *ps, void __user *arg)
 
 static int proc_connectinfo(struct dev_state *ps, void __user *arg)
 {
-	struct usbdevfs_connectinfo ci;
+	struct usbdevfs_connectinfo ci = {
+		.devnum = ps->dev->devnum,
+		.slow = ps->dev->speed == USB_SPEED_LOW
+	};
 
-	ci.devnum = ps->dev->devnum;
-	ci.slow = ps->dev->speed == USB_SPEED_LOW;
 	if (copy_to_user(arg, &ci, sizeof(ci)))
 		return -EFAULT;
 	return 0;
-- 
1.7.4.4

