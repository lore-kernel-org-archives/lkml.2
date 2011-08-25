Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1HYEwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:52:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49516 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1HYEwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:52:11 -0400
Date: Thu, 25 Aug 2011 14:52:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20110825145206.4888b9f62a9bcbeeaf8678b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/xhci-ring.c between commit 48df4a6fd8c4 ("xhci: Handle
zero-length isochronous packets") from the usb.current tree and commit
29cc88979a88 ("USB: use usb_endpoint_maxp() instead of le16_to_cpu()")
from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
diff --cc drivers/usb/host/xhci-ring.c
index 54139a2,bf0b52c..0000000
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@@ -3249,11 -3237,9 +3249,11 @@@ static int xhci_queue_isoc_tx(struct xh
  		addr = start_addr + urb->iso_frame_desc[i].offset;
  		td_len = urb->iso_frame_desc[i].length;
  		td_remain_len = td_len;
 -		/* FIXME: Ignoring zero-length packets, can those happen? */
  		total_packet_count = roundup(td_len,
- 				le16_to_cpu(urb->ep->desc.wMaxPacketSize));
+ 				usb_endpoint_maxp(&urb->ep->desc));
 +		/* A zero-length transfer still involves at least one packet. */
 +		if (total_packet_count == 0)
 +			total_packet_count++;
  		burst_count = xhci_get_burst_count(xhci, urb->dev, urb,
  				total_packet_count);
  		residue = xhci_get_last_burst_packet_count(xhci,
