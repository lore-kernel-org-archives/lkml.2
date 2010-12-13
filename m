Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0LMG1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:27:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab0LMG1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:27:11 -0500
Date: Sun, 12 Dec 2010 23:27:05 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: morroww6@netscape.net
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        zaitcev@redhat.com, nm127@freemail.hu
Subject: Re: [PATCH 1/1] usbmon:  usb monitor binary data incorrectly
 reported for isoc transfers
Message-ID: <20101212232705.4d14e89c@lembas.zaitcev.lan>
In-Reply-To: <8CD6861330A6BFA-A54-1FF96@webmail-m041.sysops.aol.com>
References: <8CD65EFC3E8E57F-5E0-B6E0@webmail-d061.sysops.aol.com>
	<8CD6861330A6BFA-A54-1FF96@webmail-m041.sysops.aol.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Dec 2010 17:15:21 -0500 (EST)
morroww6@netscape.net wrote:

> Since your patch can cause alot of extra data to be sent, I suggest looking
> into this patch before your usbmon become publicized.

Usbmon was publicised for years now, but let's see.

> Corrects isoc monitor data payload to represent the "actual_length"s
> of urb buffer data instead of "length" of buffer data.
> Since isoc records are a series of fragments, uninitialized buffer
> data could be sent as monitor data.

As an aside, there is no security or privacy issue with fetching
the "unitialized" data (it is the same ring buffer, so unrelated
kernel memory does not leak).

> -       if (urb->num_sgs == 0) {
> -               mon_copy_to_buff(rp, offset, urb->transfer_buffer, length);
> -               length = 0;
> -       } else {
> +       if (!ndesc && urb->num_sgs > 0) {
> +               struct scatterlist *sg;
>                 /* If IOMMU coalescing occurred, we cannot trust sg_page */
>[............]
>                         *flag = 'D';
> +       } else {
> +               if (ndesc) {
> +                       struct usb_iso_packet_descriptor *fp;
>[............]
> +               }
> +               else {
> +                       mon_copy_to_buff(rp, offset, buf, length);
> +                       length = 0;
> +               }
>         }

This looks obviously incorrect. If anyone ever submits an ISO with
the newfanged s/g URB, we're going to copy the scatterlist (if not
crash).

> +                       fp = urb->iso_frame_desc;
> +                       for (i=ndesc; length > 0 && --i >= 0; ++fp) {
> +                               this_ofs = fp->offset;
> +                               this_len = min_t(unsigned int, fp->actual_length, length);
> +                               offset = mon_copy_to_buff(rp, offset, buf+this_ofs, this_len);
> +                               length -= this_len;
> +                       }

This is no better. It is not going to save anything from outgoing
transfers, where actual_lengh is not set.

In any case, the whole excersie seems rather pointless to me.
Even for the numbers that Marton presented, I was not sure it was
worth to rescan the descriptors, only to save a few kilobytes per
URB. It was 19KB total for bz#22182. In the event, we saved almost
all of it: the existing code only transfers 4170 bytes of 19200.
Now all this new code to save 4KB? No way.

-- Pete
