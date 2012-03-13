Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab2CMSOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:14:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758568Ab2CMSOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:14:51 -0400
Date: Tue, 13 Mar 2012 19:07:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: fix the usage of kthread_stop()
Message-ID: <20120313180718.GA9224@redhat.com>
References: <20110920124419.GA10759@hallyn.com> <20110920134108.GA30749@redhat.com> <20110920143920.GA15859@redhat.com> <20110920143942.GB15859@redhat.com> <20110920151410.GA16569@redhat.com> <20110920183810.GA25159@suse.de> <20120306173925.GA17551@redhat.com> <20120306193040.GD21503@distanz.ch> <20120308185739.GA18935@redhat.com> <20120313114512.GM21503@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313114512.GM21503@distanz.ch>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13, Tobias Klauser wrote:
>
> Looks OK to me at a first glance. I'll try to dig up my test system
> where I was able to produce that NULL pointer dereference and test your
> patch there and will then let you know my results.

Oh, great. Please find the patch below.

Of course it wasn't tested at all ;)

-----------------------------------------------------------------------
>From 8bec01c69c2b523e93432d36f9e211b6ec4a6771 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 13 Mar 2012 18:55:20 +0100
Subject: [PATCH] staging: usbip: fix the usage of kthread_stop()

stub_shutdown_connection() and vhci_shutdown_connection() use
task_is_dead() before kthread_stop(). This buys nothing and wrong.
kthread_stop() is fine even if this thread is dead. However, if it
is dead nothing protects this task_struct, we shouldn't touch this
memory.

Change the code to do the necessary get_task_struct/put_task_struct.

This patch assumes that

	- xxx_shutdown_connection() is always called, so we can't
	  leak the task_struct.

	- kthread_stop_put() can't be called twice on the same task.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 drivers/staging/usbip/stub_dev.c     |   12 ++++++------
 drivers/staging/usbip/usbip_common.h |   17 +++++++++++++++++
 drivers/staging/usbip/vhci_hcd.c     |    8 ++++----
 drivers/staging/usbip/vhci_sysfs.c   |    4 ++--
 4 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 03420e2..fc6ceca 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -113,8 +113,8 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 
 		spin_unlock(&sdev->ud.lock);
 
-		sdev->ud.tcp_rx = kthread_run(stub_rx_loop, &sdev->ud, "stub_rx");
-		sdev->ud.tcp_tx = kthread_run(stub_tx_loop, &sdev->ud, "stub_tx");
+		sdev->ud.tcp_rx = kthread_get_run(stub_rx_loop, &sdev->ud, "stub_rx");
+		sdev->ud.tcp_tx = kthread_get_run(stub_tx_loop, &sdev->ud, "stub_tx");
 
 		spin_lock(&sdev->ud.lock);
 		sdev->ud.status = SDEV_ST_USED;
@@ -187,10 +187,10 @@ static void stub_shutdown_connection(struct usbip_device *ud)
 	}
 
 	/* 1. stop threads */
-	if (ud->tcp_rx && !task_is_dead(ud->tcp_rx))
-		kthread_stop(ud->tcp_rx);
-	if (ud->tcp_tx && !task_is_dead(ud->tcp_tx))
-		kthread_stop(ud->tcp_tx);
+	if (ud->tcp_rx)
+		kthread_stop_put(ud->tcp_rx);
+	if (ud->tcp_tx)
+		kthread_stop_put(ud->tcp_tx);
 
 	/*
 	 * 2. close the socket
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index b8f8c48..0d52234 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -292,6 +292,23 @@ struct usbip_device {
 	} eh_ops;
 };
 
+#define kthread_get_run(threadfn, data, namefmt, ...)			   \
+({									   \
+	struct task_struct *__k						   \
+		= kthread_create(threadfn, data, namefmt, ## __VA_ARGS__); \
+	if (!IS_ERR(__k)) {						   \
+		get_task_struct(__k);					   \
+		wake_up_process(__k);					   \
+	}								   \
+	__k;								   \
+})
+
+#define kthread_stop_put(k)		\
+	do {				\
+		kthread_stop(k);	\
+		put_task_struct(k);	\
+	} while (0)
+
 /* usbip_common.c */
 void usbip_dump_urb(struct urb *purb);
 void usbip_dump_header(struct usbip_header *pdu);
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 2ee97e2..fb50fdc 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -860,10 +860,10 @@ static void vhci_shutdown_connection(struct usbip_device *ud)
 	}
 
 	/* kill threads related to this sdev, if v.c. exists */
-	if (vdev->ud.tcp_rx && !task_is_dead(vdev->ud.tcp_rx))
-		kthread_stop(vdev->ud.tcp_rx);
-	if (vdev->ud.tcp_tx && !task_is_dead(vdev->ud.tcp_tx))
-		kthread_stop(vdev->ud.tcp_tx);
+	if (vdev->ud.tcp_rx)
+		kthread_stop_put(vdev->ud.tcp_rx);
+	if (vdev->ud.tcp_tx)
+		kthread_stop_put(vdev->ud.tcp_tx);
 
 	pr_info("stop threads\n");
 
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index 0cd039b..7ce9c2f 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -222,8 +222,8 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 	spin_unlock(&the_controller->lock);
 	/* end the lock */
 
-	vdev->ud.tcp_rx = kthread_run(vhci_rx_loop, &vdev->ud, "vhci_rx");
-	vdev->ud.tcp_tx = kthread_run(vhci_tx_loop, &vdev->ud, "vhci_tx");
+	vdev->ud.tcp_rx = kthread_get_run(vhci_rx_loop, &vdev->ud, "vhci_rx");
+	vdev->ud.tcp_tx = kthread_get_run(vhci_tx_loop, &vdev->ud, "vhci_tx");
 
 	rh_port_connect(rhport, speed);
 
-- 
1.5.5.1


