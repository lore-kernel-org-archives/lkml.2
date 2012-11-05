Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2KEKbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:31:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37645 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2KEKbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:31:32 -0500
Date: Mon, 5 Nov 2012 11:31:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: pebolle@tiscali.nl, linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: [PATCH 8/9] isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
Message-ID: <20121105103126.GB5220@gmail.com>
References: <20121103224832.GA24262@gmail.com>
 <1352024091.1434.17.camel@x61.thuisdomein>
 <20121104105332.GC27124@gmail.com>
 <20121104.123013.700345271120279281.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121104.123013.700345271120279281.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does something like look like a better solution?

Author: Lee Jones <lee.jones@linaro.org>
Date:   Sat Nov 3 22:06:02 2012 +0100

    isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
    
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
