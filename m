Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2HDECp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 00:02:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2HDECj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 00:02:39 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 08/15] firmware loader: fix device lifetime
Date: Sat,  4 Aug 2012 12:01:23 +0800
Message-Id: <1344052890-31935-9-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers of request_firmware* must hold the reference count of
@device, otherwise it is easy to trigger oops since the firmware
loader device is the child of @device.

This patch adds comments about the usage. In fact, most of drivers
call request_firmware* in its probe() or open(), so the constraint
should be reasonable and can be satisfied.

Also this patch holds the reference count of @device before
schedule_work() in request_firmware_nowait() to avoid that
the @device is released after request_firmware_nowait returns
and before the worker function is scheduled.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index fc119ce..7d3a83b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -742,6 +742,8 @@ err_put_dev:
  *      @name will be used as $FIRMWARE in the uevent environment and
  *      should be distinctive enough not to be confused with any other
  *      firmware image for this or any other device.
+ *
+ *	Caller must hold the reference count of @device.
  **/
 int
 request_firmware(const struct firmware **firmware_p, const char *name,
@@ -823,6 +825,7 @@ static void request_firmware_work_func(struct work_struct *work)
 
  out:
 	fw_work->cont(fw, fw_work->context);
+	put_device(fw_work->device);
 
 	module_put(fw_work->module);
 	kfree(fw_work);
@@ -841,6 +844,8 @@ static void request_firmware_work_func(struct work_struct *work)
  * @cont: function will be called asynchronously when the firmware
  *	request is over.
  *
+ *	Caller must hold the reference count of @device.
+ *
  *	Asynchronous variant of request_firmware() for user contexts where
  *	it is not possible to sleep for long time. It can't be called
  *	in atomic contexts.
@@ -869,6 +874,7 @@ request_firmware_nowait(
 		return -EFAULT;
 	}
 
+	get_device(fw_work->device);
 	INIT_WORK(&fw_work->work, request_firmware_work_func);
 	schedule_work(&fw_work->work);
 	return 0;
-- 
1.7.9.5

