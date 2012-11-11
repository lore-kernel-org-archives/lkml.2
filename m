Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2KKMgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:36:08 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37302 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2KKMgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:36:06 -0500
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v5 5/6] PM / Runtime: force memory allocation with no I/O during Runtime PM callbcack
Date: Sun, 11 Nov 2012 20:34:37 +0800
Message-Id: <1352637278-19968-6-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352637278-19968-1-git-send-email-ming.lei@canonical.com>
References: <1352637278-19968-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies the introduced memalloc_noio_save() and
memalloc_noio_restore() to force memory allocation with no I/O
during runtime_resume/runtime_suspend callback on device with
the flag of 'memalloc_noio' set.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v5:
	- use inline memalloc_noio_save()
v4:
	- runtime_suspend need this too because rpm_resume may wait for
	completion of concurrent runtime_suspend, so deadlock still may
	be triggered in runtime_suspend path.
---
 drivers/base/power/runtime.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 3e198a0..96d99ea 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -371,6 +371,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 	int (*callback)(struct device *);
 	struct device *parent = NULL;
 	int retval;
+	unsigned int noio_flag;
 
 	trace_rpm_suspend(dev, rpmflags);
 
@@ -480,7 +481,20 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 	if (!callback && dev->driver && dev->driver->pm)
 		callback = dev->driver->pm->runtime_suspend;
 
-	retval = rpm_callback(callback, dev);
+	/*
+	 * Deadlock might be caused if memory allocation with GFP_KERNEL
+	 * happens inside runtime_suspend callback of one block device's
+	 * ancestor or the block device itself. Network device might be
+	 * thought as part of iSCSI block device, so network device and
+	 * its ancestor should be marked as memalloc_noio.
+	 */
+	if (dev->power.memalloc_noio) {
+		noio_flag = memalloc_noio_save();
+		retval = rpm_callback(callback, dev);
+		memalloc_noio_restore(noio_flag);
+	} else {
+		retval = rpm_callback(callback, dev);
+	}
 	if (retval)
 		goto fail;
 
@@ -563,6 +577,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
 	int (*callback)(struct device *);
 	struct device *parent = NULL;
 	int retval = 0;
+	unsigned int noio_flag;
 
 	trace_rpm_resume(dev, rpmflags);
 
@@ -712,7 +727,20 @@ static int rpm_resume(struct device *dev, int rpmflags)
 	if (!callback && dev->driver && dev->driver->pm)
 		callback = dev->driver->pm->runtime_resume;
 
-	retval = rpm_callback(callback, dev);
+	/*
+	 * Deadlock might be caused if memory allocation with GFP_KERNEL
+	 * happens inside runtime_resume callback of one block device's
+	 * ancestor or the block device itself. Network device might be
+	 * thought as part of iSCSI block device, so network device and
+	 * its ancestor should be marked as memalloc_noio.
+	 */
+	if (dev->power.memalloc_noio) {
+		noio_flag = memalloc_noio_save();
+		retval = rpm_callback(callback, dev);
+		memalloc_noio_restore(noio_flag);
+	} else {
+		retval = rpm_callback(callback, dev);
+	}
 	if (retval) {
 		__update_runtime_status(dev, RPM_SUSPENDED);
 		pm_runtime_cancel_pending(dev);
-- 
1.7.9.5

