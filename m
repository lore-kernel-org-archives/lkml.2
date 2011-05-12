Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1ELCf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:35:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62732 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab1ELCf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:35:28 -0400
Message-ID: <4DCB4827.4030609@cn.fujitsu.com>
Date: Thu, 12 May 2011 10:38:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Doug Thompson <dougthompson@xmission.com>,
        EDAC-CORE <bluesmoke-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] edac,rcu: use synchronize_rcu() instead of call_rcu()+rcu_barrier()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-12 10:35:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-12 10:35:38,
	Serialize complete at 2011-05-12 10:35:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

synchronize_rcu() does the stuff as needed.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/edac/edac_core.h   |   12 ------------
 drivers/edac/edac_device.c |   24 ++++++------------------
 drivers/edac/edac_mc.c     |   16 ++++++----------
 drivers/edac/edac_pci.c    |   21 ++++++---------------
 4 files changed, 18 insertions(+), 55 deletions(-)
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index eefa350..55b8278 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -421,10 +421,6 @@ struct mem_ctl_info {
 	u32 ce_count;		/* Total Correctable Errors for this MC */
 	unsigned long start_time;	/* mci load start time (in jiffies) */
 
-	/* this stuff is for safe removal of mc devices from global list while
-	 * NMI handlers may be traversing list
-	 */
-	struct rcu_head rcu;
 	struct completion complete;
 
 	/* edac sysfs device control */
@@ -620,10 +616,6 @@ struct edac_device_ctl_info {
 
 	unsigned long start_time;	/* edac_device load start time (jiffies) */
 
-	/* these are for safe removal of mc devices from global list while
-	 * NMI handlers may be traversing list
-	 */
-	struct rcu_head rcu;
 	struct completion removal_complete;
 
 	/* sysfs top name under 'edac' directory
@@ -722,10 +714,6 @@ struct edac_pci_ctl_info {
 
 	unsigned long start_time;	/* edac_pci load start time (jiffies) */
 
-	/* these are for safe removal of devices from global list while
-	 * NMI handlers may be traversing list
-	 */
-	struct rcu_head rcu;
 	struct completion complete;
 
 	/* sysfs top name under 'edac' directory
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index a7408cf..c3f6743 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -346,30 +346,18 @@ fail1:
 }
 
 /*
- * complete_edac_device_list_del
- *
- *	callback function when reference count is zero
- */
-static void complete_edac_device_list_del(struct rcu_head *head)
-{
-	struct edac_device_ctl_info *edac_dev;
-
-	edac_dev = container_of(head, struct edac_device_ctl_info, rcu);
-	INIT_LIST_HEAD(&edac_dev->link);
-}
-
-/*
  * del_edac_device_from_global_list
- *
- *	remove the RCU, setup for a callback call,
- *	then wait for the callback to occur
  */
 static void del_edac_device_from_global_list(struct edac_device_ctl_info
 						*edac_device)
 {
 	list_del_rcu(&edac_device->link);
-	call_rcu(&edac_device->rcu, complete_edac_device_list_del);
-	rcu_barrier();
+
+	/* these are for safe removal of devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	synchronize_rcu();
+	INIT_LIST_HEAD(&edac_device->link);
 }
 
 /*
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 1d80560..d69144a 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -447,20 +447,16 @@ fail1:
 	return 1;
 }
 
-static void complete_mc_list_del(struct rcu_head *head)
-{
-	struct mem_ctl_info *mci;
-
-	mci = container_of(head, struct mem_ctl_info, rcu);
-	INIT_LIST_HEAD(&mci->link);
-}
-
 static void del_mc_from_global_list(struct mem_ctl_info *mci)
 {
 	atomic_dec(&edac_handlers);
 	list_del_rcu(&mci->link);
-	call_rcu(&mci->rcu, complete_mc_list_del);
-	rcu_barrier();
+
+	/* these are for safe removal of devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	synchronize_rcu();
+	INIT_LIST_HEAD(&mci->link);
 }
 
 /**
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index efb5d56..2b378207 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -164,19 +164,6 @@ fail1:
 }
 
 /*
- * complete_edac_pci_list_del
- *
- *	RCU completion callback to indicate item is deleted
- */
-static void complete_edac_pci_list_del(struct rcu_head *head)
-{
-	struct edac_pci_ctl_info *pci;
-
-	pci = container_of(head, struct edac_pci_ctl_info, rcu);
-	INIT_LIST_HEAD(&pci->link);
-}
-
-/*
  * del_edac_pci_from_global_list
  *
  *	remove the PCI control struct from the global list
@@ -184,8 +171,12 @@ static void complete_edac_pci_list_del(struct rcu_head *head)
 static void del_edac_pci_from_global_list(struct edac_pci_ctl_info *pci)
 {
 	list_del_rcu(&pci->link);
-	call_rcu(&pci->rcu, complete_edac_pci_list_del);
-	rcu_barrier();
+
+	/* these are for safe removal of devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	synchronize_rcu();
+	INIT_LIST_HEAD(&pci->link);
 }
 
 #if 0
