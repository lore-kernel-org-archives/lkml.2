Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1LUWcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 17:32:07 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56205 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1LUWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 17:32:03 -0500
Date: Wed, 21 Dec 2011 17:31:54 -0500 (EST)
Message-Id: <20111221.173154.1606390008477964264.davem@davemloft.net>
To: joachim.foerster@missinglinkelectronics.com
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix usb/isp1760 build on sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 14:31:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This commit:

commit 8f5d621543cb064d2989fc223d3c2bc61a43981e
Author: Joachim Foerster <joachim.foerster@missinglinkelectronics.com>
Date:   Mon Oct 10 18:06:54 2011 +0200

    usb/isp1760: Let OF bindings depend on general CONFIG_OF instead of PPC_OF .
    
    To be able to use the driver on other OF-aware architectures, too.
    And add necessary OF related #includes to fix compilation error.
    
    Signed-off-by: Joachim Foerster <joachim.foerster@missinglinkelectronics.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

enabled the build on all CONFIG_OF architectures, but it cannot do
this.

This driver depends upon CONFIG_OF_IRQ but not all CONFIG_OF platforms
support that infrastructure, in particular Sparc does not so the
build fails.

Please push a patch like the following to Linus so that this code only
gets built where it actually should.

--------------------
usb/isp1760: Add missing CONFIG_OF_IRQ dependency on OF code.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index a7dc1e1..2ac4ac2 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -18,7 +18,7 @@
 
 #include "isp1760-hcd.h"
 
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && defined(CONFIG_OF_IRQ)
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -31,7 +31,7 @@
 #include <linux/pci.h>
 #endif
 
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && defined(CONFIG_OF_IRQ)
 struct isp1760 {
 	struct usb_hcd *hcd;
 	int rst_gpio;
@@ -437,7 +437,7 @@ static int __init isp1760_init(void)
 	ret = platform_driver_register(&isp1760_plat_driver);
 	if (!ret)
 		any_ret = 0;
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && defined(CONFIG_OF_IRQ)
 	ret = platform_driver_register(&isp1760_of_driver);
 	if (!ret)
 		any_ret = 0;
@@ -457,7 +457,7 @@ module_init(isp1760_init);
 static void __exit isp1760_exit(void)
 {
 	platform_driver_unregister(&isp1760_plat_driver);
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && defined(CONFIG_OF_IRQ)
 	platform_driver_unregister(&isp1760_of_driver);
 #endif
 #ifdef CONFIG_PCI
