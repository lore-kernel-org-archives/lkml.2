Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2EDUpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:45:31 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab2EDUp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:45:28 -0400
Message-Id: <20120504204226.884649355@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 29/75] USB: cdc-wdm: fix race leading leading to memory corruption
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 5c22837adca7c30b66121cf18ad3e160134268d4 upstream.

This patch fixes a race whereby a pointer to a buffer
would be overwritten while the buffer was in use leading
to a double free and a memory leak. This causes crashes.
This bug was introduced in 2.6.34

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Tested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -108,8 +108,9 @@ static void wdm_out_callback(struct urb
 	spin_lock(&desc->iuspin);
 	desc->werr = urb->status;
 	spin_unlock(&desc->iuspin);
-	clear_bit(WDM_IN_USE, &desc->flags);
 	kfree(desc->outbuf);
+	desc->outbuf = NULL;
+	clear_bit(WDM_IN_USE, &desc->flags);
 	wake_up(&desc->wait);
 }
 
@@ -312,7 +313,7 @@ static ssize_t wdm_write
 	if (we < 0)
 		return -EIO;
 
-	desc->outbuf = buf = kmalloc(count, GFP_KERNEL);
+	buf = kmalloc(count, GFP_KERNEL);
 	if (!buf) {
 		rv = -ENOMEM;
 		goto outnl;
@@ -376,10 +377,12 @@ static ssize_t wdm_write
 	req->wIndex = desc->inum;
 	req->wLength = cpu_to_le16(count);
 	set_bit(WDM_IN_USE, &desc->flags);
+	desc->outbuf = buf;
 
 	rv = usb_submit_urb(desc->command, GFP_KERNEL);
 	if (rv < 0) {
 		kfree(buf);
+		desc->outbuf = NULL;
 		clear_bit(WDM_IN_USE, &desc->flags);
 		dev_err(&desc->intf->dev, "Tx URB error: %d\n", rv);
 	} else {


