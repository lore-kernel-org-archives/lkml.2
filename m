Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab0J1PcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:32:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801Ab0J1Pb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YYmet6ImVxKGKwWtWnfvqcoNL96bAbvKPnpJamtAwRpL9KLwVt2Pfk6ziR/LBQWEic
         vYVwudCQRWEgMhaICkHMm5v4X9So8DWotaMFHVCf1NiL5HuQboH9XlQyp1kIIhT3fgh8
         QPKiRvOBbU2/IR59h3vTl6iKVdprbUCs58tas=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2 3/7] USB: gadget: f_mass_storage: use ?: instead of a macro
Date: Thu, 28 Oct 2010 17:31:20 +0200
Message-Id: <c98d8da2966a20ac381d87298c215b4fc487faaf.1288256118.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
References: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes an "OR" macro defined in Mass Storage
Function in favour of a two argument version of "?:" operator
(which is a GCC extension).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

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

