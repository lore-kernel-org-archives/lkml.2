Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab1GKOXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:23:40 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:61982 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785Ab1GKOXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:23:38 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJMFG05tg34q/2dsb2JhbABTpzl4iHy/QA6GLASSVJBJ
Date: Mon, 11 Jul 2011 16:23:36 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/11] watchdog: WatchDog Timer Driver Core - Add ioctl call
Message-ID: <1310392522-9949-9-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
User-Agent: Mutt/1.5.18 (2008-05-17)
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
---
 Documentation/watchdog/watchdog-kernel-api.txt |    5 +++++
 drivers/watchdog/watchdog_dev.c                |    6 ++++++
 include/linux/watchdog.h                       |    1 +
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 79f6edf..377be98 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -75,6 +75,7 @@ struct watchdog_ops {
 	int (*ping)(struct watchdog_device *);
 	unsigned int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, unsigned int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
 It is important that you first define the module owner of the watchdog timer
@@ -119,6 +120,10 @@ they are supported. These optional routines/operations are:
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
index c66bb6d..83c08a8 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -191,6 +191,12 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
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
index e2c7337..fa4a46b 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -72,6 +72,7 @@ struct watchdog_ops {
 	int (*ping)(struct watchdog_device *);
 	unsigned int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, unsigned int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
 /* The structure that defines a watchdog device */
-- 
1.7.6

