Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab0KNTkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 14:40:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab0KNTkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 14:40:00 -0500
Date: Sun, 14 Nov 2010 12:40:35 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, zaitcev@redhat.com
Subject: Re: [PATCH, RFC] usbmon: correct computing of the ISO packets with
 mmap
Message-ID: <20101114124035.6a0c9b80@lembas.zaitcev.lan>
In-Reply-To: <4CDF0DF4.4020405@freemail.hu>
References: <4CD8ECE4.1090206@freemail.hu>
	<20101109075056.59a2e7d8@lembas.zaitcev.lan>
	<4CD9A96D.1010306@freemail.hu>
	<4CDF0DF4.4020405@freemail.hu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Nov 2010 23:15:16 +0100
Németh Márton <nm127@freemail.hu> wrote:

> The length of the isochronous packets were not computed correctly in case of memory
> mapped operation because the gaps between the isodesc data were not taken into
> account. The last data byte can be found at offset+actual_length of the
> last ISO description.

Indeed this is a bug, thanks for doing the legwork to find it. However,
I would rather describe it as "received ISO buffer has gaps and
actual_length is a length of actually transferred data segments,
not whole buffer". Your own Bugzilla entry has a better explanation:

> The second packet contains the completed URB. In the user space we see that
> there are 1000 data bytes in this URB. This data is spread between ISO blocks
> 0...5 giving 155+160+185+174+156+170=1000. ISO desc 6...12 have zero length
> each. ISO desciptors 13..23 are not completed (-EXDEV). The problem is that the
> first 1000 bytes transfered from the kernel contains 800 bytes from the isodesc
> 0 out of 155 bytes are used. The next 800 bytes are not transfered completely,
> only the first 200 bytes out of 16 bytes are used. Then isodesc 2...5 are not
> transfered at all.

I think we should just include this in the patch header.

> +++ linux-2.6.37-rc1/drivers/usb/mon/mon_bin.c	2010-11-13 22:29:09.000000000 +0100
> @@ -515,6 +515,26 @@ static void mon_bin_event(struct mon_rea
>  	}
> 
>  	if (rp->mmap_active) {
> +		if (usb_endpoint_xfer_isoc(epd) &&
> +		    ((usb_urb_dir_in(urb) && ev_type == 'C') ||
> +		     (usb_urb_dir_out(urb) && ev_type == 'S'))) {
> +			int i;
> +
> +			/* Search for the last ISO descritor with OK status
> +			 * and non-zero length
> +			 */
> +			length = 0;
> +			i = urb->number_of_packets - 1;
> +			while (0 <= i &&
> +			       (urb->iso_frame_desc[i].status != 0 ||
> +			        urb->iso_frame_desc[i].actual_length == 0)) {
> +				i--;
> +			}
> +			if (0 <= i) {
> +				length = urb->iso_frame_desc[i].offset +
> +					 urb->iso_frame_desc[i].actual_length;
> +			}
> +		}
>  		offset = mon_buff_area_alloc_contiguous(rp,
>  						 length + PKT_SIZE + lendesc);
>  	} else {

I am not entirely satisfied with the fix, for a couple of reasons.

First, it looks to me that the copy-out access with read(2) has exactly
the same problem as access with mmap(2), so the patch should correct
both cases.

Second, the recomputation of length is done after the anti-bursting
check, thus bypassing it.

Finally, I'm not quite certain that using actual descriptors
(urb->number_of_packets) is saner than returned descriptors
(ep->ndesc). It's not like Wireshark can use those data bytes for
anything useful without the corresponding descriptors, or does it?

Again, in Bugzilla:

> I could imagine different expected behaviours:
> 
> (a) the transfered size equals to 800+800+800+800+800+170=4170 bytes, so the
> iso desc 0...4 are fully transfered and the useful data from  isodesc 5 
> 
> (b) the transfered size equals to 800+800+800+800+800+800=4800 bytes, so the
> iso desc 0...5 are fully transfered
> 
> (c) the transfered size equals to maximum possible size always, in this case
> 24*800=19200 bytes

I see you went for (a). I leaned towards (c), just for simplicity.
On the other hand, we already loop over the descriptors in
mon_bin_get_isodesc, so you're not adding an additional crash.

Let's do this: I'll rework your patch, and you review it to make
sure it works, then sign it off if it checks out. Would that work?

-- Pete
