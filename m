Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab1KIUdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:33:35 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:37364 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1KIUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 4/7] TTY: coalesce fail paths in tty_open
Date: Wed,  9 Nov 2011 21:33:21 +0100
Message-Id: <1320870804-23687-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
References: <1320870804-23687-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move them to the end of the function and use gotos as usual.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/tty_io.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 00b8498..ba9194e 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1916,27 +1916,20 @@ retry_open:
 
 	tty = tty_open_current_tty(device, filp);
 	if (IS_ERR(tty)) {
-		tty_unlock();
-		mutex_unlock(&tty_mutex);
-		tty_free_file(filp);
-		return PTR_ERR(tty);
+		retval = PTR_ERR(tty);
+		goto err_unlock;
 	} else if (!tty) {
 		driver = tty_lookup_driver(device, filp, &noctty, &index);
 		if (IS_ERR(driver)) {
-			tty_unlock();
-			mutex_unlock(&tty_mutex);
-			tty_free_file(filp);
-			return PTR_ERR(driver);
+			retval = PTR_ERR(driver);
+			goto err_unlock;
 		}
 
 		/* check whether we're reopening an existing tty */
 		tty = tty_driver_lookup_tty(driver, inode, index);
 		if (IS_ERR(tty)) {
-			tty_unlock();
-			mutex_unlock(&tty_mutex);
-			tty_driver_kref_put(driver);
-			tty_free_file(filp);
-			return PTR_ERR(tty);
+			retval = PTR_ERR(tty);
+			goto err_unlock;
 		}
 	}
 
@@ -1952,8 +1945,8 @@ retry_open:
 		tty_driver_kref_put(driver);
 	if (IS_ERR(tty)) {
 		tty_unlock();
-		tty_free_file(filp);
-		return PTR_ERR(tty);
+		retval = PTR_ERR(tty);
+		goto err_file;
 	}
 
 	tty_add_file(tty, filp);
@@ -2013,6 +2006,15 @@ retry_open:
 	tty_unlock();
 	mutex_unlock(&tty_mutex);
 	return 0;
+err_unlock:
+	tty_unlock();
+	mutex_unlock(&tty_mutex);
+	/* after locks to avoid deadlock */
+	if (!IS_ERR_OR_NULL(driver))
+		tty_driver_kref_put(driver);
+err_file:
+	tty_free_file(filp);
+	return retval;
 }
 
 
-- 
1.7.7


