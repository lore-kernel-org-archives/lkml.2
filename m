Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1G0URj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:17:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:35088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1G0URe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:17:34 -0400
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 3/9] watchdog: WatchDog Timer Driver Core - Add WDIOC_KEEPALIVE ioctl
Date: Wed, 27 Jul 2011 20:16:34 +0000
Message-Id: <1311797800-2706-3-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311797800-2706-1-git-send-email-wim@iguana.be>
References: <20110727201537.GA13819@infomag.iguana.be>
 <1311797800-2706-1-git-send-email-wim@iguana.be>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jul 2011 20:17:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part add's the WDIOC_KEEPALIVE ioctl functionality to the
WatchDog Timer Driver Core framework. Please note that the
WDIOF_KEEPALIVEPING bit has to be set in the watchdog_info
options field.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    3 +++
 drivers/watchdog/watchdog_dev.c                |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 2bdc6dc..abbcf2c 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -101,6 +101,9 @@ they are supported. These optional routines/operations are:
   the watchdog timer driver core does: to send a keepalive ping to the watchdog
   timer hardware it will either use the ping operation (when available) or the
   start operation (when the ping operation is not available).
+  (Note: the WDIOC_KEEPALIVE ioctl call will only be active when the
+  WDIOF_KEEPALIVEPING bit has been set in the option field on the watchdog's
+  info structure).
 * status: this routine checks the status of the watchdog timer device. The
   status of the device is reported with watchdog WDIOF_* status flags/bits.
 
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 00a6112..2fb4cec 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -120,6 +120,11 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 		return put_user(val, p);
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(wdd->bootstatus, p);
+	case WDIOC_KEEPALIVE:
+		if (!(wdd->info->options & WDIOF_KEEPALIVEPING))
+			return -EOPNOTSUPP;
+		watchdog_ping(wdd);
+		return 0;
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.6

