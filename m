Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0DHQ5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:57:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47188 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758745Ab0DHQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:57:36 -0400
Date: Thu, 8 Apr 2010 12:57:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <daniel@caiaq.de>
cc: Robert Hancock <hancockrwd@gmail.com>, <linux-kernel@vger.kernel.org>,
       Pedro Ribeiro <pedrib@gmail.com>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100408073041.GO30801@buzzloop.caiaq.de>
Message-ID: <Pine.LNX.4.44L0.1004081245330.1720-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Apr 2010, Daniel Mack wrote:

> > > AFAIK, the driver shouldn't have to worry about this at all. When the 
> > > buffer gets DMA-mapped for the controller, the DMA mapping code should 
> > > see that the device has a 32-bit DMA mask and either bounce or IOMMU-map 
> > > the memory so that it appears below 4GB.
> > 
> > That's true.  It would of course be more efficient for the buffer to be
> > allocated below 4 GB, but it should work okay either way.  Daniel, do
> > you have any idea why it fails?
> 
> No, and I can't do real tests as I lack a 64bit machine. I'll do some
> more investigation later today, but for now the only explanation I have
> is that not the remapped DMA buffer is used eventually by the EHCI code
> but the physical address of the original buffer.
> 
> It would of course be best to fix the whole problem at this level, if
> possible.

It definitely needs to be fixed at this level.  But I still think it's 
appropriate to have new USB core functions for allocating and 
deallocating I/O memory.  The additional price is small compared to 
constantly bouncing the buffers.

Pedro, in the hope of tracking down the problem, can you apply this 
patch and see what output it produces in the system log when the 
"interference" happens?  (Warning: It will produce quite a lot of 
output whenever you send data to the audio device -- between 500 and 
1000 lines per second.)

Alan Stern



Index: 2.6.33/drivers/usb/core/hcd.c
===================================================================
--- 2.6.33.orig/drivers/usb/core/hcd.c
+++ 2.6.33/drivers/usb/core/hcd.c
@@ -1395,6 +1395,10 @@ int usb_hcd_submit_urb (struct urb *urb,
 		usbmon_urb_submit_error(&hcd->self, urb, status);
 		goto error;
 	}
+	if (usb_endpoint_is_isoc_out(&urb->ep->desc))
+		dev_info(&urb->dev->dev, "Iso xfer %p dma %llx\n",
+				urb->transfer_buffer,
+				(unsigned long long) urb->transfer_dma);
 
 	if (is_root_hub(urb->dev))
 		status = rh_urb_enqueue(hcd, urb);

