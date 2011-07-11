Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802Ab1GKOVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:21:50 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:59001 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932222Ab1GKOVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:21:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAA0FG05tg34q/2dsb2JhbABTpzl4iHy/SQ6GLASSVIgiiCc
Date: Mon, 11 Jul 2011 16:21:46 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 03/11] watchdog: WatchDog Timer Driver Core - Add
	WDIOC_KEEPALIVE ioctl
Message-ID: <1310392522-9949-3-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This part add's the WDIOC_KEEPALIVE ioctl functionality to the
WatchDog Timer Driver Core framework. Please note that the
WDIOF_KEEPALIVEPING bit has to be set in the watchdog_info
options field.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    3 +++
 drivers/watchdog/watchdog_dev.c                |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 544eb19..8ca0571 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -99,6 +99,9 @@ they are supported. These optional routines/operations are:
   the watchdog timer driver core does: to send a keepalive ping to the watchdog
   timer hardware it will either use the ping operation (when available) or the
   start operation (when the ping operation is not available).
+  (Note: the WDIOC_KEEPALIVE ioctl call will only be active when the
+  WDIOF_KEEPALIVEPING bit has been set in the option field on the watchdog's
+  info structure).
 * status: this routine checks the status of the watchdog timer device. The
   status of the device is reported with watchdog WDIOF_* status flags/bits.
 
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index bebea38..cc361e1 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -131,6 +131,11 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
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

