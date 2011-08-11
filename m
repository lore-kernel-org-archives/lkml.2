Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1HKOgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:36:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50343 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750741Ab1HKOgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:36:48 -0400
Date: Thu, 11 Aug 2011 10:36:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andiry Xu <andiry.xu@amd.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Daniel Mack <zonque@gmail.com>, Florian Mickler <florian@mickler.org>,
        Oliver Neukum <oliver@neukum.org>, <linux-usb@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, <pedrib@gmail.com>,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        <linux-kernel@vger.kernel.org>, Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
In-Reply-To: <1313032941.1918.8.camel@brienza-desktop>
Message-ID: <Pine.LNX.4.44L0.1108111027520.1958-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011, Andiry Xu wrote:

> > Please don't submit zero-length transfers.  The xHCI driver just isn't
> > able to handle it.  Arguably, it probably should have just rejected your
> > URB when it found a zero length buffer, so I'll probably be submitting a
> > patch to fix that.
> > 
> 
> I think queue a zero-length TRB to xhci host is OK. I've not tested it,
> but the issue here seems is caused by td->last_trb = NULL. Check
> count_isoc_trbs_needed(), num_trbs will be 0 if the packet length is
> zero and (addr & (TRB_MAS_BUFF_SIZE - 1)) is zero. We can not return
> num_trbs as 0 to xhci_queue_isoc_tx(), which caused a td added to ep's
> td list, while it's not actually queued to ep ring and last_trb is not
> set.
> 
> In order to avoid this, we just make sure count_isoc_trbs_needed()
> always return 1 or larger numbers, instead of reject the urb. Is that
> feasible?

I just looked for the first time at the code in 
count_isoc_trbs_needed().  It does seem rather sub-optimal.

The basic idea is that you need to know how many TRB buffers can cover 
the memory area spanned by the packet data, where a TRB buffer's size 
cannot be larger than TRB_MAX_BUFF_SIZE and all but the first buffer 
must be aligned on a TRB_MAX_BUFF_SIZE boundary, right?  With a slight 
adjustment in the case of a zero-length packet, since you always need 
at least one TRB.

Given that the packet data starts at addr and has length td_len, the 
number of TRBs should be calculated as follows:

	num = DIV_ROUND_UP(td_len + (addr & (TRB_MAX_BUFF_SIZE - 1))), 
			TRB_MAX_BUFF_SIZE);
	num += (num == 0);

No need for a running_total or a loop.

Alan Stern

