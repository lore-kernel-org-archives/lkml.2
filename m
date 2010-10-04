Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab0JDJpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:45:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59281 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0JDJpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:45:49 -0400
From: vkuzmichev@mvista.com
To: linux-arm-kernel@lists.infradead.org
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH 3/4] ARM: mpcore_wdt: Fix WDIOC_SETOPTIONS handling
Date: Mon,  4 Oct 2010 13:45:39 +0400
Message-Id: <1286185540-19569-4-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuzmichev <vkuzmichev@mvista.com>

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
index 1bd3529..6d3ac06 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -238,7 +238,8 @@ static long mpcore_wdt_ioctl(struct file *file, unsigned int cmd,
 	if (_IOC_DIR(cmd) && _IOC_SIZE(cmd) > sizeof(uarg))
 		return -ENOTTY;
 
-	if (_IOC_DIR(cmd) & _IOC_WRITE) {
+	if (_IOC_DIR(cmd) & _IOC_WRITE
+			|| cmd == WDIOC_SETOPTIONS) {
 		ret = copy_from_user(&uarg, (void __user *)arg, _IOC_SIZE(cmd));
 		if (ret)
 			return -EFAULT;
-- 
1.7.2.2

