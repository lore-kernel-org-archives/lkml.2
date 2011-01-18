Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab1ARMok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 07:44:40 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:33329 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1ARMoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 07:44:39 -0500
Message-ID: <4D358B34.7040902@linux.vnet.ibm.com>
Date: Tue, 18 Jan 2011 18:14:36 +0530
From: Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/0] Panic on softdog timeout
Content-Type: multipart/mixed;
 boundary="------------040803070002000903000708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040803070002000903000708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi.

We currently have no way of determining the reason for failure when a 
softdog timeout occurs. At the minimum a snapshot of the system would 
help to determine the cause.
The attached patch invokes panic on softdog timeout iff kdump is 
configured, if kdump is not configured it works as usual.





--------------040803070002000903000708
Content-Type: text/plain;
 name="softdogpanic"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="softdogpanic"

Signed-off-by: Anithra P J <anithra@linux.vnet.ibm.com>

---
 drivers/watchdog/softdog.c |   14 ++++++++++----
 kernel/kexec.c             |    1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6.37-rc4/drivers/watchdog/softdog.c
===================================================================
--- linux-2.6.37-rc4.orig/drivers/watchdog/softdog.c
+++ linux-2.6.37-rc4/drivers/watchdog/softdog.c
@@ -48,6 +48,7 @@
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/uaccess.h>
+#include <linux/kexec.h>

 #define PFX "SoftDog: "

@@ -99,10 +100,15 @@
 	if (soft_noboot)
 		printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
 	else {
-		printk(KERN_CRIT PFX "Initiating system reboot.\n");
-		emergency_restart();
-		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
-	}
+		if (kexec_crash_image) {
+			printk(KERN_CRIT PFX "Initiating kdump. \n");
+			panic("Watchdog timer expired.");
+		} else {
+			printk(KERN_CRIT PFX "Initiating system reboot. \n");
+			emergency_restart();
+			printk(KERN_CRIT PFX "Reboot didn't ?????\n");
+		}
+	      }
 }

 /*
Index: linux-2.6.37-rc4/kernel/kexec.c
===================================================================
--- linux-2.6.37-rc4.orig/kernel/kexec.c
+++ linux-2.6.37-rc4/kernel/kexec.c
@@ -935,6 +935,7 @@
  */
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
+EXPORT_SYMBOL(kexec_crash_image);

 static DEFINE_MUTEX(kexec_mutex);



--------------040803070002000903000708--
