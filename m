Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2FFO5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:57:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38897 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2FFO5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:57:53 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 22:57:53 +0800
Message-ID: <CABawtvNv7LwT_awXscXGEid-1wes-+ZELc7YMLZqyo2h=h98UA@mail.gmail.com>
Subject: [next-net PATCH] drivers/net/ethernet/intel/e1000e: fix unregistered
 net_device ethX name output by e1000e
From: Ethan Zhao <ethan.kernel@gmail.com>
To: eric.dumazet@gmail.com, linux.nics@intel.com,
        e1000-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ca3ccc6835943287b6f69e973c126a02bc4de409
Author: ethan.zhao <ethan.kernel@gmail.com>
Date:   Wed Jun 6 07:32:11 2012 -0700

        modified:   drivers/net/ethernet/intel/e1000e/param.c

    While e1000e_check_options() is called, netdev is not registered, so the
    e1000e driver will print out confused ethernet interface name
(unregistered net_device) :

    e1000e 0000:04:00.0:(unregistered net_device): Interrupt
Throttling Rate (ints/sec) set to dynamic conservative mode

    So change e_info() back to dev_printk() by simply redefine the
e_info macro used by
    e1000e_check_options() and e1000_validate_option

    after applied this patch, we got:

    e1000e 0000:04:00.0: Interrupt Throttling Rate (ints/sec) set to
dynamic conservative mode
    e1000e 0000:04:00.0: irq 95 for MSI/MSI-X

diff --git a/drivers/net/ethernet/intel/e1000e/param.c
b/drivers/net/ethernet/intel/e1000e/param.c
index 55cc156..0f4f9db 100644
--- a/drivers/net/ethernet/intel/e1000e/param.c
+++ b/drivers/net/ethernet/intel/e1000e/param.c
@@ -186,6 +186,17 @@ struct e1000_option {
        } arg;
 };

+
+/**
+ * For netdev is not registered here, will get (unregistered
net_device) such confused
+ * name, so change back to dev_printk() lazy redfine the e_info()
+ */
+#ifdef e_info
+#undef e_info
+#define e_info(format, arg...) \
+       dev_printk(KERN_INFO,&adapter->pdev->dev, format, ## arg)
+#endif
+
 static int __devinit e1000_validate_option(unsigned int *value,
                                           const struct e1000_option *opt,
                                           struct e1000_adapter *adapter)
