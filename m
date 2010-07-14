Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0GNAsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:48:07 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:44856 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347Ab0GNAsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:48:06 -0400
Date: Tue, 13 Jul 2010 17:48:04 -0700 (PDT)
From: Shreyas Bhatewara <sbhatewara@vmware.com>
X-X-Sender: sbhatewara@localhost.localdomain
To: netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org, pv-drivers@vmware.com, ronghua@vmware.com
Subject: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [2/5] Interrupt control
 bitmap
In-Reply-To: <alpine.LRH.2.00.1007070222110.6105@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1007131746370.32055@localhost.localdomain>
References: <alpine.LRH.2.00.1007070125440.4652@localhost.localdomain> <alpine.LRH.2.00.1007070222110.6105@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A new bit map 'intrCtrl' is introduced in the DriverShared area. The driver
should update VMXNET3_IC_DISABLE_ALL bit before writing IMR.

Signed-off-by: Ronghua Zang <ronghua@vmware.com>
Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

---

 drivers/net/vmxnet3/vmxnet3_defs.h |    6 +++++-
 drivers/net/vmxnet3/vmxnet3_drv.c  |    3 +++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index b4889e6..ca7727b 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -464,6 +464,9 @@ enum vmxnet3_intr_type {
 /* addition 1 for events */
 #define VMXNET3_MAX_INTRS      25
 
+/* value of intrCtrl */
+#define VMXNET3_IC_DISABLE_ALL  0x1   /* bit 0 */
+
 
 struct Vmxnet3_IntrConf {
 	bool		autoMask;
@@ -471,7 +474,8 @@ struct Vmxnet3_IntrConf {
 	u8		eventIntrIdx;
 	u8		modLevels[VMXNET3_MAX_INTRS];	/* moderation level for
 							 * each intr */
-	__le32		reserved[3];
+	__le32		intrCtrl;
+	__le32		reserved[2];
 };
 
 /* one bit per VLAN ID, the size is in the units of u32	*/
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 5a50d10..7792a44 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -72,6 +72,7 @@ vmxnet3_enable_all_intrs(struct vmxnet3_adapter *adapter)
 
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_enable_intr(adapter, i);
+	adapter->shared->devRead.intrConf.intrCtrl &= ~VMXNET3_IC_DISABLE_ALL;
 }
 
 
@@ -80,6 +81,7 @@ vmxnet3_disable_all_intrs(struct vmxnet3_adapter *adapter)
 {
 	int i;
 
+	adapter->shared->devRead.intrConf.intrCtrl |= VMXNET3_IC_DISABLE_ALL;
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_disable_intr(adapter, i);
 }
@@ -1880,6 +1882,7 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 		devRead->intrConf.modLevels[i] = adapter->intr.mod_levels[i];
 
 	devRead->intrConf.eventIntrIdx = adapter->intr.event_intr_idx;
+	devRead->intrConf.intrCtrl |= VMXNET3_IC_DISABLE_ALL;
 
 	/* rx filter settings */
 	devRead->rxFilterConf.rxMode = 0;

