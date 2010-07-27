Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab0G0OIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab0G0OIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:08:06 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] ipmi: Check the return status of open firmware device registration
Date: Tue, 27 Jul 2010 10:07:57 -0400
Message-Id: <1280239677-25743-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the registration of the Open Firmware IPMI device fails then we may
attempt to unregister a device that doesn't exist. Check the return code.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 094bdc3..e39a744 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3337,8 +3337,11 @@ static __devinit int init_ipmi_si(void)
 #endif
 
 #ifdef CONFIG_PPC_OF
-	of_register_platform_driver(&ipmi_of_platform_driver);
-	of_registered = 1;
+	rv = of_register_platform_driver(&ipmi_of_platform_driver);
+	if (rv)
+		printk(KERN_ERR PFX "Unable to register OF driver: %d\n", rv);
+	else
+		of_registered = 1;
 #endif
 
 	/* We prefer devices with interrupts, but in the case of a machine
-- 
1.7.1.1

