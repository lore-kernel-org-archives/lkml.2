Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2JOFP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:15:29 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35964 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab2JOFPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:15:25 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-pm@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [RFC PATCH 2/3] PM / Runtime: force memory allocation with no I/O during runtime_resume callbcack
Date: Mon, 15 Oct 2012 13:14:18 +0800
Message-Id: <1350278059-14904-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies the introduces tsk_memalloc_forbid_io() and
tsk_memalloc_allow_io() to force memory allocation with no I/O
during runtime_resume callback.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/power/runtime.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 3148b10..76836c1 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -652,7 +652,20 @@ static int rpm_resume(struct device *dev, int rpmflags)
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
+	tsk_memalloc_forbid_io(current);
 	retval = rpm_callback(callback, dev);
+	tsk_memalloc_allow_io(current);
 	if (retval) {
 		__update_runtime_status(dev, RPM_SUSPENDED);
 		pm_runtime_cancel_pending(dev);
-- 
1.7.9.5

