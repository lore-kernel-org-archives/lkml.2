Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab0KODCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:02:03 -0500
Received: from netrider.rowland.org ([192.131.102.5]:53497 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932493Ab0KODCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:02:02 -0500
Date: Sun, 14 Nov 2010 22:01:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pete Zaitcev <zaitcev@redhat.com>
cc: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] usbmon: correct computing of the ISO packets with
 mmap
In-Reply-To: <20101114162502.6d6318e7@lembas.zaitcev.lan>
Message-ID: <Pine.LNX.4.44L0.1011142159090.4076-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, Pete Zaitcev wrote:

> diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
> index 44cb37b..15c5e46 100644
> --- a/drivers/usb/mon/mon_bin.c
> +++ b/drivers/usb/mon/mon_bin.c
> @@ -437,6 +437,28 @@ static unsigned int mon_bin_get_data(const struct mon_reader_bin *rp,
>  	return length;
>  }
>  
> +/*
> + * This is the look-ahead pass in case of 'Ci', when actual_length cannot
> + * be used to determine the length of the whole contiguous buffer.
> + */

Shouldn't the comment say "Cz" instead of "Ci"?

> +static unsigned int mon_bin_collate_isodesc(const struct mon_reader_bin *rp,
> +    struct urb *urb, unsigned int ndesc)
> +{
> +	struct usb_iso_packet_descriptor *fp;
> +	unsigned int length;
> +
> +	length = 0;
> +	fp = urb->iso_frame_desc;
> +	while (ndesc-- != 0) {
> +		if (fp->status == 0 && fp->actual_length != 0) {

I'd leave out the fp->status == 0 test.  It's not relevant; a buffer 
can contain valid data even if the final status isn't 0.

Alan Stern

