Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0CaAis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:38:48 -0400
Received: from kroah.org ([198.145.64.141]:48508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab0C3XJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:07 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:56 2010
Message-Id: <20100330224955.552012312@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [23/45] USB: usbfs: only copy the actual data received
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg KH <greg@kroah.com>

commit d4a4683ca054ed9917dfc9e3ff0f7ecf74ad90d6 upstream.

We need to only copy the data received by the device to userspace, not
the whole kernel buffer, which can contain "stale" data.

Thanks to Marcus Meissner for pointing this out and testing the fix.

Reported-by: Marcus Meissner <meissner@suse.de>
Tested-by: Marcus Meissner <meissner@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1224,9 +1224,9 @@ static int processcompl(struct async *as
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer)
+	if (as->userbuffer && urb->actual_length)
 		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->transfer_buffer_length))
+				 urb->actual_length))
 			goto err_out;
 	if (put_user(as->status, &userurb->status))
 		goto err_out;
@@ -1347,9 +1347,9 @@ static int processcompl_compat(struct as
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer)
+	if (as->userbuffer && urb->actual_length)
 		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->transfer_buffer_length))
+				 urb->actual_length))
 			return -EFAULT;
 	if (put_user(as->status, &userurb->status))
 		return -EFAULT;


