Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0GGJbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 05:31:41 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:54798 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004Ab0GGJbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 05:31:40 -0400
Date: Wed, 7 Jul 2010 02:31:39 -0700 (PDT)
From: Shreyas Bhatewara <sbhatewara@vmware.com>
X-X-Sender: sbhatewara@localhost.localdomain
To: netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com, ronghua@vmware.com,
       matthieu@vmware.com
Subject: [PATCH 2.6.35-rc1] net: vmxnet3 fixes [4/5] Do not reset when the
 device is not opened
In-Reply-To: <alpine.LRH.2.00.1007070202080.5939@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1007070229030.5939@localhost.localdomain>
References: <alpine.LRH.2.00.1007070125440.4652@localhost.localdomain> <alpine.LRH.2.00.1007070202080.5939@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



commit bc8b3f0b3978d3c0a201926b2e2bd5c732e0352e
Author: Shreyas Bhatewara <sbhatewara@vmware.com>
Date:   Tue Jul 6 17:00:48 2010 -0700

No reset when the device is not opened
    
If a reset is scheduled, and the device goes thru close and open, it
may happen that reset and open may run in parallel.  
The reset code now bails out if the device is not opened.
 
Signed-off-by: Ronghua Zang <ronghua@vmware.com>
Signed-off-by: Matthieu Bucchianeri <matthieu@vmware.com>
Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

---

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 31a838f..01a5bb7 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2417,8 +2417,9 @@ vmxnet3_reset_work(struct work_struct *data)
 	if (test_and_set_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state))
 		return;
 
-	/* if the device is closed, we must leave it alone */
-	if (netif_running(adapter->netdev)) {
+	/* if the device is closed or is being opened, we must leave it alone */
+	if (netif_running(adapter->netdev) &&
+	    (adapter->netdev->flags & IFF_UP)) {
 		printk(KERN_INFO "%s: resetting\n", adapter->netdev->name);
 		vmxnet3_quiesce_dev(adapter);
 		vmxnet3_reset_dev(adapter);
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 5c94afa..8e1f704 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -68,10 +68,10 @@
 /*
  * Version numbers
  */
-#define VMXNET3_DRIVER_VERSION_STRING   "1.0.10.0-k"
+#define VMXNET3_DRIVER_VERSION_STRING   "1.0.11.0-k"
 
 /* a 32-bit int, each byte encode a verion number in VMXNET3_DRIVER_VERSION */
-#define VMXNET3_DRIVER_VERSION_NUM      0x01000A00
+#define VMXNET3_DRIVER_VERSION_NUM      0x01000B00
 
 
 /*
