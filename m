Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019Ab2E0BRI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:17:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422675Ab2E0BQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:16:59 -0400
Message-Id: <20120527002514.521649769@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:41 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 35/91] USB: cdc-wdm: remove from device list on disconnect
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 6286d85e8efdb59252d1ceb99a56fa6b0b11526c upstream.

Prevents dereferencing an invalid struct usb_interface
pointer.

Always delete entry from device list whether or not the
rest of the device state cleanup is postponed. The device
list uses desc->intf as key, and wdm_open will dereference
this key while searching for a matching device.  A device
should not appear in the list unless probe() has succeeded
and disconnect() has not finished.

Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -309,9 +309,6 @@ static void free_urbs(struct wdm_device
 
 static void cleanup(struct wdm_device *desc)
 {
-	spin_lock(&wdm_device_list_lock);
-	list_del(&desc->device_list);
-	spin_unlock(&wdm_device_list_lock);
 	kfree(desc->sbuf);
 	kfree(desc->inbuf);
 	kfree(desc->orq);
@@ -778,6 +775,9 @@ static int wdm_create(struct usb_interfa
 out:
 	return rv;
 err:
+	spin_lock(&wdm_device_list_lock);
+	list_del(&desc->device_list);
+	spin_unlock(&wdm_device_list_lock);
 	cleanup(desc);
 	return rv;
 }
@@ -903,6 +903,12 @@ static void wdm_disconnect(struct usb_in
 	cancel_work_sync(&desc->rxwork);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
+
+	/* the desc->intf pointer used as list key is now invalid */
+	spin_lock(&wdm_device_list_lock);
+	list_del(&desc->device_list);
+	spin_unlock(&wdm_device_list_lock);
+
 	if (!desc->count)
 		cleanup(desc);
 	mutex_unlock(&wdm_mutex);


