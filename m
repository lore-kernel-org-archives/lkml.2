Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598Ab2C3VEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:04:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761568Ab2C3VED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:04:03 -0400
Message-Id: <20120330195724.981284809@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [ 020/108] cdc-wdm: Fix more races on the read path
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 711c68b3c0f7a924ffbee4aa962d8f62b85188ff upstream.

We must not allow the input buffer length to change while we're
shuffling the buffer contents.  We also mustn't clear the WDM_READ
flag after more data might have arrived.  Therefore move both of these
into the spinlocked region at the bottom of wdm_read().

When reading desc->length without holding the iuspin lock, use
ACCESS_ONCE() to ensure the compiler doesn't re-read it with
inconsistent results.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -397,7 +397,7 @@ outnl:
 static ssize_t wdm_read
 (struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
-	int rv, cntr = 0;
+	int rv, cntr;
 	int i = 0;
 	struct wdm_device *desc = file->private_data;
 
@@ -406,7 +406,8 @@ static ssize_t wdm_read
 	if (rv < 0)
 		return -ERESTARTSYS;
 
-	if (desc->length == 0) {
+	cntr = ACCESS_ONCE(desc->length);
+	if (cntr == 0) {
 		desc->read = 0;
 retry:
 		if (test_bit(WDM_DISCONNECTING, &desc->flags)) {
@@ -457,25 +458,30 @@ retry:
 			goto retry;
 		}
 		clear_bit(WDM_READ, &desc->flags);
+		cntr = desc->length;
 		spin_unlock_irq(&desc->iuspin);
 	}
 
-	cntr = count > desc->length ? desc->length : count;
+	if (cntr > count)
+		cntr = count;
 	rv = copy_to_user(buffer, desc->ubuf, cntr);
 	if (rv > 0) {
 		rv = -EFAULT;
 		goto err;
 	}
 
+	spin_lock_irq(&desc->iuspin);
+
 	for (i = 0; i < desc->length - cntr; i++)
 		desc->ubuf[i] = desc->ubuf[i + cntr];
 
-	spin_lock_irq(&desc->iuspin);
 	desc->length -= cntr;
-	spin_unlock_irq(&desc->iuspin);
 	/* in case we had outstanding data */
 	if (!desc->length)
 		clear_bit(WDM_READ, &desc->flags);
+
+	spin_unlock_irq(&desc->iuspin);
+
 	rv = cntr;
 
 err:


