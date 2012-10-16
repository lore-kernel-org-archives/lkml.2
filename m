Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2JPQBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:01:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35475 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2JPQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:01:02 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 3/3] USB: forbid memory allocation with I/O during bus reset
Date: Tue, 16 Oct 2012 23:59:43 +0800
Message-Id: <1350403183-12650-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350403183-12650-1-git-send-email-ming.lei@canonical.com>
References: <1350403183-12650-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one storage interface or usb network interface(iSCSI case)
exists in current configuration, memory allocation with
GFP_KERNEL during usb_device_reset() might trigger I/O transfer
on the storage interface itself and cause deadlock because
the 'us->dev_mutex' is held in .pre_reset() and the storage
interface can't do I/O transfer when the reset is triggered
by other interface, or the error handling can't be completed
if the reset is triggered by the storage itself(error handling path).

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/usb/core/hub.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 9dc8ff2..3ea81f6 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5028,6 +5028,7 @@ int usb_reset_device(struct usb_device *udev)
 {
 	int ret;
 	int i;
+	unsigned int noio_flag;
 	struct usb_host_config *config = udev->actconfig;
 
 	if (udev->state == USB_STATE_NOTATTACHED ||
@@ -5037,6 +5038,15 @@ int usb_reset_device(struct usb_device *udev)
 		return -EINVAL;
 	}
 
+	/*
+	 * Don't allocate memory with GFP_KERNEL in current
+	 * context to avoid possible deadlock if usb mass
+	 * storage interface or usbnet interface(iSCSI case)
+	 * is included in current configuration. The easiest
+	 * approach is to do it for all devices.
+	 */
+	memalloc_noio_save(noio_flag);
+
 	/* Prevent autosuspend during the reset */
 	usb_autoresume_device(udev);
 
@@ -5081,6 +5091,7 @@ int usb_reset_device(struct usb_device *udev)
 	}
 
 	usb_autosuspend_device(udev);
+	memalloc_noio_restore(noio_flag);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(usb_reset_device);
-- 
1.7.9.5

