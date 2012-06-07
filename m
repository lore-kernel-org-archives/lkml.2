Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab2FGIWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:22:06 -0400
Received: from www84.your-server.de ([213.133.104.84]:39300 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327Ab2FGIU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:28 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 06/13] Handle a non blocking read without blocking
Date: Thu,  7 Jun 2012 10:20:36 +0200
Message-Id: <1339057243-10029-7-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
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
index 2ca2530..e4cb88a 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -225,9 +225,14 @@ static ssize_t skel_read(struct file *file, char *buffer, size_t count,
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
 
 	if (!dev->interface) {		/* disconnect() was called */
 		retval = -ENODEV;
-- 
1.7.8.6

