Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1HHSpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:45:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48810 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750774Ab1HHSps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:45:48 -0400
Date: Mon, 8 Aug 2011 14:45:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Per Forlin <per.forlin@linaro.org>
cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] usb: gadget: storage_common: make FSG_NUM_BUFFERS variable
 size
In-Reply-To: <CAJ0pr1-DVAiu7Z_Rcumkwji1+=D4Sw2d4GMFsZa-9KCJ06FauA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1108081430140.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011, Per Forlin wrote:

> > Okay, 6% is a worthwhile improvement, though not huge.  Did you try 6
> > or 8 buffers?  I bet going beyond 4 makes very little difference.
> >
> On my board 4 buffers are enough. More buffers will make no difference.
> 
> Background study
> I started by running dd to measure performance on my target side.
> Simply to measure what would be the maximum bandwidth, 20MiB/s on my
> board. Then I started the gadget mass storage on the device and run
> the sae test from the PC host side, 18.7 MiB/s. I guessed this might
> be due to serialized cache handling. I tested to remove the dma_map
> call (replaced it with virt_to_dma). This is just a dummy test to see
> if this is causing the performance drop. Without dma_map I get
> 20MiB/s. It appears that the loss is due to dma_map call. The dma_map
> only adds latency for the first request.

What exactly do you mean by "first request"?  g_usb_storage uses two
usb_request structures for bulk-IN transfers; are they what you're
talking about?  Or are you talking about calls to usb_ep_queue()?  Or
something else?

Your test showed an extra latency of about 0.4 seconds when using 
dma_map.  All that latency comes from a single request (the first one)?  
That doesn't sound right.

> Studying the flow of buffers I can see, both buffers are filled with
> data from vfs, then both are transmitted over USB, burst like
> behaviour.

Actually the first buffer is filled from VFS, then it is transmitted 
over USB.  While the transmission is in progress, the second buffer is 
filled from VFS.  Each time a transmission ends, the next buffer is 
queued for transmission -- unless it hasn't been filled yet, in which 
case it is queued when it gets filled.

What do you mean by "burst like behavior"?

>  More buffers will add "smoothness" and prevent the bursts
> to affect performance negatively. With 4 buffers, there were very few
> cases when all 4 buffers were empty during a transfer

In what sense do the bursts affect performance?  It makes sense that
having all the buffers empty from time to time would reduce throughput.  
But as long as each buffer gets filled and queued before the previous
buffer has finished transmitting, it shouldn't matter how "bursty" the
behavior is.

Alan Stern

