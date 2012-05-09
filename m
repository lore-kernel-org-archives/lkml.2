Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2EIF6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:58:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39113 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756729Ab2EIFxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:47 -0400
Message-Id: <20120509055045.572430914@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        Oliver Neukum <oneukum@suse.de>,
        =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 115/167] [PATCH] USB: cdc-wdm: fix race leading leading to memory corruption
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-wdm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index c6f6560..0bb2b32 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -157,8 +157,9 @@ static void wdm_out_callback(struct urb *urb)
 	spin_lock(&desc->iuspin);
 	desc->werr = urb->status;
 	spin_unlock(&desc->iuspin);
-	clear_bit(WDM_IN_USE, &desc->flags);
 	kfree(desc->outbuf);
+	desc->outbuf = NULL;
+	clear_bit(WDM_IN_USE, &desc->flags);
 	wake_up(&desc->wait);
 }
 
@@ -338,7 +339,7 @@ static ssize_t wdm_write
 	if (we < 0)
 		return -EIO;
 
-	desc->outbuf = buf = kmalloc(count, GFP_KERNEL);
+	buf = kmalloc(count, GFP_KERNEL);
 	if (!buf) {
 		rv = -ENOMEM;
 		goto outnl;
@@ -406,10 +407,12 @@ static ssize_t wdm_write
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
-- 
1.7.10



