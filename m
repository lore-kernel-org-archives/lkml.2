Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1IUWnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:43:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21919 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1IUWmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 18:42:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/pciback: Use mutexes when working with Xenbus state transitions.
Date: Wed, 21 Sep 2011 18:42:45 -0400
Message-Id: <1316644966-19386-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316644966-19386-1-git-send-email-konrad.wilk@oracle.com>
References: <1316644966-19386-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020206.4E7A686B.0013:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The caller that orchestrates the state changes is xenwatch_thread
and it takes a mutex. In our processing of Xenbus states we can take
the luxery of going to sleep on a mutex, so lets do that and
also fix this bug:

BUG: sleeping function called from invalid context at /linux/kernel/mutex.c:271
in_atomic(): 1, irqs_disabled(): 0, pid: 32, name: xenwatch
2 locks held by xenwatch/32:
 #0:  (xenwatch_mutex){......}, at: [<ffffffff813856ab>] xenwatch_thread+0x4b/0x180
 #1:  (&(&pdev->dev_lock)->rlock){......}, at: [<ffffffff8138f05b>] xen_pcibk_disconnect+0x1b/0x80
Pid: 32, comm: xenwatch Not tainted 3.1.0-rc6-00015-g3ce340d #2
Call Trace:
 [<ffffffff810892b2>] __might_sleep+0x102/0x130
 [<ffffffff8163b90f>] mutex_lock_nested+0x2f/0x50
 [<ffffffff81382c1c>] unbind_from_irq+0x2c/0x1b0
 [<ffffffff8110da66>] ? free_irq+0x56/0xb0
 [<ffffffff81382dbc>] unbind_from_irqhandler+0x1c/0x30
 [<ffffffff8138f06b>] xen_pcibk_disconnect+0x2b/0x80
 [<ffffffff81390348>] xen_pcibk_frontend_changed+0xe8/0x140
 [<ffffffff81387ac2>] xenbus_otherend_changed+0xd2/0x150
 [<ffffffff810895c1>] ? get_parent_ip+0x11/0x50
 [<ffffffff81387de0>] frontend_changed+0x10/0x20
 [<ffffffff81385712>] xenwatch_thread+0xb2/0x180

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pciback.h |    2 +-
 drivers/xen/xen-pciback/xenbus.c  |   22 +++++++++-------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/xen-pciback/pciback.h b/drivers/xen/xen-pciback/pciback.h
index d095acd..e9b4011 100644
--- a/drivers/xen/xen-pciback/pciback.h
+++ b/drivers/xen/xen-pciback/pciback.h
@@ -29,7 +29,7 @@ struct pci_dev_entry {
 
 struct xen_pcibk_device {
 	void *pci_dev_data;
-	spinlock_t dev_lock;
+	struct mutex dev_lock;
 	struct xenbus_device *xdev;
 	struct xenbus_watch be_watch;
 	u8 be_watching;
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 522f2da..474d52e 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -43,7 +43,7 @@ static struct xen_pcibk_device *alloc_pdev(struct xenbus_device *xdev)
 	pdev->xdev = xdev;
 	dev_set_drvdata(&xdev->dev, pdev);
 
-	spin_lock_init(&pdev->dev_lock);
+	mutex_init(&pdev->dev_lock);
 
 	pdev->sh_info = NULL;
 	pdev->evtchn_irq = INVALID_EVTCHN_IRQ;
@@ -61,14 +61,12 @@ out:
 
 static void xen_pcibk_disconnect(struct xen_pcibk_device *pdev)
 {
-	spin_lock(&pdev->dev_lock);
-
+	mutex_lock(&pdev->dev_lock);
 	/* Ensure the guest can't trigger our handler before removing devices */
 	if (pdev->evtchn_irq != INVALID_EVTCHN_IRQ) {
 		unbind_from_irqhandler(pdev->evtchn_irq, pdev);
 		pdev->evtchn_irq = INVALID_EVTCHN_IRQ;
 	}
-	spin_unlock(&pdev->dev_lock);
 
 	/* If the driver domain started an op, make sure we complete it
 	 * before releasing the shared memory */
@@ -76,13 +74,11 @@ static void xen_pcibk_disconnect(struct xen_pcibk_device *pdev)
 	/* Note, the workqueue does not use spinlocks at all.*/
 	flush_workqueue(xen_pcibk_wq);
 
-	spin_lock(&pdev->dev_lock);
 	if (pdev->sh_info != NULL) {
 		xenbus_unmap_ring_vfree(pdev->xdev, pdev->sh_info);
 		pdev->sh_info = NULL;
 	}
-	spin_unlock(&pdev->dev_lock);
-
+	mutex_unlock(&pdev->dev_lock);
 }
 
 static void free_pdev(struct xen_pcibk_device *pdev)
@@ -119,9 +115,7 @@ static int xen_pcibk_do_attach(struct xen_pcibk_device *pdev, int gnt_ref,
 		goto out;
 	}
 
-	spin_lock(&pdev->dev_lock);
 	pdev->sh_info = vaddr;
-	spin_unlock(&pdev->dev_lock);
 
 	err = bind_interdomain_evtchn_to_irqhandler(
 		pdev->xdev->otherend_id, remote_evtchn, xen_pcibk_handle_event,
@@ -131,10 +125,7 @@ static int xen_pcibk_do_attach(struct xen_pcibk_device *pdev, int gnt_ref,
 				 "Error binding event channel to IRQ");
 		goto out;
 	}
-
-	spin_lock(&pdev->dev_lock);
 	pdev->evtchn_irq = err;
-	spin_unlock(&pdev->dev_lock);
 	err = 0;
 
 	dev_dbg(&pdev->xdev->dev, "Attached!\n");
@@ -149,6 +140,7 @@ static int xen_pcibk_attach(struct xen_pcibk_device *pdev)
 	char *magic = NULL;
 
 
+	mutex_lock(&pdev->dev_lock);
 	/* Make sure we only do this setup once */
 	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
 	    XenbusStateInitialised)
@@ -193,6 +185,7 @@ static int xen_pcibk_attach(struct xen_pcibk_device *pdev)
 
 	dev_dbg(&pdev->xdev->dev, "Connected? %d\n", err);
 out:
+	mutex_unlock(&pdev->dev_lock);
 
 	kfree(magic);
 
@@ -368,6 +361,7 @@ static int xen_pcibk_reconfigure(struct xen_pcibk_device *pdev)
 
 	dev_dbg(&pdev->xdev->dev, "Reconfiguring device ...\n");
 
+	mutex_lock(&pdev->dev_lock);
 	/* Make sure we only reconfigure once */
 	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
 	    XenbusStateReconfiguring)
@@ -505,6 +499,7 @@ static int xen_pcibk_reconfigure(struct xen_pcibk_device *pdev)
 	}
 
 out:
+	mutex_unlock(&pdev->dev_lock);
 	return 0;
 }
 
@@ -561,6 +556,7 @@ static int xen_pcibk_setup_backend(struct xen_pcibk_device *pdev)
 	char dev_str[64];
 	char state_str[64];
 
+	mutex_lock(&pdev->dev_lock);
 	/* It's possible we could get the call to setup twice, so make sure
 	 * we're not already connected.
 	 */
@@ -641,10 +637,10 @@ static int xen_pcibk_setup_backend(struct xen_pcibk_device *pdev)
 				 "Error switching to initialised state!");
 
 out:
+	mutex_unlock(&pdev->dev_lock);
 	if (!err)
 		/* see if pcifront is already configured (if not, we'll wait) */
 		xen_pcibk_attach(pdev);
-
 	return err;
 }
 
-- 
1.7.4.1

