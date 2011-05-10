Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1EJJVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:21:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46632 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1EJJVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:21:17 -0400
From: Niels de Vos <ndevos@redhat.com>
To: linux-omap@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Niels de Vos <ndevos@redhat.com>
Subject: [PATCH] omap2/omapfb: make DBG() more resistant in if-else constructions
Date: Tue, 10 May 2011 10:20:49 +0100
Message-Id: <1305019249-9898-1-git-send-email-ndevos@redhat.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DBG() is used in a simple if-else, the resulting code path
currently depends on the definition of DBG(). Inserting the statement in
a "do { ... } while (0)" prevents this possible misuse.

Signed-off-by: Niels de Vos <ndevos@redhat.com>

---
Note, I have not found any offenders, but a mistake can easily be made.
The following example shows what can go wrong if little intention is
paid to the definition of the DBG() macro.

Example:
	if something_went_wrong()
		DBG("oh no, something went wrong!\n");
	else
		printk("all went fine\n");

Old result where the else is placed inside the first if-statment:
	if something_went_wrong() {
		if (omapfb_debug) {
			printk(KERN_DEBUG "oh no, something went wrong!\n");
		} else {
			printk("all went fine\n");
		}
	}

New result where the else is an alternative to the first if-statement:
	if something_went_wrong() {
		do {
			if (omapfb_debug)
				printk(KERN_DEBUG "oh no, something went wrong!\n");
		} while (0);
	} else {
		printk("all went fine\n");
	}
---
 drivers/video/omap2/omapfb/omapfb.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/omap2/omapfb/omapfb.h b/drivers/video/omap2/omapfb/omapfb.h
index 1305fc9..a01b0bb 100644
--- a/drivers/video/omap2/omapfb/omapfb.h
+++ b/drivers/video/omap2/omapfb/omapfb.h
@@ -34,8 +34,10 @@
 #ifdef DEBUG
 extern unsigned int omapfb_debug;
 #define DBG(format, ...) \
-	if (omapfb_debug) \
-		printk(KERN_DEBUG "OMAPFB: " format, ## __VA_ARGS__)
+	do { \
+		if (omapfb_debug) \
+			printk(KERN_DEBUG "OMAPFB: " format, ## __VA_ARGS__); \
+	while (0)
 #else
 #define DBG(format, ...)
 #endif
-- 
1.7.4.4

