Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab0IMKF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:05:58 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52715 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0IMKF5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Mon, 13 Sep 2010 06:05:57 -0400
Message-Id: <4C8E139F0200007800015AA5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 13 Sep 2010 11:05:51 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <fenghua.yu@intel.com>, <khali@linux-fr.org>
Cc: <gong.chen@linux.intel.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/hwmon: fix module init for
	 hotplug-but-no-device-found case
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 0dca94baeab4a1a514841b0a4c8e3a51dfb4d5ae the call to
platform_driver_unregister() was made conditional upon !HOTPLUG_CPU,
but the return value from coretemp_init() was left to indicate an
error. This isn't correct, as the negative return value indicates to
the module loader that initialization failed, which isn't intended
here and results in dangling pointers.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Chen Gong <gong.chen@linux.intel.com>

---
 drivers/hwmon/coretemp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.36-rc4/drivers/hwmon/coretemp.c	2010-09-13 08:45:02.000000000 +0200
+++ 2.6.36-rc4-x86-coretemp-hotplug-init-return/drivers/hwmon/coretemp.c	2010-09-03 17:54:14.000000000 +0200
@@ -541,16 +541,19 @@ static int __init coretemp_init(void)
 				" has no thermal sensor.\n", c->x86_model);
 		}
 	}
+
+#ifndef CONFIG_HOTPLUG_CPU
 	if (list_empty(&pdev_list)) {
 		err = -ENODEV;
 		goto exit_driver_unreg;
 	}
+#endif
 
 	register_hotcpu_notifier(&coretemp_cpu_notifier);
 	return 0;
 
-exit_driver_unreg:
 #ifndef CONFIG_HOTPLUG_CPU
+exit_driver_unreg:
 	platform_driver_unregister(&coretemp_driver);
 #endif
 exit:



