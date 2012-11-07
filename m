Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2KGJz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:55:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57811 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab2KGJz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:55:27 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, Lee Jones <lee.jones@linaro.org>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH 1/1] isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
Date: Wed,  7 Nov 2012 10:55:03 +0100
Message-Id: <1352282103-13665-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make much sense to enable ISDN services if you don't
intend to connect to a network. Therefore insisting that ISDN
depends on NETDEVICES seems logical. We can then remove any
guards mentioning NETDEVICES inside all subordinate drivers.

This also has the nice side-effect of fixing the warning below
when ISDN_I4L && !CONFIG_NETDEVICES at compile time.

This patch fixes:
drivers/isdn/i4l/isdn_common.c: In function ‘isdn_ioctl’:
drivers/isdn/i4l/isdn_common.c:1278:8: warning: unused variable ‘s’ [-Wunused-variable]

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/isdn/Kconfig           |    2 +-
 drivers/isdn/i4l/Kconfig       |    2 +-
 drivers/isdn/i4l/isdn_common.c |    4 ----
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index a233ed5..86cd75a 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig ISDN
 	bool "ISDN support"
-	depends on NET
+	depends on NET && NETDEVICES
 	depends on !S390 && !UML
 	---help---
 	  ISDN ("Integrated Services Digital Network", called RNIS in France)
diff --git a/drivers/isdn/i4l/Kconfig b/drivers/isdn/i4l/Kconfig
index 2302fbe..9c6650e 100644
--- a/drivers/isdn/i4l/Kconfig
+++ b/drivers/isdn/i4l/Kconfig
@@ -6,7 +6,7 @@ if ISDN_I4L
 
 config ISDN_PPP
 	bool "Support synchronous PPP"
-	depends on INET && NETDEVICES
+	depends on INET
 	select SLHC
 	help
 	  Over digital connections such as ISDN, there is no need to
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 8c610fa..e2a945e 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1312,7 +1312,6 @@ isdn_ioctl(struct file *file, uint cmd, ulong arg)
 			} else
 				return -EINVAL;
 			break;
-#ifdef CONFIG_NETDEVICES
 		case IIOCNETGPN:
 			/* Get peer phone number of a connected
 			 * isdn network interface */
@@ -1322,7 +1321,6 @@ isdn_ioctl(struct file *file, uint cmd, ulong arg)
 				return isdn_net_getpeer(&phone, argp);
 			} else
 				return -EINVAL;
-#endif
 		default:
 			return -EINVAL;
 		}
@@ -1352,7 +1350,6 @@ isdn_ioctl(struct file *file, uint cmd, ulong arg)
 		case IIOCNETLCR:
 			printk(KERN_INFO "INFO: ISDN_ABC_LCR_SUPPORT not enabled\n");
 			return -ENODEV;
-#ifdef CONFIG_NETDEVICES
 		case IIOCNETAIF:
 			/* Add a network-interface */
 			if (arg) {
@@ -1491,7 +1488,6 @@ isdn_ioctl(struct file *file, uint cmd, ulong arg)
 				return -EFAULT;
 			return isdn_net_force_hangup(name);
 			break;
-#endif                          /* CONFIG_NETDEVICES */
 		case IIOCSETVER:
 			dev->net_verbose = arg;
 			printk(KERN_INFO "isdn: Verbose-Level is %d\n", dev->net_verbose);
-- 
1.7.9.5

