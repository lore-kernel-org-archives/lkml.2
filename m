Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810Ab1GKOW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:22:27 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:1752 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512Ab1GKOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:22:23 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAMAGG05tg34q/2dsb2JhbABTpzl4iHy/KQ6GLASSVIgiiCc
Date: Mon, 11 Jul 2011 16:22:22 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/11] watchdog: WatchDog Timer Driver Core - Add
	WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
Message-ID: <1310392522-9949-5-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part add's the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
functionality to the WatchDog Timer Driver Core framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 Documentation/watchdog/watchdog-kernel-api.txt |   10 ++++++++++
 drivers/watchdog/watchdog_dev.c                |   20 ++++++++++++++++++++
 include/linux/watchdog.h                       |    2 ++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 6df1ade..3085c5c 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -42,6 +42,7 @@ struct watchdog_device {
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
 	unsigned int bootstatus;
+	unsigned int timeout;
 	void *priv;
 	unsigned long status;
 };
@@ -50,6 +51,7 @@ It contains following fields:
 * info: a pointer to a watchdog_info structure. This structure gives some
   additional information about the watchdog timer itself. (Like it's unique name)
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
+* timeout: the watchdog timer's timeout value (in seconds).
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
 * priv: a pointer to the private data of a watchdog device
@@ -68,6 +70,7 @@ struct watchdog_ops {
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
 	unsigned int (*status)(struct watchdog_device *);
+	int (*set_timeout)(struct watchdog_device *, unsigned int);
 };
 
 It is important that you first define the module owner of the watchdog timer
@@ -105,6 +108,13 @@ they are supported. These optional routines/operations are:
   info structure).
 * status: this routine checks the status of the watchdog timer device. The
   status of the device is reported with watchdog WDIOF_* status flags/bits.
+* set_timeout: this routine checks and changes the timeout of the watchdog
+  timer device. It returns 0 on success, -EINVAL for "parameter out of range"
+  and -EIO for "could not write value to the watchdog". On success the timeout
+  value of the watchdog_device will be changed to the value that was just used
+  to re-program the watchdog timer device.
+  (Note: the WDIOF_SETTIMEOUT needs to be set in the options field of the
+  watchdog's info structure).
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bits that are defined are:
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 530003b..0d4b16d 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -201,6 +201,26 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 			return -EOPNOTSUPP;
 		watchdog_ping(wdd);
 		return 0;
+	case WDIOC_SETTIMEOUT:
+		if ((wdd->ops->set_timeout == NULL) ||
+		    !(wdd->info->options & WDIOF_SETTIMEOUT))
+			return -EOPNOTSUPP;
+		if (get_user(val, p))
+			return -EFAULT;
+		err = wdd->ops->set_timeout(wdd, val);
+		if (err < 0)
+			return err;
+		wdd->timeout = val;
+		/* If the watchdog is active then we sent a keepalive ping
+		 * to make sure that the watchdog keep's running (and if
+		 * possible that it takes the new timeout) */
+		watchdog_ping(wdd);
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		/* timeout == 0 means that we don't know the timeout */
+		if (wdd->timeout)
+			return put_user(wdd->timeout, p);
+		return -EOPNOTSUPP;
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 853387f..7e37fdf 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -71,6 +71,7 @@ struct watchdog_ops {
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
 	unsigned int (*status)(struct watchdog_device *);
+	int (*set_timeout)(struct watchdog_device *, unsigned int);
 };
 
 /* The structure that defines a watchdog device */
@@ -78,6 +79,7 @@ struct watchdog_device {
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
 	unsigned int bootstatus;
+	unsigned int timeout;
 	void *priv;
 	unsigned long status;
 /* Bit numbers for status flags */
-- 
1.7.6

