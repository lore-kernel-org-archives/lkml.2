Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1HJOcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:32:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53146 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751906Ab1HJOcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:32:23 -0400
Date: Wed, 10 Aug 2011 10:32:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <zonque@gmail.com>
cc: Florian Mickler <florian@mickler.org>, Oliver Neukum <oliver@neukum.org>,
        <linux-usb@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
        <pedrib@gmail.com>, William Light <wrl@illest.net>,
        Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
        Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
In-Reply-To: <CACTFLAPb-ks_hwQZqp8J0A_3svG4GzYEZ2vL7VOVC5U8dkit-Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011, Daniel Mack wrote:

> So it seems we can finally close this issue. I got myself a new laptop
> recently, and was actually happy to see that this machine showed the
> bug as well. So I started investigating on what's going on and after
> hours of debugging in the wrong area, I stumbled over a bug in my own
> code. The patch attached fixes the problem for me, and William (one of
> the very few people who saw it, too) also reported green light.
> 
> However, it remains a puzzle to me where the acutal root cause is for
> this is, and I would much like to know. Let me briefly explain what
> I'm seeing.
> 
> The driver operates in a mode so that it copies the layout of its
> inbound stream to the output stream, thus guaranteeing the data rate
> of outbound data is equal to that of the input stream. For that, I
> walk the isochronous frames of each received urb and prepare an urb
> for sending that has the same iso packet structure in terms of lengths
> and offsets, jumping over and ignoring frames that are actually
> invalid (status != 0). So here was the problem: if there were frames
> with any different status field, the driver would calculate the wrong
> offset and the playback stream will have artefacts. So, a classic bug
> you might think, and the fix is trivial.
> 
> However, what I really don't understand is why this wasn't observed
> any earlier by any of the many users, and why iit makes a difference
> which type of memory I use for this. Recall that my original patch
> that allocates DMA coherent memory for the transfer buffers also fixes
> the problem just fine. Or put it that way: when allocating "normal"
> memory using kmalloc(), the stream appears to have "holes" in the iso
> packet structure, while with DMA coherent memory, the layout is
> different. And all this only happens on fairly new 64bit-enabled
> machines.
> 
> Can anyone explain this?

Looking at the driver's current code, it appears that your patch does 
not fix the bug properly.  Using discontiguous regions in the transfer 
buffer is perfectly okay.  The real problem is later on, where you do:

	if (send_it) {
		out->number_of_packets = FRAMES_PER_URB;

This should be

		out->number_of_packets = outframe;

The way it is now, the USB stack will try to use data from all the 
frame descriptors, and the last few will be stale because the loop 
doesn't set them.

I don't know why this would cause the strange symptoms, though.

Alan Stern

