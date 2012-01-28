Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2A1Mxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 07:53:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59526 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab2A1Mxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 07:53:43 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: [Patch] lkdtm: avoid calling lkdtm_do_action() with spin lock held
Date: Sat, 28 Jan 2012 20:52:47 +0800
Message-Id: <1327755168-12240-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lkdtm_do_action() may call sleeping functions like kmalloc(),
so do not call it with spin lock held.

Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 150cd70..28adefe 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -354,6 +354,7 @@ static void lkdtm_do_action(enum ctype which)
 static void lkdtm_handler(void)
 {
 	unsigned long flags;
+	bool do_it = false;
 
 	spin_lock_irqsave(&count_lock, flags);
 	count--;
@@ -361,10 +362,13 @@ static void lkdtm_handler(void)
 			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
 
 	if (count == 0) {
-		lkdtm_do_action(cptype);
+		do_it = true;
 		count = cpoint_count;
 	}
 	spin_unlock_irqrestore(&count_lock, flags);
+
+	if (do_it)
+		lkdtm_do_action(cptype);
 }
 
 static int lkdtm_register_cpoint(enum cname which)
