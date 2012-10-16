Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2JPQAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:00:48 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57050 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab2JPQAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:00:46 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC PATCH v1 2/3] PM / Runtime: force memory allocation with no I/O during runtime_resume callbcack
Date: Tue, 16 Oct 2012 23:59:42 +0800
Message-Id: <1350403183-12650-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350403183-12650-1-git-send-email-ming.lei@canonical.com>
References: <1350403183-12650-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies the introduced memalloc_noio_save() and
memalloc_noio_restore() to force memory allocation with no I/O
during runtime_resume callback.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/power/runtime.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 3148b10..c71a8f0 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -503,6 +503,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
 	int (*callback)(struct device *);
 	struct device *parent = NULL;
 	int retval = 0;
+	unsigned int noio_flag;
 
 	trace_rpm_resume(dev, rpmflags);
 
@@ -652,7 +653,20 @@ static int rpm_resume(struct device *dev, int rpmflags)
 	if (!callback && dev->driver && dev->driver->pm)
 		callback = dev->driver->pm->runtime_resume;
 
+	/*
+	 * Deadlock might be caused if memory allocation with GFP_KERNEL
+	 * happens inside runtime_resume callback of one block device's
+	 * ancestor or the block device itself. The easiest approach is
+	 * to forbid I/O inside runtime_resume of all devices.
+	 *
+	 * In fact, it can be done only if the deivce is a block device
+	 * or there is one block device descendant. But that may become
+	 * complicated and not efficient because device tree traversing
+	 * is involved.
+	 */
+	memalloc_noio_save(noio_flag);
 	retval = rpm_callback(callback, dev);
+	memalloc_noio_restore(noio_flag);
 	if (retval) {
 		__update_runtime_status(dev, RPM_SUSPENDED);
 		pm_runtime_cancel_pending(dev);
-- 
1.7.9.5

