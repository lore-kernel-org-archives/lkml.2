Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1GGMZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:25:54 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:62456 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab1GGMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:25:50 -0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Wim Van Sebroeck <wim@iguana.be>, Marc Zyngier <marc.zyngier@arm.com>,
        Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH V3 3/4] ARM: mpcore_wdt: Fix WDIOC_SETOPTIONS handling
Date: Thu,  7 Jul 2011 16:23:15 +0400
Message-Id: <1310041396-2461-3-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com>
References: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the include/linux/watchdog.h WDIOC_SETOPTIONS is
classified as 'read from device' ioctl call:
  #define WDIOC_SETOPTIONS        _IOR(WATCHDOG_IOCTL_BASE, 4, int)

However, the driver 'mpcore_wdt' performs 'copy_from_user' only if
_IOC_WRITE is set, thus the local variable 'uarg' which is used in
WDIOC_SETOPTIONS handling remains uninitialized.

The proper way to fix this is to bind WDIOC_SETOPTIONS to _IOW,
but this will break compatibility.
So adding additional condition for performing 'copy_from_user'.

Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
---
 drivers/watchdog/mpcore_wdt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index efde50b..f99e49e 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -233,7 +233,8 @@ static long mpcore_wdt_ioctl(struct file *file, unsigned int cmd,
 	if (_IOC_DIR(cmd) && _IOC_SIZE(cmd) > sizeof(uarg))
 		return -ENOTTY;
 
-	if (_IOC_DIR(cmd) & _IOC_WRITE) {
+	if ((_IOC_DIR(cmd) & _IOC_WRITE)
+			|| cmd == WDIOC_SETOPTIONS) {
 		ret = copy_from_user(&uarg, (void __user *)arg, _IOC_SIZE(cmd));
 		if (ret)
 			return -EFAULT;
-- 
1.7.3.4

