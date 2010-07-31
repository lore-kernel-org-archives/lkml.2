Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0GaRjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:39:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64477 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0GaRjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cK4X1+MHx8dYTgxaO7WGxfVTKrTi4PsJEgZ7mjdyqmdepOU+DHUDR4QcDA+tjyKHJH
         WSgfdbivneAtteg2NjwVRWI49K6L60alWU618i2IPFJjH08+CZx+1AzF45kPUNt4EUkH
         f3u6TXMTD3sqiSMi7BhujVQkiwdRWK6yH6vXA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tony Lindgren <tony@atomide.com>,
        Cory Maccarrone <darkstar6262@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] usb: omap_udc: check return value of proc_create()
Date: Sat, 31 Jul 2010 21:39:24 +0400
Message-Id: <1280597965-8525-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_create() may fail, if so return -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/gadget/omap_udc.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index f81e4f0..1083216 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2544,9 +2544,9 @@ static const struct file_operations proc_ops = {
 	.release	= single_release,
 };
 
-static void create_proc_file(void)
+static int create_proc_file(void)
 {
-	proc_create(proc_filename, 0, NULL, &proc_ops);
+	return (proc_create(proc_filename, 0, NULL, &proc_ops) == NULL);
 }
 
 static void remove_proc_file(void)
@@ -2556,7 +2556,7 @@ static void remove_proc_file(void)
 
 #else
 
-static inline void create_proc_file(void) {}
+static inline int create_proc_file(void) { return 0; }
 static inline void remove_proc_file(void) {}
 
 #endif
@@ -2998,13 +2998,19 @@ known:
 #endif
 	}
 
-	create_proc_file();
+	if (create_proc_file()) {
+		status = -ENOMEM;
+		goto cleanup3;
+	}
+
 	status = device_add(&udc->gadget.dev);
 	if (!status)
 		return status;
 	/* If fail, fall through */
-#ifdef	USE_ISO
+
+	remove_proc_file();
 cleanup3:
+#ifdef	USE_ISO
 	free_irq(pdev->resource[2].start, udc);
 #endif
 
-- 
1.7.0.4

