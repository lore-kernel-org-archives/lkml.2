Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1KIUdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:33:35 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37362 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1KIUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/7] TTY: move tty_lookup_driver to switch-cases
Date: Wed,  9 Nov 2011 21:33:22 +0100
Message-Id: <1320870804-23687-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
References: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The labels express more the nature of the decision tree. We returned
from each if with a driver. Now we do this at the end of the function
and the code flow is clear.

While at it, remove an obsolete comment (we already take the
reference).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_io.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index ba9194e..76e66ff 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1841,16 +1841,17 @@ static struct tty_driver *tty_lookup_driver(dev_t device, struct file *filp,
 {
 	struct tty_driver *driver;
 
+	switch (device) {
 #ifdef CONFIG_VT
-	if (device == MKDEV(TTY_MAJOR, 0)) {
+	case MKDEV(TTY_MAJOR, 0): {
 		extern struct tty_driver *console_driver;
 		driver = tty_driver_kref_get(console_driver);
 		*index = fg_console;
 		*noctty = 1;
-		return driver;
+		break;
 	}
 #endif
-	if (device == MKDEV(TTYAUX_MAJOR, 1)) {
+	case MKDEV(TTYAUX_MAJOR, 1): {
 		struct tty_driver *console_driver = console_device(index);
 		if (console_driver) {
 			driver = tty_driver_kref_get(console_driver);
@@ -1858,15 +1859,17 @@ static struct tty_driver *tty_lookup_driver(dev_t device, struct file *filp,
 				/* Don't let /dev/console block */
 				filp->f_flags |= O_NONBLOCK;
 				*noctty = 1;
-				return driver;
+				break;
 			}
 		}
 		return ERR_PTR(-ENODEV);
 	}
-
-	driver = get_tty_driver(device, index);
-	if (!driver)
-		return ERR_PTR(-ENODEV);
+	default:
+		driver = get_tty_driver(device, index);
+		if (!driver)
+			return ERR_PTR(-ENODEV);
+		break;
+	}
 	return driver;
 }
 
-- 
1.7.7


