Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031172Ab2HGWq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:46:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51211 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031033Ab2HGWqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:46:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 12/49] usbdevfs: Correct amount of data copied to user in processcompl_compat
Date: Tue,  7 Aug 2012 15:44:30 -0700
Message-Id: <20120807222027.967692914@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 2102e06a5f2e414694921f23591f072a5ba7db9f upstream.

iso data buffers may have holes in them if some packets were short, so for
iso urbs we should always copy the entire buffer, just like the regular
processcompl does.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/devio.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1557,10 +1557,14 @@ static int processcompl_compat(struct as
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer && urb->actual_length)
-		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->actual_length))
+	if (as->userbuffer && urb->actual_length) {
+		if (urb->number_of_packets > 0)		/* Isochronous */
+			i = urb->transfer_buffer_length;
+		else					/* Non-Isoc */
+			i = urb->actual_length;
+		if (copy_to_user(as->userbuffer, urb->transfer_buffer, i))
 			return -EFAULT;
+	}
 	if (put_user(as->status, &userurb->status))
 		return -EFAULT;
 	if (put_user(urb->actual_length, &userurb->actual_length))


