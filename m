Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2FFQ1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:27:45 -0400
Received: from www84.your-server.de ([213.133.104.84]:36718 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab2FFQ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:27:25 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 08/11] Handle a non blocking read without blocking
Date: Wed,  6 Jun 2012 18:27:09 +0200
Message-Id: <1339000032-10313-9-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index cab16e2..46c1bbb 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -241,9 +241,14 @@ static ssize_t skel_read(struct file *file, char *buffer, size_t count,
 		return 0;
 
 	/* no concurrent readers */
-	retval = mutex_lock_interruptible(&dev->io_mutex);
-	if (retval < 0)
-		return retval;
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&dev->io_mutex))
+			return -EAGAIN;
+	} else {
+		retval = mutex_lock_interruptible(&dev->io_mutex);
+		if (retval < 0)
+			return retval;
+	}
 
 	if (!dev->connected) {		/* disconnect() was called */
 		retval = -ENODEV;
-- 
1.7.8.6

