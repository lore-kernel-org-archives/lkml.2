Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1I1WiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1I1Wh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:28 2011
Message-Id: <20110928220128.088112658@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Daniel Mack <zonque@gmail.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: [027/244] xhci: Handle zero-length isochronous packets.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 48df4a6fd8c40c0bbcbca2044f5f2bc75dcf6db1 upstream.

For a long time, the xHCI driver has had this note:
	/* FIXME: Ignoring zero-length packets, can those happen? */

It turns out that, yes, there are drivers that need to queue zero-length
transfers for isochronous OUT transfers.  Without this patch, users will
see kernel hang messages when a driver attempts to enqueue an isochronous
URB with a zero length transfer (because count_isoc_trbs_needed will return
zero for that TD, xhci_td->last_trb will never be set, and updating the
dequeue pointer will cause an infinite loop).

Matěj ran into this issue when using an NI Audio4DJ USB soundcard
with the snd-usb-caiaq driver.  See
	https://bugzilla.kernel.org/show_bug.cgi?id=40702

Fix count_isoc_trbs_needed() to return 1 for zero-length transfers (thanks
Alan on the math help).  Update the various TRB field calculations to deal
with zero-length transfers.  We're still transferring one packet with a
zero-length data payload, so the total_packet_count should be 1. The
Transfer Burst Count (TBC) and Transfer Last Burst Packet Count (TLBPC)
fields should be set to zero.

This patch should be backported to kernels as old as 2.6.36.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Matěj Laitl <matej@laitl.cz>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2692,6 +2692,10 @@ static u32 xhci_v1_0_td_remainder(int ru
 {
 	int packets_transferred;
 
+	/* One TRB with a zero-length data packet. */
+	if (running_total == 0 && trb_buff_len == 0)
+		return 0;
+
 	/* All the TRB queueing functions don't count the current TRB in
 	 * running_total.
 	 */
@@ -3133,20 +3137,15 @@ static int count_isoc_trbs_needed(struct
 		struct urb *urb, int i)
 {
 	int num_trbs = 0;
-	u64 addr, td_len, running_total;
+	u64 addr, td_len;
 
 	addr = (u64) (urb->transfer_dma + urb->iso_frame_desc[i].offset);
 	td_len = urb->iso_frame_desc[i].length;
 
-	running_total = TRB_MAX_BUFF_SIZE - (addr & (TRB_MAX_BUFF_SIZE - 1));
-	running_total &= TRB_MAX_BUFF_SIZE - 1;
-	if (running_total != 0)
-		num_trbs++;
-
-	while (running_total < td_len) {
+	num_trbs = DIV_ROUND_UP(td_len + (addr & (TRB_MAX_BUFF_SIZE - 1)),
+			TRB_MAX_BUFF_SIZE);
+	if (num_trbs == 0)
 		num_trbs++;
-		running_total += TRB_MAX_BUFF_SIZE;
-	}
 
 	return num_trbs;
 }
@@ -3258,9 +3257,11 @@ static int xhci_queue_isoc_tx(struct xhc
 		addr = start_addr + urb->iso_frame_desc[i].offset;
 		td_len = urb->iso_frame_desc[i].length;
 		td_remain_len = td_len;
-		/* FIXME: Ignoring zero-length packets, can those happen? */
 		total_packet_count = roundup(td_len,
 				le16_to_cpu(urb->ep->desc.wMaxPacketSize));
+		/* A zero-length transfer still involves at least one packet. */
+		if (total_packet_count == 0)
+			total_packet_count++;
 		burst_count = xhci_get_burst_count(xhci, urb->dev, urb,
 				total_packet_count);
 		residue = xhci_get_last_burst_packet_count(xhci,


