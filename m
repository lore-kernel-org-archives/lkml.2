Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab0LHBCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:02:53 -0500
Received: from kroah.org ([198.145.64.141]:33535 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab0LHBCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:50 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:40 2010
Message-Id: <20101208005740.876388141@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [194/289] xhci: Fix reset-device and configure-endpoint commands
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit 7a3783efffc7bc2e702d774e47fad5b8e37e9ad1 upstream.

We have been having problems with the USB-IF Gold Tree tests when plugging
and unplugging devices from the tree. I have seen that the reset-device
and configure-endpoint commands, which are invoked from
xhci_discover_or_reset_device() and xhci_configure_endpoint(), will sometimes
time out.

After much debugging, I determined that the commands themselves do not actually
time out, but rather their completion events do not get delivered to the right
place.

This happens when the command ring has just wrapped around, and it's enqueue
pointer is left pointing to the link TRB. xhci_discover_or_reset_device() and
xhci_configure_endpoint() use the enqueue pointer directly as their command
TRB pointer, without checking whether it's pointing to the link TRB.

When the completion event arrives, if the command TRB is pointing to the link
TRB, the check against the command ring dequeue pointer in
handle_cmd_in_cmd_wait_list() fails, so the completion inside the command does
not get signaled.

The patch below fixes the timeout problem for me.

This should be queued for the 2.6.35 and 2.6.36 stable trees.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1284,6 +1284,15 @@ static int xhci_configure_endpoint(struc
 		cmd_completion = command->completion;
 		cmd_status = &command->status;
 		command->command_trb = xhci->cmd_ring->enqueue;
+
+		/* Enqueue pointer can be left pointing to the link TRB,
+		 * we must handle that
+		 */
+		if ((command->command_trb->link.control & TRB_TYPE_BITMASK)
+				== TRB_TYPE(TRB_LINK))
+			command->command_trb =
+				xhci->cmd_ring->enq_seg->next->trbs;
+
 		list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
 	} else {
 		in_ctx = virt_dev->in_ctx;
@@ -1993,6 +2002,15 @@ int xhci_reset_device(struct usb_hcd *hc
 	/* Attempt to submit the Reset Device command to the command ring */
 	spin_lock_irqsave(&xhci->lock, flags);
 	reset_device_cmd->command_trb = xhci->cmd_ring->enqueue;
+
+	/* Enqueue pointer can be left pointing to the link TRB,
+	 * we must handle that
+	 */
+	if ((reset_device_cmd->command_trb->link.control & TRB_TYPE_BITMASK)
+			== TRB_TYPE(TRB_LINK))
+		reset_device_cmd->command_trb =
+			xhci->cmd_ring->enq_seg->next->trbs;
+
 	list_add_tail(&reset_device_cmd->cmd_list, &virt_dev->cmd_list);
 	ret = xhci_queue_reset_device(xhci, slot_id);
 	if (ret) {


