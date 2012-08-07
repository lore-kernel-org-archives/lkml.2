Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2HGT6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:58:04 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49928 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2HGT6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:58:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 32/41] TTY: con3215, unset raw3215[line]
Date: Tue,  7 Aug 2012 21:47:57 +0200
Message-Id: <1344368886-24033-33-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

raw3215[line] is set in probe, but not unset in remove. This will lead
to random crashes if the device is removed and the corresponding tty
opened later. open would dereference freed memory.

So set raw3215[line] to NULL in remove to fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/con3215.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 6c0116d..1655498 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -716,10 +716,17 @@ static int raw3215_probe (struct ccw_device *cdev)
 static void raw3215_remove (struct ccw_device *cdev)
 {
 	struct raw3215_info *raw;
+	unsigned int line;
 
 	ccw_device_set_offline(cdev);
 	raw = dev_get_drvdata(&cdev->dev);
 	if (raw) {
+		spin_lock(&raw3215_device_lock);
+		for (line = 0; line < NR_3215; line++)
+			if (raw3215[line] == raw)
+				break;
+		raw3215[line] = NULL;
+		spin_unlock(&raw3215_device_lock);
 		dev_set_drvdata(&cdev->dev, NULL);
 		raw3215_free_info(raw);
 	}
-- 
1.7.10.4


