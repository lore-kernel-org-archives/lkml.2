Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab0JZNh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:37:58 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35427 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889Ab0JZNgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:36:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 26 Oct 2010 15:38:54 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 3/7] USB: gadget: f_mass_storage: use ?: instead of a macro
In-reply-to: <4a6e11ec91ee592689f553dc69df515b4302691b.1288099890.git.m.nazarewicz@samsung.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Message-id: <e4d7faa839773178984edc8e17cffed7b44e1411.1288099890.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <7214986593243afb11434ddb86da7e0460dc1f51.1288099890.git.m.nazarewicz@samsung.com>
 <4a6e11ec91ee592689f553dc69df515b4302691b.1288099890.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit removes an "OR" macro defined in Mass Storage
Function in favour of a two argument version of "?:" operator
(which is a GCC extension).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

"?:" is probably not very nice either, but it's better than a custom macro,
isn't it?

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index c89b992..2a4aca1 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2822,14 +2822,12 @@ buffhds_first_it:
 			i = 0x0399;
 		}
 	}
-#define OR(x, y) ((x) ? (x) : (y))
 	snprintf(common->inquiry_string, sizeof common->inquiry_string,
-		 "%-8s%-16s%04x",
-		 OR(cfg->vendor_name, "Linux   "),
+		 "%-8s%-16s%04x", cfg->vendor_name ?: "Linux",
 		 /* Assume product name dependent on the first LUN */
-		 OR(cfg->product_name, common->luns->cdrom
+		 cfg->product_name ?: (common->luns->cdrom
 				     ? "File-Stor Gadget"
-				     : "File-CD Gadget  "),
+				     : "File-CD Gadget"),
 		 i);
 
 
@@ -2848,14 +2846,13 @@ buffhds_first_it:
 	/* Tell the thread to start working */
 	common->thread_task =
 		kthread_create(fsg_main_thread, common,
-			       OR(cfg->thread_name, "file-storage"));
+			       cfg->thread_name ?: "file-storage");
 	if (IS_ERR(common->thread_task)) {
 		rc = PTR_ERR(common->thread_task);
 		goto error_release;
 	}
 	init_completion(&common->thread_notifier);
 	init_waitqueue_head(&common->fsg_wait);
-#undef OR
 
 
 	/* Information */
-- 
1.7.1

