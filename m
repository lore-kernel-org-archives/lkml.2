Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab2JVIgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:36:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55660 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2JVIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:36:11 -0400
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
Subject: [RFC PATCH v2 5/6] PM / Runtime: force memory allocation with no I/O during runtime_resume callbcack
Date: Mon, 22 Oct 2012 16:33:13 +0800
Message-Id: <1350894794-1494-6-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350894794-1494-1-git-send-email-ming.lei@canonical.com>
References: <1350894794-1494-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies the introduced memalloc_noio_save() and
memalloc_noio_restore() to force memory allocation with no I/O
during runtime_resume callback on device which is marked as
memalloc_noio_resume.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/power/runtime.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index a75eeca..c61b7b0 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -556,6 +556,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
 	int (*callback)(struct device *);
 	struct device *parent = NULL;
 	int retval = 0;
+	unsigned int noio_flag;
 
 	trace_rpm_resume(dev, rpmflags);
 
@@ -705,7 +706,20 @@ static int rpm_resume(struct device *dev, int rpmflags)
 	if (!callback && dev->driver && dev->driver->pm)
 		callback = dev->driver->pm->runtime_resume;
 
-	retval = rpm_callback(callback, dev);
+	/*
+	 * Deadlock might be caused if memory allocation with GFP_KERNEL
+	 * happens inside runtime_resume callback of one block device's
+	 * ancestor or the block device itself. Network device might be
+	 * thought as part of iSCSI block device, so network device and
+	 * its ancestor should be marked as memalloc_noio_resume.
+	 */
+	if (dev->power.memalloc_noio_resume) {
+		memalloc_noio_save(noio_flag);
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

