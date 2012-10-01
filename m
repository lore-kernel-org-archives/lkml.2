Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab2JAXBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:01:18 -0400
Received: from 1wt.eu ([62.212.114.60]:35322 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873Ab2JAXBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:15 -0400
Message-Id: <20121001225202.055055370@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 105/180] usbdevfs: Correct amount of data copied to user in processcompl_compat
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 2102e06a5f2e414694921f23591f072a5ba7db9f upstream.

iso data buffers may have holes in them if some packets were short, so for
iso urbs we should always copy the entire buffer, just like the regular
processcompl does.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/core/devio.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index df1e873..48742ff 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1454,10 +1454,14 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
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
-- 
1.7.2.1.45.g54fbc



