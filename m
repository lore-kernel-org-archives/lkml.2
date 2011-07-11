Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab1GKOY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:24:28 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:57136 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406Ab1GKOY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:24:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAF4HG05tg34q/2dsb2JhbABTpzl4iHy/IA6GLASSVJBJ
Date: Mon, 11 Jul 2011 16:24:09 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/11] watchdog: WatchDog Timer Driver Core - Add parent
	device
Message-ID: <1310392522-9949-8-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for a parent device so that it can
be set as the parent of the misc_device.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    4 ++++
 drivers/watchdog/watchdog_dev.c                |    1 +
 include/linux/watchdog.h                       |    1 +
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index fb53001..79f6edf 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -41,6 +41,7 @@ The watchdog device structure looks like this:
 struct watchdog_device {
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	struct device *parent;
 	unsigned int bootstatus;
 	unsigned int timeout;
 	void *priv;
@@ -51,6 +52,9 @@ It contains following fields:
 * info: a pointer to a watchdog_info structure. This structure gives some
   additional information about the watchdog timer itself. (Like it's unique name)
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
+* parent: a pointer to the parent device of the watchdog. This will be set
+  as the parent of the misc device to improve dependencies in driver model
+  (e.g. sysfs).
 * timeout: the watchdog timer's timeout value (in seconds).
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index ca60bea..c66bb6d 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -367,6 +367,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 	wdd = watchdog;
 
 	/* Register the miscdevice */
+	watchdog_miscdev.parent = watchdog->parent;
 	err = misc_register(&watchdog_miscdev);
 	if (err != 0) {
 		pr_err("%s: cannot register miscdev on minor=%d (err=%d).\n",
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index aa54fb1..e2c7337 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -78,6 +78,7 @@ struct watchdog_ops {
 struct watchdog_device {
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	struct device *parent;
 	unsigned int bootstatus;
 	unsigned int timeout;
 	void *priv;
-- 
1.7.6

