Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0C3XKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:10:07 -0400
Received: from kroah.org ([198.145.64.141]:48662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab0C3XJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:26 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:50:09 2010
Message-Id: <20100330225008.999625477@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:49:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [44/45] USB: fix usbfs regression
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 7152b592593b9d48b33f8997b1dfd6df9143f7ec upstream.

This patch (as1352) fixes a bug in the way isochronous input data is
returned to userspace for usbfs transfers.  The entire buffer must be
copied, not just the first actual_length bytes, because the individual
packets will be discontiguous if any of them are short.

Reported-by: Markus Rechberger <mrechberger@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1123,6 +1123,13 @@ static int proc_do_submiturb(struct dev_
 			free_async(as);
 			return -ENOMEM;
 		}
+		/* Isochronous input data may end up being discontiguous
+		 * if some of the packets are short.  Clear the buffer so
+		 * that the gaps don't leak kernel data to userspace.
+		 */
+		if (is_in && uurb->type == USBDEVFS_URB_TYPE_ISO)
+			memset(as->urb->transfer_buffer, 0,
+					uurb->buffer_length);
 	}
 	as->urb->dev = ps->dev;
 	as->urb->pipe = (uurb->type << 30) |
@@ -1224,10 +1231,14 @@ static int processcompl(struct async *as
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
 			goto err_out;
+	}
 	if (put_user(as->status, &userurb->status))
 		goto err_out;
 	if (put_user(urb->actual_length, &userurb->actual_length))


