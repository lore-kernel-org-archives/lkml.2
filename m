Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab1G0URn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:17:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:35089 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab1G0URf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:17:35 -0400
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 9/9] watchdog: WatchDog Timer Driver Core - Add minimum and max timeout
Date: Wed, 27 Jul 2011 20:16:40 +0000
Message-Id: <1311797800-2706-9-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311797800-2706-1-git-send-email-wim@iguana.be>
References: <20110727201537.GA13819@infomag.iguana.be>
 <1311797800-2706-1-git-send-email-wim@iguana.be>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jul 2011 20:17:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add min_timeout (minimum timeout) and max_timeout
values so that the framework can check if the new
timeout value is between the minimum and maximum
timeout values. If both values are 0, then the
framework will leave the check for the watchdog
device driver itself.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    4 ++++
 drivers/watchdog/watchdog_core.c               |   10 ++++++++++
 drivers/watchdog/watchdog_dev.c                |    3 +++
 include/linux/watchdog.h                       |    4 ++++
 4 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 829955b..4f7c894 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -43,6 +43,8 @@ struct watchdog_device {
 	const struct watchdog_ops *ops;
 	unsigned int bootstatus;
 	unsigned int timeout;
+	unsigned int min_timeout;
+	unsigned int max_timeout;
 	void *driver_data;
 	unsigned long status;
 };
@@ -52,6 +54,8 @@ It contains following fields:
   additional information about the watchdog timer itself. (Like it's unique name)
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
 * timeout: the watchdog timer's timeout value (in seconds).
+* min_timeout: the watchdog timer's minimum timeout value (in seconds).
+* max_timeout: the watchdog timer's maximum timeout value (in seconds).
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
 * driver_data: a pointer to the drivers private data of a watchdog device.
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 47fc126..cfa1a15 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -59,6 +59,16 @@ int watchdog_register_device(struct watchdog_device *wdd)
 		return -EINVAL;
 
 	/*
+	 * Check that we have valid min and max timeout values, if
+	 * not reset them both to 0 (=not used or unknown)
+	 */
+	if (wdd->min_timeout > wdd->max_timeout) {
+		pr_info("Invalid min and max timeout values, resetting to 0!\n");
+		wdd->min_timeout = 0;
+		wdd->max_timeout = 0;
+	}
+
+	/*
 	 * Note: now that all watchdog_device data has been verified, we
 	 * will not check this anymore in other functions. If data gets
 	 * corrupted in a later stage then we expect a kernel panic!
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index e7134a5..d33520d 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -220,6 +220,9 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 			return -EOPNOTSUPP;
 		if (get_user(val, p))
 			return -EFAULT;
+		if ((wdd->max_timeout != 0) &&
+		    (val < wdd->min_timeout || val > wdd->max_timeout))
+				return -EINVAL;
 		err = wdd->ops->set_timeout(wdd, val);
 		if (err < 0)
 			return err;
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 325d90b..111843f 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -95,6 +95,8 @@ struct watchdog_ops {
  * @ops:	Pointer to the list of watchdog operations.
  * @bootstatus:	Status of the watchdog device at boot.
  * @timeout:	The watchdog devices timeout value.
+ * @min_timeout:The watchdog devices minimum timeout value.
+ * @max_timeout:The watchdog devices maximum timeout value.
  * @driver-data:Pointer to the drivers private data.
  * @status:	Field that contains the devices internal status bits.
  *
@@ -109,6 +111,8 @@ struct watchdog_device {
 	const struct watchdog_ops *ops;
 	unsigned int bootstatus;
 	unsigned int timeout;
+	unsigned int min_timeout;
+	unsigned int max_timeout;
 	void *driver_data;
 	unsigned long status;
 /* Bit numbers for status flags */
-- 
1.7.6

