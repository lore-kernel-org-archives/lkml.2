Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab1CAWQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:16:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab1CAWP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:15:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Max Vozeler <max@vozeler.com>
Subject: Re: [PATCH 03/20] staging/usbip: convert to kthread
Date: Tue, 1 Mar 2011 23:15:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-4-git-send-email-arnd@arndb.de> <4D4302AC.3050903@vozeler.com>
In-Reply-To: <4D4302AC.3050903@vozeler.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103012315.55188.arnd@arndb.de>
X-Provags-ID: V02:K0:wgX9L+hFt3/8IYlQsqKlwVTIfrRh/TpOrMkOHK/yIQ7
 n9ZsfV4Jv6gUOvU9cGfg42Ju/7/Hi8P5GkQGF/itE/jUQgxDXu
 JDLRx8l+j5nI9lIXVvhechZb5fd5oia9X3OKT+MQz5LFXxHOFu
 Bwk8vtp0ggz/ZgwOuBD1owcqThf3YGHrj+sd9Y0zgXqQ/Qc8dA
 BMNGDMP2o+K0PiQ5xeUMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 January 2011 18:53:48 Max Vozeler wrote:
> I need to leave now for the next couple of days,
> so this is a bit rushed.
> 
> I can take a closer look and do tests in different
> setups during the next week.
> 

It seems we both forgot about this. This is what I now added to my tree.
Greg, I'll resubmit a folded version with the original patch.

	Arnd
8<------

staging/usbip: fix breakage from BKL removal
    
wait_event_interruptible() in a kthread needs
to check if the kthread should stop.
    
Thread creation was racy, calling kthread_run
instead of wake_up on an existing kthread
fixes this.
    
Reported-by: Max Vozeler <max@vozeler.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index f2c6148..8214c35 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -139,8 +139,8 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 
 		spin_unlock(&sdev->ud.lock);
 
-		wake_up_process(sdev->ud.tcp_rx);
-		wake_up_process(sdev->ud.tcp_tx);
+		sdev->ud.tcp_rx = kthread_run(stub_rx_loop, &sdev->ud, "stub_rx");
+		sdev->ud.tcp_tx = kthread_run(stub_tx_loop, &sdev->ud, "stub_tx");
 
 		spin_lock(&sdev->ud.lock);
 		sdev->ud.status = SDEV_ST_USED;
@@ -339,9 +339,6 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 	 */
 	sdev->devid     = (busnum << 16) | devnum;
 
-	sdev->ud.tcp_rx = kthread_create(stub_rx_loop, &sdev->ud, "stub_rx");
-	sdev->ud.tcp_tx = kthread_create(stub_tx_loop, &sdev->ud, "stub_tx");
-
 	sdev->ud.side = USBIP_STUB;
 	sdev->ud.status = SDEV_ST_AVAILABLE;
 	/* sdev->ud.lock = SPIN_LOCK_UNLOCKED; */
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index 2477481..5523f25 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -365,7 +365,8 @@ int stub_tx_loop(void *data)
 
 		wait_event_interruptible(sdev->tx_waitq,
 				(!list_empty(&sdev->priv_tx) ||
-				 !list_empty(&sdev->unlink_tx)));
+				 !list_empty(&sdev->unlink_tx) ||
+				 kthread_should_stop()));
 	}
 
 	return 0;
diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
index 89aecec..f4b287e 100644
--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -67,12 +67,13 @@ static int event_handler_loop(void *data)
 	struct usbip_device *ud = data;
 
 	while (!kthread_should_stop()) {
-		if (event_handler(ud) < 0)
-			break;
-
 		wait_event_interruptible(ud->eh_waitq,
-					usbip_event_happened(ud));
+					usbip_event_happened(ud) ||
+					kthread_should_stop());
 		usbip_dbg_eh("wakeup\n");
+
+		if (event_handler(ud) < 0)
+			break;
 	}
 	return 0;
 }
diff --git a/drivers/staging/usbip/vhci_tx.c b/drivers/staging/usbip/vhci_tx.c
index 6d065b9..d9ab49d 100644
--- a/drivers/staging/usbip/vhci_tx.c
+++ b/drivers/staging/usbip/vhci_tx.c
@@ -230,7 +230,8 @@ int vhci_tx_loop(void *data)
 
 		wait_event_interruptible(vdev->waitq_tx,
 				(!list_empty(&vdev->priv_tx) ||
-				 !list_empty(&vdev->unlink_tx)));
+				 !list_empty(&vdev->unlink_tx) ||
+				 kthread_should_stop()));
 
 		usbip_dbg_vhci_tx("pending urbs ?, now wake up\n");
 	}
