Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0LLXrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36407 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab0LLXr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:27 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: Paul.Zimmerman@synopsys.com, paulz@synopsys.com,
        sarah.a.sharp@linux.intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [143/223] xhci: Fix reset-device and configure-endpoint commands
Message-Id: <20101212234725.E9C8FB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux/drivers/usb/host/xhci.c
===================================================================
--- linux.orig/drivers/usb/host/xhci.c
+++ linux/drivers/usb/host/xhci.c
@@ -1224,6 +1224,15 @@ static int xhci_configure_endpoint(struc
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
@@ -1933,6 +1942,15 @@ int xhci_reset_device(struct usb_hcd *hc
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
