Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1GKOVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:21:38 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:32255 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535Ab1GKOVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:21:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJMFG05tg34q/2dsb2JhbABTpzl4iHy/QA6GLASSVJBJ
Date: Mon, 11 Jul 2011 16:21:34 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/11] watchdog: WatchDog Timer Driver Core - Add basic
	ioctl functionality
Message-ID: <1310392522-9949-2-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part add's the basic ioctl functionality to the
WatchDog Timer Driver Core framework. The supported
ioctl call's are:
	WDIOC_GETSUPPORT
	WDIOC_GETSTATUS
	WDIOC_GETBOOTSTATUS

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    6 ++++
 drivers/watchdog/watchdog_dev.c                |   33 ++++++++++++++++++++++++
 include/linux/watchdog.h                       |    2 +
 3 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 03c1066..544eb19 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -41,6 +41,7 @@ The watchdog device structure looks like this:
 struct watchdog_device {
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	unsigned int bootstatus;
 	void *priv;
 	unsigned long status;
 };
@@ -49,6 +50,8 @@ It contains following fields:
 * info: a pointer to a watchdog_info structure. This structure gives some
   additional information about the watchdog timer itself. (Like it's unique name)
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
+* bootstatus: status of the device after booting (reported with watchdog
+  WDIOF_* status bits).
 * priv: a pointer to the private data of a watchdog device
 * status: this field contains a number of status bits that give extra
   information about the status of the device (Like: is the device opened via
@@ -63,6 +66,7 @@ struct watchdog_ops {
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	unsigned int (*status)(struct watchdog_device *);
 };
 
 It is important that you first define the module owner of the watchdog timer
@@ -95,6 +99,8 @@ they are supported. These optional routines/operations are:
   the watchdog timer driver core does: to send a keepalive ping to the watchdog
   timer hardware it will either use the ping operation (when available) or the
   start operation (when the ping operation is not available).
+* status: this routine checks the status of the watchdog timer device. The
+  status of the device is reported with watchdog WDIOF_* status flags/bits.
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bits that are defined are:
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index c47154c..bebea38 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -106,6 +106,38 @@ static ssize_t watchdog_write(struct file *file, const char __user *data,
 }
 
 /*
+ *	watchdog_ioctl: handle the different ioctl's for the watchdog device.
+ *	@file: file handle to the device
+ *	@cmd: watchdog command
+ *	@arg: argument pointer
+ *
+ *	The watchdog API defines a common set of functions for all watchdogs
+ *	according to their available features.
+ */
+
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	unsigned int val;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, wdd->info,
+			sizeof(struct watchdog_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		val = wdd->ops->status ? wdd->ops->status(wdd) : 0;
+		return put_user(val, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(wdd->bootstatus, p);
+	default:
+		return -ENOTTY;
+	}
+	return -ENOTTY;
+}
+
+/*
  *	watchdog_open: open the /dev/watchdog device.
  *	@inode: inode of device
  *	@file: file handle to device
@@ -181,6 +213,7 @@ static const struct file_operations watchdog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
 	.open		= watchdog_open,
 	.release	= watchdog_release,
 };
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 40333ff..a2b639b 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -70,12 +70,14 @@ struct watchdog_ops {
 	int (*stop)(struct watchdog_device *);
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
+	unsigned int (*status)(struct watchdog_device *);
 };
 
 /* The structure that defines a watchdog device */
 struct watchdog_device {
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	unsigned int bootstatus;
 	void *priv;
 	unsigned long status;
 /* Bit numbers for status flags */
-- 
1.7.6

