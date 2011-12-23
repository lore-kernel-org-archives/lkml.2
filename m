Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1LWVlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:41:22 -0500
Received: from mail.datadirectnet.com ([74.62.46.229]:32510 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1LWVlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:41:20 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Dec 2011 16:41:20 EST
Message-ID: <4EF4F419.2080809@ddn.com>
Date: Fri, 23 Dec 2011 16:35:21 -0500
From: Karandeep Chahal <kchahal@ddn.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.25) Gecko/20111214 Lightning/1.0b2 Thunderbird/3.1.17
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mchehab@redhat.com
Subject: [PATCH] sb_edac.c, kernel linux-3.2-rc6.
Content-Type: multipart/mixed;
	boundary="------------020406040500020305070408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------020406040500020305070408
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

While testing Sandy Bridge EDAC module I discovered a problem in the way 
sb_edac was registering itself for machine check notifications. The 
symptoms of the problem include:
1. Injecting a machine check exception can cause the system to hang for 
10-15 seconds.
2. Removing and re-inserting the kernel module can cause panic.

The system hangs for 10-15 seconds because the sb_edac notifier gets 
called by the kernel (notifier_call_chain) 0xffffffff times ((u32)(-1)).

The problem occurs because sb_edac calls atomic_notifier_chain_register 
twice with the same static notifier_block structure. The function 
atomic_notifier_chain_register gets called once for each memory 
controller (MC) with the same structure. The patch, then, fixes this 
problem by making sure that sb_edac registers for machine check 
notifications only once.

Also copying Mauro Carvalho Chehab (maintainer of sb_edac) for the 
review of the patch.

Cheers,
Karan

--- linux-3.2-rc6/drivers/edac/sb_edac.c    2011-12-16 
21:36:26.000000000 -0500
+++ linux-3.2-rc6-new/drivers/edac/sb_edac.c    2011-12-23 
14:54:57.000000000 -0500
@@ -1661,9 +1661,6 @@
      debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
          __func__, mci, &sbridge_dev->pdev[0]->dev);

-    atomic_notifier_chain_unregister(&x86_mce_decoder_chain,
- &sbridge_mce_dec);
-
      /* Remove MC sysfs nodes */
      edac_mc_del_mc(mci->dev);

@@ -1731,8 +1728,6 @@
          goto fail0;
      }

-    atomic_notifier_chain_register(&x86_mce_decoder_chain,
- &sbridge_mce_dec);
      return 0;

  fail0:
@@ -1861,8 +1856,11 @@

      pci_rc = pci_register_driver(&sbridge_driver);

-    if (pci_rc >= 0)
+    if (pci_rc >= 0) {
+         atomic_notifier_chain_register(&x86_mce_decoder_chain,
+ &sbridge_mce_dec);
          return 0;
+    }

      sbridge_printk(KERN_ERR, "Failed to register device with error %d.\n",
                pci_rc);
@@ -1877,6 +1875,9 @@
  static void __exit sbridge_exit(void)
  {
      debugf2("MC: " __FILE__ ": %s()\n", __func__);
+    atomic_notifier_chain_unregister(&x86_mce_decoder_chain,
+ &sbridge_mce_dec);
+
      pci_unregister_driver(&sbridge_driver);
  }



--------------020406040500020305070408
Content-Type: text/x-patch; name="me.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="me.patch"

--- linux-3.2-rc6/drivers/edac/sb_edac.c	2011-12-16 21:36:26.000000000 -0500
+++ linux-3.2-rc6-new/drivers/edac/sb_edac.c	2011-12-23 14:54:57.000000000 -0500
@@ -1661,9 +1661,6 @@
 	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
 		__func__, mci, &sbridge_dev->pdev[0]->dev);
 
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain,
-					 &sbridge_mce_dec);
-
 	/* Remove MC sysfs nodes */
 	edac_mc_del_mc(mci->dev);
 
@@ -1731,8 +1728,6 @@
 		goto fail0;
 	}
 
-	atomic_notifier_chain_register(&x86_mce_decoder_chain,
-				       &sbridge_mce_dec);
 	return 0;
 
 fail0:
@@ -1861,8 +1856,11 @@
 
 	pci_rc = pci_register_driver(&sbridge_driver);
 
-	if (pci_rc >= 0)
+	if (pci_rc >= 0) {
+ 		atomic_notifier_chain_register(&x86_mce_decoder_chain,
+						  &sbridge_mce_dec);
 		return 0;
+	}
 
 	sbridge_printk(KERN_ERR, "Failed to register device with error %d.\n",
 		      pci_rc);
@@ -1877,6 +1875,9 @@
 static void __exit sbridge_exit(void)
 {
 	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain,
+					 &sbridge_mce_dec);
+
 	pci_unregister_driver(&sbridge_driver);
 }
 

--------------020406040500020305070408
Content-Type: text/plain; name="README"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="README"

[PATCH] sb_edac.c, kernel linux-3.2-rc6.
Karandeep Chahal <karandeepchahal@gmail.com>

The sb_edac patch fixes incorrect Sandy Bridge machine check notifier chain registration problem.


--------------020406040500020305070408--
