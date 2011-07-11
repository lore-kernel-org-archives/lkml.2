Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1GKOYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:24:25 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:28498 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002Ab1GKOYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:24:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADoFG05tg34q/2dsb2JhbABTpzl4iHy/SQ6GLASSVJBJ
Date: Mon, 11 Jul 2011 16:24:22 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/11] watchdog: WatchDog Timer Driver Core - Add minimum
	and max timeout
Message-ID: <1310392522-9949-10-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
User-Agent: Mutt/1.5.18 (2008-05-17)
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
---
 Documentation/watchdog/watchdog-kernel-api.txt |    4 ++++
 drivers/watchdog/watchdog_core.c               |   10 ++++++++++
 drivers/watchdog/watchdog_dev.c                |    3 +++
 include/linux/watchdog.h                       |    2 ++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 377be98..7c0ccb1 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -44,6 +44,8 @@ struct watchdog_device {
 	struct device *parent;
 	unsigned int bootstatus;
 	unsigned int timeout;
+	unsigned int min_timeout;
+	unsigned int max_timeout;
 	void *priv;
 	unsigned long status;
 };
@@ -56,6 +58,8 @@ It contains following fields:
   as the parent of the misc device to improve dependencies in driver model
   (e.g. sysfs).
 * timeout: the watchdog timer's timeout value (in seconds).
+* min_timeout: the watchdog timer's minimum timeout value (in seconds).
+* max_timeout: the watchdog timer's maximum timeout value (in seconds).
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
 * priv: a pointer to the private data of a watchdog device
diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 79684ad..85fc787 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -63,6 +63,16 @@ int watchdog_register_device(struct watchdog_device *wdd)
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
index 83c08a8..f6aa4b5 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -231,6 +231,9 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
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
index fa4a46b..444b506 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -82,6 +82,8 @@ struct watchdog_device {
 	struct device *parent;
 	unsigned int bootstatus;
 	unsigned int timeout;
+	unsigned int min_timeout;
+	unsigned int max_timeout;
 	void *priv;
 	unsigned long status;
 /* Bit numbers for status flags */
-- 
1.7.6

