Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1G0URt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:17:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839Ab1G0URh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:17:37 -0400
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 8/9] watchdog: WatchDog Timer Driver Core - Add ioctl call
Date: Wed, 27 Jul 2011 20:16:39 +0000
Message-Id: <1311797800-2706-8-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311797800-2706-1-git-send-email-wim@iguana.be>
References: <20110727201537.GA13819@infomag.iguana.be>
 <1311797800-2706-1-git-send-email-wim@iguana.be>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jul 2011 20:17:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for extra ioctl calls by adding a
ioctl watchdog operation. This operation will be
called before we do our own handling of ioctl
commands. This way we can override the internal
ioctl command handling and we can also add
extra ioctl commands. The ioctl watchdog operation
should return the appropriate error codes or
-ENOIOCTLCMD if the ioctl command should be handled
through the internal ioctl handling of the framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    5 +++++
 drivers/watchdog/watchdog_dev.c                |    6 ++++++
 include/linux/watchdog.h                       |    2 ++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 785fa0c..829955b 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -73,6 +73,7 @@ struct watchdog_ops {
 	int (*ping)(struct watchdog_device *);
 	unsigned int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, unsigned int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
 It is important that you first define the module owner of the watchdog timer
@@ -117,6 +118,10 @@ they are supported. These optional routines/operations are:
   to re-program the watchdog timer device.
   (Note: the WDIOF_SETTIMEOUT needs to be set in the options field of the
   watchdog's info structure).
+* ioctl: if this routine is present then it will be called first before we do
+  our own internal ioctl call handling. This routine should return -ENOIOCTLCMD
+  if a command is not supported. The parameters that are passed to the ioctl
+  call are: watchdog_device, cmd and arg.
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bits that are defined are:
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index ac20f92..e7134a5 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -180,6 +180,12 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 	unsigned int val;
 	int err;
 
+	if (wdd->ops->ioctl) {
+		err = wdd->ops->ioctl(wdd, cmd, arg);
+		if (err != -ENOIOCTLCMD)
+			return err;
+	}
+
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, wdd->info,
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index f719883..325d90b 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -70,6 +70,7 @@ struct watchdog_device;
  * @ping:	The routine that sends a keepalive ping to the watchdog device.
  * @status:	The routine that shows the status of the watchdog device.
  * @set_timeout:The routine for setting the watchdog devices timeout value.
+ * @ioctl:	The routines that handles extra ioctl calls.
  *
  * The watchdog_ops structure contains a list of low-level operations
  * that control a watchdog device. It also contains the module that owns
@@ -85,6 +86,7 @@ struct watchdog_ops {
 	int (*ping)(struct watchdog_device *);
 	unsigned int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, unsigned int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
 /** struct watchdog_device - The structure that defines a watchdog device
-- 
1.7.6

