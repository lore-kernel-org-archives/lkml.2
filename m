Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2CCUWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 15:22:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36158 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2CCUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 15:22:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of chunkeey@googlemail.com designates 10.213.19.205 as permitted sender) smtp.mail=chunkeey@googlemail.com; dkim=pass header.i=chunkeey@googlemail.com
Subject: [RFC] firmware loader: retry _nowait requests when userhelper is not yet available
Cc: gregkh@linuxfoundation.org, chunkeey@googlemail.com
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-kernel@vger.kernel.org
Date: Sat, 3 Mar 2012 21:22:36 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203032122.36745.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During resume, the userhelper might not be available. However for
drivers which use the request_firmware_nowait interface, this will
only lead to a pointless WARNING and a device which no longer works
after the resume [since it couldn't get the firmware, because the
userhelper was not available to take the request].

In order to solve this "chicken or egg" dilemma, the code now
retries _nowait requests at one second intervals until the
"loading_timeout" time is up.

---
I'm aware about the previous "request_firmware* in probe" discussions.
Unfortunately, the hardware needs firmware so there is no other way
around it. So please, I just wanted to know what the general opinion
about the idea behind this patch is.

Regards,
	Christian

BTW: I'm not on the list, so please keep the 'CC'.
---
 drivers/base/firmware_class.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6c9387d..9f70096 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -19,6 +19,7 @@
 #include <linux/kthread.h>
 #include <linux/highmem.h>
 #include <linux/firmware.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
@@ -535,6 +536,11 @@ static int _request_firmware(const struct firmware **firmware_p,
 
 	read_lock_usermodehelper();
 
+	if (nowait && usermodehelper_is_disabled()) {
+		retval = -EBUSY;
+		goto out;
+	}
+
 	if (WARN_ON(usermodehelper_is_disabled())) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
 		retval = -EBUSY;
@@ -633,7 +639,7 @@ static int request_firmware_work_func(void *arg)
 {
 	struct firmware_work *fw_work = arg;
 	const struct firmware *fw;
-	int ret;
+	int ret, timeout = loading_timeout;
 
 	if (!arg) {
 		WARN_ON(1);
@@ -642,6 +648,22 @@ static int request_firmware_work_func(void *arg)
 
 	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
 				fw_work->uevent, true);
+
+	while (ret == -EBUSY) {
+		/*
+		 * Try to retrieve the firmware within the loading timeout.
+		 * To stick with the loading timeout convention from above:
+		 *	loading_timeout = 0 means 'try forever' as well.
+		 */
+
+		msleep(1000);
+		ret = _request_firmware(&fw, fw_work->name, fw_work->device,
+					fw_work->uevent, true);
+
+		if (timeout != 0 && timeout-- == 1)
+			break;
+	};
+
 	fw_work->cont(fw, fw_work->context);
 
 	module_put(fw_work->module);
-- 
1.7.9.1

